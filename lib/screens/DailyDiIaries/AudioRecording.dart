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

  @override
  void initState() {
    initializeAudioRecord();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    audioRecord.dispose();
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
              SvgPicture.asset(
                AppAssets.audioWaves,
                color: AppColor.lightBlackColor,
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