
import 'package:dartz/dartz.dart';
import 'package:leyu_mobile/features/auth/data/models/language.dart';
import 'package:leyu_mobile/features/auth/data/models/verification_response.dart';

import '../../../../../core/errors/failure.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/datasources/base_data_remote_data_source.dart';
import '../../data/models/dialect.dart';
import '../../data/models/login_response.dart';

class BaseDataRepository {
  final BaseDataRemoteDataSource _remoteDataSource;
  BaseDataRepository(this._remoteDataSource);

  Future<Either<Failure, List<Language>>> getLanguages() async {
    try {
      final response = await _remoteDataSource.getLanguages();
      return Right(response);
    }
    on Exception catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  Future<Either<Failure, List<Dialect>>> getDialects(String languageId) async {
    try {
      final response = await _remoteDataSource.getDialects(languageId);
      return Right(response);
    }
    on Exception catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

}
