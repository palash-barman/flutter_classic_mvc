import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:demo_project/controllers/products_controller.dart';
import 'package:demo_project/views/base/empty_widget.dart';
import 'package:demo_project/views/base/error_widget.dart';
import 'package:demo_project/views/base/loading_widget.dart';
import 'package:demo_project/views/base/product_card.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductsController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('products'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: controller.logout,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.products.isEmpty) {
          return const LoadingWidget();
        }

        if (controller.hasError.value && controller.products.isEmpty) {
          return AppErrorWidget(
            message: controller.errorMessage.value,
            onRetry: controller.refreshProducts,
          );
        }

        if (controller.products.isEmpty) {
          return EmptyWidget(message: 'no_products'.tr);
        }

        return RefreshIndicator(
          onRefresh: controller.refreshProducts,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount:
                controller.products.length + (controller.hasMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == controller.products.length) {
                controller.loadMoreProducts();
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              return ProductCard(product: controller.products[index]);
            },
          ),
        );
      }),
    );
  }
}
