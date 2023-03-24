import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voting_app/screens/events.dart';

import '../flutterflow/flutter_flow_theme.dart';
import '../objects/Company.dart';
import '../services/firestore_functions.dart';
import '../widgets/create_company.dart';

class Companies extends StatefulWidget {
  const Companies({super.key});

  @override
  State<Companies> createState() => _CompaniesState();
}

class _CompaniesState extends State<Companies> {
  bool createbox = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCompanyList();
  }

  List<Company> companies = [];

  getCompanyList() async {
    companies = await FirestoreFunctions().getCompanies();
    setState((){
      companies;
    });

    print("iwjeofwjioe");
    print(companies);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child:
        Column(
          children: [
            Align(
              alignment: AlignmentDirectional(-0.85, 0),
              child: Text(
                'Companies',
                style: FlutterFlowTheme.of(context).bodyText1.override(
                      fontFamily: 'Urbanist',
                      color: FlutterFlowTheme.of(context).darkBGstatic,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Container(
              height: 360,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: companies.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(CompanyEvents(cid:"cid"));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: const EdgeInsets.all(10),
                      elevation: 0,
                      color: FlutterFlowTheme.of(context).cardBackgroundColor,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.business,
                              color: FlutterFlowTheme.of(context).primaryColor,
                              size: 24,
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    companies[index].cin.isNotEmpty ? Text('${companies[index].cin}',style: TextStyle(color: FlutterFlowTheme.of(context).cardTextColor, fontSize: 12 ) ):Container(),
                                    SizedBox(height: 4),
                                    Text('${companies[index].name}',style: TextStyle(color: FlutterFlowTheme.of(context).cardTextColor, fontSize: 20 ) ),
                                    SizedBox(height: 6),
                                    companies[index].admin == FirebaseAuth.instance.currentUser!.uid ? Container(
                                      width: 70,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context).cardTextColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Admin',
                                          style: FlutterFlowTheme.of(context).bodyText1.override(
                                            fontFamily: 'Urbanist',
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ):Container(),
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.navigate_next), onPressed: () {
                              Get.to(CompanyEvents(cid:"cid"));
                            },)
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(const CreateCompany());
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
