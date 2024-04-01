import 'package:adi_soft/app/core/use_cases/no_param_use_case.dart';
import 'package:adi_soft/domain/entities/feature/app_feature.dart';
import 'package:adi_soft/domain/repository/app/user_repository.dart';

class UsersUseCase extends NoParamUseCase<List<AppFeature>> {
  final UserRepository _repo;

  UsersUseCase(this._repo);

  @override
  Future<List<AppFeature>> execute() {
    return _repo.list();
  }
}
