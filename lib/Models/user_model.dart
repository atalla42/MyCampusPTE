import 'dart:convert';

class UserModel {
  String firstName;
  String lastName;
  final String email;
  final String neptuneCode;
  final String role;
   String faculty;
   int yearOfStudy;
  UserModel(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.role,
      required this.neptuneCode,
      required this.faculty,
      required this.yearOfStudy});

  UserModel copyWith(
      {String? firstName,
      String? lastName,
      String? email,
      String? password,
      String? role,
      String? neptuneCode,
      String? faculty,
      int? yearOfStudy}) {
    return UserModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      role: email ?? this.role,
      neptuneCode: neptuneCode ?? this.neptuneCode,
      faculty: faculty ?? this.faculty,
      yearOfStudy: yearOfStudy ?? this.yearOfStudy,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'role': role,
      'neptuneCode': neptuneCode,
      'faculty': faculty,
      'yearOfStudy': yearOfStudy
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? '',
      neptuneCode: map['neptuneCode'] ?? '',
      faculty: map['faculty'] ?? '',
      yearOfStudy: map['yearOfStudy'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(firstName: $firstName, lastName: $lastName, email: $email, neptuneCode: $neptuneCode, role: $role, yearOfStudy: $yearOfStudy, faculty: $faculty)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.email == email &&
        other.role == role &&
        other.neptuneCode == neptuneCode &&
        other.faculty == faculty &&
        other.yearOfStudy == yearOfStudy;
  }

  @override
  int get hashCode {
    return firstName.hashCode ^
        lastName.hashCode ^
        email.hashCode ^
        role.hashCode ^
        neptuneCode.hashCode ^
        faculty.hashCode ^
        yearOfStudy.hashCode;
  }
}
