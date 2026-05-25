class AppUser {
  final int id;
  final String name;
  final String email;
  final String password;
  final String region;
  final String specialty;
  final String avatar;
  int posts;
  final int followers;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.region,
    required this.specialty,
    required this.avatar,
    required this.posts,
    required this.followers,
  });
}

final List<AppUser> usersDB = [
  AppUser(id: 1, name: 'Ahmed Ben Ali', email: 'ahmed@agri.tn', password: '123456', region: 'Tunis', specialty: 'Céréales', avatar: '🌾', posts: 24, followers: 138),
  AppUser(id: 2, name: 'Fatima Trabelsi', email: 'fatima@agri.tn', password: '123456', region: 'Sfax', specialty: 'Oliviers', avatar: '🫒', posts: 41, followers: 210),
];