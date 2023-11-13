import 'package:data_table_2/data_table_2.dart';

import 'package:flutter/material.dart';
import 'package:data_logger/Screen/Service/controller.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class PloterTableView extends StatelessWidget {
  PloterTableView({Key? key}) : super(key: key);

  final HomeController ctrl = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Select Date  ",
              style:
                  GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            _buildDateSelector("Start Date", ctrl.StartData),
            Text(
              " To   ",
              style:
                  GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            _buildDateSelector("End Date", ctrl.EndDate),
            InkWell(
                onTap: () {
                  if (ctrl.StartData != "-- :-- :--" &&
                      ctrl.EndDate != "-- :-- :--") ctrl.readData();
                },
                child: _buildLoadDataButton()),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(10),
              child: DataTable2(
                columnSpacing: 0,
                horizontalMargin: 0,
                minWidth: 800,
                headingRowHeight: 40,
                columns: _buildColumns(),
                rows: _buildRows(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelector(String label, String date) {
    return InkWell(
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: Get.context!,
          initialDate: DateTime.now(),
          firstDate: DateTime.parse("2023-11-10"),
          lastDate: DateTime.parse("2050-11-10"),
        );

        final selectedTime = await showTimePicker(
          context: Get.context!,
          initialTime: TimeOfDay.now(),
        );

        if (selectedDate != null && selectedTime != null) {
          DateTime combinedDateTime = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );

          if (label == "Start Date") {
            ctrl.StartData = combinedDateTime.toString();
          } else {
            ctrl.EndDate = combinedDateTime.toString();
          }

          ctrl.update();
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 4),
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          border: Border.all(color: const Color.fromRGBO(142, 142, 142, 1)),
          borderRadius: BorderRadius.circular(6),
        ),
        width: 150,
        child: Text(
          "$date",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildLoadDataButton() {
    return Container(
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Color(0xff191F26),
      ),
      child: Text(
        "Load Data",
        style: GoogleFonts.lato(fontSize: 14, color: Colors.white),
      ),
    );
  }

  List<DataColumn2> _buildColumns() {
    return [
      DataColumn2(
        fixedWidth: 7.w,
        label: _buildDataColumnLabel("SI NO"),
        size: ColumnSize.L,
      ),
      DataColumn2(
        fixedWidth: 25.w,
        label: _buildDataColumnLabel("Time Stamp"),
        size: ColumnSize.L,
      ),
      DataColumn2(
        fixedWidth: 8.w,
        label: _buildDataColumnLabel("pH"),
      ),
      DataColumn2(
        fixedWidth: 12.w,
        label: _buildDataColumnLabel("Dh (mg/l)"),
      ),
      DataColumn2(
        fixedWidth: 15.w,
        label: _buildDataColumnLabel("Temperature (°C)"),
      ),
      DataColumn2(
        fixedWidth: 14.w,
        label: _buildDataColumnLabel("Pressure (Kpa)"),
        numeric: true,
      ),
    ];
  }

  List<DataRow> _buildRows() {
    return ctrl.MachineData.reversed.map((data) {
      int index = ctrl.MachineData.indexOf(data);
      return DataRow(
        cells: [
          _buildDataCell(index.toString(), width: 7.w),
          _buildDataCell(data.timeStamp!, width: 25.w),
          _buildDataCell(data.ph!, width: 8.w),
          _buildDataCell(data.Dh!, width: 12.w),
          _buildDataCell(data.temp!, width: 15.w),
          _buildDataCell(data.pressure!, width: 14.w),
        ],
      );
    }).toList();
  }

  DataCell _buildDataCell(String text, {required double width}) {
    return DataCell(
      Container(
        alignment: Alignment.center,
        width: width,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text,
            style: GoogleFonts.inter(fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildDataColumnLabel(String label) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        color: Colors.blueGrey.withOpacity(.6),
      ),
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          label,
          style: GoogleFonts.inter(fontSize: 14),
        ),
      ),
    );
  }
}
