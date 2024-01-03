class Post {
  final String id;
  final String title;
  final String content;
  final int like;
  final int dislike;

  // Définir les valeurs par défaut à 0 dans le constructeur
  Post({
    required this.id,
    required this.title,
    required this.content,
    this.like = 0,  // Valeur par défaut de like est 0
    this.dislike = 0,  // Valeur par défaut de dislike est 0
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'],
      title: json['title'],
      content: json['content'],
      like: json['like'] ?? 0,  // Utiliser la valeur de json['like'], sinon 0 par défaut
      dislike: json['dislike'] ?? 0,  // Utiliser la valeur de json['dislike'], sinon 0 par défaut
    );
  }
}
