import 'package:flutter/material.dart';
import 'PlayslistVideosScreen.dart';
import 'youtube_service.dart';
import 'playlist_model.dart';

class PlaylistsScreen extends StatefulWidget {
  final String channelId;

  const PlaylistsScreen({Key? key, required this.channelId}) : super(key: key);

  @override
  _PlaylistsScreenState createState() => _PlaylistsScreenState();
}

class _PlaylistsScreenState extends State<PlaylistsScreen> {
  late Future<List<YoutubePlaylist>> _futurePlaylists;

  @override
  void initState() {
    super.initState();
    _futurePlaylists = YoutubeService.fetchChannelPlaylists(widget.channelId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Channel Playlists'),
      ),
      body: FutureBuilder<List<YoutubePlaylist>>(
        future: _futurePlaylists,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No playlists found.'));
          }

          final playlists = snapshot.data!;

          return ListView.builder(
            itemCount: playlists.length,
            itemBuilder: (context, index) {
              final playlist = playlists[index];
              return ListTile(
                leading: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: playlist.thumbnailUrl.contains('no_thumbnail')?Image.asset('assets/images/logo.jpg'):Image.network(playlist.thumbnailUrl ),
                ),
                title: Text(playlist.title, style: TextStyle(fontWeight: FontWeight.bold),),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PlaylistVideosScreen(
                        playlistId: playlist.id,
                        playlistTitle: playlist.title,
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
