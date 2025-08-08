class User {
  final String id;
  final String username;
  final String? email; // Added email for registration/login flexibility

  User({required this.id, required this.username, this.email});
}