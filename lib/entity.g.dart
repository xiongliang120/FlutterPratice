// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Person _$PersonFromJson(Map<String, dynamic> json) {
  return Person(
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    dateOfBirth: json['dateOfBirth'] == null
        ? null
        : DateTime.parse(json['dateOfBirth'] as String),
    child: json['child'] == null
        ? null
        : Children.fromJson(json['child'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PersonToJson(Person instance) => <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'child': instance.child,
    };

Children _$ChildrenFromJson(Map<String, dynamic> json) {
  return Children(
    json['age'] as int,
    json['school'] as String,
  );
}

Map<String, dynamic> _$ChildrenToJson(Children instance) => <String, dynamic>{
      'age': instance.age,
      'school': instance.school,
    };
