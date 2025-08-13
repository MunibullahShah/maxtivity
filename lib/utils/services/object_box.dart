import 'package:maxtivity/constants/app_constants.dart';
import 'package:maxtivity/objectbox.g.dart';
import 'package:maxtivity/utils/models/user_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class ObjectBox {
  late final Store store;
  late final Box<UserModel> userBox;
  // late final Box<DataModel> dataBox;

  ObjectBox._create(this.store) {
    userBox = Box<UserModel>(store);
    // dataBox = Box<DataModel>(store);
  }

  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
    final store =
        await openStore(directory: p.join(docsDir.path, "obx-example"));
    return ObjectBox._create(store);
  }

  // get user from box on the basis of jwt token
  UserModel getUser(int id) {
    UserModel user = userBox.get(id) ?? UserModel();
    return user;
  }

  // put user in box
  int putUser(UserModel user) {
    int id = userBox.put(user);
    return id;
  }

  // remove user from box
  void removeUser() {
    userBox.remove(user!.id!);
  }

  // remove all users
  void removeAllUsers() {
    userBox.removeAll();
  }

  // // get data from box on the basis of id
  // String getData(int id) {
  //   DataModel data = dataBox.get(id) ?? DataModel();
  //   return data.data ?? "";
  // }

  // // put data in box
  // int putData(DataModel data) {
  //   int id = dataBox.put(data);
  //   return id;
  // }

  // // remove data from box
  // void removeAllData() {
  //   dataBox.removeAll();
  // }
}
