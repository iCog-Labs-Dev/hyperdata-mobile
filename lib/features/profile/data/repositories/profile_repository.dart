import 'package:dartz/dartz.dart';
import 'package:leyu_mobile/core/errors/failure.dart';
import 'package:leyu_mobile/features/auth/data/models/user.dart';
import '../datasources/profile_remote_data_source.dart';

abstract class ProfileRepository {
  Future<Either<Failure, User>> getUserProfile();
  Future<Either<Failure, bool>> updateUserProfile(
      Map<String, dynamic> profileData);
  Future<Either<Failure, String?>> uploadProfilePicture(String imagePath);
  Future<Either<Failure, bool>> changePassword(String currentPassword, String newPassword);
}

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, User>> getUserProfile() async {
    try {
      final response = await _remoteDataSource.getUserProfile();
      return Right(response);
    } on Exception catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, bool>> updateUserProfile(
      Map<String, dynamic> profileData) async {
    try {
      final response = await _remoteDataSource.updateUserProfile(profileData);
      return Right(response);
    } on Exception catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String?>> uploadProfilePicture(
      String imagePath) async {
    try {
      final response = await _remoteDataSource.uploadProfilePicture(imagePath);
      return Right(response);
    } on Exception catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, bool>> changePassword(String currentPassword, String newPassword) async {
    try {
      final response = await _remoteDataSource.changePassword(currentPassword, newPassword);
      return Right(response);
    } on Exception catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
}
