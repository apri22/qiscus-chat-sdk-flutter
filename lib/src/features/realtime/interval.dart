part of qiscus_chat_sdk.usecase.realtime;

class Interval {
  Interval(
    this._storage,
    this._mqttClient,
  );

  final Storage _storage;
  final IRealtimeService _mqttClient;
  bool _stopped = false;

  Duration get _interval => _mqttClient.isConnected
      ? _storage.syncIntervalWhenConnected
      : _storage.syncInterval;

  void start() {
    if (_stopped) _stopped = false;
  }

  void stop() {
    if (!_stopped) _stopped = true;
  }

  Stream<Unit> interval([Stream<Duration> interval]) async* {
    var interval$ = interval ??
        Stream.periodic(
          _storage.accSyncInterval,
          (_) => _storage.accSyncInterval,
        );

    await for (var it in interval$) {
      if (!_stopped && it > _interval) {
        yield unit;
      }
    }
  }
}
