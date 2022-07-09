class LeaveModel {
  int? id;
  String? leaveDate;
  String? leaveFor;
  String? description;
  String? status;
  String? requestedBy;
  String? signatureImagePath;

  LeaveModel(
      {this.id,
      this.leaveDate,
      this.leaveFor,
      this.description,
      this.status,
      this.requestedBy,
      this.signatureImagePath});

  LeaveModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    leaveDate = json['leaveDate'];
    leaveFor = json['leaveFor'];
    description = json['description'];
    status = json['status'];
    requestedBy = json['requestedBy'];
    signatureImagePath = json['signatureImagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['leaveDate'] = leaveDate;
    data['leaveFor'] = leaveFor;
    data['description'] = description;
    data['status'] = status;
    data['requestedBy'] = requestedBy;
    data['signatureImagePath'] = signatureImagePath;
    return data;
  }
}
