class BlogModel {
  BlogModel({
    required this.title,
    required this.content,
    required this.author,
    required this.imageUrl,
    required this.createdAt,
  });

  final String? title;
  final String? content;
  final String? author;
  final String? imageUrl;
  final String? createdAt;

  BlogModel copyWith({
    String? title,
    String? content,
    String? author,
    String? imageUrl,
    String? createdAt,
  }) {
    return BlogModel(
      title: title ?? this.title,
      content: content ?? this.content,
      author: author ?? this.author,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory BlogModel.fromJson(Map<String, dynamic> json) {
    return BlogModel(
      title: json["title"],
      content: json["content"],
      author: json["author"],
      imageUrl: json["image"],
      createdAt: json["createdAt"],
    );
  }

  Map<String, dynamic> toJson() => {
        "title": title,
        "content": content,
        "author": author,
        "image": imageUrl,
        "createdAt": createdAt,
      };

  @override
  String toString() {
    return "$title, $content, $author, $imageUrl, $createdAt, ";
  }
}
