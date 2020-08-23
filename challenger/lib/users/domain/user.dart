class User {
  final String id;
  final String name;
  final String username;
  final String email;
  final DateTime createdAt;

  const User({this.id, this.name, this.username, this.email, this.createdAt});

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'name': this.name,
      'username': this.username,
      'email': this.email,
      'createdAt': this.createdAt.toIso8601String(),
    };
  }

  factory User.fromJson(Map<String, dynamic> map) {
    return new User(
      id: map['id'] as String,
      name: map['name'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is User &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'User{id: $id, name: $name, username: $username, email: $email, createdAt: $createdAt}';
  }
}


class CreateUserRequest {
  final String name;
  final String username;
  final String email;
  final String password;

  const CreateUserRequest({this.name,this.username,this.email,this.password,});

  Map<String, dynamic> toJson() {
    return {
      'name': this.name,
      'username': this.username,
      'email': this.email,
      'password': this.password,
    };
  }

  factory CreateUserRequest.fromJson(Map<String, dynamic> map) {
    return new CreateUserRequest(
      name: map['name'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CreateUserRequest &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              username == other.username &&
              email == other.email;

  @override
  int get hashCode =>
      name.hashCode ^
      username.hashCode ^
      email.hashCode;

  @override
  String toString() {
    return 'CreateUserRequest{name: $name, username: $username, email: $email}';
  }
}

class LoginUserRequest {
  final String emailOrUsername;
  final String password;

  const LoginUserRequest({this.emailOrUsername, this.password});

  Map<String, dynamic> toJson() {
    return {
      'emailOrUsername': this.emailOrUsername,
      'password': this.password,
    };
  }

  factory LoginUserRequest.fromJson(Map<String, dynamic> map) {
    return new LoginUserRequest(
      emailOrUsername: map['emailOrUsername'] as String,
      password: map['password'] as String,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is LoginUserRequest &&
              runtimeType == other.runtimeType &&
              emailOrUsername == other.emailOrUsername;

  @override
  int get hashCode => emailOrUsername.hashCode;

  @override
  String toString() {
    return 'LoginUserRequest{emailOrUsername: $emailOrUsername}';
  }
}

class UpdateUser {
  final String name;
  final String email;
  final String username;
  final String oldPassword;
  final String newPassword;

  const UpdateUser({
    this.name,
    this.email,
    this.username,
    this.oldPassword,
    this.newPassword,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is UpdateUser &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              email == other.email &&
              username == other.username;

  @override
  int get hashCode =>
      name.hashCode ^
      email.hashCode ^
      username.hashCode;

  @override
  String toString() {
    return 'UpdateUser{name: $name, email: $email, username: $username}';
  }

  Map<String, dynamic> toJson() {
    return {
      'name': this.name,
      'email': this.email,
      'username': this.username,
      'oldPassword': this.oldPassword,
      'newPassword': this.newPassword,
    };
  }

  factory UpdateUser.fromJson(Map<String, dynamic> map) {
    return new UpdateUser(
      name: map['name'] as String,
      email: map['email'] as String,
      username: map['username'] as String,
      oldPassword: map['oldPassword'] as String,
      newPassword: map['newPassword'] as String,
    );
  }
}