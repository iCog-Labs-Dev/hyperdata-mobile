import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leyu_mobile/core/theme/app_colors.dart';
import 'package:leyu_mobile/core/widgets/button.dart';

import '../../../../core/utils/screen_size.dart';
import '../controllers/introduction_controller.dart';
import '../widgets/introduction_card_widget.dart';

class IntroductionPage extends StatelessWidget {
  IntroductionPage({super.key});

  final IntroductionController introductionController = Get.put(
    IntroductionController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity != null) {
                if (details.primaryVelocity! < 0) {
                  // Swipe left (next page)
                  introductionController.next(isSwiped: true);
                } else if (details.primaryVelocity! > 0) {
                  // Swipe right (previous page)
                  introductionController.previous();
                }
              }
            },
            child: Obx(
              () => SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Animated page content with consistent sizing
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 600),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                      child: _buildPage(
                        context,
                        introductionController.pageIndex.value,
                      ),
                    ),
                    SizedBox(height: getScreenHeight(context) * 0.03),

                    // Page indicators
                    _buildPageIndicators(context),

                    SizedBox(height: getScreenHeight(context) * 0.075),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Obx(
        () => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: ButtonWidget(
            onPressed: () {
              introductionController.next();
            },
            text: introductionController.pageIndex.value < 2
                ? "Next".tr
                : "Get Started".tr,
            width: getScreenWidth(context) * 0.7,
            height: 50,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicators(BuildContext context) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (int i = 0; i < 3; i++)
            InkWell(
              onTap: () {
                introductionController.pageIndex.value = i;
              },
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: introductionController.pageIndex.value == i
                      ? AppColors.primary
                      : AppColors.primary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(15),
                ),
                width: introductionController.pageIndex.value == i ? 40 : 18,
                height: 12,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPage(BuildContext context, int pageIndex) {
    // Consistent image size for all pages
    final imageHeight = getScreenHeight(context) * 0.35;
    final imageWidth = getScreenWidth(context) * 0.8;

    switch (pageIndex) {
      case 0:
        return IntroductionCardWidget(
          key: const ValueKey(0),
          imageUrl: "intro-1.svg",
          imageHeight: imageHeight,
          imageWidth: imageWidth,
          primaryTitle: "Choose a task",
          secondaryTitle:
              "Explore a wide range of tasks tailored to your interests and skills, and select one to kickstart your journey in the app."
                  .tr,
        );
      case 1:
        return IntroductionCardWidget(
          key: const ValueKey(1),
          imageUrl: "intro-2.svg",
          imageHeight: imageHeight,
          imageWidth: imageWidth,
          primaryTitle: "Start Recording",
          secondaryTitle:
              "Begin capturing your progress by recording text, audio, or other responses to complete your tasks efficiently and accurately."
                  .tr,
        );
      case 2:
        return IntroductionCardWidget(
          key: const ValueKey(2),
          imageUrl: "intro-3.svg",
          imageHeight: imageHeight,
          imageWidth: imageWidth,
          primaryTitle: "Scroll for the next task",
          secondaryTitle:
              "Easily navigate to the next task by scrolling when you're ready, keeping your workflow smooth and uninterrupted."
                  .tr,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
