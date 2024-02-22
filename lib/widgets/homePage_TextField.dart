import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inbetrieb/resources/appColors.dart';

class HomeTextField extends StatelessWidget {
  final Function(String)? onFieldSubmitted;
  const HomeTextField({super.key, this.onFieldSubmitted,});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: 50,
      decoration: const BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 50,
            decoration: const BoxDecoration(
              color: Color(0xFF05425C),
            ),
          ),
          SizedBox(
            width: Get.width * 0.87,
            child: TextFormField(
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(top: 15),
                prefixIcon: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                ),
              ),
              autofocus: true,
              onFieldSubmitted: onFieldSubmitted,
            ),
          ),
        ],
      ),
    );
  }
}
