// ignore_for_file: non_constant_identifier_names

class AllDoctors {
  final String state;

  final String clinic_name;
  final String available_days;
  final String website;
  final String address;
  final String image_url;
  final String category;
  final double latitude;
  final double longitude;
  final String contact;
  final String formatted_opening_hours;

  AllDoctors({
    required this.state,
    required this.clinic_name,
    required this.available_days,
    required this.website,
    required this.address,
    required this.image_url,
    required this.category,
    required this.latitude,
    required this.longitude,
    required this.contact,
    required this.formatted_opening_hours,
  });

  factory AllDoctors.fromJson(Map<String, dynamic> json) {
    return AllDoctors(
      state: json['state'] ?? 'Unknown', // Default value to avoid null

      clinic_name: json['clinic_name'] ?? 'N/A',
      available_days: json['available_days'] ?? 'N/A',
      website: json['website'] ?? 'N/A',
      address: json['address'] ?? 'N/A',
      image_url: json['image_url'] ?? 'N/A',
      category: json['category'] ?? 'N/A',
      latitude: json['latitude'] is String
          ? double.tryParse(json['latitude']) ?? 0.0
          : (json['latitude'] as num).toDouble(),
      longitude: json['longitude'] is String
          ? double.tryParse(json['longitude']) ?? 0.0
          : (json['longitude'] as num).toDouble(),
      contact: json['contact'] ?? 'N/A',
      formatted_opening_hours: json['formatted_opening_hours'] ?? 'N/A',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'state': state,
      'clinic_name': clinic_name,
      'available_days': available_days,
      'website': website,
      'address': address,
      'image_url': image_url,
      'category': category,
      'latitude': latitude,
      'longitude': longitude,
      'contact': contact,
      'formatted_opening_hours': formatted_opening_hours,
    };
  }
}
