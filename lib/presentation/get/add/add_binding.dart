import 'package:adi_soft/data/providers/network/sources/app/city_remote_data_source.dart';
import 'package:adi_soft/data/providers/network/sources/app/user_remote_data_source.dart';
import 'package:adi_soft/data/repository/app/city_repository_impl.dart';
import 'package:adi_soft/data/repository/app/user_repository_impl.dart';
import 'package:adi_soft/domain/use_cases/network/app/add_city_use_case.dart';
import 'package:adi_soft/domain/use_cases/network/app/add_user_use_case.dart';
import 'package:adi_soft/domain/use_cases/network/app/cities_use_case.dart';
import 'package:adi_soft/presentation/get/add/add_controller.dart';
import 'package:get/get.dart';

class AddBinding extends Bindings {
  @override
  void dependencies() {
    _dataSource();
    _repository();
    _useCase();

    Get.put(
      AddController(
        addUserUseCase: Get.find<AddUserUseCase>(),
        citiesUseCase: Get.find<CitiesUseCase>(),
        addCityUseCase: Get.find<AddCityUseCase>(),
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
      () => AddUserUseCase(
        Get.find<UserRepositoryImpl>(),
      ),
    );
    Get.lazyPut(
      () => CitiesUseCase(
        Get.find<CityRepositoryImpl>(),
      ),
    );
    Get.lazyPut(
      () => AddCityUseCase(
        Get.find<CityRepositoryImpl>(),
      ),
    );
  }
}
