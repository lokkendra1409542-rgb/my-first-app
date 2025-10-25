class KycStore {
  KycStore._();
  static final KycStore instance = KycStore._();

  // Step-1
  dynamic type; // BusinessType? but kept dynamic to avoid circular import
  String? individualType;

  // आगे के steps के लिए fields जोड़ सकते हैं
  // String? selfiePath;
  // String? panNumber;
  // String? gstin;
}
