import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/onboarding_service.dart';
import '../../domain/entities/task_type_enum.dart';

class TaskSubmissionOnboarding {
  final BuildContext context;
  final TaskType taskType;
  final GlobalKey backButtonKey;
  final GlobalKey titleKey;
  final GlobalKey infoButtonKey;
  final GlobalKey progressKey;
  final GlobalKey? navigationKey;

  // Task-specific widget keys
  final GlobalKey? taskSpecificKey1;
  final GlobalKey? taskSpecificKey2;
  final GlobalKey? taskSpecificKey3;

  TutorialCoachMark? _tutorialCoachMark;

  TaskSubmissionOnboarding({
    required this.context,
    required this.taskType,
    required this.backButtonKey,
    required this.titleKey,
    required this.infoButtonKey,
    required this.progressKey,
    this.navigationKey,
    this.taskSpecificKey1,
    this.taskSpecificKey2,
    this.taskSpecificKey3,
  });

  /// Show the onboarding tutorial if not seen before for this task type
  void showIfNeeded() {
    if (!_hasSeenOnboarding()) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!context.mounted) return;
        show();
      });
    }
  }

  /// Force show the tutorial (for help button)
  void show() {
    if (!context.mounted) return;
    _createTutorial();
    _tutorialCoachMark?.show(context: context);
  }

  bool _hasSeenOnboarding() {
    switch (taskType) {
      case TaskType.Text_to_Speech:
        return OnboardingService.hasSeenTTSOnboarding();
      case TaskType.Text_to_Text:
        return OnboardingService.hasSeenTTTOnboarding();
      case TaskType.Speech_to_Text:
        return OnboardingService.hasSeenSTTOnboarding();
      default:
        return true;
    }
  }

  void _markAsSeen() {
    switch (taskType) {
      case TaskType.Text_to_Speech:
        OnboardingService.markTTSOnboardingAsSeen();
        break;
      case TaskType.Text_to_Text:
        OnboardingService.markTTTOnboardingAsSeen();
        break;
      case TaskType.Speech_to_Text:
        OnboardingService.markSTTOnboardingAsSeen();
        break;
      default:
        break;
    }
  }

  void _createTutorial() {
    _tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: AppColors.primary,
      paddingFocus: 10,
      opacityShadow: 0.8,
      hideSkip: true, // Hide default skip button to avoid overlap
      onFinish: _markAsSeen,
      onSkip: () {
        _markAsSeen();
        return true;
      },
    );
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];

    // 1. Back Button
    targets.add(
      TargetFocus(
        identify: "back_button",
        keyTarget: backButtonKey,
        alignSkip: Alignment.topRight,
        shape: ShapeLightFocus.Circle,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return _buildContent(
                title: 'onboarding.task_submission.back_button_title'.tr,
                description: 'onboarding.task_submission.back_button_desc'.tr,
                icon: Icons.arrow_back,
              );
            },
          ),
        ],
      ),
    );

    // 2. Task Title
    targets.add(
      TargetFocus(
        identify: "task_title",
        keyTarget: titleKey,
        alignSkip: Alignment.topRight,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return _buildContent(
                title: 'onboarding.task_submission.title_title'.tr,
                description: 'onboarding.task_submission.title_desc'.tr,
                icon: Icons.title,
              );
            },
          ),
        ],
      ),
    );

    // 3. Info Button
    targets.add(
      TargetFocus(
        identify: "info_button",
        keyTarget: infoButtonKey,
        alignSkip: Alignment.topRight,
        shape: ShapeLightFocus.Circle,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return _buildContent(
                title: 'onboarding.task_submission.info_button_title'.tr,
                description: 'onboarding.task_submission.info_button_desc'.tr,
                icon: Icons.info_outline,
              );
            },
          ),
        ],
      ),
    );

    // 4. Progress Indicator
    targets.add(
      TargetFocus(
        identify: "progress",
        keyTarget: progressKey,
        alignSkip: Alignment.topRight,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return _buildContent(
                title: 'onboarding.task_submission.progress_title'.tr,
                description: 'onboarding.task_submission.progress_desc'.tr,
                icon: Icons.track_changes,
              );
            },
          ),
        ],
      ),
    );

    // 5-7. Task-specific widget elements
    _addTaskSpecificTargets(targets);

    // 8. Navigation Buttons (if available)
    if (navigationKey != null) {
      targets.add(
        TargetFocus(
          identify: "navigation",
          keyTarget: navigationKey!,
          alignSkip: Alignment.topRight,
          shape: ShapeLightFocus.RRect,
          radius: 12,
          contents: [
            TargetContent(
              align: ContentAlign.left,
              builder: (context, controller) {
                return _buildContent(
                  title: 'onboarding.task_submission.navigation_title'.tr,
                  description: 'onboarding.task_submission.navigation_desc'.tr,
                  icon: Icons.swap_vert,
                );
              },
            ),
          ],
        ),
      );
    }

    return targets;
  }

  void _addTaskSpecificTargets(List<TargetFocus> targets) {
    switch (taskType) {
      case TaskType.Text_to_Speech:
        _addTextToSpeechTargets(targets);
        break;
      case TaskType.Text_to_Text:
        _addTextToTextTargets(targets);
        break;
      case TaskType.Speech_to_Text:
        _addSpeechToTextTargets(targets);
        break;
      default:
        break;
    }
  }

  void _addTextToSpeechTargets(List<TargetFocus> targets) {
    // Microphone/Recording button
    if (taskSpecificKey1 != null) {
      targets.add(
        TargetFocus(
          identify: "tts_mic_button",
          keyTarget: taskSpecificKey1!,
          alignSkip: Alignment.topRight,
          shape: ShapeLightFocus.Circle,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              builder: (context, controller) {
                return _buildContent(
                  title: 'onboarding.tts.mic_button_title'.tr,
                  description: 'onboarding.tts.mic_button_desc'.tr,
                  icon: Icons.mic,
                );
              },
            ),
          ],
        ),
      );
    }

    // Submit/Check button
    if (taskSpecificKey2 != null) {
      targets.add(
        TargetFocus(
          identify: "tts_submit_button",
          keyTarget: taskSpecificKey2!,
          alignSkip: Alignment.topRight,
          shape: ShapeLightFocus.Circle,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              builder: (context, controller) {
                return _buildContent(
                  title: 'onboarding.tts.submit_button_title'.tr,
                  description: 'onboarding.tts.submit_button_desc'.tr,
                  icon: Icons.check,
                );
              },
            ),
          ],
        ),
      );
    }

    // Restart button
    if (taskSpecificKey3 != null) {
      targets.add(
        TargetFocus(
          identify: "tts_restart_button",
          keyTarget: taskSpecificKey3!,
          alignSkip: Alignment.topRight,
          shape: ShapeLightFocus.Circle,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              builder: (context, controller) {
                return _buildContent(
                  title: 'onboarding.tts.restart_button_title'.tr,
                  description: 'onboarding.tts.restart_button_desc'.tr,
                  icon: Icons.restart_alt,
                );
              },
            ),
          ],
        ),
      );
    }
  }

  void _addTextToTextTargets(List<TargetFocus> targets) {
    // Text input field
    if (taskSpecificKey1 != null) {
      targets.add(
        TargetFocus(
          identify: "ttt_text_input",
          keyTarget: taskSpecificKey1!,
          alignSkip: Alignment.topRight,
          shape: ShapeLightFocus.RRect,
          radius: 12,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              builder: (context, controller) {
                return _buildContent(
                  title: 'onboarding.ttt.text_input_title'.tr,
                  description: 'onboarding.ttt.text_input_desc'.tr,
                  icon: Icons.edit,
                );
              },
            ),
          ],
        ),
      );
    }

    // Submit button
    if (taskSpecificKey2 != null) {
      targets.add(
        TargetFocus(
          identify: "ttt_submit_button",
          keyTarget: taskSpecificKey2!,
          alignSkip: Alignment.topRight,
          shape: ShapeLightFocus.RRect,
          radius: 8,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              builder: (context, controller) {
                return _buildContent(
                  title: 'onboarding.ttt.submit_button_title'.tr,
                  description: 'onboarding.ttt.submit_button_desc'.tr,
                  icon: Icons.send,
                );
              },
            ),
          ],
        ),
      );
    }

    // Cancel button
    if (taskSpecificKey3 != null) {
      targets.add(
        TargetFocus(
          identify: "ttt_cancel_button",
          keyTarget: taskSpecificKey3!,
          alignSkip: Alignment.topRight,
          shape: ShapeLightFocus.RRect,
          radius: 8,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              builder: (context, controller) {
                return _buildContent(
                  title: 'onboarding.ttt.cancel_button_title'.tr,
                  description: 'onboarding.ttt.cancel_button_desc'.tr,
                  icon: Icons.cancel,
                );
              },
            ),
          ],
        ),
      );
    }
  }

  void _addSpeechToTextTargets(List<TargetFocus> targets) {
    // Audio player
    if (taskSpecificKey1 != null) {
      targets.add(
        TargetFocus(
          identify: "stt_audio_player",
          keyTarget: taskSpecificKey1!,
          alignSkip: Alignment.topRight,
          shape: ShapeLightFocus.RRect,
          radius: 12,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              builder: (context, controller) {
                return _buildContent(
                  title: 'onboarding.stt.audio_player_title'.tr,
                  description: 'onboarding.stt.audio_player_desc'.tr,
                  icon: Icons.headphones,
                );
              },
            ),
          ],
        ),
      );
    }

    // Text input field
    if (taskSpecificKey2 != null) {
      targets.add(
        TargetFocus(
          identify: "stt_text_input",
          keyTarget: taskSpecificKey2!,
          alignSkip: Alignment.topRight,
          shape: ShapeLightFocus.RRect,
          radius: 12,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              builder: (context, controller) {
                return _buildContent(
                  title: 'onboarding.stt.text_input_title'.tr,
                  description: 'onboarding.stt.text_input_desc'.tr,
                  icon: Icons.edit,
                );
              },
            ),
          ],
        ),
      );
    }

    // Submit button
    if (taskSpecificKey3 != null) {
      targets.add(
        TargetFocus(
          identify: "stt_submit_button",
          keyTarget: taskSpecificKey3!,
          alignSkip: Alignment.topRight,
          shape: ShapeLightFocus.RRect,
          radius: 8,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              builder: (context, controller) {
                return _buildContent(
                  title: 'onboarding.stt.submit_button_title'.tr,
                  description: 'onboarding.stt.submit_button_desc'.tr,
                  icon: Icons.send,
                );
              },
            ),
          ],
        ),
      );
    }
  }

  Widget _buildContent({
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          // Custom navigation buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Skip button
              TextButton(
                onPressed: () {
                  _tutorialCoachMark?.skip();
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey[600],
                ),
                child: Text('common.skip'.tr),
              ),
              const SizedBox(width: 8),
              // Next button
              ElevatedButton(
                onPressed: () {
                  _tutorialCoachMark?.next();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('common.next'.tr),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
