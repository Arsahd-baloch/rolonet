class CampaignModel {
  final int? id;
  final String title;
  final String description;
  final String donationType;
  final double? goalAmount;
  final String status;

  CampaignModel({
    this.id,
    required this.title,
    required this.description,
    required this.donationType,
    this.goalAmount,
    this.status = "DRAFT",
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "donation_type": donationType,
      "goal_amount": goalAmount,
      "status": status,
    };
  }
}