import 'dart:async';

import 'package:adi_soft/app/config/app_strings.dart';
import 'package:adi_soft/app/config/constants/assets_constants.dart';
import 'package:adi_soft/app/config/localizations/translation_key.dart';
import 'package:adi_soft/app/config/routes/app_routes.dart';
import 'package:adi_soft/app/config/styles/shape_styles.dart';
import 'package:adi_soft/app/config/styles/text_styles.dart';
import 'package:adi_soft/app/exception/app_exception.dart';
import 'package:adi_soft/app/types/snack_bar_type.dart';
import 'package:adi_soft/app/utils/validators/form_validator.dart';
import 'package:adi_soft/domain/entities/feature/app_feature.dart';
import 'package:adi_soft/domain/entities/widget/menu_data.dart';
import 'package:adi_soft/domain/use_cases/network/app/cities_use_case.dart';
import 'package:adi_soft/domain/use_cases/network/app/users_use_case.dart';
import 'package:adi_soft/presentation/ui/widgets/base/actions/base_buttons_view.dart';
import 'package:adi_soft/presentation/ui/widgets/base/communication/base_snackbar_view.dart';
import 'package:adi_soft/presentation/ui/widgets/base/containment/base_spacer_view.dart';
import 'package:adi_soft/presentation/ui/widgets/base/selection/base_menus_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class HomeController extends GetxController {
  final UsersUseCase usersUseCase;
  final CitiesUseCase citiesUseCase;

  HomeController({
    required this.usersUseCase,
    required this.citiesUseCase,
  });

  StreamSubscription<InternetStatus>? connectionListener;
  final formKey = GlobalKey<FormState>();

  final TextEditingController searchETCtrl = TextEditingController();

  final String pageGetXId = "pageGetXId";

  final _users = <AppFeature>[].obs;
  final _sortMenuList = <MenuData>[].obs;
  final _cityMenuList = <MenuData>[].obs;

  final _sortMenuSelected = MenuData().obs;
  final _cityMenuSelected = MenuData().obs;

  final _loadingPage = true.obs;
  final _errorPage = false.obs;
  final _enableButton = false.obs;

  String imageErrorPage = "";
  String titleErrorPage = "";
  String messageErrorPage = "";

  final _errorPageCode = 0.obs;

  ///set user data
  setUserData(List<AppFeature> value) {
    _users.value = value;
  }

  ///set sort data
  setSortData(List<MenuData> value) {
    _sortMenuList.value = value;
  }

  ///set city data
  setCityData(List<MenuData> value) {
    _cityMenuList.value = value;
  }

  ///select sort data
  selectSortMenu(MenuData value) {
    _sortMenuSelected.value = value;
  }

  //select city data
  selectCityMenu(MenuData value) {
    _cityMenuSelected.value = value;
  }

  ///set loading
  setLoadingPage(bool value) {
    if (isLoadingPage != value) {
      _loadingPage.value = value;
    }
  }

  ///set error
  setErrorPage(bool value) {
    if (isErrorPage != value) {
      _errorPage.value = value;
    }
  }

  ///set enable button
  setEnableButton(bool value) {
    if (isEnableButton != value) {
      _enableButton.value = value;
    }
  }

  ///set error code
  setErrorPageCode(int value) {
    _errorPageCode.value = value;
  }

  List<AppFeature> get items => _users.toList();

  List<MenuData> get sortMenuList => _sortMenuList.toList();

  List<MenuData> get cityMenuList => _cityMenuList.toList();

  MenuData get sortMenuSelected => _sortMenuSelected.value;

  MenuData get cityMenuSelected => _cityMenuSelected.value;

  bool get isLoadingPage => _loadingPage.value;

  bool get isErrorPage => _errorPage.value;

  bool get isEnableButton => _enableButton.value;

  int get errorPageCode => _errorPageCode.value;

  @override
  void onInit() {
    super.onInit();
    setSortData([
      MenuData(
        id: "0",
        name: "Nama (A-Z)",
      ),
      MenuData(
        id: "1",
        name: "Nama (Z-A)",
      ),
      MenuData(
        id: "2",
        name: "Kota (A-Z)",
      ),
      MenuData(
        id: "3",
        name: "Kota (Z-A)",
      ),
    ]);

    selectSortMenu(sortMenuList.first);
  }

  @override
  void onReady() {
    super.onReady();
    onCall(index: 2);
    onCall();
  }

  ///function to refresh the page
  onRefreshPage({
    bool refreshPage = false,
    BuildContext? context,
  }) async {
    if (refreshPage) {
      loadingPage();
    }
    onCall(index: 2);
    await onCall();
  }

  ///for submit form
  onSubmit({
    BuildContext? context,
  }) {}

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
        data.insert(
          0,
          MenuData(
            id: "0",
            name: "Seluruh Kota",
          ),
        );
        setCityData(data);
        selectCityMenu(cityMenuList.first);
      }).onError<Exception>((error, stackTrace) {
        setCityData(
          [
            MenuData(
              id: "0",
              name: "Seluruh Kota",
            ),
          ],
        );
        selectCityMenu(cityMenuList.first);
      });
    } else {
      usersUseCase.execute().then((value) {
        if (value.isNotEmpty) {
          List<AppFeature> data = value;

          if (!search) {
            List<AppFeature> sort = value;

            //sort
            if (sortMenuSelected.id == "1") {
              sort.sort((a, b) => b.name!.toLowerCase().compareTo(a.name!.toLowerCase()));
            } else if (sortMenuSelected.id == "2") {
              sort.sort((a, b) => a.city!.toLowerCase().compareTo(b.city!.toLowerCase()));
            } else if (sortMenuSelected.id == "3") {
              sort.sort((a, b) => b.city!.toLowerCase().compareTo(a.city!.toLowerCase()));
            } else {
              sort.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
            }

            //filter
            if (cityMenuSelected.id != "0") {
              data = sort.where((i) => i.city == cityMenuSelected.name).toList();
            } else {
              data = sort;
            }
          } else {
            String search = searchETCtrl.text;
            data = data
                .where((i) =>
                    i.name!.contains(search) ||
                    i.address!.contains(search) ||
                    i.phoneNumber!.contains(search) ||
                    i.email!.contains(search) ||
                    i.city!.contains(search))
                .toList();
          }

          setUserData(data);

          pageLoadSuccess();
        } else {
          pageLoadFail(
            errorPageCode: 2,
          );
        }
      }).onError<Exception>((error, stackTrace) {
        if (error is AppException) {
          errorHandlerPage(
            error,
          );
        } else {
          pageLoadFail(
            errorPageCode: 3,
          );
        }
      });
    }
  }

  ///for change route
  onRoute({
    int? route,
    int? index,
  }) async{
    var result =  await Get.toNamed(
      AppRoutes.addUser,
    );
    if(result != null){
      onCall();
    }
  }

  onFilter() async {
    final result = await Get.bottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: ShapeStyles.rounded(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      Wrap(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.only(
                  top: 32,
                  bottom: 32,
                  left: 16,
                  right: 16,
                ),
                child: Text(
                  "Filter dan Sort",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    BaseMenusView.basicFrameSingleTP(
                      showSearchBox: true,
                      label: "Urutkan berdasarkan:",
                      listItem: sortMenuList,
                      callback: (value) => value != null ? selectSortMenu(value) : null,
                      value: FormValidator.checkValueDropDown<MenuData>(
                        value: sortMenuSelected,
                        valueName: sortMenuSelected.name,
                      ),
                    ),
                    BaseSpacerView.heightMedium,
                    BaseMenusView.basicFrameSingleTP(
                      showSearchBox: true,
                      label: "Data berdasarkan:",
                      listItem: cityMenuList,
                      callback: (value) => value != null ? selectCityMenu(value) : null,
                      value: FormValidator.checkValueDropDown<MenuData>(
                        value: cityMenuSelected,
                        valueName: cityMenuSelected.name,
                      ),
                    ),
                  ],
                ),
              ),
              BaseSpacerView.heightLarge,
              Container(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                ),
                width: double.infinity,
                child: BaseButtonView.flatButton(
                  label: "Tampilkan Filter",
                  textStyle: TextStyles.bottomSheetButtonText(),
                  radiusSize: 15,
                  onPressed: () => Get.back(
                    result: true,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                child: BaseButtonView.flatButton(
                    label: "Hapus Filter",
                    textStyle: TextStyles.bottomSheetButtonText(),
                    radiusSize: 15,
                    onPressed: () {
                      Get.back(
                        result: true,
                      );
                      selectCityMenu(cityMenuList.first);
                      selectSortMenu(sortMenuList.first);
                    },
                    color: Colors.grey.withOpacity(0.1),
                    textColor: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );

    if (result != null && result!) {
      await onCall();
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

  ///enable the display to load the entire content page
  loadingPage() {
    setErrorPage(false);
    setLoadingPage(true);

    update([pageGetXId]);
  }

  ///handles the display when the page successfully loads
  pageLoadSuccess() {
    setErrorPage(false);
    setLoadingPage(false);

    update([pageGetXId]);
  }

  ///handles the display when the page fails to load
  ///Error Code:
  ///0 = no internet connection
  ///1 = data not found
  ///2 = not found
  ///3 = system error
  ///4 = server error
  pageLoadFail({
    int? errorPageCode,
  }) {
    setErrorPageCode(errorPageCode ?? 0);
    setLoadingPage(false);
    setErrorPage(true);

    update([pageGetXId]);
  }

  ///displays a special page view for not found
  notFoundErrorPage() {
    pageLoadFail(
      errorPageCode: 2,
    );
  }

  ///default function to handle error callbacks. this function is called automatically when an error occurs.
  errorHandlerPage(
    AppException exception, {
    Function()? custom,
  }) {
    if (exception.code == AppStrings.codeAEOther ||
        exception.code == AppStrings.codeAEConnectTimeOut ||
        exception.code == AppStrings.codeAEBadCertificate ||
        exception.code == AppStrings.codeAESendTimeOut ||
        exception.code == AppStrings.codeAEReceiveTimeOut) {
      pageLoadFail(
        errorPageCode: 4,
      );
    } else if (exception.code == AppStrings.codeAEConnection || exception.code == AppStrings.codeAECancel) {
      pageLoadFail(
        errorPageCode: 0,
      );
    } else if (exception.code == AppStrings.codeAEResponse) {
      dynamic response = exception.response;
      if (response != null && response is List) {
        if (response.isEmpty) {
          pageLoadFail(
            errorPageCode: 1,
          );
        } else {
          pageLoadFail(
            errorPageCode: 4,
          );
        }
      } else {
        pageLoadFail(
          errorPageCode: 4,
        );
      }
    } else {
      if (custom != null) {
        custom();
      }
    }
  }

  ///handles data for error page display
  Widget builderPageError(
    Widget Function(String image, String title, String subtitle) builder,
  ) {
    if (errorPageCode == 0) {
      return builder(
        AssetsConstants.imageIllustrationNoConnection,
        baseLoadingAndErrorErrorTitle1,
        baseLoadingAndErrorErrorMessage1,
      );
    } else if (errorPageCode == 1) {
      return builder(
        AssetsConstants.imageIllustrationEmptyData,
        baseLoadingAndErrorErrorTitle2,
        baseLoadingAndErrorErrorMessage2,
      );
    } else if (errorPageCode == 2) {
      return builder(
        AssetsConstants.imageIllustrationNotFound,
        baseLoadingAndErrorErrorTitle3,
        baseLoadingAndErrorErrorMessage3,
      );
    } else if (errorPageCode == 3) {
      return builder(
        AssetsConstants.imageIllustrationInternalSystemError,
        baseLoadingAndErrorErrorTitle4,
        baseLoadingAndErrorErrorMessage4,
      );
    } else if (errorPageCode == 4) {
      return builder(
        AssetsConstants.imageIllustrationServerError,
        baseLoadingAndErrorErrorTitle5,
        baseLoadingAndErrorErrorMessage5,
      );
    } else {
      return builder(
        imageErrorPage,
        titleErrorPage,
        messageErrorPage,
      );
    }
  }
}
