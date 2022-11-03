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
        this.images});

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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
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