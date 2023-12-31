import 'package:objectbox/objectbox.dart';

@Entity()
class UserModel {
  @Id(assignable: true)
  int? id;

  String? name;
  String? email;
  String? password;

  UserModel({this.id, this.name, this.email, this.password});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id ?? 0;
    data['name'] = this.name ?? "";
    data['email'] = this.email ?? "";
    data['password'] = this.password ?? "";
    return data;
  }
}
