import '../../../../core/network/api_client.dart';
import '../../../../core/utils/constants.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts({required int skip, required int limit});
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiClient apiClient;

  ProductRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<ProductModel>> getProducts({required int skip, required int limit}) async {
    final response = await apiClient.get(
      ApiUrls.products,
      queryParams: {
        'limit': limit.toString(),
        'skip': skip.toString(),
      },
    );

    final List<dynamic> productsJson = response['products'] ?? [];
    return productsJson.map((json) => ProductModel.fromJson(json)).toList();
  }
}