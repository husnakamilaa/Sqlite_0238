import 'package:sqlite/domain/entities/user_entity.dart';

abstract class UserEvent {}
class LoadUsers extends UserEvent {}
class AddUserEvent extends UserEvent {
  final UserEntity user;
  AddUserEvent(this.user);
}
