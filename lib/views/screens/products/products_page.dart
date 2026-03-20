import 'package:flutter_classic_mvc/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_classic_mvc/controllers/products_controller.dart';
import 'package:flutter_classic_mvc/views/base/product_card.dart';
import 'package:flutter_classic_mvc/views/base/app_list_view.dart'; // 👈 তোমার reusable widget

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductsController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('products'.tr),
        actions: [
          IconButton(onPressed: (){
            Get.toNamed(AppRoutes.profile);
          }, icon: const Icon(Icons.person)),
          

          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: controller.logout,
          ),
        ],
      ),
      body: Obx(() {
        return AppListView(
          items: controller.products,
          isLoading: controller.isLoading.value,
          isLoadMore: controller.isLoadMore.value,
          hasMore: controller.hasMore.value,
          hasError: controller.hasError.value,
          errorMessage: controller.errorMessage.value,
          onRefresh: controller.refreshProducts,
          onLoadMore: controller.loadMoreProducts,
          item: (product) => ProductCard(product: product),
        );
      }),
    );
  }
}