import 'package:flutter/material.dart';

class NButton extends StatelessWidget {
  final Function() onPressed;
  final Function()? onLongPressed;
  final bool isChecked;
  final IconData iconData;
  final Color iconColor;
  final Color iconActiveColor;
  final bool hasText;
  final bool hasIcon;
  final String text;
  final double fontSize;
  final double width;
  final double height;
  final Color defaultTextColor;
  final Color backgroundActiveColor;
  final Color backgroundColor;
  final bool isHoriz;
  const NButton(
      {super.key,
      required this.onPressed,
      required this.isChecked,
      required this.iconData,
      this.onLongPressed,
      this.defaultTextColor = Colors.white,
      this.iconColor = Colors.white,
      this.iconActiveColor = Colors.white,
      this.backgroundColor = const Color.fromARGB(255, 55, 55, 100),
      this.backgroundActiveColor = const Color.fromARGB(255, 255, 128, 0),
      this.hasText = false,
      this.hasIcon = true,
      this.fontSize = 9.0,
      this.text = "",
      this.width = 60,
      this.height = 40,
      this.isHoriz = false});

  @override
  Widget build(BuildContext context) {
    if (!hasText) {
      return SizedBox(
        width: width,
        height: height,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                backgroundColor:
                    isChecked ? backgroundActiveColor : backgroundColor,
                padding: const EdgeInsets.all(1)),
            onPressed: onPressed,
            onLongPress: onLongPressed ?? () {},
            child: hasIcon
                ? Icon(iconData,
                    color: isChecked ? iconActiveColor : iconColor, size: 22)
                : Container(),
          ),
        ),
      );
    } else {
      return SizedBox(
        width: width,
        height: height,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              backgroundColor:
                  isChecked ? backgroundActiveColor : backgroundColor,
              padding: const EdgeInsets.all(1),
            ),
            onPressed: onPressed,
            onLongPress: onLongPressed ?? () {},
            child: isHoriz
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(1, 0, 3, 0),
                        child: hasIcon
                            ? Icon(iconData,
                                color: isChecked ? iconActiveColor : iconColor,
                                size: 15)
                            : Container(),
                      ),
                      Text(
                        text,
                        style: TextStyle(
                          color: defaultTextColor,
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      hasIcon
                          ? Icon(iconData,
                              color: isChecked ? iconActiveColor : iconColor,
                              size: 12)
                          : Container(),
                      Text(
                        text,
                        style: TextStyle(
                          color: defaultTextColor,
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
          ),
        ),
      );
    }
  }
}
