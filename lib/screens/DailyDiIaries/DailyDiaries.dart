import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:inbetrieb/resources/appAssets.dart';
import 'package:inbetrieb/resources/appColors.dart';
import 'package:inbetrieb/screens/DailyDiIaries/dailyDiariesController.dart';
import 'package:inbetrieb/widgets/Text.dart';
import 'package:record/record.dart';
import 'package:shimmer/shimmer.dart';

class DailyDiaries extends StatefulWidget {
  final int? menuesId;
  final String? menuesName;
  const DailyDiaries({super.key, this.menuesName, this.menuesId});

  @override
  State<DailyDiaries> createState() => _DailyDiariesState();
}

class _DailyDiariesState extends State<DailyDiaries> {
  final DiaryController controller = Get.put(DiaryController());
  TextEditingController textController = TextEditingController();
  TextEditingController newTextController = TextEditingController();
  TextEditingController editMenuesNameController = TextEditingController();

  @override
  void initState() {
    debugPrint("menuesID ${widget.menuesId}");
    debugPrint("menuesName ${widget.menuesName}");
    editMenuesNameController = TextEditingController(text: widget.menuesName);
    initializeAudioRecord();
    super.initState();
    controller.getDailyDiaries(widget.menuesId!.toInt());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          controller.textFieldValueFalse();
          controller.editTextFalse();
          controller.editMenuesFieldValueFalse();
        });
      },
      child: WillPopScope(
        onWillPop: () {
          Navigator.pop(context, editMenuesNameController.text);
          return Future.value(true);
        },
        child: Scaffold(
          backgroundColor: AppColor.whiteColor,
          appBar: AppBar(
            backgroundColor: AppColor.whiteColor,
            leading: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context, editMenuesNameController.text);
                },
                child: SvgPicture.asset(
                  AppAssets.iconBack,
                ),
              ),
            ),
            leadingWidth: 45,
            centerTitle: true,
            title: Obx(
              () => controller.isEDitMenuesFieldVisible.value
                  ? SizedBox(
                      width: Get.width * 0.4,
                      child: TextFormField(
                        controller: editMenuesNameController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(top: 15),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              controller.editFolder(
                                widget.menuesId!.toInt(),
                                editMenuesNameController.text.toString(),
                              );
                              controller.editMenuesFieldValueFalse();
                            },
                            child: const Icon(
                              Icons.check,
                              color: AppColor.primaryColor,
                            ),
                          ),
                        ),
                        autofocus: true,
                        textInputAction: TextInputAction.newline,
                        maxLines: null,
                      ),
                    )
                  : MyText(
                      text: editMenuesNameController.text,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: AppColor.blackColor,
                    ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    controller.editMenuesFieldValueTrue();
                  },
                  child: SvgPicture.asset(
                    AppAssets.edit,
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 15.0,
                    right: 15,
                    top: 10,
                  ),
                  child: Container(
                    width: Get.width * 0.9,
                    height: 86,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4FEFF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            recordVoice(context);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                AppAssets.microphone,
                              ),
                              const MyText(
                                text: "Add Voice\nNote",
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: AppColor.blackColor,
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _showBottomSheet();
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                AppAssets.photo,
                              ),
                              const MyText(
                                text: "Add Image",
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: AppColor.blackColor,
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.textFieldValueTrue();
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                AppAssets.edit,
                              ),
                              const MyText(
                                text: "Add Text",
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: AppColor.blackColor,
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.deleteMenuesData(widget.menuesId!.toInt(), context);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                AppAssets.trash,
                              ),
                              const MyText(
                                text: "Delete",
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: AppColor.blackColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Obx(
                  () => controller.isTextFieldVisible.value
                      ? Container(
                          width: Get.width * 0.9,
                          // height: 100,
                          decoration: const BoxDecoration(
                            color: AppColor.whiteColor,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: Get.width * 0.87,
                                child: TextFormField(
                                  controller: newTextController,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(top: 15),
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        debugPrint("Second");
                                        controller.textFieldValueFalse();
                                        controller.text.value = newTextController.text.toString();
                                        controller.addDailyDiary(widget.menuesId!.toInt());
                                        newTextController.clear();
                                      },
                                      child: const Icon(
                                        Icons.check,
                                        color: AppColor.primaryColor,
                                      ),
                                    ),
                                  ),
                                  autofocus: true,
                                  textInputAction: TextInputAction.newline,
                                  maxLines: null,
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                ),
                Obx(
                  () => controller.editTexts.value
                      ? Container(
                          width: Get.width * 0.9,
                          // height: 50,
                          decoration: const BoxDecoration(
                            color: AppColor.whiteColor,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: Get.width * 0.87,
                                child: TextFormField(
                                  controller: textController,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(top: 15),
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        debugPrint("First");
                                        debugPrint(
                                            "textController ${textController.text.toString()}");
                                        controller.editTextFalse();
                                        controller.editText(widget.menuesId!.toInt(), textController.text.toString());
                                        textController.clear();
                                      },
                                      child: const Icon(
                                        Icons.check,
                                        color: AppColor.primaryColor,
                                      ),
                                    ),
                                  ),
                                  autofocus: true,
                                  textInputAction: TextInputAction.newline,
                                  maxLines: null,
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                ),
                Obx(
                  () => controller.isLoading.value
                      ? SizedBox(
                          height: Get.height * 0.6,
                          child: ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: 1,
                              itemBuilder: (BuildContext context, int i) {
                                return Column(
                                  children: [
                                    Container(
                                      width: Get.width,
                                      height: 50,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 5),
                                      child: Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: const Card(
                                          elevation: 1.0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                              topLeft: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: Get.width,
                                      height: 200,
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                      ),
                                      child: Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: const Card(
                                          elevation: 1.0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                              topLeft: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                        )
                      : SizedBox(
                          height: Get.height * 0.77,
                          width: Get.width,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: controller.getDailyDiary.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              final diary = controller.getDailyDiary[index];
                              final dataType = diary["data_type"];
                              final menuesData = diary["menues_data"];
                              final menuesDataId = diary["menues_data_id"];
                              if (dataType == "audio") {
                                _initAudioPlayer('https://tree.eigix.net/public/$menuesData', menuesDataId);
                              }
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    dataType == "text"
                                        ? Column(
                                            children: [
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: SizedBox(
                                                  width: Get.width * 0.15,
                                                  child: Row(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          controller.editTextTrue();
                                                          if (controller.editTexts.value) {
                                                            textController.text = menuesData;
                                                            controller.menuesDataID = menuesDataId;
                                                            debugPrint(textController.text);
                                                            debugPrint(menuesDataId.toString());
                                                            debugPrint(dataType.toString());
                                                          }
                                                        },
                                                        child: SvgPicture.asset(
                                                          AppAssets.edit,
                                                          height: 20,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            controller.selectedIndex = menuesDataId;
                                                            debugPrint("menuesDataId ${controller.selectedIndex}");
                                                            controller.deleteSpecificMenuesData(widget.menuesId!.toInt(), context);
                                                          });
                                                        },
                                                        child: SvgPicture.asset(
                                                          AppAssets.trash,
                                                          height: 20,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: Get.width,
                                                child: MyRichText(
                                                  text: menuesData,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          )
                                        : dataType == "image"
                                            ? SizedBox(
                                                width: Get.width,
                                                height: Get.height * 0.3,
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                      child: Image.network(
                                                        'https://tree.eigix.net/public/$menuesData',
                                                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                          return Image.asset('assets/images/fade_in_image.jpeg');
                                                        },
                                                        loadingBuilder:
                                                            (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                                          if (loadingProgress == null) {
                                                            return child;
                                                          }
                                                          return Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                              color: AppColor.primaryColor,
                                                              value: loadingProgress.expectedTotalBytes != null
                                                                  ? loadingProgress.cumulativeBytesLoaded /
                                                                      loadingProgress.expectedTotalBytes!
                                                                  : null,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: 10,
                                                      right: 30,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            controller.selectedIndex = menuesDataId;
                                                            debugPrint("menuesDataId ${controller.selectedIndex}");
                                                            controller.deleteSpecificMenuesData(widget.menuesId!.toInt(), context);
                                                          });
                                                        },
                                                        child: SvgPicture.asset(
                                                          AppAssets.trash,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : dataType == "audio"
                                                ? Container(
                                                    height: 68,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(6),
                                                      boxShadow: const [
                                                        BoxShadow(
                                                          color: Color(0x1405425C),
                                                          blurRadius: 6,
                                                          offset: Offset(0, 0),
                                                          spreadRadius: 0,
                                                        )
                                                      ],
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              const MyText(
                                                                text: "Voice Note",
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w500,
                                                                color: AppColor.blackColor,
                                                              ),
                                                              Text(
                                                                '${positionMap[menuesDataId]?.inMinutes ?? 0}:${positionMap[menuesDataId]?.inSeconds.remainder(60).toString().padLeft(2, '0') ?? '00'} / ${durationMap[menuesDataId]?.inMinutes ?? 0}:${durationMap[menuesDataId]?.inSeconds.remainder(60).toString().padLeft(2, '0') ?? '00'}',
                                                                style: const TextStyle(
                                                                    fontSize: 12,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () {
                                                                  playPause('https://tree.eigix.net/public/$menuesData', menuesDataId);
                                                                },
                                                                child: isPlayingMap[menuesDataId] == true
                                                                    ? const Icon(Icons.stop,
                                                                        size: 25,
                                                                        color: AppColor.primaryColor,
                                                                      )
                                                                    : SvgPicture.asset(
                                                                        AppAssets.player,
                                                                        width: 25,
                                                                      ),
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  setState(() {
                                                                    controller.selectedIndex = menuesDataId;
                                                                    debugPrint("menuesDataId ${controller.selectedIndex}");
                                                                    controller.deleteSpecificMenuesData(widget.menuesId!.toInt(), context);
                                                                  });
                                                                },
                                                                child: SvgPicture.asset(AppAssets.trash,),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Map<int, AudioPlayer> audioPlayersMap = {};
  Map<int, bool> isPlayingMap = {};
  Map<int, Duration> durationMap = {};
  Map<int, Duration> positionMap = {};
  AudioPlayer? audioPlayer;

  void _initAudioPlayer(String url, int menuesDataId) async {
    if (audioPlayersMap.containsKey(menuesDataId)) {
      return;
    }

    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.setSourceUrl(url);
    audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        durationMap[menuesDataId] = duration;
      });
    });
    audioPlayer.onPositionChanged.listen((Duration position) {
      setState(() {
        positionMap[menuesDataId] = position;
      });
    });
    audioPlayersMap[menuesDataId] = audioPlayer;
  }

  @override
  void dispose() {
    audioPlayersMap.clear();
    audioPlayer?.dispose();
    super.dispose();
  }

  void playPause(String url, int menuesDataId) {
    audioPlayer = audioPlayersMap[menuesDataId];

    bool isPlaying = isPlayingMap[menuesDataId] ?? false;

    if (isPlaying) {
      audioPlayer?.pause();
    } else {
      audioPlayer?.play(UrlSource(url));
    }

    setState(() {
      isPlayingMap[menuesDataId] = !isPlaying;
    });

    audioPlayer?.onPlayerComplete.listen((event) {
      setState(() {
        isPlayingMap[menuesDataId] = false;
      });
    });
  }

  void _showBottomSheet() {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.25,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Center(
              child: ListTile(
                title: MyText(
                  text: "Pick Image",
                  fontSize: 18,
                  color: AppColor.blackColor,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                controller.imagePick(widget.menuesId!.toInt());
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 15.0, bottom: 25, top: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.image_outlined,
                      color: AppColor.blackColor,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    MyText(
                      text: "Upload Image from Galley",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColor.blackColor,
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                controller.cameraPick(widget.menuesId!.toInt());
              },
              child: const Padding(
                padding: EdgeInsets.only(
                  left: 15.0,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.camera_alt_outlined,
                      color: AppColor.blackColor,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    MyText(
                      text: "Upload Image from Camera",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColor.blackColor,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  late Record audioRecord;

  Future<void> initializeAudioRecord() async {
    try {
      audioRecord = Record();
    } catch (e) {
      debugPrint('Error initializing audioRecord: $e');
    }
  }

  void recordVoice(context) {
    showModalBottomSheet(
      isDismissible: false,
      context: context,
      builder: (builder) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            height: Get.height * 0.3,
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
                                    : 'Start Recording')
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
        );
      },
    );
  }

  Future<void> stopRecording() async {
    try {
      String? path = await audioRecord.stop();
      setState(() {
        controller.recordingFalse();
        controller.audioPath.value = path!;
        debugPrint("audioPath ${controller.audioPath.value}");
        controller.addDailyDiary(widget.menuesId!.toInt());
      });
    } catch (e) {
      debugPrint('error111111: $e');
    }
    Get.back();
  }

  Future<void> startRecording() async {
    try {
      if (await audioRecord.hasPermission()) {
        // Start recording to file
        await audioRecord.start();
        controller.recordingTrue();
      }
    } catch (e) {
      debugPrint('error111: $e');
    }
  }
}
