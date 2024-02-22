import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:inbetrieb/widgets/Text.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inbetrieb/resources/const.dart';
import 'package:inbetrieb/widgets/TextFields.dart';
import 'package:inbetrieb/resources/appAssets.dart';
import 'package:inbetrieb/resources/appColors.dart';
import 'package:inbetrieb/Models/api_response.dart';
import 'package:inbetrieb/widgets/large_Button.dart';
import 'package:inbetrieb/Services/api_services.dart';
import 'package:inbetrieb/resources/toastMessage.dart';
import 'package:inbetrieb/Models/SignUp_LogIn_Model.dart';
import 'package:inbetrieb/screens/HomePage/HomePage.dart';
import 'package:inbetrieb/widgets/TextFieldValidation.dart';
import 'package:inbetrieb/screens/AuthScreens/SignupPage.dart';
import 'package:inbetrieb/screens/AuthScreens/ForgotPassword.dart';
import 'package:inbetrieb/widgets/background_Image_container.dart';
import 'package:secure_shared_preferences/secure_shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _logInKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool isLoadingStart = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    init();
  }

  init() async {
    setState(() {
      isLoadingStart = true;
    });
    prefs = await SecureSharedPref.getInstance();
    setState(() {
      isLoadingStart = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoadingStart
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            backgroundColor: AppColor.whiteColor,
            body: ImageContainer(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: Get.height * 0.1,
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
                      text: "Sign In",
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const MyText(
                      text: "Let’s me help you meet up your tasks",
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColor.lightBlackColor,
                    ),
                    SizedBox(
                      height: Get.height * 0.07,
                    ),
                    Form(
                      key: _logInKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18.0,
                        ),
                        child: Column(
                          children: [
                            CustomTextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              hintText: "Username or Email Address",
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Please enter the email address or username';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            CustomTextFormField(
                              controller: passwordController,
                              hintText: "Password",
                              obscureText: true,
                              validator: validatePassword,
                              keyboardType: TextInputType.visiblePassword,
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(
                                      () => const ForgotPassword(),
                                      duration:
                                          const Duration(milliseconds: 350),
                                      transition: Transition.rightToLeft,
                                    );
                                  },
                                  child: const MyText(
                                    text: "Forgot password?",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.secondaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.09,
                    ),
                    isLoading
                        ? LargeButton(
                            text: "Please wait...",
                            onTap: () {},
                          )
                        : LargeButton(
                            text: "Login",
                            onTap: () => logInButton(context),
                          ),
                    SizedBox(
                      height: Get.height * 0.13,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const MyText(
                            text: "Create another account? ",
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColor.secondaryColor,
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(
                                () => const SignupPage(),
                                duration: const Duration(milliseconds: 350),
                                transition: Transition.downToUp,
                              );
                            },
                            child: const MyText(
                              text: "Signup",
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColor.secondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  bool isLoading = false;
  late APIResponse<SignUpLogInClass> _responseLogIn;
  ApiServices get service => GetIt.I<ApiServices>();

  logInButton(BuildContext context) async {
    if (_logInKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      Map logInData = {
        "identification": emailController.text,
        "password": passwordController.text,
      };
      _responseLogIn = await service.logInAPI(logInData);

      if (_responseLogIn.status!.toLowerCase() == 'success') {
        await prefs.putString(
          'userID',
          _responseLogIn.data!.users_customer_id.toString(),
        );
        await prefs.putString('userName', _responseLogIn.data!.users_customer_name.toString());
        await prefs.putString('userEmail', _responseLogIn.data!.email!);
        await prefs.putString('isLogin', 'true');
        showToastSuccess(
          'Login successfully',
          FToast().init(context),
        );
        Get.offAll(
          () => const HomePage(),
          duration: const Duration(milliseconds: 350),
          transition: Transition.rightToLeft,
        );
      } else {
        showToastError(
          _responseLogIn.message.toString(),
          FToast().init(context),
        );
      }
      setState(() {
        isLoading = false;
      });
    } else {
      showToastError(
        'All fields are required',
        FToast().init(context),
      );
    }
  }
}
