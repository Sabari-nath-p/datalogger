import 'package:crlibserialport/crlibserialport.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  TextEditingController IntervelController = TextEditingController();
  List PortList = ["Select Port"];
  String portController = "Select Port";
  String TimeMode = "Second";
  bool isRunning = false;

  startDataListner() async {
    final name = SerialPort.availablePorts.first;
    final port = SerialPort(name);
    if (!port.openReadWrite()) {
      print(SerialPort.lastError);
      //exit(-1);
    }

    //port.write(/* ... */);

    final reader = SerialPortReader(port);
    reader.stream.listen((data) {
      print('received: $data');
    });
  }

  UpdatePorts() {
    PortList = SerialPort.availablePorts;
    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    PortList = SerialPort.availablePorts;
  }
}
