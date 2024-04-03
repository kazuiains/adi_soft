import 'package:adi_soft/data/providers/network/sources/app/city_remote_data_source.dart';
import 'package:adi_soft/data/providers/network/sources/app/user_remote_data_source.dart';
import 'package:adi_soft/data/repository/app/city_repository_impl.dart';
import 'package:adi_soft/data/repository/app/user_repository_impl.dart';
import 'package:adi_soft/domain/use_cases/network/app/cities_use_case.dart';
import 'package:adi_soft/domain/use_cases/network/app/users_use_case.dart';
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
        usersUseCase: Get.find<UsersUseCase>(),
        citiesUseCase: Get.find<CitiesUseCase>(),
      ),
    );
  }

  _dataSource() {
    Get.lazyPut(() => UserRemoteDataSourceImpl());
    Get.lazyPut(() => CityRemoteDataSourceImpl());
  }

  _repository() {
    Get.lazyPut(
      () => UserRepositoryImpl(
        remoteDataSource: Get.find<UserRemoteDataSourceImpl>(),
      ),
    );
    Get.lazyPut(
      () => CityRepositoryImpl(
        remoteDataSource: Get.find<CityRemoteDataSourceImpl>(),
      ),
    );
  }

  _useCase() {
    Get.lazyPut(
      () => UsersUseCase(
        Get.find<UserRepositoryImpl>(),
      ),
    );
    Get.lazyPut(
      () => CitiesUseCase(
        Get.find<CityRepositoryImpl>(),
      ),
    );
  }
}
