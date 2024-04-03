import 'package:adi_soft/app/core/use_cases/no_param_use_case.dart';
import 'package:adi_soft/domain/entities/feature/app_feature.dart';
import 'package:adi_soft/domain/repository/app/city_repository.dart';

class CitiesUseCase extends NoParamUseCase<List<AppFeature>> {
  final CityRepository _repo;

  CitiesUseCase(this._repo);

  @override
  Future<List<AppFeature>> execute() {
    return _repo.list();
  }
}
