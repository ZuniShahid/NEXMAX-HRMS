import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../constants/app_colors.dart';
import '../../constants/assets.dart';
import '../../constants/gradeinet_background.dart';
import '../announcement/announcement_list.dart';
import '../leaves/leave_page.dart';
import '../notebook/notebook_page.dart';
import '../pay_slip/pay_slip.dart';
import '../salary/advance_salary.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  final List<Widget> _pages = [
    const HomePage(),
    const LeavePage(),
    const PaySlipPage(),
    const AdvanceSalaryPage(),
    const NoteBookPage(),
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Image> icons = [
      Image.asset(
        AppAssets.home,
        width: 34,
        height: 34,
        color: _selectedIndex == 0 ? AppColors.secondary : Colors.white,
      ),
      Image.asset(
        AppAssets.leave,
        width: 34,
        height: 34,
        color: _selectedIndex == 1 ? AppColors.secondary : Colors.white,
      ),
      Image.asset(
        AppAssets.paySlip,
        width: 34,
        height: 34,
        color: _selectedIndex == 2 ? AppColors.secondary : Colors.white,
      ),
      Image.asset(
        AppAssets.advanceSalary,
        width: 55,
        height: 38,
        color: _selectedIndex == 3 ? AppColors.secondary : Colors.white,
      ),
      Image.asset(
        AppAssets.noteBook,
        width: 36,
        height: 34,
        color: _selectedIndex == 4 ? AppColors.secondary : Colors.white,
      ),
    ];
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: _pages[_selectedIndex],
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.only(top: 10),
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              for (int i = 0; i < icons.length; i++)
                GestureDetector(
                  onTap: () {
                    _onItemTapped(i);
                  },
                  child: SizedBox(
                    height: 40,
                    width: 100.w / 5,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        icons[i],
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
