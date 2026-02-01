import 'package:hive/hive.dart';

part 'task_submission_model.g.dart';

@HiveType(typeId: 0)
class TaskSubmissionModel extends HiveObject {
  @HiveField(0)
  final String taskId;

  @HiveField(1)
  final int batch;

  @HiveField(2)
  final bool isTest;

  @HiveField(3)
  final Map<String, String> audioFilePaths;

  @HiveField(4)
  final Map<String, String> textOutputs;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final DateTime updatedAt;

  TaskSubmissionModel({
    required this.taskId,
    required this.batch,
    required this.isTest,
    required this.audioFilePaths,
    required this.textOutputs,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'taskId': taskId,
      'batch': batch,
      'isTest': isTest,
      'audioFilePaths': audioFilePaths,
      'textOutputs': textOutputs,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory TaskSubmissionModel.fromMap(Map<String, dynamic> map) {
    return TaskSubmissionModel(
      taskId: map['taskId'] as String,
      batch: map['batch'] as int,
      isTest: map['isTest'] as bool,
      audioFilePaths: Map<String, String>.from(map['audioFilePaths'] as Map),
      textOutputs: Map<String, String>.from(map['textOutputs'] as Map),
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  TaskSubmissionModel copyWith({
    String? taskId,
    int? batch,
    bool? isTest,
    Map<String, String>? audioFilePaths,
    Map<String, String>? textOutputs,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TaskSubmissionModel(
      taskId: taskId ?? this.taskId,
      batch: batch ?? this.batch,
      isTest: isTest ?? this.isTest,
      audioFilePaths: audioFilePaths ?? this.audioFilePaths,
      textOutputs: textOutputs ?? this.textOutputs,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
