import 'package:adi_soft/app/utils/validators/form_validator.dart';
import 'package:adi_soft/domain/entities/widget/menu_data.dart';
import 'package:adi_soft/presentation/get/add/add_controller.dart';
import 'package:adi_soft/presentation/ui/widgets/base/actions/base_buttons_view.dart';
import 'package:adi_soft/presentation/ui/widgets/base/containment/base_spacer_view.dart';
import 'package:adi_soft/presentation/ui/widgets/base/navigation/base_top_app_bar_view.dart';
import 'package:adi_soft/presentation/ui/widgets/base/selection/base_menus_view.dart';
import 'package:adi_soft/presentation/ui/widgets/base/text_inputs/base_text_fields_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPage extends GetView<AddController> {
  const AddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseTopAppBarView.whiteAppBar(
        context,
        title: const Text("Tambah Pengguna"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BaseTextFieldsView.basicFrame(
                controller: controller.nameETCtrl,
                label: "Nama",
                textInputAction: TextInputAction.next,
                onChanged: (value) => controller.checkAllField(),
              ),
              BaseSpacerView.formTextFieldBasicFrameSpace,
              BaseTextFieldsView.basicFrame(
                controller: controller.emailETCtrl,
                label: "Email",
                textInputAction: TextInputAction.next,
                onChanged: (value) => controller.checkAllField(),
              ),
              BaseSpacerView.formTextFieldBasicFrameSpace,
              BaseTextFieldsView.basicFrame(
                controller: controller.phoneNumberETCtrl,
                label: "Nomor Telepon",
                textInputAction: TextInputAction.next,
                onChanged: (value) => controller.checkAllField(),
              ),
              BaseSpacerView.formTextFieldBasicFrameSpace,
              Obx(() {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    BaseMenusView.basicFrameSingleTP(
                      showSearchBox: true,
                      label: "Kota",
                      listItem: controller.cityMenuList,
                      callback: (value) => value != null ? controller.selectCityMenu(value) : null,
                      value: FormValidator.checkValueDropDown<MenuData>(
                        value: controller.cityMenuSelected,
                        valueName: controller.cityMenuSelected.name,
                      ),
                    ),
                    BaseSpacerView.formTextFieldBasicFrameSpace,
                    if (controller.cityMenuSelected.id == "0") ...{
                      BaseTextFieldsView.basicFrame(
                        controller: controller.otherETCtrl,
                        label: "Kota Lainnya",
                        textInputAction: TextInputAction.next,
                        onChanged: (value) => controller.checkAllField(),
                      ),
                      BaseSpacerView.formTextFieldBasicFrameSpace,
                    }
                  ],
                );
              }),
              BaseTextFieldsView.basicFrame(
                controller: controller.addressETCtrl,
                label: "Alamat",
                maxLines: 6,
                minLines: 6,
                textInputAction: TextInputAction.done,
                onChanged: (value) => controller.checkAllField(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: 16,
          right: 16,
        ),
        child: Obx(
          () => BaseButtonView.flatButton(
            label: "Tambah",
            radiusSize: 50,
            onPressed: controller.isEnableButton
                ? () => controller.onSubmit(
                      context: context,
                    )
                : null,
          ),
        ),
      ),
    );
  }
}
