// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_submission_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskSubmissionModelAdapter extends TypeAdapter<TaskSubmissionModel> {
  @override
  final int typeId = 0;

  @override
  TaskSubmissionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskSubmissionModel(
      taskId: fields[0] as String,
      batch: fields[1] as int,
      isTest: fields[2] as bool,
      audioFilePaths: (fields[3] as Map).cast<String, String>(),
      textOutputs: (fields[4] as Map).cast<String, String>(),
      createdAt: fields[5] as DateTime,
      updatedAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, TaskSubmissionModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.taskId)
      ..writeByte(1)
      ..write(obj.batch)
      ..writeByte(2)
      ..write(obj.isTest)
      ..writeByte(3)
      ..write(obj.audioFilePaths)
      ..writeByte(4)
      ..write(obj.textOutputs)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskSubmissionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
