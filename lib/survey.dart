


class Survey{

  String id;

  String video_file;

  List<double> accelerometerValues = List<double>();
  List<double> userAccelerometerValues = List<double>();
  List<double> gyroscopeValues = List<double>();

  double o2_gt;
  double hr_gt;


  void clearSensorData(){
    accelerometerValues.clear();
    gyroscopeValues.clear();
    userAccelerometerValues.clear();
  }

}