class GpsDto {
  double? latitude;
  double? longitude;
  double? speed;
  String? timestamp;

  GpsDto({this.latitude, this.longitude, this.speed, this.timestamp});

  GpsDto.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    speed = json['speed'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['speed'] = this.speed;
    data['timestamp'] = this.timestamp;
    return data;
  }
}