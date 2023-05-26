import 'package:flutter_meedu/meedu.dart';

enum DataStatus { none, loading, loaded, error }

class MeeduPlayerDataStatus {
  Rx<DataStatus> status = Rx(DataStatus.none);

  bool get none => status.value == DataStatus.none;
  bool get loading => status.value == DataStatus.loading;
  bool get loaded => status.value == DataStatus.loaded;
  bool get error => status.value == DataStatus.error;
}
