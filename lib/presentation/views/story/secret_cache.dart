class SecretCache {
  SecretCache._();

  static late final Map<String, String> _cache = {};

  ///Looks up secret message for [imageUrl] in cache
  static String? lookup(String imageUrl) {
    return _cache[imageUrl];
  }

  ///Temporarily stores secret message decoded from [imageUrl]
  static void cacheSecret({
    required String imageUrl,
    required String secret,
  }) {
    _cache[imageUrl] = secret;
  }
}
