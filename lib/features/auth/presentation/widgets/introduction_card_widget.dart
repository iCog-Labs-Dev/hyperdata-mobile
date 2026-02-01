import 'package:flutter/material.dart';
import 'package:leyu_mobile/core/theme/app_colors.dart';
import 'package:leyu_mobile/core/widgets/image.dart';

import '../../../../core/utils/screen_size.dart';

class IntroductionCardWidget extends StatelessWidget {
  final String imageUrl;
  final double imageHeight;
  final double imageWidth;
  final String primaryTitle;
  final String secondaryTitle;

  const IntroductionCardWidget({
    super.key,
    required this.imageUrl,
    required this.imageHeight,
    required this.imageWidth,
    required this.primaryTitle,
    required this.secondaryTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: getScreenHeight(context) * 0.04),

          // Consistent image container with fixed dimensions
          SizedBox(
            height: imageHeight,
            width: imageWidth,
            child: Center(
              child: assetSvgImageWidget(
                imageUrl,
                height: imageHeight,
                width: imageWidth,
                fit: BoxFit.contain,
              ),
            ),
          ),

          SizedBox(height: getScreenHeight(context) * 0.05),

          // Title
          SizedBox(
            width: getScreenWidth(context) * 0.8,
            child: Center(
              child: Text(
                primaryTitle,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          SizedBox(height: getScreenHeight(context) * 0.025),

          // Description
          SizedBox(
            width: getScreenWidth(context) * 0.9,
            child: Center(
              child: Text(
                secondaryTitle,
                style: const TextStyle(fontSize: 16, color: AppColors.grayText),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
