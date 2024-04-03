import 'package:adi_soft/app/config/localizations/translation_key.dart';
import 'package:adi_soft/app/types/snack_bar_type.dart';
import 'package:adi_soft/domain/entities/feature/app_feature.dart';
import 'package:adi_soft/domain/entities/widget/menu_data.dart';
import 'package:adi_soft/domain/use_cases/network/app/add_city_use_case.dart';
import 'package:adi_soft/domain/use_cases/network/app/add_user_use_case.dart';
import 'package:adi_soft/domain/use_cases/network/app/cities_use_case.dart';
import 'package:adi_soft/presentation/ui/widgets/base/communication/base_snackbar_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class AddController extends GetxController {
  final AddUserUseCase addUserUseCase;
  final CitiesUseCase citiesUseCase;
  final AddCityUseCase addCityUseCase;

  AddController({
    required this.addUserUseCase,
    required this.citiesUseCase,
    required this.addCityUseCase,
  });

  final TextEditingController nameETCtrl = TextEditingController();
  final TextEditingController phoneNumberETCtrl = TextEditingController();
  final TextEditingController emailETCtrl = TextEditingController();

  final TextEditingController otherETCtrl = TextEditingController();
  final TextEditingController addressETCtrl = TextEditingController();

  final _cityMenuList = <MenuData>[].obs;

  final _cityMenuSelected = MenuData().obs;

  final _enableButton = false.obs;

  ///set city data
  setCityData(List<MenuData> value) {
    _cityMenuList.value = value;
  }

  //select city data
  selectCityMenu(MenuData value) {
    _cityMenuSelected.value = value;
  }

  ///set enable button
  setEnableButton(bool value) {
    if (isEnableButton != value) {
      _enableButton.value = value;
    }
  }

  List<MenuData> get cityMenuList => _cityMenuList.toList();

  MenuData get cityMenuSelected => _cityMenuSelected.value;

  bool get isEnableButton => _enableButton.value;

  @override
  void onReady() {
    super.onReady();
    onCall(index: 3);
  }

  onSubmit({
    BuildContext? context,
  }) {
    callWhenConnected(() {});
  }

  ///to call a function related to processes and data
  onCall({
    BuildContext? context,
    int? index,
    bool? pageScope,
    bool? hideError,
    bool? hideFailed,
    bool? useBasicHandleFailed,
    bool search = false,
  }) {
    if (index == 2) {
      addCityUseCase.execute(
        AppFeature(
          name: otherETCtrl.text,
        ),
      );
    } else if (index == 3) {
      citiesUseCase.execute().then((value) {
        List<MenuData> data = [];
        for (var i in value) {
          data.add(
            MenuData(
              id: i.id,
              name: i.name,
            ),
          );
        }
        data.add(
          MenuData(
            id: "0",
            name: "Lainnya",
          ),
        );
        setCityData(data);
      }).onError<Exception>((error, stackTrace) {
        setCityData(
          [
            MenuData(
              id: "0",
              name: "Lainnya",
            ),
          ],
        );
      });
    } else {
      addUserUseCase
          .execute(
            AppFeature(
              name: nameETCtrl.text,
              email: emailETCtrl.text,
              address: addressETCtrl.text,
              phoneNumber: phoneNumberETCtrl.text,
              city: cityMenuSelected.id == "0" ? otherETCtrl.text : cityMenuSelected.name,
            ),
          )
          .then((value) => Get.back(result: true))
          .onError<Exception>((error, stackTrace) => noTitleSnackBar(snackBarType: SnackBarType.error, message: "Terjadi kesalahan"));
    }
  }

  ///to check the internet connection on the device
  Future<bool> isConnected() async {
    return await InternetConnection().hasInternetAccess;
  }

  ///calling a function after internet checking
  callWhenConnected(Function function) async {
    bool connected = await isConnected();
    if (connected) {
      function();
    } else {
      noInternetSnackBar();
    }
  }

  ///displays a special snackbar for no internet notifications
  noInternetSnackBar() {
    noTitleSnackBar(
      snackBarType: SnackBarType.warning,
      message: baseErrorMessage1.tr,
      primary: true,
    );
  }

  ///displays a snackbar with a design without a title
  noTitleSnackBar({
    SnackBarType snackBarType = SnackBarType.success,
    String? message,
    Color? color,
    bool primary = false,
    SnackPosition? snackPosition,
  }) {
    BaseSnackBarView.basicWithOutTitle(
      message: message ?? "",
      snackBarType: snackBarType,
      color: color,
      primary: primary,
      snackPosition: snackPosition,
    );
  }

  checkAllField() {
    if (nameETCtrl.text.isEmpty && phoneNumberETCtrl.text.isEmpty && emailETCtrl.text.isEmpty && addressETCtrl.text.isEmpty) {
      setEnableButton(false);
    } else {
      setEnableButton(true);
    }
  }
}
