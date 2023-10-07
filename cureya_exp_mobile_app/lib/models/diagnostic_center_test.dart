class DiagnosticCenterTest {
  late String id;
  String? diagnosticCenterId;
  String? globalDiagnosisTestId;
  String? basePrice;
  String? custPrice;
  String? createdAt;
  String? updatedAt;

  DiagnosticCenterTest({
    required this.id,
    this.diagnosticCenterId,
    this.globalDiagnosisTestId,
    this.basePrice,
    this.custPrice,
    this.createdAt,
    this.updatedAt,
  });
  
  DiagnosticCenterTest.fromMap(Map diagnosticCenterTest) {
    id = diagnosticCenterTest['id'];
    diagnosticCenterId = diagnosticCenterTest['diagnostic_center_id'];
    globalDiagnosisTestId = diagnosticCenterTest['global_diagnosis_test_id'];
    basePrice = diagnosticCenterTest['base_price'];
    custPrice = diagnosticCenterTest['cust_price'];
    createdAt = diagnosticCenterTest['createdAt'];
    updatedAt = diagnosticCenterTest['updatedAt'];
  }

}