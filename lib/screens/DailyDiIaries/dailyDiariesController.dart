import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inbetrieb/resources/appColors.dart';
import 'package:inbetrieb/resources/const.dart';
import 'package:secure_shared_preferences/secure_shared_preferences.dart';

import '../../resources/toastMessage.dart';

class DiaryController extends GetxController {
  Rx<CroppedFile?> imageFile = Rx<CroppedFile?>(null);
  RxString base64Image = RxString("");
  RxBool isTextFieldVisible = false.obs;
  RxBool isEDitMenuesFieldVisible = false.obs;
  RxString text = RxString("");
  RxBool isLoading = false.obs;
  RxBool isRecording = false.obs;
  RxBool editTexts = false.obs;
  RxString audioPath = ''.obs;
  late Record audioRecord;
  RxList getDailyDiary = [].obs;
  var selectedIndex = -1.obs;
  var menuesDataID = -1.obs;

  editText(int menuesId, String menuesData) async {

    debugPrint("menuesDataID $menuesDataID");
    debugPrint("textController $menuesData");

    isLoading.value = true;
    String getDiariesApiUrl = 'https://tree.eigix.net/public/api/text_item';
    http.Response response = await http.post(
      Uri.parse(getDiariesApiUrl),
      headers: {"Accept": "application/json"},
      body: {
        "menues_data_id": menuesDataID.toString(),
        "menues_data": menuesData.toString(),
        "data_type": "text",
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == "success") {
        isLoading.value = false;
        getDailyDiaries(menuesId);
      } else {
        debugPrint("Failed edit Text");
        isLoading.value = false;
      }
    } else {
      debugPrint("Response Bode::${response.body}");
      isLoading.value = false;
    }
  }

  editFolder(int menuesId, String folderName) async {

    prefs = await SecureSharedPref.getInstance();
    userID = (await prefs.getString('userID'));
    debugPrint("userID $userID");

    // isLoading.value = true;
    String editMenuesNameApiUrl = 'https://tree.eigix.net/public/api/edit_menue_name';
    http.Response response = await http.post(
      Uri.parse(editMenuesNameApiUrl),
      headers: {"Accept": "application/json"},
      body: {
        "users_customer_id": userID.toString(),
        "menues_name": folderName.toString(),
        "menues_id": menuesId.toString(),
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == "success") {
        // isLoading.value = false;
      } else {
        debugPrint("Failed editMenuesName Text");
        // isLoading.value = false;
      }
    } else {
      debugPrint("Response Bode::${response.body}");
      isLoading.value = false;
    }
  }

  deleteSpecificMenuesData(int menuesId, BuildContext context) async {

    isLoading.value = true;
    String getDiariesApiUrl = 'https://tree.eigix.net/public/api/delete_diary_item';
    http.Response response = await http.post(
      Uri.parse(getDiariesApiUrl),
      headers: {"Accept": "application/json"},
      body: {
        "menues_data_id": selectedIndex.toString(),
      },
    );

        if (response.statusCode == 200) {
          var jsonResponse = json.decode(response.body);
          if (jsonResponse['status'] == "succes") {
            getDailyDiaries(menuesId);
            showToastSuccess(
              jsonResponse['message'],
              FToast().init(context),
            );
            isLoading = false.obs;
          } else {
            debugPrint(jsonResponse['status']);
            isLoading = false.obs;
          }
        } else {
          debugPrint("Response Bode::${response.body}");
          isLoading = false.obs;
        }
  }

  deleteMenuesData(int menuesId, BuildContext context) async {

    isLoading.value = true;
    String getDiariesApiUrl = 'https://tree.eigix.net/public/api/delete_diary_data';
    http.Response response = await http.post(
      Uri.parse(getDiariesApiUrl),
      headers: {"Accept": "application/json"},
      body: {
        "menues_id": menuesId.toString(),
      },
    );

        if (response.statusCode == 200) {
          var jsonResponse = json.decode(response.body);
          if (jsonResponse['status'] == "succes") {
            getDailyDiaries(menuesId);
            showToastSuccess(
              jsonResponse['message'],
              FToast().init(context),
            );
            isLoading = false.obs;
          } else {
            debugPrint(jsonResponse['status']);
            isLoading = false.obs;
          }
        } else {
          debugPrint("Response Bode::${response.body}");
          isLoading = false.obs;
        }
  }

  getDailyDiaries(int menuesId) async {

    isLoading.value = true;

    String getDiariesApiUrl = 'https://tree.eigix.net/public/api/get_a_diary';
    http.Response response = await http.post(
      Uri.parse(getDiariesApiUrl),
      headers: {"Accept": "application/json"},
      body: {
        "menues_id": menuesId.toString(),
      },
    );
        if (response.statusCode == 200) {
          var jsonResponse = json.decode(response.body);
          if (jsonResponse['data'] != null &&
              jsonResponse['data'] is List<dynamic>) {
            getDailyDiary.value = jsonResponse['data'];
            debugPrint("getDailyDiary: $getDailyDiary");
            isLoading.value = false;
          } else {
            debugPrint("Failed getDailyDiary");
            isLoading.value = false;
          }
        } else {
          debugPrint("Response Bode::${response.body}");
          isLoading.value = false;
        }
  }

  recordingTrue(){
    isRecording.value = true;
  }

  recordingFalse(){
    isRecording.value = false;
  }

  editTextTrue(){
    editTexts.value = true;
  }

  editTextFalse(){
    editTexts.value = false;
  }


  addDailyDiary(int menuesId) async {

  isLoading.value = true;

    prefs = await SecureSharedPref.getInstance();
    userID = await prefs.getString('userID');
    debugPrint("userID $userID");

    String base64Audio = '';
  if (audioPath.value.isNotEmpty) {
    File audioFile = File(audioPath.value);
    List<int> audioBytes = await audioFile.readAsBytes();
    base64Audio = base64Encode(audioBytes);
    debugPrint("base64Audio $base64Audio");
  }

    String addDailyApiUrl = 'https://tree.eigix.net/public/api/update_diary';
    http.Response response = await http.post(
      Uri.parse(addDailyApiUrl),
      headers: {"Accept": "application/json"},
      body: {
        "users_customer_id": userID,
        "menues_id": menuesId.toString(),
        "data_type": base64Image.value.isNotEmpty ? "image" : text.value.isNotEmpty ? "text" :  base64Audio.isNotEmpty ? "audio" : "",
        // "menues_images": base64Image.value.isNotEmpty ? base64Image.value : "",
        // "menues_audios": base64Audio.isNotEmpty ? base64Audio : "",
        // "menues_texts": text.value.isNotEmpty ? text.value : "",
        "menues_data": base64Image.value.isNotEmpty ? base64Image.value : text.value.isNotEmpty ? text.value  :  base64Audio.isNotEmpty ? base64Audio : "",
      },
    );
        if (response.statusCode == 200) {
          base64Image.value = '';
          audioPath.value = '';
          text.value = '';
          getDailyDiaries(menuesId.toInt());
            isLoading.value = false;
            debugPrint("Response Bode::${response.body}");
        } else {
          debugPrint("Response Bode::${response.body}");
          isLoading.value = false;
        }
  }

  textFieldValueTrue(){
    isTextFieldVisible.value = true;
  }

  textFieldValueFalse(){
    isTextFieldVisible.value = false;
  }

  editMenuesFieldValueTrue(){
    isEDitMenuesFieldVisible.value = true;
  }

  editMenuesFieldValueFalse(){
    isEDitMenuesFieldVisible.value = false;
  }

  Future<void> imagePick(int menuesId) async {
    final picker = ImagePicker();
    XFile? pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedImage != null) {
      await cropImage(pickedImage.path, menuesId);
    }
  }

  Future<void> cameraPick(int menuesId) async {
    final picker = ImagePicker();
    XFile? pickedImage = await picker.pickImage(
      source: ImageSource.camera, // Set source to camera
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedImage != null) {
      await cropImage(pickedImage.path, menuesId);
    }
  }

  Future<void> cropImage(String imagePath, int menuesId) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePath,
      maxWidth: 1800,
      maxHeight: 1800,
      cropStyle: CropStyle.rectangle,
      uiSettings: [
        AndroidUiSettings(
          initAspectRatio: CropAspectRatioPreset.ratio4x3,
          toolbarTitle: 'Upload',
          toolbarColor: AppColor.primaryColor,
          backgroundColor: AppColor.secondaryColor,
          showCropGrid: false,
          toolbarWidgetColor: AppColor.whiteColor,
          hideBottomControls: true,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          showActivitySheetOnDone: false,
          resetAspectRatioEnabled: false,
          title: 'Cropper',
          hidesNavigationBar: true,
        ),
      ],
    );
    if (croppedFile != null) {
      imageFile.value = croppedFile;
      if (imageFile.value != null) {
        Get.back();
      }
      await convertToBase64(croppedFile, menuesId);
    }
  }

  Future<void> convertToBase64(CroppedFile croppedFile, int menuesId) async {
    List<int> imageBytes = await croppedFile.readAsBytes();
    String base64String = base64Encode(imageBytes);
    base64Image.value = base64String;
    addDailyDiary(menuesId);
    debugPrint("base64Image ${base64Image.value}");
  }

}