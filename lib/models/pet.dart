class Pet {
  String? petId;
  String? userId;
  String? petName;
  String? petType;
  String? category;
  String? description;
  List<String>? imagePaths;
  String? lat;
  String? lng;
  String? createdAt;

  String? name, email, phone;

  Pet({
    this.petId,
    this.userId,
    this.petName,
    this.petType,
    this.category,
    this.description,
    this.lat,
    this.lng,
    this.createdAt,
    this.name,
    this.email,
    this.phone,
  });

  Pet.fromJson(Map<String, dynamic> json) {
    petId = json['pet_id'];
    userId = json['user_id'];
    petName = json['pet_name'];
    petType = json['pet_type'];
    category = json['category'];
    description = json['description'];
    lat = json['lat'];
    lng = json['lng'];
    createdAt = json['created_at'];

    //user field
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pet_id'] = petId;
    data['user_id'] = userId;
    data['pet_name'] = petName;
    data['pet_type'] = petType;
    data['category'] = category;
    data['description'] = description;
    data['lat'] = lat;
    data['lng'] = lng;
    data['created_at'] = createdAt;

    // user field
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    return data;
  }
}
