class Role {
  final int id;
  final String name;

  Role({required this.id, required this.name});

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

class ClassModel {
  final int id;
  final String name;

  ClassModel({required this.id, required this.name});

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

class UserModel {
  final int id;
  final String name;
  final String username;
  final Role role;
  final ClassModel classModel;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.role,
    required this.classModel,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      role: Role.fromJson(json['role']),
      classModel: ClassModel.fromJson(json['class']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'role': role.toJson(),
      'class': classModel.toJson(),
    };
  }
}
