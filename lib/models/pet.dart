class Pet {
  final int petId;
  final int userId;
  final String petName;
  final String petType;
  final String category;
  final String description;
  final List<String> imagePaths;
  final String lat;
  final String lng;
  final DateTime createdAt;

  Pet({
    required this.petId,
    required this.userId,
    required this.petName,
    required this.petType,
    required this.category,
    required this.description,
    required this.imagePaths,
    required this.lat,
    required this.lng,
    required this.createdAt,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    List<String> images;

    if (json['image_paths'] is String) {
      images = json['image_paths'].toString().split(',');
    } else {
      images = [];
    }

    return Pet(
      petId: int.parse(json['pet_id'].toString()),
      userId: int.parse(json['user_id'].toString()),
      petName: json['pet_name'],
      petType: json['pet_type'],
      category: json['category'],
      description: json['description'],
      imagePaths: images,
      lat: json['lat'],
      lng: json['lng'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
