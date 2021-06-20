class Case {
  // ignore: non_constant_identifier_names
  int case_id;
  // ignore: non_constant_identifier_names
  int algset_id;
  // ignore: non_constant_identifier_names
  String case_name;
  String case_pic;

  Case(this.case_id, this.algset_id, this.case_name, this.case_pic);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'case_id': case_id,
      'algset_id': algset_id,
      'case_name': case_name,
      'case_pic': case_pic,
    };
    return map;
  }

  Case.fromMap(Map<String, dynamic> map) {
    //case_id = map['case_id']; //hvorfor får vi string og ikke int inn???

    case_id = int.parse(map['case_id']);

    algset_id = int.parse(map['algset_id']);
    case_name = map['case_name'];
    case_pic = map['case_pic'];
  }

  getCaseId() {
    return case_id;
  }

  getCaseName() {
    return case_name;
  }

  getAlg() {
    return case_pic;
  }

  getNumString(int n) {
    return n < 10 ? '0$n' : '$n';
  }

  getPicURL() {
    List<String> algsetNames = [
      'u',
      't',
      'l',
      's',
      'as',
      's',
      'as'
    ]; //note duplicates

    return 'assets/alg_pics/' +
        algsetNames[algset_id - 1] +
        '/' +
        algsetNames[algset_id - 1] +
        '_' +
        getNumString(int.parse(case_name.split(' ')[2])) +
        '.svg';
  }
}
