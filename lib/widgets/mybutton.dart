import 'package:flutter/material.dart';
import 'package:mycampuspte/utils/theme/theme.dart';

class Mybutton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget label;
  const Mybutton({super.key, required this.onTap, required this.label});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double width = size.width;
    final double height = size.height;
    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: width,
          height: (width < 550) ? height * 0.05 : height * 0.1,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: buttonColor),
          child: Center(
            // child: Text(
            //   label,
            //   style: GoogleFonts.poppins(
            //       color: white, fontSize: (width < 550) ? 12 : 16),
            // ),
            child: label,
          )),
    );
  }
}
