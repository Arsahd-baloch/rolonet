// class DonationModel {
//   final int? id;
//   final int campaignId;
//   final int? donorId;
//   final String donationType;
//   final double? amount;
//   final int? quantity;
//   final String? donorName;
//   final String? donorEmail;
//   final String? message;
//   final String? status;

//   DonationModel({
//     this.id,
//     required this.campaignId,
//     this.donorId,
//     required this.donationType,
//     this.amount,
//     this.quantity,
//     this.donorName,
//     this.donorEmail,
//     this.message,
//     this.status,
//   });

//   factory DonationModel.fromJson(Map<String, dynamic> json) {
//     return DonationModel(
//       id: int.tryParse(json['id'].toString()),
//       campaignId: int.parse(json['campaign_id'].toString()),
//       donorId: json['donor_id'] != null
//           ? int.tryParse(json['donor_id'].toString())
//           : null,
//       donationType: json['donation_type'] ?? 'MONEY',
//       amount: json['amount'] != null
//           ? double.tryParse(json['amount'].toString())
//           : null,
//       quantity: json['quantity'] != null
//           ? int.tryParse(json['quantity'].toString())
//           : null,
//       donorName: json['donor_name'],
//       donorEmail: json['donor_email'],
//       message: json['message'],
//       status: json['status'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'donation_type': donationType,
//       if (amount != null) 'amount': amount,
//       if (quantity != null) 'quantity': quantity,
//       if (donorName != null && donorName!.isNotEmpty) 'donor_name': donorName,
//       if (donorEmail != null && donorEmail!.isNotEmpty)
//         'donor_email': donorEmail,
//       if (message != null && message!.isNotEmpty) 'message': message,
//     };
//   }
// }

class DonationModel {
  final int? id;
  final int campaignId;
  final int? donorId;
  final String donationType;
  final double? amount;
  final int? quantity;
  final String? donorName;
  final String? donorEmail;
  final String? message;
  final String? status;
  final String? proofImage;
  final String? pickupLocation;
  final DateTime? availableDatetime;

  DonationModel({
    this.id,
    required this.campaignId,
    this.donorId,
    required this.donationType,
    this.amount,
    this.quantity,
    this.donorName,
    this.donorEmail,
    this.message,
    this.status,
    this.proofImage,
    this.pickupLocation,
    this.availableDatetime,
  });

  factory DonationModel.fromJson(Map<String, dynamic> json) {
    return DonationModel(
      id: int.tryParse(json['id'].toString()),
      campaignId: int.parse(json['campaign_id'].toString()),
      donorId: json['donor_id'] != null
          ? int.tryParse(json['donor_id'].toString())
          : null,
      donationType: json['donation_type'] ?? 'MONEY',
      amount: json['amount'] != null
          ? double.tryParse(json['amount'].toString())
          : null,
      quantity: json['quantity'] != null
          ? int.tryParse(json['quantity'].toString())
          : null,
      donorName: json['donor_name'],
      donorEmail: json['donor_email'],
      message: json['message'],
      status: json['status'],
      proofImage: json['proof_image'],
      pickupLocation: json['pickup_location'],
      availableDatetime: json['available_datetime'] != null
          ? DateTime.tryParse(json['available_datetime'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'donation_type': donationType,
      if (amount != null) 'amount': amount,
      if (quantity != null) 'quantity': quantity,
      if (donorName != null && donorName!.isNotEmpty) 'donor_name': donorName,
      if (donorEmail != null && donorEmail!.isNotEmpty) 'donor_email': donorEmail,
      if (message != null && message!.isNotEmpty) 'message': message,
      if (proofImage != null) 'proof_image': proofImage,
      if (pickupLocation != null && pickupLocation!.isNotEmpty) 'pickup_location': pickupLocation,
      if (availableDatetime != null) 'available_datetime': availableDatetime!.toIso8601String(),
    };
  }
}