import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'playlist_model.dart';
import 'playlist_video_model.dart';

class YoutubeService {
  static const String _baseUrl = 'www.googleapis.com';
  static final String _apiKey = dotenv.env['YOUTUBE_API_KEY'] ?? ''; // Replace with your API key

  /// Fetch all playlists from a given channel
  static Future<List<YoutubePlaylist>> fetchChannelPlaylists(String channelId) async {
    final uri = Uri.https(
      _baseUrl,
      '/youtube/v3/playlists',
      {
        'part': 'snippet',
        'channelId': channelId,
        'maxResults': '25',
        'key': _apiKey,
      },
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final items = data['items'] as List;
      return items.map((item) => YoutubePlaylist.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch playlists');
    }
  }

  /// Fetch all videos in a given playlist
  static Future<List<YoutubeVideo>> fetchPlaylistVideos(String playlistId) async {
    final uri = Uri.https(
      _baseUrl,
      '/youtube/v3/playlistItems',
      {
        'part': 'snippet',
        'playlistId': playlistId,
        'maxResults': '25',
        'key': _apiKey,
      },
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final items = data['items'] as List;
      return items.map((item) => YoutubeVideo.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch playlist videos');
    }
  }
}
