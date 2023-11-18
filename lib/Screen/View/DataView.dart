import 'package:data_logger/Screen/Service/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class DataView extends StatelessWidget {
  DataView({super.key});
  HomeController ctrl = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 6.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: Colors.white),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Realtime Data Ploting",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500, fontSize: 22),
              ),
              SizedBox(
                height: 10,
              ),
              Wrap(
                spacing: 10,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                runAlignment: WrapAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "pH Value",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500, fontSize: 19),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        width: 150,
                        height: 55,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.black.withOpacity(.09)),
                        child: Text(
                          ctrl.ph,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500, fontSize: 19),
                        ),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "DO (mg/l)",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500, fontSize: 19),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        width: 150,
                        height: 55,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.black.withOpacity(.09)),
                        child: Text(
                          ctrl.Dh,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500, fontSize: 19),
                        ),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Temperature (°C)",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500, fontSize: 17.8),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        width: 150,
                        height: 55,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.black.withOpacity(.09)),
                        child: Text(
                          ctrl.tm,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500, fontSize: 19),
                        ),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Pressure (Pa)",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500, fontSize: 19),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        width: 150,
                        height: 55,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.black.withOpacity(.09)),
                        child: Text(
                          ctrl.p,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500, fontSize: 19),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                margin: EdgeInsets.only(top: 20),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      "Intervel : ",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontSize: 16),
                    ),
                    Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        margin: EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Color.fromRGBO(142, 142, 142, 1)),
                            borderRadius: BorderRadius.circular(6)),
                        width: 110,
                        child: TextField(
                          enabled: !ctrl.isSave,
                          controller: ctrl.IntervelController,
                          style: GoogleFonts.lato(
                              color: Colors.black, fontSize: 15),
                          onChanged: (value) {
                            if (value.isNumericOnly) {
                            } else {
                              ctrl.IntervelController.text = "";
                            }
                          },
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              labelStyle: GoogleFonts.lato(
                                  color: Colors.black, fontSize: 15),
                              // isCollapsed: true,
                              hintText: "No Value",
                              hintStyle: GoogleFonts.lato(
                                  color: Colors.black, fontSize: 15)),
                        )),
                    Container(
                        width: 75,
                        child: DropdownButton<String>(
                          value: (ctrl.isSave) ? null : ctrl.TimeMode,
                          //  dropdownColor: Colors.white60,
                          isExpanded: false,
                          items: ["Minute", "Second", "Hour"]
                              .map((e) => DropdownMenuItem<String>(
                                    value: e,
                                    child: Text(
                                      e,
                                      style: GoogleFonts.lato(
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                          fontSize: 14),
                                    ),
                                  ))
                              .toList(),
                          underline: Container(),
                          // hint: Text("Select Mode"),
                          onChanged: (value) {
                            ctrl.TimeMode = value!;
                            ctrl.update();
                          },
                        )),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Pre-Saving :     ",
                    style: GoogleFonts.inter(
                        fontSize: 14, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  _buildDateSelector("Start Date", ctrl.FutureData),
                  if (!ctrl.isSave)
                    InkWell(
                        onTap: () {
                          ctrl.FutureData = "";
                          ctrl.update();
                        },
                        child: Icon(Icons.clear_sharp))
                ],
              ),
              InkWell(
                onTap: () {
                  if (!ctrl.isSave && ctrl.IntervelController.text.isNotEmpty) {
                    ctrl.isSave = true;

                    ctrl.update();
                  } else if (ctrl.IntervelController.text.isEmpty) {
                    FlutterPlatformAlert.showAlert(
                        windowTitle: "Couldn't Connect",
                        text: "Please enter intervel");
                  } else {
                    ctrl.isSave = false;
                    ctrl.update();
                  }
                },
                child: Container(
                  width: 160,
                  height: 50,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(right: 10, top: 10),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Color(0xff191F26)),
                  child: Text(
                    (ctrl.isSave) ? "Stop" : "Start",
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelector(String label, String date) {
    return InkWell(
      onTap: () async {
        if (!ctrl.isSave) {
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

            ctrl.FutureData = combinedDateTime.toString();

            ctrl.update();
          }
        } else {
          FlutterPlatformAlert.showAlert(
              windowTitle: "Couldn't Edit",
              text: "Could'n edit while in live mode");
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 4),
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Color.fromRGBO(142, 142, 142, 1)),
          borderRadius: BorderRadius.circular(6),
        ),
        width: 200,
        child: Text(
          "$date",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
