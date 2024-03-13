import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:inbetrieb/resources/appAssets.dart';
import 'package:inbetrieb/resources/appColors.dart';
import 'package:inbetrieb/screens/DailyDiIaries/dailyDiariesController.dart';
import 'package:inbetrieb/widgets/Text.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class VoiceRecorderPage extends StatefulWidget {
  int? menuesId;
  VoiceRecorderPage({super.key, required this.menuesId});

  @override
  State<VoiceRecorderPage> createState() => _VoiceRecorderPageState();
}

class _VoiceRecorderPageState extends State<VoiceRecorderPage> {
  late Record audioRecord;
  Timer? timer;
  int _seconds = 0;
  bool _isTimerRunning = false;
  final DiaryController controller = Get.put(DiaryController());

  final StreamController<int> recordDurationController =
      StreamController<int>.broadcast()..add(0);

  Sink<int> get recordDurationInput => recordDurationController.sink;

  Stream<double> get amplitudeStream => audioRecord
      .onAmplitudeChanged(const Duration(milliseconds: 160))
      .map((amp) => amp.current);

  Stream<RecordState> get recordStateStream => audioRecord.onStateChanged();

  Stream<int> get recordDurationOutput => recordDurationController.stream;

  final ScrollController scrollController = ScrollController();
  List<double> amplitude = [];
  late StreamSubscription<double> amplitudeSubscription;
  double waveMaxHeight = 45;
  final double minimumAmp = -67;

  @override
  void initState() {
    initializeAudioRecord();
    amplitudeSubscription = amplitudeStream.listen((amp) {
      setState(() {
        amplitude.add(amp);
      });
      if (scrollController.positions.isNotEmpty) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          curve: Curves.linear,
          duration: const Duration(milliseconds: 175),
        );
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    audioRecord.dispose();
    recordDurationController.close();
    amplitudeSubscription.cancel();
    super.dispose();
  }

  Future<void> initializeAudioRecord() async {
    try {
      audioRecord = Record();
    } catch (e) {
      debugPrint('Error initializing audioRecord: $e');
    }
  }

  Future<void> stopRecording() async {
    try {
      String? path = await audioRecord.stop();

      if (path != null && path.isNotEmpty) {
        Directory? dir;
        if (Platform.isIOS) {
          dir = await getApplicationDocumentsDirectory();
        } else {
          dir = Directory("/storage/emulated/0/Download");
          if (!await dir.exists()) dir = (await getExternalStorageDirectory())!;
        }
        String fileName = 'audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
        File destinationFile = File('${dir.path}/$fileName');
        await File(path).copy(destinationFile.path);
        setState(() {
          controller.recordingFalse();
          controller.audioPath.value = destinationFile.path;
          debugPrint("audioPath ${controller.audioPath.value}");
          controller.addDailyDiary(widget.menuesId!.toInt());
        });
      }
    } catch (e) {
      debugPrint('error111111: $e');
    } finally {
      Get.back();
      if (_isTimerRunning) {
        stopTimer();
      }
    }
  }

  Future<void> startRecording() async {
    try {
      if (await audioRecord.hasPermission()) {
        // Start recording to file
        await audioRecord.start();
        _isTimerRunning ? null : startTimer();
        controller.recordingTrue();
      }
    } catch (e) {
      debugPrint('error111: $e');
    }
  }

  void startTimer() {
    if (_isTimerRunning) return;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
        recordDurationInput.add(_seconds);
      });
    });

    setState(() {
      _isTimerRunning = true;
    });
  }

  void stopTimer() {
    if (!_isTimerRunning) return;

    timer?.cancel();
    setState(() {
      _seconds = 0;
      _isTimerRunning = false;
      recordDurationInput.add(0);
    });
  }

  String getFormattedTime() {
    int hours = _seconds ~/ 3600;
    int minutes = (_seconds % 3600) ~/ 60;
    int seconds = _seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = getFormattedTime();
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: SvgPicture.asset(
              AppAssets.iconBack,
            ),
          ),
        ),
        centerTitle: true,
        title: const MyText(
          text: "Record Voice",
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColor.blackColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          height: Get.height * 0.6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // SvgPicture.asset(
              //   AppAssets.audioWaves,
              //   color: AppColor.lightBlackColor,
              // ),
              SizedBox(
                height: waveMaxHeight,
                child: ListView.builder(
                    controller: scrollController,
                    itemCount: amplitude.length,
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    itemExtent: 6,
                    itemBuilder: (context, index) {
                      double amplitudes = amplitude[index].clamp(minimumAmp+1, 0);
                      double ampPercentage = 1 - (amplitudes / minimumAmp).abs();
                      double waveHeight = waveMaxHeight * ampPercentage;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Center(
                          child: TweenAnimationBuilder(
                              tween: Tween(begin: 0, end: waveHeight),
                              duration: const Duration(milliseconds: 100),
                              curve: Curves.decelerate,
                              builder: (context, animatedWaveHeight, child){
                                return SizedBox(
                                  height: animatedWaveHeight.toDouble(),
                                  width: 8,
                                  child: child,
                                );
                              },
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              MyText(
                text: formattedTime,
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColor.blackColor,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Obx(
                    () => Expanded(
                      child: InkWell(
                        onTap: () {
                          if (controller.isRecording.value) {
                            stopRecording();
                            controller.recordingFalse();
                          } else {
                            startRecording();
                            controller.recordingTrue();
                          }
                        },
                        child: SizedBox(
                          child: Column(
                            children: [
                              Icon(
                                controller.isRecording.value
                                    ? Icons.stop
                                    : Icons.play_arrow,
                                size: 60,
                              ),
                              Text(controller.isRecording.value
                                  ? 'Stop Recording'
                                  : 'Start Recording'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
