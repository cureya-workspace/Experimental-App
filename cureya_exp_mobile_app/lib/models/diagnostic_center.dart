class DiagnosticCenter {
  late String id;
  late String name;
  late String address;
  late String pincode;
  late String operatingStartTime;
  late String operatingEndTime;
  late bool doesHomeVisit;
  late String city;

  DiagnosticCenter({
    required this.id,
    required this.name,
    required this.address,
    required this.pincode,
    required this.operatingStartTime,
    required this.operatingEndTime,
    required this.doesHomeVisit,
    required this.city,
  });

  DiagnosticCenter.fromMap(Map diagnosticCenter) {
    print(diagnosticCenter);

    name = diagnosticCenter['name'];
    address = diagnosticCenter['address'];
    pincode = diagnosticCenter['pincode'];
    operatingStartTime = diagnosticCenter['operating_start_time'];
    operatingEndTime = diagnosticCenter['operating_end_time'];
    doesHomeVisit = diagnosticCenter['does_home_visit'];
    city = diagnosticCenter['city'];
    id = diagnosticCenter['id'];
  }
}
