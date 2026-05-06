class CampaignModel {
  final int id;
  final String title;
  final String description;
  final String status;
  final double goalAmount;
  final double totalAmount;
  final int donorCount;
  final int goalQuantity;
  final int totalQuantity;
  final String? donationType;

  CampaignModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.goalAmount,
    required this.totalAmount,
    required this.donorCount,
    required this.goalQuantity,
    required this.totalQuantity,
    this.donationType,
  });

  // ================= FROM JSON =================
  factory CampaignModel.fromJson(Map<String, dynamic> json) {
    int toInt(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    double toDouble(dynamic value) {
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return CampaignModel(
      id: toInt(json['id']),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 'DRAFT',
      goalAmount: toDouble(json['goal_amount']),
      totalAmount: toDouble(json['total_amount']),
      donorCount: toInt(json['donor_count']),
      goalQuantity: toInt(json['goal_quantity']),
      totalQuantity: toInt(json['total_quantity']),
      donationType: (json['donation_type'] as String?)?.toUpperCase() ?? 'MONEY',
    );
  }

  // ================= COPY WITH ✅ NEW =================
  CampaignModel copyWith({
    int? id,
    String? title,
    String? description,
    String? status,
    double? goalAmount,
    double? totalAmount,
    int? donorCount,
    int? goalQuantity,
    int? totalQuantity,
    String? donationType,
  }) {
    return CampaignModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      goalAmount: goalAmount ?? this.goalAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      donorCount: donorCount ?? this.donorCount,
      goalQuantity: goalQuantity ?? this.goalQuantity,
      totalQuantity: totalQuantity ?? this.totalQuantity,
      donationType: donationType ?? this.donationType,
    );
  }

  // ================= SAFE DONATION TYPE =================
  String get safeDonationType {
    switch ((donationType ?? '').toUpperCase()) {
      case "MONEY":
        return "Money";
      case "ITEMS":
        return "Items";
      case "BOTH":
        return "Both";
      default:
        return "Not Set";
    }
  }

  // ================= FOR CREATE =================
  Map<String, dynamic> toCreateJson() {
    return {
      'title': title,
      'description': description,
      'status': status,
      'goal_amount': goalAmount,
      'donation_type': donationType ?? 'MONEY',
    };
  }

  // ================= FOR UPDATE ✅ NEW =================
  Map<String, dynamic> toUpdateJson() {
    return {
      'title': title,
      'description': description,
      //'status': status,
      'goal_amount': goalAmount,
      'donation_type': donationType ?? 'MONEY',
    };
  }

  // ================= FOR READ =================
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'goal_amount': goalAmount,
      'total_amount': totalAmount,
      'donor_count': donorCount,
      'goal_quantity': goalQuantity,
      'total_quantity': totalQuantity,
      'donation_type': donationType,
    };
  }

  // ================= PROGRESS =================
  double get progress {
    if (goalAmount > 0) return totalAmount / goalAmount;
    if (goalQuantity > 0) return totalQuantity / goalQuantity;
    return 0;
  }
}