import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

/// Global audio manager to ensure only one audio plays at a time across the app
class AudioManagerService extends GetxService {
  AudioPlayer? _currentPlayer;
  String? _currentPlayerId;

  // Track all registered players to stop any that might be playing
  final Map<String, AudioPlayer> _allPlayers = {};

  /// Register a new audio player and stop any currently playing audio
  void registerPlayer(AudioPlayer player, String playerId) {
    print('AudioManager: Registering player $playerId');

    // Add to tracked players
    _allPlayers[playerId] = player;
    print('AudioManager: Total tracked players: ${_allPlayers.length}');

    // Stop all other playing audio
    stopAllOtherAudio(playerId);

    _currentPlayer = player;
    _currentPlayerId = playerId;
    print('AudioManager: Current player is now $playerId');
  }

  /// Stop all audio except the specified player
  void stopAllOtherAudio(String exceptPlayerId) {
    print('AudioManager: Stopping all audio except $exceptPlayerId');
    int stoppedCount = 0;

    _allPlayers.forEach((id, player) {
      if (id != exceptPlayerId) {
        try {
          if (player.playing) {
            print('AudioManager: Stopping player $id (was playing)');
            player.stop();
            stoppedCount++;
          }
        } catch (e) {
          print('AudioManager: Error stopping player $id: $e');
        }
      }
    });

    print('AudioManager: Stopped $stoppedCount players');
  }

  /// Stop the currently playing audio
  void stopCurrentAudio() {
    if (_currentPlayer != null) {
      try {
        print('AudioManager: Attempting to stop player $_currentPlayerId');
        _currentPlayer!.stop();
        print('AudioManager: Successfully stopped player $_currentPlayerId');
      } catch (e) {
        print('AudioManager: Error stopping current audio: $e');
      }
    } else {
      print('AudioManager: No current player to stop');
    }
  }

  /// Unregister a player when it's disposed
  void unregisterPlayer(String playerId) {
    print('AudioManager: Unregistering player $playerId');
    _allPlayers.remove(playerId);

    if (_currentPlayerId == playerId) {
      _currentPlayer = null;
      _currentPlayerId = null;
    }

    print('AudioManager: Total tracked players: ${_allPlayers.length}');
  }

  /// Check if a specific player is the current active player
  bool isCurrentPlayer(String playerId) {
    return _currentPlayerId == playerId;
  }

  /// Stop all audio (useful for debugging or emergency stop)
  void stopAllAudio() {
    print('AudioManager: Stopping ALL audio');
    _allPlayers.forEach((id, player) {
      try {
        if (player.playing) {
          print('AudioManager: Force stopping player $id');
          player.stop();
        }
      } catch (e) {
        print('AudioManager: Error force stopping player $id: $e');
      }
    });
  }
}
