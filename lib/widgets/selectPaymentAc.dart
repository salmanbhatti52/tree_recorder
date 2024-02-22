import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:inbetrieb/widgets/Text.dart';

class SelectPaymentAcc extends StatelessWidget {
  final String acImage;
  final String bName;
  final Color containerColor;
  final Color textColor;
  final Color imageColor;
  final Function onTap;
  const SelectPaymentAcc({super.key, required this.imageColor, required this.textColor, required this.containerColor, required this.onTap, required this.bName,  required this.acImage,});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onTap();
      },
      child: Container(
        height: 54,
        width: Get.width * 0.33,
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(10),
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
              padding: const EdgeInsets.only(left: 10.0, right: 5),
              child: SvgPicture.asset(acImage, color: imageColor,),
            ),
            MyText(
              text: bName,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: textColor,
            ),
          ],
        ),
      ),
    );
  }
}
