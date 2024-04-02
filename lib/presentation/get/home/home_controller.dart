import 'dart:async';

import 'package:adi_soft/app/config/app_strings.dart';
import 'package:adi_soft/app/config/constants/assets_constants.dart';
import 'package:adi_soft/app/config/localizations/translation_key.dart';
import 'package:adi_soft/app/exception/app_exception.dart';
import 'package:adi_soft/app/types/snack_bar_type.dart';
import 'package:adi_soft/domain/entities/feature/app_feature.dart';
import 'package:adi_soft/domain/use_cases/network/app/cities_use_case.dart';
import 'package:adi_soft/presentation/ui/widgets/base/communication/base_snackbar_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class HomeController extends GetxController {
  final UsersUseCase useCase;

  HomeController({
    required this.useCase,
  });

  StreamSubscription<InternetStatus>? connectionListener;
  final formKey = GlobalKey<FormState>();

  final String pageGetXId = "pageGetXId";

  final _users = <AppFeature>[].obs;

  final _loadingPage = true.obs;
  final _errorPage = false.obs;
  final _enableButton = false.obs;

  String imageErrorPage = "";
  String titleErrorPage = "";
  String messageErrorPage = "";

  final _errorPageCode = 0.obs;

  setUserData(List<AppFeature> value) {
    _users.value = value;
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

  bool get isLoadingPage => _loadingPage.value;

  bool get isErrorPage => _errorPage.value;

  bool get isEnableButton => _enableButton.value;

  int get errorPageCode => _errorPageCode.value;

  @override
  void onReady() {
    super.onReady();
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
  }) {
    useCase.execute().then((value) {
      if (value.isNotEmpty) {
        setUserData(value);
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

  ///for change route
  onRoute({
    int? route,
    int? index,
  }) {}

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
