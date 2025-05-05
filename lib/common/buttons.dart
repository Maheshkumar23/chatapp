import 'package:flutter/material.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:orange_ui/utils/font_res.dart';

class SubmitButton1 extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const SubmitButton1({Key? key, required this.title, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ColorRes.lightOrange,
              ColorRes.darkOrange,
            ],
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: ColorRes.white,
              fontSize: 15,
              fontFamily: FontRes.semiBold,
            ),
          ),
        ),
      ),
    );
  }
}

class SubmitButton2 extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const SubmitButton2({Key? key, required this.title, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ColorRes.lightOrange,
              ColorRes.darkOrange,
            ],
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: ColorRes.white,
              fontSize: 14,
              fontWeight: FontWeight.w300,
              fontFamily: FontRes.bold,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}
