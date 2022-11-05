class Incident {
  String? id;
  String? reportedBy;
  String? riskLevel;
  String? location;
  String? description;
  String? immediateActionTaken;
  String? isViewed;
  String? happenedAt;
  String? createdAt;
  String? updatedAt;
  List<Images>? images;
  Reporter? reporter;

  Incident(
      {this.id,
      this.reportedBy,
      this.riskLevel,
      this.location,
      this.description,
      this.immediateActionTaken,
      this.isViewed,
      this.happenedAt,
      this.createdAt,
      this.updatedAt,
      this.images,
      this.reporter});

  Incident.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reportedBy = json['reported_by'];
    riskLevel = json['risk_level'];
    location = json['location'];
    description = json['description'];
    immediateActionTaken = json['immediate_action_taken'];
    isViewed = json['is_viewed'];
    happenedAt = json['happened_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    }
    reporter = json['reporter'] != null
        ? new Reporter.fromJson(json['reporter'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['reported_by'] = reportedBy;
    data['risk_level'] = riskLevel;
    data['location'] = location;
    data['description'] = description;
    data['immediate_action_taken'] = immediateActionTaken;
    data['is_viewed'] = isViewed;
    data['happened_at'] = happenedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    if (reporter != null) {
      data['reporter'] = reporter!.toJson();
    }

    return data;
  }
}

class Images {
  String? id;
  String? incidentId;
  String? path;
  String? createdAt;
  String? updatedAt;

  Images({this.id, this.incidentId, this.path, this.createdAt, this.updatedAt});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    incidentId = json['incident_id'];
    path = json['path'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['incident_id'] = incidentId;
    data['path'] = path;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Reporter {
  String? id;
  String? departmentId;
  String? name;
  String? email;
  String? phoneNumber;
  String? emailVerifiedAt;
  String? isActive;
  String? createdAt;
  String? updatedAt;

  Reporter(
      {this.id,
      this.departmentId,
      this.name,
      this.email,
      this.phoneNumber,
      this.emailVerifiedAt,
      this.isActive,
      this.createdAt,
      this.updatedAt});

  Reporter.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    departmentId = json['department_id'];
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    emailVerifiedAt = json['email_verified_at'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
    return data;
  }
}
