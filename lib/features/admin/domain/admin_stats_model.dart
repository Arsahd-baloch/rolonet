class AdminStatsModel {
  final int totalUsers;
  final int totalNgos;
  final int activeCampaigns;
  final int totalDonations;

  AdminStatsModel({
    required this.totalUsers,
    required this.totalNgos,
    required this.activeCampaigns,
    required this.totalDonations,
  });

  factory AdminStatsModel.fromJson(Map<String, dynamic> json) {
    return AdminStatsModel(
      totalUsers: int.parse(json['total_users'].toString()),
      totalNgos: int.parse(json['total_ngos'].toString()),
      activeCampaigns: int.parse(json['active_campaigns'].toString()),
      totalDonations: int.parse(json['total_donations'].toString()),
    );
  }
}

// ── Pending Donations Model ──
class PendingDonationModel {
  final int id;
  final int campaignId;
  final double? amount;
  final String status;
  final String? donationType; // ← NEW: MONEY | ITEMS | BOTH
  final int? quantity; // ← NEW
  final String? proofImage; // ← NEW: Cloudinary URL
  final String? pickupLocation; // ← NEW
  final DateTime? availableDatetime; // ← NEW

  PendingDonationModel({
    required this.id,
    required this.campaignId,
    this.amount,
    required this.status,
    this.donationType,
    this.quantity,
    this.proofImage,
    this.pickupLocation,
    this.availableDatetime,
  });

  factory PendingDonationModel.fromJson(Map<String, dynamic> json) {
    return PendingDonationModel(
      id: int.parse(json['id'].toString()),
      campaignId: int.parse(json['campaign_id'].toString()),
      amount: json['amount'] != null
          ? double.tryParse(json['amount'].toString())
          : null,
      status: json['status'] ?? 'PENDING',
      donationType: json['donation_type'],
      quantity: json['quantity'] != null
          ? int.tryParse(json['quantity'].toString())
          : null,
      proofImage: json['proof_image'],
      pickupLocation: json['pickup_location'],
      availableDatetime: json['available_datetime'] != null
          ? DateTime.tryParse(json['available_datetime'].toString())
          : null,
    );
  }
}

// ── Pending NGO Model ──
class PendingNgoModel {
  final int id;
  final String name;
  final String? registrationNumber;

  PendingNgoModel({
    required this.id,
    required this.name,
    this.registrationNumber,
  });

  factory PendingNgoModel.fromJson(Map<String, dynamic> json) {
    return PendingNgoModel(
      id: int.parse(json['id'].toString()),
      name: json['name'] ?? '',
      registrationNumber: json['registration_number'],
    );
  }
}

// ── Recent Action Model ──
class RecentActionModel {
  final String? userName;
  final String action;
  final String entityType;
  final DateTime createdAt;

  RecentActionModel({
    this.userName,
    required this.action,
    required this.entityType,
    required this.createdAt,
  });

  factory RecentActionModel.fromJson(Map<String, dynamic> json) {
    return RecentActionModel(
      userName: json['name'],
      action: json['action'] ?? '',
      entityType: json['entity_type'] ?? '',
      createdAt:
          DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now(),
    );
  }
}
