import 'dart:io';

class ServiceClass{

  static Future<String> runBashCommand(String command) async {
    try {
      // Execute a Bash command
      ProcessResult result = await Process.run('bash', ['-c', command]);

      // Check the exit code and standard output
      if (result.exitCode == 0) {
        print('Command executed successfully');
        print('Output: ${result.stdout}');
        return result.stdout;
      } else {
        print('Error executing the command');
        print('Exit code: ${result.exitCode}');
        print('Error: ${result.stderr}');
        return "error";
      }
    } catch (e) {
      print('Error: $e');
      return "error";
    }
  }

  static Map<String, String> extractArtistAndTitle(String payload) {
    final artistRegex = RegExp(r'"Artist"\s+variant\s+string\s+"([^"]+)"');
    final titleRegex = RegExp(r'"Title"\s+variant\s+string\s+"([^"]+)"');

    final artistMatch = artistRegex.firstMatch(payload);
    final titleMatch = titleRegex.firstMatch(payload);

    final artist = artistMatch?.group(1) ?? 'Artist not found';
    final title = titleMatch?.group(1) ?? 'Title not found';

    return {
      'Artist': artist,
      'Title': title,
    };
  }

}