import 'dart:io';
import 'dart:convert';

void main() async {
  // ⚠️ CONFIGURATION: Change these to match your repo
  const String githubUsername = "wallpaper74-max";
  const String repoName = "my-wallpaper-db";
  const String branch = "main";
  
  // The folder where images are stored
  final Directory imageDir = Directory('images');
  
  if (!await imageDir.exists()) {
    print("❌ Error: 'images' folder not found!");
    return;
  }

  // The base URL for the raw images
  final String baseUrl = "https://raw.githubusercontent.com/$githubUsername/$repoName/$branch/images/";

  List<Map<String, String>> jsonList = [];
  int idCounter = 1;

  // Get all files in the directory
  List<FileSystemEntity> files = imageDir.listSync();

  for (var file in files) {
    if (file is File) {
      String filename = file.uri.pathSegments.last;
      
      // Filter for image files only
      if (filename.endsWith('.jpg') || filename.endsWith('.png') || filename.endsWith('.jpeg')) {
        
        // Auto-Generate Category from filename (e.g., "Nature_01.jpg" -> "Nature")
        // If no underscore, it defaults to "General"
        String category = "General";
        if (filename.contains('_')) {
          category = filename.split('_')[0];
          // Capitalize first letter
          category = category[0].toUpperCase() + category.substring(1);
        }

        jsonList.add({
          "url": baseUrl + filename,
          "category": category,
          "id": idCounter.toString()
        });
        
        idCounter++;
      }
    }
  }

  // Convert to pretty JSON
  String jsonOutput = JsonEncoder.withIndent('  ').convert(jsonList);

  // Write to data.json
  File('data.json').writeAsStringSync(jsonOutput);

  print("✅ Success! Generated data.json with ${jsonList.length} images.");
}