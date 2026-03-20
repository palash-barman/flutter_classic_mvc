import 'package:flutter_classic_mvc/core/base/base_controller.dart';
import 'package:flutter_classic_mvc/models/product_model.dart';
import 'package:flutter_classic_mvc/routes/app_routes.dart';
import 'package:flutter_classic_mvc/services/api_endpoints.dart';
import 'package:flutter_classic_mvc/services/api_service.dart';
import 'package:flutter_classic_mvc/services/storage_service.dart';
import 'package:get/get.dart';

class ProductsController extends BaseController {
  final _api = ApiService();

  final products = <ProductModel>[].obs;
  int _currentPage = 1;
  final hasMore = true.obs;
  final isLoadMore = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  Future<void> loadProducts() async {
    _currentPage = 1;
    hasMore.value = true;
    products.clear();

    final result = await apiCall<List<ProductModel>>(
      () async {
        final data = await _api.get(
          ApiEndpoints.products,
          queryParams: {'page': _currentPage},
        );
        final responseData = data['data'] as Map<String, dynamic>;
        hasMore.value = responseData['next'] != null;
        final list = responseData['results'] as List;
        return list
            .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );

    if (result != null) {
      products.addAll(result);
      _currentPage++;
    }
  }

  Future<void> loadMoreProducts() async {
    if (!hasMore.value || isLoadMore.value) return;
    isLoadMore.value = true;

    final result = await apiCall<List<ProductModel>>(
      () async {
        final data = await _api.get(
          ApiEndpoints.products,
          queryParams: {'page': _currentPage},
        );
        final responseData = data['data'] as Map<String, dynamic>;
        hasMore.value = responseData['next'] != null;
        final list = responseData['results'] as List;
        return list
            .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
      showLoading: false,
    );

    if (result != null) {
      products.addAll(result);
      _currentPage++;
    }

    isLoadMore.value = false;
  }

  Future<void> refreshProducts() => loadProducts();

  void logout() {
    StorageService().removeToken();
    Get.offAllNamed(AppRoutes.login);
  }
}