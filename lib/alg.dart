class Alg {
  // ignore: non_constant_identifier_names
  int alg_id;
  // ignore: non_constant_identifier_names
  int case_id;
  // ignore: non_constant_identifier_names
  String alg;
  String time_added;

  int in_use;

  Alg(this.alg_id, this.case_id, this.alg, this.time_added, this.in_use);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'alg_id': alg_id,
      'case_id': case_id,
      'alg': alg,
      'time_added': time_added,
      'in_use': in_use
    };
    return map;
  }

  Alg.fromMap(Map<String, dynamic> map) {
    alg_id = int.parse(map['alg_id']);
    case_id = int.parse(map['case_id']);
    alg = map['alg'];
    time_added = map['time_added'];
    in_use = int.parse(map['in_use']);
  }
}
