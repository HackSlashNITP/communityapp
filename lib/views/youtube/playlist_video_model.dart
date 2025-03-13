class YoutubeVideo {
  final String videoId;
  final String title;
  final String thumbnailUrl;

  YoutubeVideo({
    required this.videoId,
    required this.title,
    required this.thumbnailUrl,
  });

  factory YoutubeVideo.fromJson(Map<String, dynamic> json) {
    final snippet = json['snippet'];
    final resourceId = snippet['resourceId'];
    return YoutubeVideo(
      videoId: resourceId['videoId'] ?? '',
      title: snippet['title'] ?? '',
      thumbnailUrl: snippet['thumbnails']['default']['url'] ?? '',
    );
  }
}
