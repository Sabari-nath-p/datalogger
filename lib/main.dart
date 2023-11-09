import 'package:crlibserialport/crlibserialport.dart';
import 'package:data_logger/Screen/MainScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, Orientation, DeviceType) {
      return GetMaterialApp(
        title: 'Data Logger',
        home: MainScreen(),
      );
    });
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        child: InkWell(
            onTap: () async {
              var ports = SerialPort.availablePorts;
              print(ports);
              //  if ()    reader.close();
              //SerialPort serialPort =
              //     SerialPort('/dev/ttyUSB0', baudrate: Baudrate.b9600);
              // final reader = SerialPortReader(
              //     SerialPort("/dev/cu.usbmodem111401").openRead());

              // reader.stream.listen((data) {
              //   print(data);
              // });
            },
            child: Text("Font Size")),
      ),
    );
  }
}
