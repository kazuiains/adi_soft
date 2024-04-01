import 'package:adi_soft/data/models/feature/app_feature_model.dart';
import 'package:adi_soft/data/providers/network/sources/app/city_remote_data_source.dart';
import 'package:adi_soft/domain/entities/feature/app_feature.dart';
import 'package:adi_soft/domain/repository/app/city_repository.dart';

class CityRepositoryImpl implements CityRepository {
  final CityRemoteDataSource remoteDataSource;

  CityRepositoryImpl({
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
