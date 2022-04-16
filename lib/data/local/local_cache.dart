abstract class LocalCache {
  ///Retrieves access token for authorizing requests
  Future<String> getToken();

  ///Saves access token for authorizing requests
  Future<void> saveToken(String tokenId);

  ///Deletes cached access token
  Future<void> deleteToken();

  ///Saves `value` to cache using `key`
  Future<void> saveToLocalCache({required String key, required dynamic value});

  ///Retrieves a cached value stored with `key`
  Object? getFromLocalCache(String key);

  ///Removes cached value stored with `key` from cache
  Future<void> removeFromLocalCache(String key);

  Future<void> clearCache();
}
