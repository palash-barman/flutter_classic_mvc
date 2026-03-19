import 'package:demo_project/routes/app_routes.dart';
import 'package:get/get.dart';

import 'package:demo_project/services/api_service.dart';
import 'package:demo_project/services/api_endpoints.dart';
import 'package:demo_project/services/storage_service.dart';
import 'package:demo_project/models/product_model.dart';


class ProductsController extends GetxController {
  final _api = ApiService();

  final products = <ProductModel>[].obs;
  int _currentPage = 1;
  final hasMore = true.obs;
  final isLoadingMore = false.obs;
  
  // Base state
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  Future<void> loadProducts() async {
    _currentPage = 1;
    hasMore.value = true;
    products.clear();

    try {
      isLoading.value = true;
      errorMessage.value = '';
      hasError.value = false;

      final data = await _api.get(
        ApiEndpoints.products,
        queryParams: {'page': _currentPage},
      );
      final responseData = data['data'] as Map<String, dynamic>;
      hasMore.value = responseData['next'] != null;
      final list = responseData['results'] as List;
      final result = list
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();

      if (result.isNotEmpty) {
        products.addAll(result);
        _currentPage++;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreProducts() async {
    if (!hasMore.value || isLoadingMore.value) return;
    isLoadingMore.value = true;

    try {
      final data = await _api.get(
        ApiEndpoints.products,
        queryParams: {'page': _currentPage},
      );
      final responseData = data['data'] as Map<String, dynamic>;
      hasMore.value = responseData['next'] != null;
      final list = responseData['results'] as List;
      final result = list
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();

      if (result.isNotEmpty) {
        products.addAll(result);
        _currentPage++;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      hasError.value = true;
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> refreshProducts() => loadProducts();

  void logout() {
    StorageService().removeToken();
    Get.offAllNamed(AppRoutes.login);
  }
}
