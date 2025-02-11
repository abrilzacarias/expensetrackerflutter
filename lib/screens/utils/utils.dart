import 'package:flutter/cupertino.dart';

// Function to get the icon from the name stored in the database
IconData getCupertinoIcon(String iconName) {
  final Map<String, IconData> cupertinoIconsMap = {
    "cart": CupertinoIcons.cart,
    "car": CupertinoIcons.car,
    "tv": CupertinoIcons.tv,
    "heart": CupertinoIcons.heart,
    "book": CupertinoIcons.book,
    "bag": CupertinoIcons.bag,
    "money_dollar": CupertinoIcons.money_dollar,
    "paw": CupertinoIcons.paw,
    "circle": CupertinoIcons.circle,
  };

  return cupertinoIconsMap[iconName] ?? CupertinoIcons.question;
}


Color getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');

    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }

    return Color(int.parse(hexColor, radix: 16));
  }