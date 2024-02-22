import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:inbetrieb/widgets/Text.dart';
import 'package:inbetrieb/widgets/bankSelect.dart';
import 'package:inbetrieb/resources/appAssets.dart';
import 'package:inbetrieb/resources/appColors.dart';
import 'package:inbetrieb/widgets/large_Button.dart';
import 'package:inbetrieb/widgets/selectPaymentAc.dart';
import 'package:inbetrieb/screens/HomePage/HomePage.dart';
import 'package:inbetrieb/widgets/background_Image_container.dart';

class PaymentMethod extends StatefulWidget {
  const PaymentMethod({super.key});

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  bool isBank = true;
  bool isCard = false;
  bool isB1Value = false;
  bool isB2Value = false;
  bool isCValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: ImageContainer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: Get.height * 0.09,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: SvgPicture.asset(
                        AppAssets.arrowLeft,
                      ),
                    ),
                    const MyText(
                      text: "Payment Method",
                    ),
                    const SizedBox(),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const MyText(
                text: "Select payment method",
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColor.lightBlackColor,
              ),
              SizedBox(
                height: Get.height * 0.1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SelectPaymentAcc(
                    acImage: AppAssets.bank,
                    bName: "Bank",
                    containerColor: isBank ? AppColor.primaryColor : AppColor.whiteColor,
                    imageColor: isBank ? AppColor.whiteColor : AppColor.primaryColor,
                    textColor: isBank ? AppColor.whiteColor : AppColor.blackColor,
                    onTap: () {
                      setState(() {
                        isBank = true;
                        isCard = false;
                      });
                    },
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  SelectPaymentAcc(
                    acImage: AppAssets.card,
                    bName: "Credit Card",
                    containerColor: isCard ? AppColor.primaryColor : AppColor.whiteColor,
                    imageColor: isCard ? AppColor.whiteColor : AppColor.primaryColor,
                    textColor: isCard ? AppColor.whiteColor : AppColor.blackColor,
                    onTap: () {
                      setState(() {
                        isBank = false;
                        isCard = true;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(
                height: Get.height * 0.04,
              ),
              isBank
                  ? Column(
                      children: [
                        BankSelect(
                          borderColor: isB1Value
                              ? const Color(0xFF43A0A6)
                              : Colors.transparent,
                          onTap: () {
                            setState(() {
                              isB1Value = true;
                              isB2Value = false;
                              isCard = false;
                            });
                          },
                          containerColor: isB1Value
                              ? const Color(0xFFF4FEFF)
                              : AppColor.whiteColor,
                          bName: "BCA",
                          bImage: AppAssets.bca,
                          bNumber: "******** 8907",
                        ),
                        SizedBox(
                          height: Get.height * 0.01,
                        ),
                        BankSelect(
                          borderColor: isB2Value
                              ? const Color(0xFF43A0A6)
                              : Colors.transparent,
                          onTap: () {
                            setState(() {
                              isB2Value = true;
                              isB1Value = false;
                              isCard = false;
                            });
                          },
                          containerColor: isB2Value
                              ? const Color(0xFFF4FEFF)
                              : AppColor.whiteColor,
                          bName: "Jenius",
                          bImage: AppAssets.jenus,
                          bNumber: "******** 8907",
                        ),
                      ],
                    )
                  : BankSelect(
                      borderColor:
                          isCard ? const Color(0xFF43A0A6) : Colors.transparent,
                      onTap: () {
                        setState(() {
                          isB2Value = false;
                          isB1Value = false;
                          isCard = true;
                        });
                      },
                      containerColor: isCard
                          ? const Color(0xFFF4FEFF)
                          : AppColor.whiteColor,
                      bName: "User Name",
                      bImage: AppAssets.masterCard,
                      bNumber: "******** 8907",
                    ),
              SizedBox(
                height: isCard ? Get.height * 0.38 : Get.height * 0.27,
              ),
              LargeButton(
                text: "Next",
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => Dialog(
                      alignment: Alignment.center,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Container(
                        width: Get.width,
                        height: 321,
                        decoration: BoxDecoration(
                          color: AppColor.whiteColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                onPressed: () {
                                  Get.back();
                                },
                                icon: const Icon(
                                  Icons.close_rounded,
                                  color: AppColor.blackColor,
                                  size: 24,
                                ),
                              ),
                            ),
                            const MyText(
                              text: "Restricted Access",
                            ),
                            SizedBox(
                              height: Get.height * 0.05,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: MyText(
                                text:
                                    "You can only add 5 tasks or notes daily in free version. Buy our subscription plan to enjoy more features.",
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColor.lightBlackColor,
                              ),
                            ),
                            SizedBox(
                              height: Get.height * 0.05,
                            ),
                            LargeButton(
                              width: Get.width * 0.7,
                              text: "View Plans",
                              onTap: () {
                                Get.offAll(
                                  () => const HomePage(),
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
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
