import 'package:cureya_exp_mobile_app/constants/constants.dart';
import 'package:cureya_exp_mobile_app/services/http_service_singleton.dart';

class AppointmentHelper {
  static Future createAppointment(
      Map<String, dynamic> appointmentDetails) async {
    return (await HttpServiceSingleton().makeRequest(
        url: '$BASE_URI/appointment',
        method: HTTPMethod.POST,
        headers: {'content-type': 'application/json'},
        includeAuthCredentials: true,
        body: appointmentDetails));
  }

  static Future<Map> fetchAppointments([int page=1]) async {
    return (await HttpServiceSingleton().makeRequest(
        url: '$BASE_URI/appointment?page=$page',
        method: HTTPMethod.GET,
        headers: {'content-type': 'application/json'},
        includeAuthCredentials: true));
  }

  static Future<Map> fetchAppointmentWithId(String id) async {
    return (await HttpServiceSingleton().makeRequest(
        url: '$BASE_URI/appointment/$id',
        method: HTTPMethod.GET,
        headers: {'content-type': 'application/json'},
        includeAuthCredentials: true))['data'];
  }

  static Future addTestsInAppointment(
      String appointmentId, List<String> testIdList) async {
    for (var i = 0; i < testIdList.length; i++) {
      await HttpServiceSingleton().makeRequest(
          url: "$BASE_URI/appointment-dtest",
          method: HTTPMethod.POST,
          includeAuthCredentials: true,
          headers: {
            'content-type': 'application/json'
          },
          body: {
            "appointment_id": appointmentId,
            "dc_test_id": testIdList[i],
          });
    }
  }
}
