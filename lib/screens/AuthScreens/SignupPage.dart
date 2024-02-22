import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inbetrieb/Models/SignUp_LogIn_Model.dart';
import 'package:inbetrieb/Models/api_response.dart';
import 'package:inbetrieb/Services/api_services.dart';
import 'package:inbetrieb/resources/appAssets.dart';
import 'package:inbetrieb/resources/appColors.dart';
import 'package:inbetrieb/resources/const.dart';
import 'package:inbetrieb/resources/toastMessage.dart';
import 'package:inbetrieb/screens/HomePage/HomePage.dart';
import 'package:inbetrieb/screens/authScreens/LoginPage.dart';
import 'package:inbetrieb/widgets/Text.dart';
import 'package:inbetrieb/widgets/TextFieldValidation.dart';
import 'package:inbetrieb/widgets/TextFields.dart';
import 'package:inbetrieb/widgets/background_Image_container.dart';
import 'package:inbetrieb/widgets/large_Button.dart';
import 'package:secure_shared_preferences/secure_shared_preferences.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  final GlobalKey<FormState> _signUpKey = GlobalKey<FormState>();
  late  TextEditingController nameController;
  late  TextEditingController userNameController;
  late  TextEditingController emailController;
  late  TextEditingController passwordController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController = TextEditingController();
    userNameController = TextEditingController();
    passwordController = TextEditingController();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  bool isLoadingStart = false;

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
                text: "Signup",
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
             Form(
               key: _signUpKey,
               child:  Padding(
               padding: EdgeInsets.symmetric(
                   horizontal: 18.0, vertical: Get.height * 0.07),
               child: Column(
                 children: [
                   CustomTextFormField(
                     controller: nameController,
                     hintText: "Name",
                     keyboardType: TextInputType.text,
                     validator: (val) {
                       if (val!.isEmpty) {
                         return 'Please enter your name';
                       }
                       return null;
                     },
                   ),
                   const SizedBox(
                     height: 15,
                   ),
                   CustomTextFormField(
                     controller: userNameController,
                     hintText: "Username",
                     keyboardType: TextInputType.text,
                     validator: (val) {
                       if (val!.isEmpty) {
                         return 'Please enter username';
                       }
                       return null;
                     },
                   ),
                   const SizedBox(
                     height: 15,
                   ),
                   CustomTextFormField(
                     controller: emailController,
                     keyboardType: TextInputType.emailAddress,
                     hintText: "Email",
                     validator: validateEmail,
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
                 ],
               ),
             ),),
              SizedBox(
                height: Get.height * 0.03,
              ),
              isLoading ?
              LargeButton(
                text: "Please wait...",
                onTap: (){},
              ) : LargeButton(
                text: "Signup",
                onTap: ()=> signInButton(context),
              ),
               Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const MyText(
                      text: "Already a member? ",
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColor.secondaryColor,
                    ),
                    GestureDetector(
                      onTap: (){
                        Get.to(
                              () => LoginPage(),
                          duration: const Duration(milliseconds: 350),
                          transition: Transition.downToUp,
                        );
                      },
                      child: const MyText(
                        text: "SignIn",
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

  ApiServices get service => GetIt.I<ApiServices>();

  late APIResponse<SignUpLogInClass> _responseSignIn;

  bool isLoading = false;

  signInButton(BuildContext context) async {
    if (_signUpKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      Map signUpData = {
        "email": emailController.text,
        "password": passwordController.text,
        "name": nameController.text,
        "username": userNameController.text,
      };
      _responseSignIn = await service.signUpAPI(signUpData);
      print('object $signUpData');
      if (_responseSignIn.status!.toLowerCase() == 'success') {

        await prefs.putString(
          'userID',
          _responseSignIn.data!.users_customer_id.toString(),
        );
        await prefs.putString('userName', _responseSignIn.data!.users_customer_name.toString());
        await prefs.putString('userEmail', _responseSignIn.data!.email!);
        await prefs.putString('isLogin', 'true');
        showToastSuccess(
          _responseSignIn.status,
          FToast().init(context),
        );
        Get.offAll(
              () => const HomePage(),
          duration: const Duration(milliseconds: 350),
          transition: Transition.rightToLeft,
        );
      } else {
        print(
          'failure in sign in $signUpData${_responseSignIn.message}',
        );
        showToastError(
          _responseSignIn.message.toString(),
          // 'experiencing technical issue!',
          FToast().init(context),
        );
      }
    } else {
      showToastError(
        'All fields are required',
        FToast().init(context),
      );
    }
    setState(() {
      isLoading = false;
    });
  }
}
