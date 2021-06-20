class Algset {
  int algset_id;
  String algset_name;

  Algset(this.algset_id, this.algset_name);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'algset_id': algset_id,
      'algset_name': algset_name,
    };
    return map;
  }

  Algset.fromMap(Map<String, dynamic> map) {
    algset_id = int.parse(map['algset_id']);

    algset_name = map['algset_name'];
  }
}
