class Post {
  final int id;
  final String author;
  final String avatar;
  final String region;
  String time;
  final String category;
  final String title;
  final String body;
  int likes;
  int comments;
  bool saved;
  final String tag;
  final bool isOwn;

  Post({
    required this.id,
    required this.author,
    required this.avatar,
    required this.region,
    required this.time,
    required this.category,
    required this.title,
    required this.body,
    required this.likes,
    required this.comments,
    required this.saved,
    required this.tag,
    this.isOwn = false,
  });
}

List<Post> initialPosts = [
  Post(id: 1, author: 'Ahmed Ben Ali', avatar: '🌾', region: 'Tunis', time: 'il y a 2h', category: 'Irrigation', title: 'Méthode goutte-à-goutte pour blé dur', body: 'J\'ai testé l\'irrigation localisée cette saison avec des résultats excellents. Économie d\'eau de 40% et rendement amélioré de 20%. Je partage ma configuration...', likes: 34, comments: 12, saved: false, tag: '🌊'),
  Post(id: 2, author: 'Fatima Trabelsi', avatar: '🫒', region: 'Sfax', time: 'il y a 5h', category: 'Maladies', title: 'Traitement naturel contre l\'œil de paon', body: 'La maladie de l\'œil de paon touche mes oliviers chaque automne. Cette année j\'ai utilisé une décoction de cuivre naturel qui a donné de très bons résultats.', likes: 67, comments: 28, saved: true, tag: '🌿'),
  Post(id: 3, author: 'Mohamed Karray', avatar: '🥬', region: 'Nabeul', time: 'hier', category: 'Semences', title: 'Variétés résistantes à la sécheresse 2025', body: 'Après 3 ans de tests, voici les variétés de tomates et poivrons les plus résistantes dans notre région. Données comparatives disponibles.', likes: 89, comments: 45, saved: false, tag: '🌱'),
  Post(id: 4, author: 'Leila Mansouri', avatar: '🍋', region: 'Bizerte', time: 'il y a 2j', category: 'Marché', title: 'Prix agrumes ce mois — prévisions', body: 'Analyse des prix sur les marchés du nord. Les citrons sont en hausse de 15%, moment idéal pour vendre. Calendrier de récolte recommandé ci-joint.', likes: 52, comments: 19, saved: false, tag: '📈'),
];