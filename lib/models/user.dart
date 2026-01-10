class User {
  String? userId;
  String? name;
  String? email;
  String? phone;
  String? password;
  String? profileImagePath;
  String? regdate;

  User({
    this.userId,
    this.name,
    this.email,
    this.phone,
    this.password,
    this.profileImagePath,
    this.regdate,
  });

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    password = json['password'];
    profileImagePath = json['profile_image_path'];
    regdate = json['reg_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['password'] = password;
    data['profile_image_path'] = profileImagePath;
    data['reg_date'] = regdate;
    return data;
  }
}
