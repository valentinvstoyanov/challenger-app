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
      'createdAt': this.createdAt,
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
              id == other.id &&
              name == other.name &&
              username == other.username &&
              email == other.email &&
              createdAt == other.createdAt;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      username.hashCode ^
      email.hashCode ^
      createdAt.hashCode;

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
              email == other.email &&
              password == other.password;

  @override
  int get hashCode =>
      name.hashCode ^
      username.hashCode ^
      email.hashCode ^
      password.hashCode;

  @override
  String toString() {
    return 'CreateUserRequest{name: $name, username: $username, email: $email, password: $password}';
  }
}