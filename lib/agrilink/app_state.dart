import 'package:flutter/material.dart';
import 'models/user.dart';
import 'models/post.dart';
import '../auth_service.dart';

class AppState extends ChangeNotifier {
  AppUser? currentUser;
  List<Post> posts = List.from(initialPosts);
  Set<int> likedPosts = {};

  Future<bool> login(String email, String password) async {
    final result = await AuthService.signin(
      email: email,
      password: password,
      appType: "agrilink",
    );

    if (result["success"] == true) {
      loginFromDb(result["user"]);
      return true;
    }

    return false;
  }

  Future<bool> signup(String name, String email, String password) async {
    final result = await AuthService.signup(
      fullname: name,
      email: email,
      password: password,
      appType: "agrilink",
    );

    return result["success"] == true;
  }

  void loginFromDb(Map<String, dynamic> user) {
    currentUser = AppUser(
      id: int.tryParse(user["id"].toString()) ??
          DateTime.now().millisecondsSinceEpoch,
      name: user["fullname"]?.toString() ?? "AgriLink User",
      email: user["email"]?.toString() ?? "",
      password: "",
      avatar: "🌱",
      region: "Tunisie",
      specialty: "Agriculteur",
      posts: 0,
      followers: 0,
    );

    notifyListeners();
  }

  void logout() {
    currentUser = null;
    likedPosts.clear();
    notifyListeners();
  }

  void toggleLike(int postId) {
    final idx = posts.indexWhere((p) => p.id == postId);
    if (idx == -1) return;

    if (likedPosts.contains(postId)) {
      likedPosts.remove(postId);
      posts[idx].likes--;
    } else {
      likedPosts.add(postId);
      posts[idx].likes++;
    }

    notifyListeners();
  }

  void toggleSave(int postId) {
    final idx = posts.indexWhere((p) => p.id == postId);
    if (idx == -1) return;

    posts[idx].saved = !posts[idx].saved;
    notifyListeners();
  }

  void addPost(String title, String body, String category) {
    const tagMap = {
      'Irrigation': '🌊',
      'Maladies': '🌿',
      'Semences': '🌱',
      'Marché': '📈',
      'Matériel': '🚜',
    };

    if (currentUser == null) return;

    final newPost = Post(
      id: DateTime.now().millisecondsSinceEpoch,
      author: currentUser!.name,
      avatar: currentUser!.avatar,
      region: currentUser!.region,
      time: 'à l\'instant',
      category: category,
      title: title,
      body: body,
      likes: 0,
      comments: 0,
      saved: false,
      tag: tagMap[category] ?? '📝',
      isOwn: true,
    );

    posts.insert(0, newPost);
    currentUser!.posts++;
    notifyListeners();
  }

  void deletePost(int postId) {
    posts.removeWhere((p) => p.id == postId);
    currentUser?.posts--;
    notifyListeners();
  }

  List<Post> get myPosts =>
      posts.where((p) => p.author == currentUser?.name).toList();

  List<Post> get savedPosts => posts.where((p) => p.saved).toList();
}