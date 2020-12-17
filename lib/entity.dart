import 'package:json_annotation/json_annotation.dart';
part 'entity.g.dart';

/**
 * flutter packages pub run build_runner build
 * 使用该命名进行构建, 会根据下面注解对Model生成对应的g.dart 文件
 *
 * flutter packages pub run build_runner watch
 * 自动为后续生成实体类生成对应的g.dart文件
 *
 *
 * 参考网址:
 * https://www.jianshu.com/p/b307a377c5e8
 */
@JsonSerializable(includeIfNull: false)
class Person {
  String firstName;
  String lastName;
  DateTime dateOfBirth;
  Person({this.firstName, this.lastName, this.dateOfBirth});

  //反序列化
  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);

 //序列化
  Map<String, dynamic> toJson() => _$PersonToJson(this);
}

