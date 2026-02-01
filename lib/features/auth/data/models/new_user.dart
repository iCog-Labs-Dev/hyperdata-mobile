class NewUser {
  String firstName;
  String middleName;
  String lastName;
  String birthDate;
  String gender;
  String languageId;
  String dialectId;
  String email;
  String password;

  NewUser({
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.birthDate,
    required this.gender,
    required this.languageId,
    required this.dialectId,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'first_name': firstName,
    'middle_name': middleName,
    'last_name': lastName,
    'email': email,
    'password': password,
    'birth_date': birthDate,
    'gender': gender,
    'dialect_id': dialectId,
    'language_id': languageId,
  };
}