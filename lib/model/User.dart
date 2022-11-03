class User {
  String? id;
  String? departmentId;
  String? name;
  String? email;
  String? phoneNumber;
  String? emailVerifiedAt;
  String? isActive;
  String? createdAt;
  String? updatedAt;
  List<Roles>? roles;

  User(
      {this.id,
        this.departmentId,
        this.name,
        this.email,
        this.phoneNumber,
        this.emailVerifiedAt,
        this.isActive,
        this.createdAt,
        this.updatedAt,
        this.roles
      });

   User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    departmentId = json['department_id'].toString();
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    emailVerifiedAt = json['email_verified_at'].toString();
    isActive = json['is_active'];
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    if (json['roles'] != null) {
      roles = <Roles>[];
      json['roles'].forEach((v) {
        roles!.add(Roles.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['department_id'] = departmentId;
    data['name'] = name;
    data['email'] = email;
    data['phone_number'] = phoneNumber;
    data['email_verified_at'] = emailVerifiedAt;
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (roles != null) {
      data['roles'] = roles!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Roles {
  int? id;
  String? name;
  String? guardName;
  String? createdAt;
  String? updatedAt;
  Pivot? pivot;

  Roles(
      {this.id,
        this.name,
        this.guardName,
        this.createdAt,
        this.updatedAt,
        this.pivot});

  Roles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    guardName = json['guard_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pivot = json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['guard_name'] = guardName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (pivot != null) {
      data['pivot'] = pivot!.toJson();
    }
    return data;
  }
}

class Pivot {
  String? modelId;
  String? roleId;
  String? modelType;

  Pivot({this.modelId, this.roleId, this.modelType});

  Pivot.fromJson(Map<String, dynamic> json) {
    modelId = json['model_id'];
    roleId = json['role_id'];
    modelType = json['model_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['model_id'] = modelId;
    data['role_id'] = roleId;
    data['model_type'] = modelType;
    return data;
  }
}


