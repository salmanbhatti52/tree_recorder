import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:inbetrieb/resources/appColors.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final String hintText;
  final TextInputType keyboardType;
  final Function(String)? onChanged;
  final double? width;
  final double? height;
  final Function(String)? onFieldSubmitted;
  final bool obscureText;
  final String? Function(String?)? validator;
  const CustomTextFormField({
    Key? key,
    required this.controller,
    this.textInputAction = TextInputAction.done,
    required this.hintText,
    this.obscureText = false,
    this.height,
    this.width,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.focusNode,
    this.onFieldSubmitted,
    this.validator
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        style: const TextStyle(
          fontFamily: "SF Pro Display",
        fontSize: 14,
        color: AppColor.secondaryColor,
        fontWeight: FontWeight.w400,
      ),
        obscureText: obscureText,
        textAlign: TextAlign.left,
        textInputAction: textInputAction,
        validator: validator,
        cursorColor: AppColor.primaryColor,
        controller: controller,
        keyboardType: keyboardType,
        onChanged: onChanged,
        focusNode: focusNode,
        onFieldSubmitted: onFieldSubmitted,
        decoration: InputDecoration(
          fillColor: AppColor.whiteColor,
          filled: true,
          contentPadding:  EdgeInsets.symmetric(horizontal: Get.width * 0.05, vertical: 10),
          hintText: hintText,
          hintStyle: const TextStyle(
            fontFamily: "SF Pro Display",
            fontSize: 14,
            color: AppColor.secondaryColor,
            fontWeight: FontWeight.w400,
          ),
          enabledBorder:  OutlineInputBorder(
            borderSide: const BorderSide(width: 2, color: AppColor.borderColor),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder:  OutlineInputBorder(
            borderSide: const BorderSide(width: 2, color: AppColor.primaryColor),
            borderRadius: BorderRadius.circular(12),
          ),
          errorStyle: const TextStyle(
            fontFamily: "SF Pro Display",
            fontSize: 14,
            color: AppColor.secondaryColor,
            fontWeight: FontWeight.w400,
          ),
          errorBorder:  OutlineInputBorder(
            borderSide: const BorderSide(width: 2, color: Colors.red),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedErrorBorder:  OutlineInputBorder(
            borderSide: const BorderSide(width: 2, color: Colors.red),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}