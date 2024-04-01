import 'package:adi_soft/app/config/routes/app_routes.dart';
import 'package:adi_soft/presentation/get/add/add_binding.dart';
import 'package:adi_soft/presentation/get/home/home_binding.dart';
import 'package:adi_soft/presentation/ui/pages/add/add_page.dart';
import 'package:adi_soft/presentation/ui/pages/home/home_page.dart';
import 'package:get/get.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.addUser,
      page: () => const AddPage(),
      binding: AddBinding(),
    ),
  ];
}
