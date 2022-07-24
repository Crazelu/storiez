import 'package:flutter/material.dart';
import 'package:storiez/data/local/__local.dart';
import 'package:storiez/data/remote/storiez_service.dart';
import 'package:storiez/domain/models/user.dart';
import 'package:storiez/utils/utils.dart';

class UserStore {
  final StoriezService _storiezService;
  final LocalCache _localCache;

  UserStore({
    StoriezService? storiezService,
    LocalCache? localCache,
  })  : _storiezService = storiezService ?? locator(),
        _localCache = localCache ?? locator();

  late final _logger = Logger(runtimeType);

  late final ValueNotifier<AppUser?> _user = ValueNotifier(null);

  ValueNotifier<AppUser?> get user => _user;

  Future<void> getUser() async {
    try {
      final user = await _storiezService.getUser(await _localCache.getUserId());

      _user.value = user;
    } catch (e) {
      _logger.log(e);
    }
  }
}
