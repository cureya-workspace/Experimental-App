import 'package:cureya_exp_mobile_app/components/appbar.dart';
import 'package:cureya_exp_mobile_app/helpers/appointment_helper.dart';
import 'package:cureya_exp_mobile_app/screens/appointment_detail_screen.dart';
import 'package:cureya_exp_mobile_app/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentHistoryScreen extends StatefulWidget {
  const AppointmentHistoryScreen({super.key});

  @override
  State<AppointmentHistoryScreen> createState() =>
      _AppointmentHistoryScreenState();
}

class _AppointmentHistoryScreenState extends State<AppointmentHistoryScreen> {
  int page = 1;
  List myAppointments = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;

  @override
  initState() {
    super.initState();
    if (myAppointments.isEmpty) {
      _fetch(page);
      page++;
      _fetch(page);
    }

    _scrollController.addListener(() {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent ||
          page == 1) {
        page = page + 1;
        _fetch(page);
      }
    });
  }

  _fetch(int pageNo) async {
    setState(() {
      _isLoading = true;
    });
    var response = await AppointmentHelper.fetchAppointments(pageNo);
    print(page);
    if (response['paging']['next'] != null || page == 1) {
      if (page == 1) {
        setState(() {
          myAppointments = response['data'];
        });
      } else {
        setState(() {
          for (var element in response['data']) {
            myAppointments.add(element);
          }
        });
      }
    }
    print("object end");
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            CustomAppBar(
                title: "My Appointments",
                description: "Track your appointments, see status of them!"),
            Expanded(
                child: Column(
              children: [
                Flexible(
                  child: ListView.builder(
                      controller: _scrollController,
                      itemCount: myAppointments.length,
                      itemBuilder: (context, index) => ListTile(
                        onTap: () {
                          Navigator.push(context, 
                            MaterialPageRoute(builder: (context) => AppointmentDetailScreen(appointmentId: myAppointments[index]['id']))
                          );
                        },
                            title: Text(
                                myAppointments[index]['diagnostic_centre']['name']),
                                subtitle: Text(myAppointments[index]['diagnostic_centre']['city'],
                                  style: TextStyle(
                                    color: Colors.grey[600]
                                  ),
                                ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    "${DateFormat.yMMMd().format(DateTime.parse(myAppointments[index]['visit_date']))} | ${myAppointments[index]['slot']}"),
                              const SizedBox(height: 4),
                              Text(myAppointments[index]['status']),
                              ],
                            ),
                          )),
                ),
                _isLoading
                    ? const CircularProgressIndicator()
                    : const SizedBox()
              ],
            )),
            SizedBox(
              width: double.maxFinite,
              child: MaterialButton(
                elevation: 0,
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  SearchScreen(),));
                },
                textColor: Colors.white,
                color: const Color.fromRGBO(72, 187, 120, 1),
                child: const Text("Search another test"),
              ),
              )
          ],
        ),
      )),
    );
  }
}
