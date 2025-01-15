import 'dart:io';

void main() async {
  // Define the source file and destination file paths
  String sourceFilePath = './build/app/outputs/flutter-apk/app-release.apk'; // Replace with your source file path
  String destinationFilePath = './apk/app-release.apk'; // Replace with your destination file path

  try {
    // Create File objects for source and destination
    File sourceFile = File(sourceFilePath);
    File destinationFile = File(destinationFilePath);

    // Check if the source file exists
    if (await sourceFile.exists()) {
      // Copy the content to the destination file
      await sourceFile.copy(destinationFilePath);
      print('File copied successfully!');
    } else {
      print('Source file does not exist.');
    }
  } catch (e) {
    print('An error occurred: $e');
  }
}

