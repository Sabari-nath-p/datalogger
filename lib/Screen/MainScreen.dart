import 'package:data_logger/Screen/Service/controller.dart';
import 'package:data_logger/Screen/View/PloterTableview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class MainScreen extends StatefulWidget {
  MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  HomeController ctrl = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<HomeController>(builder: (_) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 20, bottom: 10),
              color: Color(0xff191F26),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "   Software Name",
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                          color: Colors.white),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      ctrl.startDataListner();
                    },
                    child: Container(
                      width: 80,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(right: 10),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white.withOpacity(.9)),
                      child: Text(
                        (ctrl.isRunning) ? "Stop" : "Start",
                        style: GoogleFonts.lato(
                            fontSize: 14, color: Color(0xff191F26)),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white.withOpacity(.9)),
                    child: Text(
                      "Export Data",
                      style: GoogleFonts.lato(
                          fontSize: 14, color: Color(0xff191F26)),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
                child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  bottom: 0,
                  child: PloterTableView(),
                ),
                Positioned(right: 0, top: 0, bottom: 0, child: Container()),
              ],
            )),
            Container(
              margin: EdgeInsets.only(top: 20),
              width: double.infinity,
              height: 50,
              color: Color(0xff191F26),
              child: Row(
                children: [
                  Expanded(child: Container()),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromRGBO(255, 255, 255, 1)),
                          borderRadius: BorderRadius.circular(6)),
                      width: 40,
                      child: TextField(
                        controller: ctrl.IntervelController,
                        style:
                            GoogleFonts.lato(color: Colors.white, fontSize: 12),
                        onChanged: (value) {
                          if (value.isNumericOnly || value.contains(".")) {
                          } else {
                            ctrl.IntervelController.text = "";
                          }
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            // isCollapsed: true,
                            hintText: "1 ",
                            hintStyle: GoogleFonts.lato(
                                color: Colors.white, fontSize: 14)),
                      )),
                  SizedBox(
                      width: 100,
                      child: DropdownButton<String>(
                        value: (ctrl.isRunning) ? null : ctrl.TimeMode,
                        dropdownColor: Color(0xff191F26),
                        items: ["Minute", "Second"]
                            .map((e) => DropdownMenuItem<String>(
                                  value: e,
                                  child: Text(
                                    e,
                                    style: GoogleFonts.lato(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                        fontSize: 14),
                                  ),
                                ))
                            .toList(),
                        underline: Container(),
                        onChanged: (value) {
                          ctrl.TimeMode = value!;
                          ctrl.update();
                        },
                      )),
                  SizedBox(
                      width: 100,
                      child: DropdownButton<String>(
                        value: (ctrl.PortList.isEmpty)
                            ? null
                            : ctrl.portController,
                        dropdownColor: Color(0xff191F26),
                        items:
                            ctrl.PortList.map((e) => DropdownMenuItem<String>(
                                  value: e,
                                  child: SizedBox(
                                    width: 76,
                                    height: 14,
                                    child: Text(
                                      e,
                                      maxLines: 1,
                                      style: GoogleFonts.lato(
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white,
                                          fontSize: 14),
                                    ),
                                  ),
                                )).toList(),
                        underline: Container(),
                        onChanged: (ctrl.isRunning)
                            ? null
                            : (value) {
                                ctrl.portController = value!;
                                ctrl.update();
                              },
                      )),
                  InkWell(
                    onTap: () {
                      ctrl.UpdatePorts();
                    },
                    child: Icon(
                      Icons.replay_outlined,
                      color: Colors.white,
                      size: 18,
                    ),
                  )
                ],
              ),
            )
          ],
        );
      }),
    );
  }
}
