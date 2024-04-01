import 'package:adi_soft/domain/entities/feature/app_feature.dart';

abstract class CityRepository {
  Future<AppFeature> add(
    dynamic data,
  );

  Future<List<AppFeature>> list();
}
