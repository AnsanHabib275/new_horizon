class Notificationmodel {
  final String notificationId;
  final String notificationHeading;
  final String notificationDetails;
  final String notificationType;
  final String createdAt;
  final bool isViewed;

  Notificationmodel({
    required this.notificationId,
    required this.notificationHeading,
    required this.notificationDetails,
    required this.notificationType,
    required this.createdAt,
    required this.isViewed,
  });

  factory Notificationmodel.fromJson(Map<String, dynamic> json) {
    return Notificationmodel(
      notificationId: json['notification_id'],
      notificationHeading: json['notification_heading'],
      notificationDetails: json['notification_details'],
      notificationType: json['notification_type'],
      createdAt: json['created_at'],
      isViewed: json['is_viewed'],
    );
  }
}
