abstract class LocalCache {
  ///Retrieves userId for current logged in user
  Future<String> getUserId();

  ///Saves [userId] for current logged in user
  Future<void> saveUserId(String userId);

  ///Deletes cached userId
  Future<void> deleteUserId();

  ///Saves encryption keys for current user
  Future<void> saveKeys({
    required String privateKey,
    required String publicKey,
  });

  ///Retrieves private key for current user
  Future<String> getPrivateKey();

  ///Retrieves public key for current user
  Future<String> getPublicKey();

  ///Saves `value` to cache using `key`
  Future<void> saveToLocalCache({required String key, required dynamic value});

  ///Retrieves a cached value stored with `key`
  Object? getFromLocalCache(String key);

  ///Removes cached value stored with `key` from cache
  Future<void> removeFromLocalCache(String key);

  Future<void> clearCache();

  Future<void> saveStory({
    required String id,
    required String uploadTime,
  });

  Future<List<Map<String, String>>> getSavedStories();
}
