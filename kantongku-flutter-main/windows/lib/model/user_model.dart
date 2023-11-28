class User {
  final String id;
  final String username;
  final String name;
  final String email;

  const User({
    required this.id,
    required this.username,
    required this.name,
    required this.email,
  });

  factory User.createFromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      username: json["username"],
      name: json["name"],
      email: json["email"],
    );
  }
}
