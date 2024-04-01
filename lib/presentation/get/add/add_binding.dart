import 'package:adi_soft/presentation/get/add/add_controller.dart';
import 'package:get/get.dart';

class AddBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      AddController(),
    );
  }
}
