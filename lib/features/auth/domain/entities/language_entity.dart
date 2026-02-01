import '../../data/models/language.dart';

class LanguageEntity {
  final String id;
  final String code;
  final String name;

  LanguageEntity({
    required this.id,
    required this.code,
    required this.name,
  });

  static LanguageEntity fromModel(Language language) {
    return LanguageEntity(
      id: language.id,
      code: language.code,
      name: language.name,
    );
  }

}