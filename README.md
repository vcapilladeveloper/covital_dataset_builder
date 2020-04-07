# covital_dataset_builder

This app is being build as part of the CoVital project.
The expected outcome is to gather recording and labels that will be used to implement and test an estimation method for evaluating SpO2 levels (see the [estimation](https://github.com/CoVital-Project/Spo2_evaluation) repo).

# Dependencies

The app depends on a dart openapi to upload the data to the Amazon S3 bucket where the data will be uploaded.
Go to the [pulse-ox](https://github.com/CoVital-Project/pulse-ox-data-collection-web-service) repo, clone it, run `make dart_client` in the root folder to generate the API.
Then change the relative path in the `pubspec.yaml` of this project to point to the folder where the dartapi as been generated.

# File upload

On pressing the send button a 30sec mp4 video is uploaded to the S3.
Furthermore, a json file with the user data is exported.
The json file organized as follow.

```
String id: survey id
spo2Device
|- String brand
|- String model
DateTime startTimeOfRecording: time at which the recording was started
List<double> accelerometerValues: values returned by the accelerometer during the recording. For each measurement three values (x, y, and z) ares saved in the list.
List<double> userAccelerometerValues: values returned by the gyroscope during the recording. For each measurement three values (x, y, and z) ares saved in the list.
List<double> gyroscopeValues: values returned by the accelerometer during the recording minus gravity. For each measurement three values (x, y, and z) ares saved in the list.
List<DateTime> accelerometerTimestamps: time at which each accelerometer measurement was taken.
List<DateTime> gyroscopeTimestamps: time at which each gyroscope measurement was taken
List<DateTime> userAccelerometerTimestamps:time at which each user accelerometer measurement was taken 
double o2gt: actual Spo2 measurements entered by the user.
double hrgt: actual heart rate measurements entered by the user.
int age: age of the subject.
double weight: weight of the subject.
String sex: sex of the subject. Can be "undefined", "female", or "male".
int skinColor: color of the skin represented as an int (can be converted to an Hex).
String health: health of the subject. Can be "undefined", "sick", "recovering", or "healthy".
String phoneBrand: phone brand
String phoneModel: phone model
```