import '../../../../core/network/api_client.dart';
import '../../../../core/utils/constants.dart';
import '../models/post_model.dart';

abstract class PostRemoteDataSource {
  Future<List<PostModel>> getPosts({required int skip, required int limit});
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final ApiClient apiClient;

  PostRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<PostModel>> getPosts({required int skip, required int limit}) async {
    final response = await apiClient.get(
      ApiUrls.posts,
      queryParams: {'limit': limit.toString(), 'skip': skip.toString()},
    );
    final List<dynamic> postsJson = response['posts'] ?? [];
    return postsJson.map((json) => PostModel.fromJson(json)).toList();
  }
}