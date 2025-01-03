import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

Future<File?> getImagePath({required XFile pickedFile}) async {
  if (pickedFile != null) {
    // Get the temporary file
    File tempFile = File(pickedFile.path);

    // Get the directory to store the image
    final directory = await getApplicationDocumentsDirectory();
    final newPath = '${directory.path}/uploaded_images'; // Custom folder path
    final newDirectory = Directory(newPath);

    // If the directory doesn't exist, create it
    if (!await newDirectory.exists()) {
      await newDirectory.create(recursive: true);
    }

    // Get the file extension (to preserve the original extension)
    String fileExtension = path.extension(tempFile.path);

    // Generate a new file path with the same extension as the original file
    String newFilePath =
        '${newDirectory.path}/${DateTime.now().millisecondsSinceEpoch}$fileExtension';

    // Copy the file to the new directory
    await tempFile.copy(newFilePath);

    print('File saved to: $newFilePath');

    return File(newFilePath);
  }

  return null; // Return null if pickedFile is null
}
