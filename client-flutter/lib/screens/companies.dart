import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voting_app/screens/company_details.dart';
import 'package:voting_app/screens/events.dart';

import '../flutterflow/flutter_flow_theme.dart';
import '../objects/Company.dart';
import '../objects/EmployeeSummary.dart';
import '../services/firestore_functions.dart';
import '../widgets/company_card.dart';
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
    setState(() {
      companies;
    });

    print("in companies");
    print(companies);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              height: MediaQuery.of(context).size.height * 0.79,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: companies.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(CompanyDetails(companies[index]));
                    },
                      child: CompanyCard(companies[index])
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
