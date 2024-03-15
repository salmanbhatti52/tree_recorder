import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inbetrieb/resources/appAssets.dart';
import 'package:inbetrieb/resources/appColors.dart';
import 'package:inbetrieb/resources/const.dart';
import 'package:inbetrieb/screens/AuthScreens/LoginPage.dart';
import 'package:inbetrieb/screens/HomePage/DeleteAccount.dart';
import 'package:inbetrieb/widgets/Text.dart';
import 'package:secure_shared_preferences/secure_shared_preferences.dart';

class HomeTopBar extends StatefulWidget {
  const HomeTopBar({super.key});

  @override
  State<HomeTopBar> createState() => _HomeTopBarState();
}

class _HomeTopBarState extends State<HomeTopBar> {
  init() async {
    prefs = await SecureSharedPref.getInstance();
    setState(() {
      prefs.getString('userName').then((value) {
        userName = value ?? "";
        debugPrint("userName $userName");
      });
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MyText(
              text: "Welcome",
              fontWeight: FontWeight.w600,
              fontSize: 24,
              color: AppColor.blackColor,
            ),
            MyText(
              text: userName,
              fontWeight: FontWeight.w500,
              fontSize: 18,
              color: AppColor.lightBlackColor,
            ),
          ],
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () async {
                await prefs.putString('isLogin', 'false');
                Get.to(
                  () => const LoginPage(),
                  duration: const Duration(milliseconds: 350),
                  transition: Transition.downToUp,
                );
              },
              child: const Icon(
                Icons.logout_rounded,
                color: AppColor.primaryColor,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: (){
                showDialog(
                  context: context,
                  builder: (context) => StatefulBuilder(
                      builder: (context, setState) {
                        return const DeleteAccount();
                      }),
                );
              },
              child: Image.asset(
                AppAssets.removeUser,
                width: 25,
                height: 25,
                color: AppColor.primaryColor,
              ),
            ),
            // const SizedBox(
            //   width: 10,
            // ),
            // GestureDetector(
            //   onTap: () {},
            //   child: SvgPicture.asset(
            //     AppAssets.move,
            //   ),
            // ),
          ],
        ),
      ],
    );
  }
}
