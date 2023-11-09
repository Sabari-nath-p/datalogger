import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 0)
class MData {
  @HiveField(0)
  String? timeStamp;
  @HiveField(1)
  String? ph;
  @HiveField(2)
  String? Dh;
  @HiveField(3)
  String? temp;
  @HiveField(4)
  String? pressure;
  MData(this.Dh, this.temp, this.ph, this.pressure, this.timeStamp);
}
