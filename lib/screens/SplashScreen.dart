import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:inbetrieb/widgets/Text.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inbetrieb/resources/const.dart';
import 'package:inbetrieb/resources/appAssets.dart';
import 'package:inbetrieb/resources/appColors.dart';
import 'package:inbetrieb/widgets/large_Button.dart';
import 'package:inbetrieb/screens/HomePage/HomePage.dart';
import 'package:inbetrieb/screens/AuthScreens/LoginPage.dart';
import 'package:inbetrieb/screens/authScreens/SignupPage.dart';
import 'package:inbetrieb/widgets/background_Image_container.dart';
import 'package:secure_shared_preferences/secure_shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String isLogin = 'false';

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    prefs = await SecureSharedPref.getInstance();
    isLogin = (await prefs.getString('isLogin')) ?? 'false';

    Future.delayed(const Duration(seconds: 0), () async {
      Get.offAll(
        () => isLogin == "true" ? const HomePage() : const LoginPage(),
        duration: const Duration(milliseconds: 350),
        transition: Transition.rightToLeft,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: ImageContainer(
        child: Column(
          children: [
            SizedBox(
              height: Get.height * 0.12,
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
              height: 20,
            ),
            Image.asset(AppAssets.splashImage),
            const SizedBox(
              height: 20,
            ),
            const MyText(
              text: "We Will Help You in Taking Notes",
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColor.secondaryColor,
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.12),
              child: const MyText(
                text:
                    "Lorem ipsum dolor sit amet consectetur. In convallis vitae mi tellus eu sed. Tempus rises premium squelchier incident null volute rises.",
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColor.lightBlackColor,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.07,
            ),
            LargeButton(
              text: "Let's Start",
              onTap: () {
                Get.to(
                  () => const SignupPage(),
                  duration: const Duration(milliseconds: 350),
                  transition: Transition.rightToLeft,
                );
              },
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
