import 'dart:convert';

class MahasiswaModel {
  final String id;
  final String name;
  final String nim;

  MahasiswaModel({
    required this.id,
    required this.name,
    required this.nim,
  });

  MahasiswaModel copyWith({
    String? id,
    String? name,
    String? nim,
  }) {
    return MahasiswaModel(
      id: id ?? this.id,
      name: name ?? this.name,
      nim: nim ?? this.nim,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'nim': nim,
    };
  }

  factory MahasiswaModel.fromMap(Map<String, dynamic> map) {
    return MahasiswaModel(
      id: map['id'] as String,
      name: map['name'] as String,
      nim: map['nim'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MahasiswaModel.fromJson(String source) =>
      MahasiswaModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'MahasiswaModel(id: $id, name: $name, nim: $nim)';

  @override
  bool operator ==(covariant MahasiswaModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.nim == nim;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ nim.hashCode;
}
