import 'package:adi_soft/app/config/app_constants.dart';
import 'package:adi_soft/app/config/app_dimens.dart';
import 'package:adi_soft/app/config/app_strings.dart';
import 'package:adi_soft/app/config/localizations/translation_key.dart';
import 'package:adi_soft/app/config/styles/text_styles.dart';
import 'package:adi_soft/presentation/get/home/home_controller.dart';
import 'package:adi_soft/presentation/ui/widgets/base/actions/base_buttons_view.dart';
import 'package:adi_soft/presentation/ui/widgets/base/containment/base_cards_view.dart';
import 'package:adi_soft/presentation/ui/widgets/base/containment/base_spacer_view.dart';
import 'package:adi_soft/presentation/ui/widgets/base/navigation/base_top_app_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseTopAppBarView.whiteAppBar(
        context,
        title: const Text("Users"),
        paddingRight: 0,
        actions: [
          ConstrainedBox(
            constraints: const BoxConstraints.tightFor(width: 56),
            child: IconButton(
              onPressed: () => controller.onFilter(),
              icon: Image.asset(
                AssetsConstants.iconSort,
                width: 20,
              ),
              tooltip: "Sort and Filter",
            ),
          ),
        ],
      ),
      body: GetBuilder<HomeController>(
        id: controller.pageGetXId,
        builder: (controller) {
          if (!controller.isLoadingPage && !controller.isErrorPage) {
            return Obx(() {
              return RefreshIndicator(
                onRefresh: () => controller.onRefreshPage(),
                child: ListView.separated(
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  separatorBuilder: (_, __) => BaseSpacerView.heightMedium,
                  itemBuilder: (context, index) {
                    var data = controller.items[index];
                    return ListTile(
                      title: Text(data.name ?? AppStrings.defaultNullValue),
                      subtitle: Text("${data.city ?? AppStrings.defaultNullValue} | ${data.phoneNumber ?? AppStrings.defaultNullValue}"),
                      leading: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(100.0),
                        ),
                        child: Image.asset(
                          AssetsConstants.imageDefaultProfile,
                          height: AppDimens.circularProfileSize,
                          width: AppDimens.circularProfileSize,
                        ),
                      ),
                      onTap: () => controller.onRoute(
                        index: index,
                      ),
                    );
                  },
                  itemCount: controller.items.length,
                ),
              );
            });
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (controller.isErrorPage) ...{
                  Expanded(
                    child: controller.builderPageError(
                      (image, title, subtitle) => BaseCardsView.informationDisplay(
                        image: image,
                        title: title.tr,
                        subtitle: subtitle.tr,
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    height: 65,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 8,
                        bottom: 8,
                        left: 16,
                        right: 16,
                      ),
                      child: BaseButtonView.flatButton(
                        label: baseLoadingAndErrorRefreshButton.tr,
                        textStyle: TextStyles.directTransactionFlatButtonText,
                        radiusSize: 16,
                        onPressed: () => controller.onRefreshPage(
                          refreshPage: true,
                        ),
                      ),
                    ),
                  ),
                } else ...{
                  const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                },
              ],
            );
          }
        },
      ),
    );
  }
}
