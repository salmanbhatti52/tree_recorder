import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:inbetrieb/resources/appAssets.dart';
import 'package:inbetrieb/resources/appColors.dart';
import 'package:inbetrieb/widgets/Text.dart';

class PackageContainer extends StatelessWidget {
  final String pacName;
  final String dollars;
  final String list1;
  final String list2;
  final String list3;
  final Color containerColor;
  final Color borderColor;
  final Function onTap;
  const PackageContainer({super.key, required this.containerColor,  required this.pacName, required this.borderColor, required this.onTap, required this.dollars, required this.list1, required this.list2, required this.list3});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onTap();
      },
      child: Container(
        width: Get.width * 0.9,
        height: Get.height * 0.19,
        decoration: BoxDecoration(
          color: containerColor,
           border: Border.all(width: 2, color: borderColor,),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15, top: 10,),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyText(text: pacName, fontSize: 18, color: AppColor.secondaryColor,),
                  Row(
                    children: [
                       MyText(
                        text: "\$$dollars",
                      ),
                      const MyText(
                        text: "  /Per Month",
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  )
                ],
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 5),
                  child: SvgPicture.asset(AppAssets.point),
                ),
                MyText(
                  text: list1,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColor.lightBlackColor,
                ),
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 5),
                  child: SvgPicture.asset(AppAssets.point),
                ),
                MyText(
                  text: list2,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColor.lightBlackColor,
                ),
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 5),
                  child: SvgPicture.asset(AppAssets.point),
                ),
                MyText(
                  text: list3,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColor.lightBlackColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
