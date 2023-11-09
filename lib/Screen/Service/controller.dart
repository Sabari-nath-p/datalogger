import 'package:crlibserialport/crlibserialport.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  TextEditingController IntervelController = TextEditingController();
  List PortList = ["Select Port"];
  String portController = "Select Port";
  String TimeMode = "Second";
  bool isRunning = false;
  SerialPort? port;

  startDataListner() async {
    isRunning = true;
    update();

    port = SerialPort(portController);
    if (!port!.openReadWrite()) {
      print(SerialPort.lastError);
      //exit(-1);
    }

    //port.write(/* ... */);

    final reader = SerialPortReader(port!);
    reader.stream.listen((data) {
      print('received: $data');
    });
  }

  UpdatePorts() {
    PortList.clear();
    PortList.add("Select Port");
    PortList = SerialPort.availablePorts;
    PortList.add("Select Port");
    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    UpdatePorts();
  }
}
