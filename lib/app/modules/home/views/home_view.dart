import 'package:demo/app/data/models/dio/response.dart';
import 'package:demo/app/data/models/search_products.dart';
import 'package:demo/app/widgets/product_view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          // title: const Text('HomeView'),
          backgroundColor: Colors.red,
          centerTitle: true,
          flexibleSpace: controller.showSearch.value
              ? SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 24),
                    child: Row(
                      children: [
                        SizedBox(
                            height: 20,
                            width: ((MediaQuery.sizeOf(context).width) * 0.7),
                            child: TextFormField(
                              controller: controller.searchController,
                              focusNode: controller.searchFocusnode,
                              style: TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  hintText: "Search product",
                                  counterText: "",
                                  errorText: null,
                                  hintStyle: TextStyle(color: Colors.white)),
                            )),
                        IconButton(
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            if (controller.searchController.text
                                .trim()
                                .isEmpty) {
                              Fluttertoast.showToast(
                                  msg:
                                      "Text field empty. Please enter something to search",
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white);
                            } else {
                              controller.isLoading.value = true;

                              RepoResponse<SearchProducts> products =
                                  await controller.getProducts(
                                      controller.searchController.text.trim());
                              controller.products.value = products.data!;
                              controller.isLoading.value = false;

                              if (controller.products.value.products!.isEmpty) {
                                controller.centerText.value =
                                    controller.noDataText;
                              }
                            }
                          },
                          padding: EdgeInsets.all(0),
                          icon: Icon(Icons.search),
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                )
              : null,
        ),
        body: Obx(
          () => controller.isLoading.value
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : (controller.products.value.products ?? []).isEmpty
                  ? Center(
                      child: Text(
                        controller.centerText.value,
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  : ListView.builder(
                      itemCount: controller.products.value.products!.length,
                      itemBuilder: (context, index) {
                        return ProductView(
                            image: controller.products.value.products![index]
                                    .thumbnail ??
                                "",
                            title: controller
                                    .products.value.products![index].title ??
                                "",
                            subTitle: controller.products.value.products![index]
                                    .description ??
                                "");
                      }),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            controller.showSearch.value = true;
            FocusScope.of(context).requestFocus(controller.searchFocusnode);
          },
          backgroundColor: Colors.red,
          child: Icon(Icons.search),
        ),
      ),
    );
  }
}
