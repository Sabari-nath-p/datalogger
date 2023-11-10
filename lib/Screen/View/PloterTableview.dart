import 'package:data_logger/Screen/Service/controller.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class PloterTableView extends StatelessWidget {
  PloterTableView({super.key});
  HomeController ctrl = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        padding: EdgeInsets.all(10),
        width: 84.w,
        child: DataTable2(
            columnSpacing: 0,
            horizontalMargin: 0,
            minWidth: 800,
            headingRowHeight: 40,
            columns: [
              DataColumn2(
                fixedWidth: 7.w,
                label: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(10)),
                    color: Colors.blueGrey.withOpacity(.6),
                  ),
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(
                    'SI NO',
                    style: GoogleFonts.inter(fontSize: 14),
                  ),
                ),
                size: ColumnSize.L,
              ),
              DataColumn2(
                fixedWidth: 25.w,
                label: Container(
                    width: double.infinity,
                    height: double.infinity,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    color: Colors.blueGrey.withOpacity(.6),
                    child: Text(
                      'Time Stamp',
                      style: GoogleFonts.inter(fontSize: 14),
                    )),
                size: ColumnSize.L,
              ),
              DataColumn2(
                fixedWidth: 8.w,
                label: Container(
                    width: double.infinity,
                    height: double.infinity,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    color: Colors.blueGrey.withOpacity(.6),
                    child: Text(
                      'pH',
                      style: GoogleFonts.inter(fontSize: 14),
                    )),
              ),
              DataColumn2(
                fixedWidth: 12.w,
                label: Container(
                    width: double.infinity,
                    height: double.infinity,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    color: Colors.blueGrey.withOpacity(.6),
                    child: Text(
                      'Dh (mg/l)',
                      style: GoogleFonts.inter(fontSize: 14),
                    )),
              ),
              DataColumn2(
                fixedWidth: 15.w,
                label: Container(
                    width: double.infinity,
                    height: double.infinity,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    color: Colors.blueGrey.withOpacity(.6),
                    child: Text(
                      'Temperature (°C)',
                      style: GoogleFonts.inter(fontSize: 14),
                    )),
              ),
              DataColumn2(
                fixedWidth: 14.w,
                label: Container(
                    width: double.infinity,
                    height: double.infinity,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.only(topRight: Radius.circular(10)),
                      color: Colors.blueGrey.withOpacity(.6),
                    ),
                    child: Text(
                      'Pressure (Kpa)',
                      style: GoogleFonts.inter(fontSize: 14),
                    )),
                numeric: true,
              ),
            ],
            rows: [
              for (var data in ctrl.MachineData.reversed)
                DataRow(cells: [
                  DataCell(Container(
                      alignment: Alignment.center,
                      width: 7.w,
                      child: Text(ctrl.MachineData.indexOf(data).toString()))),
                  DataCell(Container(
                    padding: EdgeInsets.only(left: 5),
                    alignment: Alignment.center,
                    width: 25.w,
                    child: Text(
                      data.timeStamp!,
                      style: GoogleFonts.inter(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  )),
                  DataCell(Container(
                    alignment: Alignment.center,
                    width: 8.w,
                    child: Text(
                      data.ph!,
                      style: GoogleFonts.inter(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  )),
                  DataCell(Container(
                    alignment: Alignment.center,
                    width: 12.w,
                    child: Text(
                      data.Dh!,
                      style: GoogleFonts.inter(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  )),
                  DataCell(Container(
                    alignment: Alignment.center,
                    width: 15.w,
                    child: Text(
                      data.temp!,
                      style: GoogleFonts.inter(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  )),
                  DataCell(Container(
                    alignment: Alignment.center,
                    width: 14.w,
                    child: Text(
                      data.pressure!,
                      style: GoogleFonts.inter(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ))
                ])
            ]),
      ),
    );
  }
}
