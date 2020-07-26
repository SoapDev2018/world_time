import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class WorldTime {
  String location;
  String time;
  String flag;
  String url;
  bool isDayTime;

  WorldTime({this.location, this.flag, this.url});

  Future<void> getTime() async{
    try {
      Response response = await get('https://worldtimeapi.org/api/timezone/$url');
      Map data = jsonDecode(response.body);
      String datetime = data['utc_datetime'];
      String offset = data['utc_offset'];
      String hours = offset.substring(1, 3);
      String minutes = offset.substring(4, 6);
      String sign = offset[0];
      DateTime now = DateTime.parse(datetime);
      now = sign == '+' ? now.add(Duration(hours: int.parse(hours), minutes: int.parse(minutes))) : now.subtract(Duration(hours: int.parse(hours), minutes: int.parse(minutes)));
      isDayTime = now.hour > 6 && now.hour < 18 ? true : false;
      time = DateFormat.jm().format(now);
    } on Exception catch (e) {
      print('Caught error $e');
      time = 'Could not load';
    }
  }
}