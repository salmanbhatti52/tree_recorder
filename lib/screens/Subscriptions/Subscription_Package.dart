import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inbetrieb/resources/appColors.dart';
import 'package:inbetrieb/screens/Subscriptions/PaymentMethod.dart';
import 'package:inbetrieb/widgets/Text.dart';
import 'package:inbetrieb/widgets/background_Image_container.dart';
import 'package:inbetrieb/widgets/large_Button.dart';
import 'package:inbetrieb/widgets/packageContainer.dart';

class SubscriptionPackages extends StatefulWidget {
   const SubscriptionPackages({super.key});

  @override
  State<SubscriptionPackages> createState() => _SubscriptionPackagesState();
}

class _SubscriptionPackagesState extends State<SubscriptionPackages> {
  bool isTapped1 = false;
  bool isTapped2 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: ImageContainer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: Get.height * 0.15,
              ),
              const MyText(
                text: "Subscription Packages",
              ),
              const SizedBox(
                height: 5,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: MyText(
                  text:
                      "Choose any packages that suites you well, and manage your daily task or activities by taking notes at your convenience.",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColor.lightBlackColor,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              PackageContainer(
                pacName: "Basic",
                dollars: "40",
                list1: "Add 5 tasks / notes daily",
                list2: "Add up to 10 subtasks / notes",
                list3: "Add up to 10 voice notes",
                borderColor: isTapped1 ? AppColor.primaryColor : const Color(0xFFDDFBFD),
                containerColor: isTapped1 ? const Color(0xFFF4FEFF) :  AppColor.whiteColor,
                onTap: () {
                  setState(() {
                    isTapped1 = true;
                    isTapped2 = false;
                  });
                },
              ),
              const SizedBox(
                height: 20 ,
              ),
              PackageContainer(
                pacName: "Premium",
                dollars: "60",
                list1: "Add unlimited tasks / notes daily",
                list2: "Add unlimited subtasks / notes",
                list3: "Add unlimited voice notes",
                borderColor: isTapped2 ? AppColor.primaryColor : const Color(0xFFDDFBFD),
                containerColor: isTapped2 ? const Color(0xFFF4FEFF) :  AppColor.whiteColor,
                onTap: () {
                  setState(() {
                    isTapped2 = true;
                    isTapped1 = false;
                  });
                },
              ),
              SizedBox(
                height: Get.height * 0.14,
              ),
              LargeButton(
                text: "Next",
                onTap: () {
                  Get.to(
                        () => const PaymentMethod(),
                    duration: const Duration(milliseconds: 350),
                    transition: Transition.rightToLeft,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
