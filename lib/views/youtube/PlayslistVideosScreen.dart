import 'package:flutter/material.dart';
import 'VideoPlayerScreen.dart';
import 'youtube_service.dart';
import 'playlist_video_model.dart';

class PlaylistVideosScreen extends StatefulWidget {
  final String playlistId;
  final String playlistTitle;

  const PlaylistVideosScreen({
    Key? key,
    required this.playlistId,
    required this.playlistTitle,
  }) : super(key: key);

  @override
  _PlaylistVideosScreenState createState() => _PlaylistVideosScreenState();
}

class _PlaylistVideosScreenState extends State<PlaylistVideosScreen> {
  late Future<List<YoutubeVideo>> _futureVideos;

  @override
  void initState() {
    super.initState();
    _futureVideos = YoutubeService.fetchPlaylistVideos(widget.playlistId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.playlistTitle),
      ),
      body: FutureBuilder<List<YoutubeVideo>>(
        future: _futureVideos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No videos found.'));
          }

          final videos = snapshot.data!;

          return ListView.builder(
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final video = videos[index];
              return ListTile(
                leading: Image.network(video.thumbnailUrl),
                title: Text(video.title,style: TextStyle(fontWeight: FontWeight.bold),),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VideoPlayerScreen(
                        videoId: video.videoId,
                        videoTitle: video.title,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
