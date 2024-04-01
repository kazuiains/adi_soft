import 'package:adi_soft/data/models/feature/app_feature_model.dart';
import 'package:adi_soft/data/providers/network/api_data_source.dart';
import 'package:adi_soft/data/providers/network/api_endpoint.dart';
import 'package:adi_soft/data/providers/network/api_request_representable.dart';

abstract class UserRemoteDataSource {
  Future<AppFeatureModel> addData(
    AppFeatureModel data,
  );

  Future<List<AppFeatureModel>> listData();
}

class UserRemoteDataSourceImpl extends ApiDataSource implements UserRemoteDataSource {
  @override
  Future<AppFeatureModel> addData(AppFeatureModel data) async {
    final response = await execute(
      endpoint: ApiEndpoint.user,
      body: data.toJson(),
      method: HTTPMethod.post,
    );

    return AppFeatureModel.fromJson(response);
  }

  @override
  Future<List<AppFeatureModel>> listData() async {
    final response = await execute(
      endpoint: ApiEndpoint.user,
      method: HTTPMethod.get,
    );

    return response
        .map<AppFeatureModel>(
          (item) => AppFeatureModel.fromJson(item),
        )
        .toList();
  }
}
