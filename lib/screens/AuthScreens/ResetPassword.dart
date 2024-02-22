import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inbetrieb/Models/SignUp_LogIn_Model.dart';
import 'package:inbetrieb/Models/api_response.dart';
import 'package:inbetrieb/Services/api_services.dart';
import 'package:inbetrieb/resources/appAssets.dart';
import 'package:inbetrieb/resources/appColors.dart';
import 'package:inbetrieb/resources/toastMessage.dart';
import 'package:inbetrieb/screens/AuthScreens/LoginPage.dart';
import 'package:inbetrieb/widgets/Text.dart';
import 'package:inbetrieb/widgets/TextFieldValidation.dart';
import 'package:inbetrieb/widgets/background_Image_container.dart';
import '../../../Widgets/TextFields.dart';
import '../../../Widgets/large_Button.dart';

// ignore: must_be_immutable
class ResetPassword extends StatefulWidget {
  final String otp;
  final String email;
  const ResetPassword({Key? key, required this.otp, required this.email,}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

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
                text: "Reset Password",
              ),
              const SizedBox(
                height: 5,
              ),
              const MyText(
                text: "Enter your new password to get started\nwith us!",
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColor.lightBlackColor,
              ),
              SizedBox(
                height: Get.height * 0.07,
              ),
              Form(
                key: formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Get.width * 0.08,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextFormField(
                          controller: passwordController,
                          hintText: "Password",
                          validator: validatePassword,
                          obscureText: true,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      CustomTextFormField(
                          controller: confirmPasswordController,
                          hintText: "Confirm Password",
                          validator: validatePassword,
                          obscureText: true,
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: Get.height * 0.15,
              ),
              isLoading
                  ? LargeButton(
                text: "Please wait...",
                onTap: () {},
              ) : LargeButton(
                text: "Reset",
                onTap: () => resetPassword(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isLoading = false;
  late APIResponse<SignUpLogInClass> _response;
  ApiServices get service => GetIt.I<ApiServices>();

  resetPassword(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      if(passwordController.text == confirmPasswordController.text) {
        setState(() {
          isLoading = true;
        });
        Map dataOTP = {
          "email": widget.email.toString(),
          "otp": widget.otp.toString(),
          "password": passwordController.text.toString(),
          "confirm_password": confirmPasswordController.text.toString(),
        };
        debugPrint(dataOTP.toString());
        _response = await service.updateForgetPassword(dataOTP);
        if (_response.status!.toLowerCase() == 'success') {
          debugPrint('otp entered successfulyy ${_response.data}');
          showToastSuccess(
            "Password Changed Successfully",
            FToast().init(context),
          );
          Get.to(
                () => const LoginPage(),
            duration: const Duration(milliseconds: 350),
            transition: Transition.rightToLeft,
          );
        } else {
          debugPrint(_response.message);
          showToastError(
            _response.message,
            FToast().init(context),
          );
        }
      } else {
        showToastError(
          'Password do not matched',
          FToast().init(context),
        );
      }
    }
    else {
      showToastError(
        'all fields are required',
        FToast().init(context),
      );
    }
    setState(() {
      isLoading = false;
    });
  }
}