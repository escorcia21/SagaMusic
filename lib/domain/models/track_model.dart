class TrackModel {
  String name, artistName, albumName, albumImg, preview;
  String playbackSeconds;

  TrackModel(
      {required this.name,
      required this.artistName,
      required this.albumName,
      required this.playbackSeconds,
      required this.albumImg,
      required this.preview});

  factory TrackModel.fromJson(Map<String, dynamic> map) {
    return TrackModel(
        name: map['name'],
        artistName: map['artistName'],
        albumName: map['albumName'],
        playbackSeconds: Duration(seconds: map['playbackSeconds'])
            .toString()
            .substring(2, 7),
        albumImg: TrackModel.imgUrl(map["albumId"]),
        preview: map["previewURL"]);
  }

  static String imgUrl(String albumId) =>
      'https://api.napster.com/imageserver/v2/albums/$albumId/images/500x500.jpg';
}
