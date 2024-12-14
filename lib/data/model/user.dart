import 'package:flutter/foundation.dart';

class User {
  User({
    this.idUser,
    this.name,
    this.email,
    this.kelas,
    this.status,
    this.password,
    this.createdAt,
    this.updatedAt,
  });

  String? idUser;
  String? name;
  String? email;
  String? kelas;
  String? status;
  String? password;
  String? createdAt;
  String? updatedAt;

  // Named constructor to create User object from JSON
  factory User.fromJson(Map<String, dynamic> json) => User(
    idUser: json["id"],
    name: json["name"],
    email: json["email"],
    kelas: json["kelas"],
    status: json["status"],
    password: json["password"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  // Convert User object to JSON
  Map<String, dynamic> toJson() => {
    "id": idUser,
    "name": name,
    "email": email,
    "kelas": kelas,
    "status": status,
    "password": password,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };

  // Setter for status to update absensi
  void updateStatus(String newStatus) {
    status = newStatus;
  }
}
