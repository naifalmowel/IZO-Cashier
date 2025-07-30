import 'package:get/get.dart';
import 'package:cashier_app/models/user_model.dart';

class LoginController extends GetxController {
  late RxList<UserModel> users = RxList([]);
  UserModel? user;
  late RxString userName = ''.obs;
}
