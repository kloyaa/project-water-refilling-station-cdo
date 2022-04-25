import 'package:app/common/pretty_print.dart';
import 'package:app/const/url.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  Future<void> createOrder(order) async {
    try {
      await Dio().post(baseUrl + "/order", data: order);
      Get.toNamed("/customer");
    } on DioError catch (e) {
      Get.back();
      if (kDebugMode) {
        prettyPrint("orderController()", e.response!.data);
      }
    }
  }

  Future<dynamic> getOrders({
    required accountId,
    status,
    required accountType,
  }) async {
    try {
      final _getOrders = await Dio().get(
        baseUrl + "/order",
        queryParameters: {
          "accountId": accountId,
          "accountType": accountType,
          "status": status,
        },
      );

      return _getOrders.data;
    } on DioError catch (e) {
      Get.back();
      if (kDebugMode) {
        prettyPrint("getOrders()", e.response!.data);
      }
    }
  }

  Future<void> updateOrderStatus({id, status}) async {
    print({id, status});
    await Dio().put(baseUrl + "/order", queryParameters: {
      "_id": id,
      "status": status,
    });
  }

  Future<void> deleteOrder(id) async {
    await Dio().delete(baseUrl + "/order/$id");
  }
}
