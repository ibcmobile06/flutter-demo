import 'package:demo/app/data/values/constants.dart';

import 'package:get_storage/get_storage.dart';

class Storage {
  Storage._privateConstructor();

  static final _box = GetStorage();

  static void setUserToken(String? token) {
    _box.write(Constants.token, token);
  }

  static String? getUserToken() => _box.read(Constants.token);

  

  static void clean() {
    _box.erase();
  }
}
