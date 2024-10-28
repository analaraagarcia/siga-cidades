import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:sigacidades/presentation/place/widgets/control_buttons.dart';
import 'package:audio_session/audio_session.dart';
import 'package:uuid/uuid.dart';

/// Widget responsável por reproduzir áudio
class SongPlayerWidget extends StatefulWidget {
  final String audioUrl; // URL do áudio
  final String audioTitle; // Título do áudio
  final Function(AudioPlayer) onPlayerInit; // Callback para retorno do player

  const SongPlayerWidget({
    Key? key,
    required this.audioUrl,
    required this.audioTitle,
    required this.onPlayerInit,
  }) : super(key: key);

  @override
  _SongPlayerWidgetState createState() => _SongPlayerWidgetState();
}

class _SongPlayerWidgetState extends State<SongPlayerWidget> {
  late AudioPlayer _player; // Instância do player de áudio
  late AudioSource _audioSource; // Fonte de áudio (com ou sem cache)

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    var uuid = const Uuid();

    // Condicional para definir o tipo de fonte de áudio de acordo com a plataforma
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      // Cache para Android e iOS
      _audioSource = LockCachingAudioSource(
        Uri.parse(widget.audioUrl),
        tag: MediaItem(
          id: uuid.v5(Namespace.url.value, widget.audioUrl),
          title: widget.audioTitle,
        ),
      );
    } else {
      // Sem cache para Web ou outras plataformas
      _audioSource = AudioSource.uri(
        Uri.parse(widget.audioUrl),
        tag: MediaItem(
          id: uuid.v5(Namespace.url.value, widget.audioUrl),
          title: widget.audioTitle,
        ),
      );
    }

    widget.onPlayerInit(_player);
    _initPlayer();
  }

  /// Inicializa o player e configura o audio_session para lidar com interrupções
  Future<void> _initPlayer() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    try {
      session.interruptionEventStream.listen((event) {
        if (event.begin) {
          switch (event.type) {
            case AudioInterruptionType.duck:
              _player.setVolume(0.3);
              break;
            case AudioInterruptionType.pause:
            case AudioInterruptionType.unknown:
              _player.pause();
              break;
          }
        } else {
          switch (event.type) {
            case AudioInterruptionType.duck:
              _player.setVolume(1.0);
              break;
            case AudioInterruptionType.pause:
              _player.play();
              break;
            case AudioInterruptionType.unknown:
              break;
          }
        }
      });

      session.becomingNoisyEventStream.listen((_) {
        _player.pause();
      });

      await _player.setAudioSource(_audioSource);
    } catch (e) {
      print("Erro ao carregar o áudio: $e");
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
        ),
        ControlButtons(_player),
        StreamBuilder<PositionData>(
          stream: _positionDataStream,
          builder: (context, snapshot) {
            final positionData = snapshot.data;
            return ProgressBar(
              progress: positionData?.position ?? Duration.zero,
              buffered: positionData?.bufferedPosition ?? Duration.zero,
              total: positionData?.duration ?? Duration.zero,
              onSeek: _player.seek,
            );
          },
        ),
      ],
    );
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _player.positionStream,
        _player.bufferedPositionStream,
        _player.durationStream,
        (position, bufferedPosition, duration) => PositionData(
          position,
          bufferedPosition,
          duration ?? Duration.zero,
        ),
      );
}

/// Classe para encapsular dados de posição, buffer e duração do player
class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}
