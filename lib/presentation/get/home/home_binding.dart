import 'package:adi_soft/data/providers/network/sources/app/user_remote_data_source.dart';
import 'package:adi_soft/data/repository/app/user_repository_impl.dart';
import 'package:adi_soft/domain/use_cases/network/app/cities_use_case.dart';
import 'package:adi_soft/presentation/get/home/home_controller.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    _dataSource();
    _repository();
    _useCase();

    Get.put(
      HomeController(
        useCase: Get.find<UsersUseCase>(),
      ),
    );
  }

  _dataSource() {
    Get.lazyPut(() => UserRemoteDataSourceImpl());
  }

  _repository() {
    Get.lazyPut(
      () => UserRepositoryImpl(
        remoteDataSource: Get.find<UserRemoteDataSourceImpl>(),
      ),
    );
  }

  _useCase() {
    Get.lazyPut(
      () => UsersUseCase(
        Get.find<UserRepositoryImpl>(),
      ),
    );
  }
}
