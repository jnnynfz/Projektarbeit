//Set ur Api String globally
class CustomConfig {
  final String serverUrl;

  CustomConfig({
    required this.serverUrl,
  });
}

final myConfig = CustomConfig(serverUrl: 'https://api.example.de');