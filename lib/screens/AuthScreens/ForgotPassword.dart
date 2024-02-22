import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inbetrieb/Models/api_response.dart';
import 'package:inbetrieb/Models/forgetPasswordModel.dart';
import 'package:inbetrieb/Services/api_services.dart';
import 'package:inbetrieb/resources/appAssets.dart';
import 'package:inbetrieb/resources/appColors.dart';
import 'package:inbetrieb/resources/toastMessage.dart';
import 'package:inbetrieb/screens/AuthScreens/OtpVerify.dart';
import 'package:inbetrieb/widgets/Text.dart';
import 'package:inbetrieb/widgets/TextFieldValidation.dart';
import 'package:inbetrieb/widgets/background_Image_container.dart';
import '../../../Widgets/TextFields.dart';
import '../../../Widgets/large_Button.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  final formKey = GlobalKey<FormState>();
  late TextEditingController emailController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
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
                text: "Forgot Password",
              ),
              const SizedBox(
                height: 5,
              ),
              const MyText(
                text: "Please enter your register email to reset password.",
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18.0,
                  ),
                  child: Column(
                    children: [
                      CustomTextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        hintText: "Email Address",
                        validator: validateEmail,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: Get.height * 0.1,
              ),
              isLoading
                  ? LargeButton(
                text: "Please wait...",
                onTap: () {},
              ) : LargeButton(
                text: "Next",
                onTap: () => forgetPassword(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isLoading = false;
  late APIResponse<DataForget> _responseForget;
  ApiServices get service => GetIt.I<ApiServices>();
  forgetPassword(BuildContext context) async {
    if (emailController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      Map forgetData = {
        "email": emailController.text.toString(),
      };
      _responseForget = await service.forgetPassword(forgetData);
      print('object successful ' + _responseForget.data!.otp.toString());
      if (_responseForget.status!.toLowerCase() == 'success') {
        showToastSuccess(
          _responseForget.data!.message.toString(),
          FToast().init(context),
        );
        Get.to(
              () => EmailVerify(
                otp: _responseForget.data!.otp.toString(),
                email: emailController.text.toString(),
              ),
          duration: const Duration(milliseconds: 350),
          transition: Transition.rightToLeft,
        );
      } else {
        showToastError(
          'experiencing technical issue!',
          FToast().init(context),
        );
      }
    } else {
      showToastError(
        'email is required',
        FToast().init(context),
      );
    }
    setState(() {
      isLoading = false;
    });
  }
}