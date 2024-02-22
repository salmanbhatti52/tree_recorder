import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:inbetrieb/resources/appColors.dart';
import 'package:inbetrieb/widgets/Text.dart';

class BankSelect extends StatelessWidget {
  final String bImage;
  final String bName;
  final String bNumber;
  final Color containerColor;
  final Color borderColor;
  final Function onTap;
  const BankSelect({super.key, required this.bNumber, required this.bName, required this.bImage, required this.containerColor, required this.borderColor, required this.onTap,});

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: (){
        onTap();
      },
      child: Container(
        width: Get.width * 0.9,
        height: 82,
        decoration: BoxDecoration(
          color: containerColor,
          border: Border.all(width: 1, color: borderColor,),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1405425C),
              blurRadius: 6,
              offset: Offset(0, 0),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 10),
              child: SvgPicture.asset(bImage,),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(text: bName, fontSize: 16, fontWeight: FontWeight.w600, color: AppColor.blackColor,),
                MyText(text: bNumber, fontSize: 14, fontWeight: FontWeight.w400, color: AppColor.lightBlackColor,),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
