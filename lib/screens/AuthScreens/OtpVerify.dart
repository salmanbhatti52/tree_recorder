import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:inbetrieb/resources/appAssets.dart';
import 'package:inbetrieb/resources/appColors.dart';
import 'package:inbetrieb/resources/toastMessage.dart';
import 'package:inbetrieb/screens/AuthScreens/ResetPassword.dart';
import 'package:inbetrieb/widgets/Text.dart';
import 'package:inbetrieb/widgets/background_Image_container.dart';
import 'package:pinput/pinput.dart';
import '../../../Widgets/large_Button.dart';
import 'package:google_fonts/google_fonts.dart';

class EmailVerify extends StatefulWidget {
  final String otp;
  final String email;
  EmailVerify({Key? key, required this.otp, required this.email}) : super(key: key);

  @override
  State<EmailVerify> createState() => _EmailVerifyState();
}

class _EmailVerifyState extends State<EmailVerify> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController pinController = TextEditingController();

  final defaultPinTheme = PinTheme(
    width: 52,
    height: 46,
    textStyle: const TextStyle(
      fontFamily: "SF Pro Display",
      fontSize: 14,
      color: AppColor.secondaryColor,
      fontWeight: FontWeight.w400,
    ),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColor.whiteColor,
        border: Border.all(width: 2, color: AppColor.borderColor),
        boxShadow: const [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 24,
            offset: Offset(0, 0),
            spreadRadius: 0,
          ),
        ]
    ),
  );

  final focusPinTheme = PinTheme(
    width: 52,
    height: 46,
    textStyle: const TextStyle(
      fontFamily: "SF Pro Display",
      fontSize: 14,
      color: AppColor.secondaryColor,
      fontWeight: FontWeight.w400,
    ),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColor.whiteColor,
        border: Border.all(width: 2, color: AppColor.primaryColor),
        boxShadow: const [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 4,
            offset: Offset(0, 0),
            spreadRadius: 0,
          ),
        ]
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ImageContainer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: Get.height * 0.07,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: Get.width * 0.05,
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                    ),
                  ),
                ),
              ),
              SvgPicture.asset(AppAssets.logo),
              Text(
                "Free Tree",
                style: GoogleFonts.sigmarOne(
                  color: AppColor.primaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const MyText(
                text: "Email Verification",
              ),
              const SizedBox(
                height: 5,
              ),
              const MyText(
                text: "Enter a 4 digit verification code we have\nsent on your email!",
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColor.lightBlackColor,
              ),
              SizedBox(
                height: Get.height * 0.07,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.18),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Pinput(
                          length: 4,
                          keyboardType: TextInputType.number,
                          closeKeyboardWhenCompleted: true,
                          controller: pinController,
                          defaultPinTheme: defaultPinTheme,
                          focusedPinTheme: focusPinTheme,
                          submittedPinTheme: defaultPinTheme,
                          textInputAction: TextInputAction.done,
                          showCursor: true,
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: Get.height * 0.1,
              ),
              LargeButton(
                text: "Verify",
                onTap: () => nextPage(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  nextPage(BuildContext context) {
    if (pinController.text.isEmail) {
      showToastError('Enter OTP', FToast().init(context));
    } else {
      if (pinController.text.toString() == widget.otp.toString()) {
        Get.to(
              () => ResetPassword(
                otp: widget.otp.toString(),
                email: widget.email.toString(),
              ),
          duration: const Duration(milliseconds: 350),
          transition: Transition.rightToLeft,
        );
      } else {
        showToastError('otp does not match', FToast().init(context));
      }
    }
  }
}