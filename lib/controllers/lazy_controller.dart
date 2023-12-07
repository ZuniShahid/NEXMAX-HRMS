import 'package:get/get.dart';
import 'package:nexmax_hrms/controllers/advance_salary_controller.dart';
import 'package:nexmax_hrms/controllers/announcement_controller.dart';
import 'package:nexmax_hrms/controllers/leaves_controller.dart';
import 'package:nexmax_hrms/controllers/notebook_controller.dart';
import 'package:nexmax_hrms/controllers/payslip_controller.dart';

import 'auth_controller.dart';


// LazyController class is a subclass of Bindings class from the Get package.
class LazyController extends Bindings {
  @override
  Future<void> dependencies() async {
    Get.put(AuthController());
  }
}
