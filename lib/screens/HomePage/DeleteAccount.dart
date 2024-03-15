import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:inbetrieb/resources/const.dart';
import 'package:inbetrieb/resources/toastMessage.dart';
import 'package:inbetrieb/screens/AuthScreens/LoginPage.dart';
import 'package:inbetrieb/widgets/large_Button.dart';
import 'package:secure_shared_preferences/secure_shared_pref.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({super.key});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.center,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: SizedBox(
        height: Get.height * 0.3,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 24,
            right: 24,
            top: 20,
            bottom: 15,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Delete Account?',
                style:
                GoogleFonts.poppins(
                  fontWeight:
                  FontWeight.w500,
                  fontSize: 28,
                  color: const Color(0xff5B4214),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: SizedBox(
                  width: 216,
                  height: 64,
                  child: Text(
                    textAlign:
                    TextAlign.center,
                    'Are you sure you want to delete you account?',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight:
                      FontWeight.w500,
                      color: const Color(0xff000000),
                    ),
                  ),
                ),
              ),
              LargeButton(
                text: "Delete Account",
                onTap: () {
                  deleteAccount();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isLoading = false;

  deleteAccount() async {
    showToastSuccess(
      "Your account will be deleted within 24 hours",
      FToast().init(context),
    );
    await prefs.putString('isLogin', 'false');
    Get.to(
          () => const LoginPage(),
      duration: const Duration(milliseconds: 350),
      transition: Transition.downToUp,
    );
    // setState(() {
    //   isLoading = true;
    // });
    // prefs = await SecureSharedPref.getInstance();
    // userID = (await prefs.getString('userID'));
    // debugPrint("userID $userID");
    // String deleteAccountApiUrl = 'https://tree.eigix.net/public/api/delete_diary';
    // http.Response response = await http.post(
    //   Uri.parse(deleteAccountApiUrl),
    //   headers: {"Accept": "application/json"},
    //   body: {
    //     "users_customer_id": "",
    //   },
    // );
    // if (mounted) {
    //   setState(() {
    //     if (response.statusCode == 200) {
    //       var jsonResponse = json.decode(response.body);
    //       if (jsonResponse['status'] == "success") {
    //         showToastSuccess(
    //           jsonResponse['message'],
    //           FToast().init(context),
    //         );
    //         isLoading = false;
    //       } else {
    //         debugPrint(jsonResponse['status']);
    //         isLoading = false;
    //       }
    //     } else {
    //       debugPrint("Response Bode::${response.body}");
    //       isLoading = false;
    //     }
    //   });
    // }
  }
}
