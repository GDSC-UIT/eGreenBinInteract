import 'package:get/get.dart';

class ScanController extends GetxController {
  final RxBool _isInitialized = RxBool(false);
  bool get isInitialized => _isInitialized.value;
  void dispose() {
    _isInitialized.value = false;
    super.dispose();
  }
}
