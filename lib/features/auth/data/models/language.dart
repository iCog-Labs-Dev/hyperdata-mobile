class Language{
  final String id;
  final String code;
  final String name;

  Language({
    required this.id,
    required this.code,
    required this.name,
  });

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      id: json['id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
    );
  }

  @override
  String toString() {
    return 'Language(code: $code, name: $name)';
  }
}