class YoutubePlaylist {
  final String id;
  final String title;
  final String thumbnailUrl;

  YoutubePlaylist({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
  });

  factory YoutubePlaylist.fromJson(Map<String, dynamic> json) {
    final snippet = json['snippet'];
    return YoutubePlaylist(
      id: json['id'] ?? '',
      title: snippet['title'] ?? '',
      thumbnailUrl: snippet['thumbnails']['default']['url'] ?? '',
    );
  }
}
