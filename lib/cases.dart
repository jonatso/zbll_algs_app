import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'alg.dart';
import 'dbhelper.dart';
import 'case.dart';
import 'algset.dart';

class Cases extends StatefulWidget {
  final int setId;

  Cases(this.setId);

  @override
  _CasesState createState() => _CasesState(setId);
}

class _CasesState extends State<Cases> {
  int setId;
  Future<List<Case>> cases;
  _CasesState(int setId) {
    this.setId = setId;
    cases = DBHelper.getCases(setId);
  }

  void setAlgSet(Algset algset) {
    cases = DBHelper.getCases(algset.algset_id);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: cases,
        builder: (context, snapshot) {
          print(snapshot.data);
          if (snapshot.data == null) {
            return CircularProgressIndicator();
          } else {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300,
                  childAspectRatio: .88,
                  crossAxisSpacing: 3,
                  mainAxisSpacing: 3),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) =>
                                CasePage(snapshot.data[index])));
                  },
                  child: Card(
                      child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          snapshot.data[index].case_name
                              .substring(5), //substring removes "ZBLL "
                          style: DefaultTextStyle.of(context)
                              .style
                              .apply(fontSizeFactor: 1.75),
                        ),
                      ),
                      SvgPicture.asset(
                        snapshot.data[index].getPicURL(),
                        height: 100,
                        width: 100,
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: FutureBuilder(
                          future: DBHelper.getMainAlg(snapshot.data[index]),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot2) {
                            if (snapshot2.data == null) {
                              return Text("Loading algs...");
                            } else {
                              return Text(
                                snapshot2.data.alg,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              );
                            }
                          },
                        ),
                      )
                    ],
                  )),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class CasePage extends StatefulWidget {
  final Case case2;

  CasePage(this.case2);

  @override
  _CasePageState createState() => _CasePageState(case2);
}

class _CasePageState extends State<CasePage> {
  final Case case2;
  Future<List<Alg>> algs;

  _CasePageState(this.case2);

  void initState() {
    //hvorfor må jeg ha algs inni her???
    super.initState();
    algs = DBHelper().getAlgs(case2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.case2.case_name),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          SvgPicture.asset(
            widget.case2.getPicURL(),
            height: 180,
            width: 180,
          ),
          Expanded(
            child: FutureBuilder(
              future: algs,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                print(snapshot.data);
                if (snapshot.data == null) {
                  return Container(
                      child: Center(child: Text("Loading algs...")));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: ListTile(
                          title: Text(snapshot.data[index].alg),
                          subtitle: Text(snapshot.data[index].time_added),
                          trailing: IconButton(
                            icon: Icon(Icons.star, size: 45),
                            color: snapshot.data[index].in_use == 1
                                ? Colors.yellow
                                : Colors.grey,
                            iconSize: 50,
                            onPressed: () {
                              setState(() {
                                DBHelper.setMainAlg(snapshot.data[index]);
                                //algs = DBHelper().getAlgs(case2);
                              });
                              Fluttertoast.showToast(
                                msg: "You've updated your main alg",
                                backgroundColor: Colors.grey.shade100,
                                textColor: Colors.black,
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
