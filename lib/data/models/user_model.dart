import 'package:sqlite/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.name,
    required super.email,
  });

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }

 
}