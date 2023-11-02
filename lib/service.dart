import 'dart:io';

class Bash{

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

}