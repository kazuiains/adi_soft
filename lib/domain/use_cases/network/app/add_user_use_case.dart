import 'package:adi_soft/app/core/use_cases/param_use_case.dart';
import 'package:adi_soft/domain/entities/feature/app_feature.dart';
import 'package:adi_soft/domain/repository/app/user_repository.dart';

class AddUserUseCase extends ParamUseCase<AppFeature, AppFeature> {
  final UserRepository _repo;

  AddUserUseCase(this._repo);

  @override
  Future<AppFeature> execute(params) {
    return _repo.add(params);
  }
}
