import 'package:demo/app/data/models/dio/response.dart';
import 'package:demo/app/data/models/search_products.dart';
import 'package:demo/app/data/network/network_requester.dart';
import 'package:demo/app/data/values/env.dart';
import 'package:demo/utils/exception_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController



FocusNode searchFocusnode = FocusNode();
TextEditingController searchController = TextEditingController();

RxBool showSearch = false.obs;
RxBool isLoading = false.obs;




Rx<SearchProducts> products = SearchProducts().obs;

Rx<String> centerText = "".obs;
String primaryText = 'Search to see product list';
String noDataText = "No data found with this id";
  @override
  void onInit() {
    super.onInit();
    centerText.value = primaryText;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

 Future<RepoResponse<SearchProducts>> getProducts(String product) async {
       
    final response = await NetworkRequester().get(
       path: Env.baseURL,
query: {"q":product}
        );

    return response is APIException
        ? RepoResponse(error: response)
        : RepoResponse(data: SearchProducts.fromJson(response));
  }


}
