class Dialect{
  final String id;
  final String name;

  Dialect({
    required this.id,
    required this.name,

  });

  factory Dialect.fromJson(Map<String, dynamic> json) {
    return Dialect(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  @override
  String toString() {
    return 'Dialect(name: $name)';
  }
}