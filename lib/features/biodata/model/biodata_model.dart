import 'dart:convert';

class BiodataModel {
  final String id;
  final String name;
  final int age;
  final String address;

  BiodataModel({
    required this.id,
    required this.name,
    required this.age,
    required this.address,
  });

  BiodataModel copyWith({
    String? id,
    String? name,
    int? age,
    String? address,
  }) {
    return BiodataModel(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'age': age,
      'address': address,
    };
  }

  factory BiodataModel.fromMap(Map<String, dynamic> map) {
    return BiodataModel(
      id: map['id'] as String,
      name: map['name'] as String,
      age: map['age'] as int,
      address: map['address'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory BiodataModel.fromJson(String source) =>
      BiodataModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BiodataModel(id: $id, name: $name, age: $age, address: $address)';
  }

  @override
  bool operator ==(covariant BiodataModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.age == age &&
        other.address == address;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ age.hashCode ^ address.hashCode;
  }
}
