import 'dart:convert';

class TrackInfo {
  final String artist;
  final String title;

  TrackInfo({required this.artist, required this.title});

  factory TrackInfo.fromJson(Map<String, dynamic> json) {
    return TrackInfo(
      artist: json['Artist'],
      title: json['Title'],
    );
  }

  static TrackInfo extractArtistAndTitle(String input) {
    final regex = RegExp(
      r'"Artist"\s+variant\s+string\s+"([^"]+)"\s+[^"]+"Title"\s+variant\s+string\s+"([^"]+)"',
    );

    final match = regex.firstMatch(input);

    if (match != null) {
      final artist = match.group(1);
      final title = match.group(2);

      return TrackInfo(artist: artist!, title: title!);
    }

    // Return a default TrackInfo if no match is found
    return TrackInfo(artist: 'Unknown', title: 'Unknown');
  }

}


