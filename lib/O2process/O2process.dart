import 'dart:async';

import 'dart:typed_data';
import 'dart:math';
import 'package:camera/camera.dart';

import 'package:image/image.dart' as img;
import 'package:smart_signal_processing/smart_signal_processing.dart';
import 'dart:math' as math;

int reverseBits(int x, int bits) {
  int y = 0;
  for (int i = 0; i < bits; ++i, x >>= 1) {
    y = (y << 1) | (x & 0x01);
  }
  return y;
}

void transform_test(Float64List real, Float64List imag) {
  print("in");
  if (real.length != imag.length) throw "Mismatched lengths";
  int n = real.length;
  if (n == 0) {
    return;
  } else if ((n & (n - 1)) == 0) {
    print("to tradix");
    // Is power of 2
    transformRadix2_test(real, imag);
  } else {
    throw "array size is not a power of 2!";
  }
}

void transformRadix2_test(Float64List real, Float64List imag) {
// Initialization
  if (real.length != imag.length) throw "Mismatched lengths";
  int n = real.length;
  if (n == 1) {
// Trivial transform
    return;
  }
  print("ttradix");
  int levels = -1;
  for (int i = 0; i < 32; i++) {
    if (1 << i == n) levels = i; // Equal to log2(n)
  }
  print("ttradix");
  if (levels == -1) throw "Length is not a power of 2";
  Float64List cosTable = Float64List(n ~/ 2);
  Float64List sinTable = Float64List(n ~/ 2);
  for (int i = 0; i < n / 2; i++) {
    cosTable[i] = math.cos(2 * math.pi * i / n);
    sinTable[i] = math.sin(2 * math.pi * i / n);
  }
  print("ttradix");

// Bit-reversed addressing permutation
  for (int i = 0; i < n; i++) {
    int j = reverseBits(i, levels);
    if (j > i) {
      double temp = real[i];
      real[i] = real[j];
      real[j] = temp;
      temp = imag[i];
      imag[i] = imag[j];
      imag[j] = temp;
    }
  }
  print("ttradix");

// Cooley-Tukey decimation-in-time radix-2 FFT
  for (int size = 2; size <= n; size *= 2) {
    int halfsize = size ~/ 2;
    int tablestep = n ~/ size;
    for (int i = 0; i < n; i += size) {
      for (int j = i, k = 0; j < i + halfsize; j++, k += tablestep) {
        double tpre =
            real[j + halfsize] * cosTable[k] + imag[j + halfsize] * sinTable[k];
        double tpim = -real[j + halfsize] * sinTable[k] +
            imag[j + halfsize] * cosTable[k];
        real[j + halfsize] = real[j] - tpre;
        imag[j + halfsize] = imag[j] - tpim;
        real[j] += tpre;
        imag[j] += tpim;
      }
    }
  }
  print("ttradix");
}

List<double> colorAverageCameraImage(CameraImage image) {
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

  return [b_sum / size_img, g_sum / size_img, r_sum / size_img];
//  return img;
}

List<double> colorAverage(img.Image frame) {
  int red = 0;
  int blue = 0;
  int green = 0;

  for (var pixel in frame.getBytes()) {
//    print("pixel: " +
//        pixel.toString()
//    );
//        " and red " +
//        img.getRed(pixel).toString());
//    print("pixel: " +
//        pixel.toString() +
//        " and bed " +
//        img.getBlue(pixel).toString());
//    print("pixel: " +
//        pixel.toString() +
//        " and ged " +
//        img.getGreen(pixel).toString());
    red = red + img.getRed(pixel);
    blue = blue + img.getBlue(pixel);
    green = green + img.getGreen(pixel);
  }

//  print("final red " + red);

  var image_size = frame.getBytes().length;
  List<double> colors = [
    blue / image_size,
    green / image_size,
    red / image_size
  ];

  return colors;
}

class O2Process {
//  List<img.Image> frames = List<img.Image>();

  double RedBlueRatio = 0;
  double Stdr = 0;
  double Stdb = 0;
  double sumred = 0;
  double sumblue = 0;
  int o2;

  //Arraylist
  List<double> redAvgList = new List<double>();
  List<double> blueAvgList = new List<double>();

  void reset() {
    RedBlueRatio = 0;
    Stdr = 0;
    Stdb = 0;
    sumred = 0;
    sumblue = 0;
    o2 = null;

    //Arraylist
    redAvgList = new List<double>();
    blueAvgList = new List<double>();
  }

  Future<double> FFT_O2(
      List<double> redAvgList_input, double samplingFrequency) async {
    double temp = 0;
    double POMP = 0;
    double frequency;

    Float64List imags_redAvgList = Float64List(redAvgList_input.length);

    for (int i = 0; i < redAvgList_input.length; ++i) {
      print(redAvgList_input[i].toString() +
          " " +
          imags_redAvgList[i].toString());
    }

    print("t: " + imags_redAvgList[0].toString());
//    FFT.transform(redAvgList_input, imags_redAvgList);
    transform_test(redAvgList_input, imags_redAvgList);
    print("t done");
//    fft.realForward(output);

    for (var el in redAvgList_input) {
      el = el.abs();
    }
    print("t");

    for (int p = 35; p < redAvgList_input.length; p++) {
      print("t");
      // 12 was chosen because it is a minimum frequency that we think people can get to determine heart rate.
      if (temp < redAvgList_input[p]) {
        temp = redAvgList_input[p];
        POMP = p.toDouble();
      }
    }

    print("t");
    if (POMP < 35) {
      POMP = 0;
    }

    print("t");
    frequency = POMP * samplingFrequency / (2 * redAvgList_input.length);
    print("end");
    return frequency;
  }

  Future<int> processO2(int total_time_in_sec) async {
    if (redAvgList.length == 0) {
      print("We need at least one frame");
      return -4;
    }

//    for (int i = 0; i < frames.length; i++) {
//      int ret = processFrame(frames[i], width, height, total_time_in_sec);
//      if (ret == -1) {
//        return -1;
//      }
//      //put width + height of the camera inside the variables
//      //        int width = size.width;
//      //        int height = size.height;
//
//      print("frame number " + i.toString());
//    }

//        long endTime = System.currentTimeMillis();
//        double totalTimeInSecs = (endTime - startTime) / 1000d; //to convert time to seconds
//        if (totalTimeInSecs >= 30) { //when 30 seconds of measuring passes do the following " we chose 30 seconds to take half sample since 60 seconds is normally a full sample of the heart beat

//            startTime = System.currentTimeMillis();
    double samplingFreq = (redAvgList.length / total_time_in_sec);
//  double red = RedAvgList.toArray(new Double[RedAvgList.size()]);
//  Double[] Blue = BlueAvgList.toArray(new Double[BlueAvgList.size()]);
//  Float64List imags_redAvgList = Float64List(redAvgList.length);

    print("fourier");
    double HRFreq = await FFT_O2(redAvgList, samplingFreq);
    print("Done fourier");

//  double HRFreq = Fft.FFT(Red, frames.size(), SamplingFreq);

    int bpm = (HRFreq * 60).ceil();

    double meanr = sumred / redAvgList.length;
    double meanb = sumblue / redAvgList.length;

    for (int i = 0; i < redAvgList.length - 1; i++) {
      double bufferb = blueAvgList[i];
      Stdb = Stdb + ((bufferb - meanb) * (bufferb - meanb));
      double bufferr = redAvgList[i];
      Stdr = Stdr + ((bufferr - meanr) * (bufferr - meanr));
    }

    double varr = sqrt(Stdr / (redAvgList.length - 1));
    double varb = sqrt(Stdb / (redAvgList.length - 1));

    double R = (varr / meanr) / (varb / meanb);

    double spo2 = 100 - 5 * (R);
    o2 = spo2.toInt();

    if ((o2 < 80 || o2 > 99) || (bpm < 45 || bpm > 200)) {
      print("Measurement failed");
      return -1;
    }

//        }

    if (o2 != 0) {
      return o2;
    }
    return -10;
//        if(RedAvg!=0){
//            ProgP=inc++/34;;
//            ProgO2.setProgress(ProgP);}
//
//        processing.set(false);
  }

  Future<int> processStackOfFrames(
      List<img.Image> frames_input, int total_time_in_sec) async {
    if (frames_input.length == 0) {
      print("We need at least one frame");
      return -2;
    }

    for (int i = 0; i < frames_input.length; i++) {
      print("frame -> " + i.toString());
      int ret = processFrame(frames_input[i]);
      if (ret == -1) {
        return -3;
      }
      //put width + height of the camera inside the variables
      //        int width = size.width;
      //        int height = size.height;

      print("frame number " + i.toString());
    }

//        long endTime = System.currentTimeMillis();
//        double totalTimeInSecs = (endTime - startTime) / 1000d; //to convert time to seconds
//        if (totalTimeInSecs >= 30) { //when 30 seconds of measuring passes do the following " we chose 30 seconds to take half sample since 60 seconds is normally a full sample of the heart beat

    return processO2(total_time_in_sec);

////            startTime = System.currentTimeMillis();
//    double samplingFreq = (frames_input.length / total_time_in_sec);
////  double red = RedAvgList.toArray(new Double[RedAvgList.size()]);
////  Double[] Blue = BlueAvgList.toArray(new Double[BlueAvgList.size()]);
////  Float64List imags_redAvgList = Float64List(redAvgList.length);
//
//    double HRFreq = await FFT_O2(redAvgList, samplingFreq);
//
////  double HRFreq = Fft.FFT(Red, frames.size(), SamplingFreq);
//
//    int bpm = (HRFreq * 60).ceil();
//
//    double meanr = sumred / frames_input.length;
//    double meanb = sumblue / frames_input.length;
//
//    for (int i = 0; i < frames_input.length - 1; i++) {
//      double bufferb = blueAvgList[i];
//      Stdb = Stdb + ((bufferb - meanb) * (bufferb - meanb));
//      double bufferr = redAvgList[i];
//      Stdr = Stdr + ((bufferr - meanr) * (bufferr - meanr));
//    }
//
//    double varr = sqrt(Stdr / (frames_input.length - 1));
//    double varb = sqrt(Stdb / (frames_input.length - 1));
//
//    double R = (varr / meanr) / (varb / meanb);
//
//    double spo2 = 100 - 5 * (R);
//    o2 = spo2.toInt();
//
//    if ((o2 < 80 || o2 > 99) || (bpm < 45 || bpm > 200)) {
//      print("Measurement failed");
//      return -1;
//    }
//
////        }
//
//    if (o2 != 0) {
//      return o2;
//    }
//    return -1;
////        if(RedAvg!=0){
////            ProgP=inc++/34;;
////            ProgO2.setProgress(ProgP);}
////
////        processing.set(false);
  }

  int processFrame(img.Image frame) {
    var colors = colorAverage(frame);

    double redAvg = colors[2];
    double blueAvg = colors[1];

    sumred = sumred + redAvg;
    sumblue = sumred + blueAvg;
//    sumred = sumred + colors[2];

    redAvgList.add(colors[2]);
    blueAvgList.add(colors[1]);

    //        ++counter; //countes number of frames in 30 seconds

    //To check if we got a good red intensity to process if not return to the condition and set it again until we get a good red intensity
//    if (redAvg < 200) {
//      print("!! ATTENTION !! redavg < 200 -> " + redAvg.toString());
//      return -1;
//    }
    return 1;
  }

  int processFrameCamera(CameraImage frame) {
    var colors = colorAverageCameraImage(frame);

    double redAvg = colors[2];
    double blueAvg = colors[1];

    sumred = sumred + redAvg;
    sumblue = sumred + blueAvg;
//    sumred = sumred + colors[2];

    redAvgList.add(colors[2]);
    blueAvgList.add(colors[1]);

    //        ++counter; //countes number of frames in 30 seconds

    //To check if we got a good red intensity to process if not return to the condition and set it again until we get a good red intensity
    if (redAvg < 200) {
      return -1;
    }
    return 1;
  }
}
