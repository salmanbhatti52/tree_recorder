import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:inbetrieb/resources/appAssets.dart';
import 'package:inbetrieb/resources/appColors.dart';
import 'package:inbetrieb/resources/const.dart';
import 'package:inbetrieb/resources/toastMessage.dart';
import 'package:inbetrieb/screens/DailyDiIaries/DailyDiaries.dart';
import 'package:inbetrieb/widgets/Text.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inbetrieb/widgets/homePage_TextField.dart';
import 'package:inbetrieb/widgets/home_top_bar.dart';
import 'package:inbetrieb/widgets/shimmer_loader.dart';
import 'package:secure_shared_preferences/secure_shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController firstController = TextEditingController();
  bool isParentTextFieldVisible = false;
  bool isParentSubTextFieldVisible = false;
  List getPDiaries = [];
  bool isLoading = false;
  Map<int, bool> expansionStates = {};
  String parentMessage = "";
  int selectedIndex = -1;
  String selectedMenuesName = "";
  bool _canExit = false;

  init() async {
    await getParentDiaries();
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isParentTextFieldVisible = false;
          isParentSubTextFieldVisible = false;
        });
      },
      child: WillPopScope(
        onWillPop: () async {
          if (_canExit) {
            return true;
          } else {
            showToastSuccess("Click Again To Exit", FToast().init(context),);
            _canExit = true;
            Timer(const Duration(seconds: 2), () {
              _canExit = false;
            });
            return false;
          }
        },
        child: Scaffold(
          backgroundColor: AppColor.whiteColor,
          body: SizedBox(
            height: Get.height,
            width: Get.width,
            child: Stack(
              children: [
                const Positioned(
                  top: 40,
                  left: 20,
                  right: 20,
                  child: HomeTopBar(),
                ),
                Visibility(
                  visible: isParentTextFieldVisible,
                  child: Positioned(
                    top: 120,
                    left: 20,
                    right: 20,
                    child: HomeTextField(
                      onFieldSubmitted: (title) {
                        addDiary(title);
                        setState(() {
                          isParentTextFieldVisible = false;
                        });
                      },
                    ),
                  ),
                ),
                Visibility(
                  visible: isParentSubTextFieldVisible,
                  child: Positioned(
                    top: 120,
                    left: 20,
                    right: 20,
                    child: HomeTextField(
                      onFieldSubmitted: (title) {
                        addSubDiary(title);
                        setState(() {
                          isParentSubTextFieldVisible = false;
                        });
                      },
                    ),
                  ),
                ),
                RefreshIndicator(
                  onRefresh: () async {
                    await getParentDiaries();
                  },
                  child: Positioned(
                    top: isParentTextFieldVisible || isParentSubTextFieldVisible
                        ? 170
                        : 100,
                    left: 20,
                    right: 20,
                    child: isLoading
                        ? const Shimmers()
                        : parentMessage == "error"
                            ? const SizedBox()
                            : SizedBox(
                                width: Get.width,
                                height: Get.height * 0.8,
                                child: ReorderableListView(
                                  onReorder: (int oldIndex, int newIndex) {
                                    setState(() {
                                      final Map<String, dynamic> item = getPDiaries.removeAt(oldIndex);

                                      if (newIndex > oldIndex) {
                                        newIndex -= 1;
                                      }

                                      getPDiaries.insert(newIndex, item);
                                      updateOrderApiCall(item, oldIndex, newIndex);
                                    });
                                  },
                                  children: List.generate(
                                    getPDiaries.length,
                                        (index) {
                                      var diary = getPDiaries[index]['diary'];
                                      var hasChildren = getPDiaries[index]['has_children'];
                                      var hasAudio = getPDiaries[index]['has_audio'];
                                      var subDiaries = getPDiaries[index]['subdiaries'];
                                      var parentId = diary?['menues_id'];
                                      var menuesName = diary?['menues_name'];
                                      var mainParentId = diary?['parent_id'];

                                      if (!expansionStates.containsKey(parentId)) {
                                        expansionStates[parentId] = false;
                                      }

                                      return ReorderableDelayedDragStartListener(
                                        key: Key('$index'),
                                        index: index,
                                        child: Column(
                                          children: [
                                            buildDiaryItem(diary!, hasChildren, hasAudio, parentId, menuesName, 0, mainParentId),
                                            Visibility(
                                              visible: expansionStates[parentId]! && hasChildren == true,
                                              child: buildNestedSubDiaries(subDiaries, 1),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 80,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF4FEFF),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x1405425C),
                          blurRadius: 6,
                          offset: Offset(0, 0),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isParentTextFieldVisible = true;
                              selectedIndex = -1;
                            });
                          },
                          child: SvgPicture.asset(
                            AppAssets.plus,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (selectedIndex != -1) {
                              setState(() {
                                isParentSubTextFieldVisible = true;
                              });
                            }
                          },
                          child: SvgPicture.asset(
                            AppAssets.subPlus,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (selectedIndex != -1) {
                                String? updatedName = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DailyDiaries(
                                      menuesId: selectedIndex,
                                      menuesName: selectedMenuesName,
                                    ),
                                  ),
                                );

                                if (updatedName != null) {
                                  setState(() {
                                    selectedMenuesName = updatedName;
                                  });
                                }
                            } else {
                              showToastError(
                                "Select the Diary",
                                FToast().init(context),
                              );
                            }
                          },
                          child: SvgPicture.asset(
                            AppAssets.edit,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              expansionStates.remove(selectedIndex);
                            });
                          },
                          child: SvgPicture.asset(
                            AppAssets.arrowBack,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (selectedIndex != -1) {
                              deleteDiaries();
                            }
                          },
                          child: SvgPicture.asset(
                            AppAssets.trash,
                          ),
                        ),
                      ],
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

  Future<void> updateOrderApiCall(Map<String, dynamic> item, int oldIndex, int newIndex) async {
    setState(() {
      isLoading = true;
    });

    String orderChangeApiUrl = 'https://tree.eigix.net/public/api/updateOrder';
    debugPrint("currentOrder :: ${item['diary']['order'].toString()}");
    debugPrint("targetOrder :: ${(newIndex + 1).toString()}");
    debugPrint("current_menue_id :: ${item['diary']['menues_id'].toString()}");
    debugPrint("target_menue_id :: ${getPDiaries[oldIndex]['diary']['menues_id'].toString()}");
    http.Response response = await http.post(
      Uri.parse(orderChangeApiUrl),
      headers: {"Accept": "application/json"},
      body: {
        "currentOrder": item['diary']['order'].toString(),
        "targetOrder": (newIndex + 1).toString(),
        "current_menue_id": item['diary']['menues_id'].toString(),
        "target_menue_id": getPDiaries[oldIndex]['diary']['menues_id'].toString(),
      },
    );
    if (mounted) {
      setState(() {
        if (response.statusCode == 200) {
          var jsonResponse = json.decode(response.body);
          if (jsonResponse['message'] == "Order updated successfully.") {
            debugPrint("message :: ${jsonResponse['message']}");
            getParentDiaries();
            isLoading = false;
          } else {
            isLoading = false;
          }
        } else {
          debugPrint("Response::${response.body}");
          isLoading = false;
        }
      });
    }
  }

  getParentDiaries() async {
    setState(() {
      isLoading = true;
    });
    prefs = await SecureSharedPref.getInstance();
    userID = (await prefs.getString('userID'));
    debugPrint("userID $userID");
    String getDiariesApiUrl = 'https://tree.eigix.net/public/api/get_diaries';
    http.Response response = await http.post(
      Uri.parse(getDiariesApiUrl),
      headers: {"Accept": "application/json"},
      body: {
        "users_customer_id": userID,
      },
    );
    if (mounted) {
      setState(() {
        selectedIndex = -1;
        if (response.statusCode == 200) {
          var jsonResponse = json.decode(response.body);
          if (jsonResponse['data'] != null &&
              jsonResponse['data'] is List<dynamic>) {
            getPDiaries = jsonResponse['data'];
            parentMessage = jsonResponse['status'];
            debugPrint("getPDiaries: $getPDiaries");
            isLoading = false;
          } else {
            parentMessage = jsonResponse['status'];
            debugPrint("parentMessage: $parentMessage");
            isLoading = false;
          }
        } else {
          debugPrint("Response Bode::${response.body}");
          isLoading = false;
        }
      });
    }
  }

  deleteDiaries() async {
    setState(() {
      isLoading = true;
    });
    String getDiariesApiUrl = 'https://tree.eigix.net/public/api/delete_diary';
    http.Response response = await http.post(
      Uri.parse(getDiariesApiUrl),
      headers: {"Accept": "application/json"},
      body: {
        "menues_id": selectedIndex.toString(),
      },
    );
    if (mounted) {
      setState(() {
        if (response.statusCode == 200) {
          var jsonResponse = json.decode(response.body);
          if (jsonResponse['status'] == "success") {
            getParentDiaries();
            showToastSuccess(
              jsonResponse['message'],
              FToast().init(context),
            );
            isLoading = false;
          } else {
            debugPrint(jsonResponse['status']);
            isLoading = false;
          }
        } else {
          debugPrint("Response Bode::${response.body}");
          isLoading = false;
        }
      });
    }
  }

  addDiary(String title) async {
    setState(() {
      isLoading = true;
    });

    prefs = await SecureSharedPref.getInstance();
    userID = await prefs.getString('userID');
    debugPrint("userID $userID");

    String addSubDiaryApiUrl = 'https://tree.eigix.net/public/api/add_diary';
    http.Response response = await http.post(
      Uri.parse(addSubDiaryApiUrl),
      headers: {"Accept": "application/json"},
      body: {
        "users_customer_id": userID,
        "menues_name": title,
        "menues_file": "",
      },
    );

    if (mounted) {
      setState(() {
        if (response.statusCode == 200) {
          getParentDiaries();
        } else {
          debugPrint("Response Bode::${response.body}");
          isLoading = false;
        }
      });
    }
  }

  addSubDiary(String subTitle) async {
    setState(() {
      isLoading = true;
    });

    prefs = await SecureSharedPref.getInstance();
    userID = await prefs.getString('userID');
    debugPrint("userID $userID");

    String addSubDiaryApiUrl = 'https://tree.eigix.net/public/api/add_subdiary';
    http.Response response =
        await http.post(Uri.parse(addSubDiaryApiUrl), headers: {
      "Accept": "application/json"
    }, body: {
      "users_customer_id": userID,
      "menues_name": subTitle,
      "parent_id": selectedIndex.toString(),
      "menues_file": ""
    });

    if (mounted) {
      setState(() {
        if (response.statusCode == 200) {
          var jsonResponse = json.decode(response.body);
          getParentDiaries();
        } else {
          debugPrint("Response Bode::${response.body}");
          isLoading = false;
        }
      });
    }
  }

  Widget buildDiaryItem(Map<String, dynamic> diary, var children, var hasAudio,
      int parentId, String menuesName,  int indentationLevel, var mainParentId) {
    Color itemColor = parentId == selectedIndex
        ? const Color(0xFF05425c)
        : const Color(0xFF9EC2D2);
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMenuesName = menuesName;
          selectedIndex = parentId;
          debugPrint(selectedIndex.toString());
          debugPrint(selectedMenuesName.toString());
        });
      },
      child: Container(
        width: Get.width,
        height: 50,
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x1405425C),
              blurRadius: 6,
              offset: Offset(0, 0),
              spreadRadius: 0,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 50,
                  decoration: BoxDecoration(
                    color: itemColor,
                  ),
                ),
                if (children == true)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          expansionStates[diary['menues_id']] =
                          !(expansionStates[diary['menues_id']] ?? false);
                        });
                      },
                      child: SvgPicture.asset(
                        expansionStates[diary['menues_id']] ?? false
                            ? AppAssets.rightDown
                            : AppAssets.right,
                        width: 18,
                      ),
                    ),
                  ),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        expansionStates[diary['menues_id']] =
                        !(expansionStates[diary['menues_id']] ?? false);
                      });
                    },
                  child: Padding(
                    padding:  EdgeInsets.only(left: children == true ? 5.0 : 8.0, right: 5),
                    child: MyText(
                      text: diary['menues_name'] ?? 'No Name',
                      color: AppColor.blackColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (hasAudio == true)
                  SvgPicture.asset(
                    AppAssets.microphone,
                    width: 18,
                    height: 18,
                    color: const Color(0xff3A4856),
                  ),
              ],
            ),
            if (mainParentId == null)
            GestureDetector(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: SvgPicture.asset(
                  AppAssets.move,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNestedSubDiaries(List<dynamic> subDiaries, int indentationLevel) {
    return Column(
      children: subDiaries.map<Widget>((subDiary) {
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 0.0 + indentationLevel * 16.0),
              child: buildDiaryItem(
                subDiary['diary'],
                subDiary['has_children'],
                subDiary['has_audio'],
                subDiary['diary']['menues_id'],
                subDiary['diary']['menues_name'],
                indentationLevel,
                subDiary['diary']['parent_id'],
              ),
            ),
            Visibility(
              visible: expansionStates[subDiary['diary']['menues_id']] ?? false,
              child: buildNestedSubDiaries(
                  subDiary['subdiaries'], indentationLevel + 1),
            ),
          ],
        );
      }).toList(),
    );
  }
}
