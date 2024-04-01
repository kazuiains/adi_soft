import 'package:adi_soft/data/models/feature/app_feature_model.dart';
import 'package:adi_soft/data/providers/network/sources/app/user_remote_data_source.dart';
import 'package:adi_soft/domain/entities/feature/app_feature.dart';
import 'package:adi_soft/domain/repository/app/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<AppFeature> add(data) async {
    final request = AppFeatureModel.fromDynamic(data);
    return remoteDataSource.addData(request);
  }

  @override
  Future<List<AppFeature>> list() async {
    return remoteDataSource.listData();
  }
}
