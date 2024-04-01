import 'package:adi_soft/data/models/feature/app_feature_model.dart';
import 'package:adi_soft/data/providers/network/api_data_source.dart';
import 'package:adi_soft/data/providers/network/api_endpoint.dart';
import 'package:adi_soft/data/providers/network/api_request_representable.dart';

abstract class CityRemoteDataSource {
  Future<AppFeatureModel> addData(
    AppFeatureModel data,
  );

  Future<List<AppFeatureModel>> listData();
}

class CityRemoteDataSourceImpl extends ApiDataSource implements CityRemoteDataSource {
  @override
  Future<AppFeatureModel> addData(AppFeatureModel data) async {
    final response = await execute(
      endpoint: ApiEndpoint.city,
      body: data.toJson(),
      method: HTTPMethod.post,
    );

    return AppFeatureModel.fromJson(response);
  }

  @override
  Future<List<AppFeatureModel>> listData() async {
    final response = await execute(
      endpoint: ApiEndpoint.city,
      method: HTTPMethod.get,
    );

    return response
        .map<AppFeatureModel>(
          (item) => AppFeatureModel.fromJson(item),
        )
        .toList();
  }
}
