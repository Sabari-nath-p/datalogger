import 'package:data_logger/Screen/Service/controller.dart';
import 'package:data_logger/Screen/View/DataView.dart';
import 'package:data_logger/Screen/View/PloterTableview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final HomeController ctrl = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<HomeController>(
        builder: (_) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(),
              _buildDataView(),
              _buildModeSelector(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 10),
      color: Color(0xff191F26),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "   SAKS Crystal Datalogger",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ),
          if (ctrl.Mode == 1)
            _buildControlButton("Export Data", Colors.white, () {
              ctrl.showSaveDialog(context);
            }),
        ],
      ),
    );
  }

  Widget _buildControlButton(String text, Color color, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 80,
        alignment: Alignment.center,
        margin: EdgeInsets.only(right: 10),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: color.withOpacity(.9),
        ),
        child: Text(
          text,
          style: GoogleFonts.lato(fontSize: 14, color: Color(0xff191F26)),
        ),
      ),
    );
  }

  Widget _buildDataView() {
    return Expanded(
      child: ctrl.Mode == 1 ? PloterTableView() : DataView(),
    );
  }

  Widget _buildModeSelector() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      width: double.infinity,
      height: 50,
      color: Color(0xff191F26),
      child: Row(
        children: [
          _buildModeButton("ONLINE", 0),
          _buildModeButton("OFFLINE", 1),
          Expanded(child: Container()),
          _buildPortDropdown(),
          InkWell(
            onTap: () {
              ctrl.UpdatePorts();
            },
            child: Icon(
              Icons.replay_outlined,
              color: Colors.white,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeButton(String text, int mode) {
    return InkWell(
      onTap: () {
        if (!ctrl.isRunning) {
          ctrl.Mode = mode;
          ctrl.update();
        }
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: ctrl.Mode != mode
              ? Colors.white.withOpacity(.5)
              : Colors.white.withOpacity(.96),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xff191F26)),
        ),
      ),
    );
  }

  Widget _buildPortDropdown() {
    return SizedBox(
      width: 100,
      child: DropdownButton<String>(
        value: ctrl.portController,
        dropdownColor: Color(0xff191F26),
        items: ctrl.PortList.map((e) => DropdownMenuItem<String>(
              value: e,
              child: SizedBox(
                width: 76,
                height: 20,
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
        onChanged: ctrl.isRunning
            ? null
            : (value) {
                ctrl.portController = value!;
                ctrl.update();
              },
      ),
    );
  }
}
