import 'dart:io';

import 'package:data_logger/Screen/Model/dataModel.dart';
import 'package:data_logger/Screen/View/Save.dart';
import 'package:excel/excel.dart' as ex;
import 'package:file_picker/file_picker.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
  String ph = "-- --";
  String Dh = "-- --";
  String tm = "-- --";
  String p = "-- --";
  int Mode = 0;
  String StartData = "-- :-- :--";
  String EndDate = "-- :-- :--";
  String FutureData = "-- :-- :--";
  TextEditingController filePathController = TextEditingController();
  TextEditingController fileNameController = TextEditingController();
  DateTime lastSaveTime = DateTime.now();
  bool isSave = false;

  SerialPort? port;
  Box<MData>? db;
  List<MData> MachineData = [];

  startDataListner() async {
    // print(port!.openStatus);
    try {
      if (portController != "Select Port") {
        port = SerialPort(portController,
            openNow: false,
            ByteSize: 8,
            ReadIntervalTimeout: 1,
            ReadTotalTimeoutConstant: 2);
        isRunning = true;
        update();

        port!.open();
        //  port?.openWithSettings(BaudRate: 9600);

        String buffer = "*${IntervelController.text}#${TimeMode[0]}@";
        port?.writeBytesFromString(buffer);
        String s = "";
        String updates = "";
        int opt = 0;
        List backup = [""];
        port!.readBytesSize = 8;
        print("reading data");
        port!.readBytesOnListen(64, (value) {
          String res = String.fromCharCodes(value);
          //pr9int(res);

          if (s.contains("*") && opt == 0) {
            //  print(s);

            opt = 1;
          }
          s = s + res;
          // print("value String");
          String check = s;
          // print(s);

          if (s.contains("@") && opt == 1) {
            print(s);
            int pos = s.lastIndexOf("@");

            if (pos != -1 && pos < s.length - 1) {
              print("Actual String");
              print(s);
              print("break String");
              check = s.substring(0, pos - 1);
              print(check);
              print("break update");

              updates = s.substring(pos + 1);
              print(updates);
            }
            check = check.replaceAll("*", "");
            check = check.replaceAll("@", "");
            check = check.replaceAll(" ", "");
            check = check.replaceAll("\n", "");

            //  print(s);
            List value = check.split("#");

            if (value.length > 1) ph = value[0];
            if (value.length > 2) Dh = value[1];
            if (value.length > 3) tm = value[2];
            if (value.length > 3) p = value[3];
            if (value.length > 4) {
              MData mData = MData(value[1], value[2], value[0], value[3],
                  DateTime.now().toString());
              if (isSave) if (checkSavable()) {
                //print(lastSaveTime.toString());
                //  print(DateTime.now());
                lastSaveTime = DateTime.now();
                //MachineData.add(mData);
                db!.put(mData.timeStamp, mData);
              }
            }
            print("updateString");
            print(updates);
            s = updates;
            update();

            opt = 0;
          }
        });
      } else {
        //custom api
        FlutterPlatformAlert.showAlert(
            windowTitle: "Couldn't Connect", text: "Please Select Port");
      }
    } catch (e) {
      FlutterPlatformAlert.showAlert(
          windowTitle: "Couldn't Connect", text: "port is busy");
    }
// or
// can only choose one function}
  }

  bool checkSavable() {
    if (FutureData == "-- :-- :--") {
      if (DateTime.now().isAfter(lastSaveTime
              .add(Duration(seconds: int.parse(IntervelController.text)))) &&
          TimeMode == "Second") {
        return true;
      } else if (DateTime.now().isAfter(lastSaveTime
              .add(Duration(minutes: int.parse(IntervelController.text)))) &&
          TimeMode == "Minute") {
        return true;
      } else if (DateTime.now().isAfter(lastSaveTime
              .add(Duration(hours: int.parse(IntervelController.text)))) &&
          TimeMode == "Hour") {
        return true;
      } else
        return false;
    } else if (DateTime.now().isAfter(DateTime.parse(FutureData))) {
      if (DateTime.now().isAfter(lastSaveTime
              .add(Duration(seconds: int.parse(IntervelController.text)))) &&
          TimeMode == "Second") {
        return true;
      } else if (DateTime.now().isAfter(lastSaveTime
              .add(Duration(minutes: int.parse(IntervelController.text)))) &&
          TimeMode == "Minute") {
        return true;
      } else if (DateTime.now().isAfter(lastSaveTime
              .add(Duration(hours: int.parse(IntervelController.text)))) &&
          TimeMode == "Hour") {
        return true;
      } else
        return false;
    } else {
      return false;
    }
  }

  readData() async {
    MachineData = db!.values
        .where((element) => (DateTime.parse(element.timeStamp!)
                .isAfter(DateTime.parse(StartData)) &&
            DateTime.parse(element.timeStamp!)
                .isBefore(DateTime.parse(EndDate))))
        .toList();
    update();
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
    db = await Hive.openBox<MData>("COLLECTION");
    // for (var data in db!.keys) {
    //   MData? dt = db!.get(data);
    //   MachineData.add(dt!);
    // }
    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    UpdatePorts();
    openDatabase();
  }

  exportToExcel(String path, String fileName) async {
    var excel = ex.Excel.createExcel();
    var sheet = excel['Sheet1'];

    // Add headers to the worksheet
    sheet.cell(ex.CellIndex.indexByString("A1")).value = "Timestamp";
    sheet.cell(ex.CellIndex.indexByString("B1")).value = "pH";
    sheet.cell(ex.CellIndex.indexByString("C1")).value = "Dh";
    sheet.cell(ex.CellIndex.indexByString("D1")).value = "Temperature";
    sheet.cell(ex.CellIndex.indexByString("E1")).value = "Pressure";

    // Add data to the worksheet
    for (int i = 0; i < MachineData.length; i++) {
      var data = MachineData[i];
      sheet.cell(ex.CellIndex.indexByString("A${i + 2}")).value =
          data.timeStamp ?? "";
      sheet.cell(ex.CellIndex.indexByString("B${i + 2}")).value = data.ph ?? "";
      sheet.cell(ex.CellIndex.indexByString("C${i + 2}")).value = data.Dh ?? "";
      sheet.cell(ex.CellIndex.indexByString("D${i + 2}")).value =
          data.temp ?? "";
      sheet.cell(ex.CellIndex.indexByString("E${i + 2}")).value =
          data.pressure ?? "";
    }

    // Directory? documentsDirectory = await getDownloadsDirectory();
    // print(documentsDirectory!.path);
// when you are in flutter web then save() downloads the excel file.

// Call function save() to download the file
    var fileBytes = excel.save();
    var directory = await getApplicationDocumentsDirectory();

    String excelFilePath = "${path}\\${fileName}.xlsx";
    File file = File(excelFilePath);
    await file.writeAsBytes(excel.encode()!);
    print(excel.encode());
    print(file.path);
    FlutterPlatformAlert.showAlert(
        windowTitle: "File Exported",
        text: "Your exported file is save in ${file.path} ");
    // excel.encode()?.then((onValue) {
    //   File(excelFilePath).writeAsBytesSync(onValue);
//});

    //print("Excel file exported to: $excelFilePath");
  }

  void showSaveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SaveDialog();
      },
    );
  }

  clearData() async {
    await db!.deleteFromDisk();
    MachineData.clear();
    update();
    openDatabase();
  }
}
