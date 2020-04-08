
import 'package:camera/camera.dart';
import 'package:smart_signal_processing/smart_signal_processing.dart';

class CameraSignal{

  List<double> variance_signal;

  List<double> signal_red;
  List<double> signal_blue;
  List<double> signal_green;


  bool valid_signal(CameraImage image){
    if(signal_blue.length <= 60){
      return false;
    }
    else{
      update_variance(image);
      if(variance_signal.length >= 60){
        var variance_variance = Sigma.variance(variance_signal, signal_red.length - 10, signal_red.length - 1);
        print("Variance of Signal Variance: " + variance_variance.toString());
        if(variance_variance <= 1){
          return true;
        }
      }
    }

    return false;

  }


  void update_variance(CameraImage image){

    colorAverageCameraImage(image);

    if(signal_blue.length >= 10){

      var signal_variance = Sigma.variance(signal_red, signal_red.length - 10, signal_red.length - 1);
      print("Signal Variance: " + signal_variance.toString());

      variance_signal.add(signal_variance);
      if(variance_signal.length >= 60 ){
        variance_signal.removeAt(0);
      }
    }

  }


  colorAverageCameraImage(CameraImage image) {
    int r_sum = 0;
    int b_sum = 0;
    int g_sum = 0;

    int width = image.width;
    int height = image.height;
//  var img = imglib.Image(image.planes[0].bytesPerRow, height); // Create Image buffer
    const int hexFF = 0xFF000000;
    final int uvyButtonStride = image.planes[1].bytesPerRow;
    final int uvPixelStride = image.planes[1].bytesPerPixel;
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        final int uvIndex =
            uvPixelStride * (x / 2).floor() + uvyButtonStride * (y / 2).floor();
        final int index = y * width + x;
        final yp = image.planes[0].bytes[index];
        final up = image.planes[1].bytes[uvIndex];
        final vp = image.planes[2].bytes[uvIndex];
        // Calculate pixel color
        int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
        int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
            .round()
            .clamp(0, 255);
        int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);
        // color: 0x FF  FF  FF  FF
        //           A   B   G   R
//      img.data[index] = hexFF | (b << 16) | (g << 8) | r;

        r_sum = r_sum + r;
        b_sum = b_sum + b;
        g_sum = g_sum + g;
      }
    }
    // Rotate 90 degrees to upright
//    var img1 = imglib.copyRotate(img, 90);

    int size_img = width * height;

    print("rgb: " +
        r_sum.toString() +
        " " +
        b_sum.toString() +
        " " +
        g_sum.toString());

    double r_mean = r_sum / size_img;
    double g_mean = g_sum / size_img;
    double b_mean = b_sum / size_img;

    signal_red.add(r_mean);
    signal_green.add(g_mean);
    signal_blue.add(b_mean);

    if(signal_blue.length > 60){
      signal_blue.removeAt(0);
      signal_red.removeAt(0);
      signal_green.removeAt(0);
    }

//    return [b_mean, g_mean, r_mean];
//  return img;
  }

}