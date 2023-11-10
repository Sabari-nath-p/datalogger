import 'package:data_logger/Screen/Model/dataModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:libserialport/libserialport.dart';
import 'package:serial_port_win32/serial_port_win32.dart';

class HomeController extends GetxController {
  TextEditingController IntervelController = TextEditingController();
  List PortList = ["Select Port"];
  String portController = "Select Port";
  String TimeMode = "Second";
  bool isRunning = false;
  SerialPort? port;
  List<MData> MachineData = [];

  startDataListner() async {
    isRunning = true;
    update();

    port = SerialPort(portController,
        openNow: true,
        ByteSize: 8,
        ReadIntervalTimeout: 1,
        ReadTotalTimeoutConstant: 2);
    port!.open();
    //  port?.openWithSettings(BaudRate: 9600);

    String buffer = "*${IntervelController.text}#$TimeMode@";
    port?.writeBytesFromString(buffer);
    String s = "";
    int opt = 0;
    port!.readBytesSize = 8;
    print("reading data");
    port!.readBytesOnListen(64, (value) {
      String res = String.fromCharCodes(value);
      //print(res);

      if (res.contains("*") && opt == 0) {
        s = "";
        opt = 1;
      }
      s = s + res;
      if (s.contains("@") && opt == 1) {
        s = s.replaceAll("*", "");
        s = s.replaceAll("@", "");
        s = s.replaceAll(" ", "");
        print(s);
        List value = s.split("#");
        MData mData = MData(
            value[1], value[2], value[0], value[3], DateTime.now().toString());
        MachineData.add(mData);
        update();
        opt = 0;
      }
    });
// or
// can only choose one function
  }

  StopListner() {
    isRunning = false;
    update();
    port!.close();
  }

  UpdatePorts() {
    PortList.clear();
    PortList.add("Select Port");
    PortList = SerialPort.getAvailablePorts();
    PortList.add("Select Port");
    portController = "Select Port";
    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    UpdatePorts();
  }
}
