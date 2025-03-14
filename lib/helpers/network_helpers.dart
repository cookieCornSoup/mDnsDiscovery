class NetworkHelper {
  static bool isIPv4(String ip) {
    final parts = ip.split('.');
    if (ip.endsWith('.local.')) {
      return true;
    }
    if (parts.length != 4) return false;

    for (var part in parts) {
      if (part.isEmpty || part.length > 3) return false;
      final num = int.tryParse(part);
      if (num == null || num < 0 || num > 255) return false;
      if (part.length > 1 && part.startsWith('0')) return false; // 01과 같은 경우는 유효하지 않음
    }

    return true;
  }
}
