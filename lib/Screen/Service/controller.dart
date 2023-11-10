import 'dart:io';

import 'package:data_logger/Screen/Model/dataModel.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:libserialport/libserialport.dart';
import 'package:serial_port_win32/serial_port_win32.dart';

class HomeController extends GetxController {
  TextEditingController IntervelController = TextEditingController();
  List PortList = ["Select Port"];
  String portController = "Select Port";
  String TimeMode = "Second";
  bool isRunning = false;
  SerialPort? port;
  Box? db;
  List<MData> MachineData = [];

  startDataListner() async {
    // port = SerialPort(portController,
    //     openNow: true,
    //     ByteSize: 8,
    //     ReadIntervalTimeout: 1,
    //     ReadTotalTimeoutConstant: 2);
    if (false) {
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
          MData mData = MData(value[1], value[2], value[0], value[3],
              DateTime.now().toString());
          MachineData.add(mData);
          db!.put(mData.timeStamp, mData);
          update();
          opt = 0;
        }
      });
    } else {
      //custom api
      FlutterPlatformAlert.showAlert(
          windowTitle: "Couldn't Connect",
          text: "Port is not open to communication");
    }
// or
// can only choose one function}
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

  openDatabase() async {
    MachineData.clear();
    db = await Hive.openBox("COLLECTION");
    for (var data in db!.keys) {
      MData dt = db!.get(data);
      MachineData.add(dt);
    }
    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    UpdatePorts();
    openDatabase();
  }

  exportToExcel() async {
    var excel = Excel.createExcel();
    var sheet = excel['Sheet1'];

    // Add headers to the worksheet
    sheet.cell(CellIndex.indexByString("A1")).value = "Timestamp";
    sheet.cell(CellIndex.indexByString("B1")).value = "pH";
    sheet.cell(CellIndex.indexByString("C1")).value = "Dh";
    sheet.cell(CellIndex.indexByString("D1")).value = "Temperature";
    sheet.cell(CellIndex.indexByString("E1")).value = "Pressure";

    // Add data to the worksheet
    for (int i = 0; i < MachineData.length; i++) {
      var data = MachineData[i];
      sheet.cell(CellIndex.indexByString("A${i + 2}")).value =
          data.timeStamp ?? "";
      sheet.cell(CellIndex.indexByString("B${i + 2}")).value = data.ph ?? "";
      sheet.cell(CellIndex.indexByString("C${i + 2}")).value = data.Dh ?? "";
      sheet.cell(CellIndex.indexByString("D${i + 2}")).value = data.temp ?? "";
      sheet.cell(CellIndex.indexByString("E${i + 2}")).value =
          data.pressure ?? "";
    }

    Directory? documentsDirectory = await getDownloadsDirectory();

    // String excelFilePath = "${documentsDirectory!.path}/data_export.xlsx";
    // excel.encode()?.then((onValue) {
    //   File(excelFilePath).writeAsBytesSync(onValue);
//});

    //print("Excel file exported to: $excelFilePath");
  }
}
