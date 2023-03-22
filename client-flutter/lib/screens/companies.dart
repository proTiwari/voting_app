import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voting_app/screens/events.dart';

import '../flutterflow/flutter_flow_theme.dart';
import '../services/firestore_functions.dart';

class Companies extends StatefulWidget {
  const Companies({super.key});

  @override
  State<Companies> createState() => _CompaniesState();
}

class _CompaniesState extends State<Companies> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCompanyList();
  }

  var companies = [];

  getCompanyList() async {
    companies = await FirestoreFunctions().getCompanies();
    print("iwjeofwjioe");
    print(companies);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Column(
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
                    child: Align(
                      alignment: AlignmentDirectional(-0.05, -0.8),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(220, 59, 58, 58),
                            borderRadius: BorderRadius.circular(18),
                          ),
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
    );
  }
}
