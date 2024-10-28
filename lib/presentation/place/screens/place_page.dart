import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sigacidades/domain/entities/place.dart';
import 'package:sigacidades/presentation/place/widgets/audio_player.dart';

/// Página responsável por exibir informações de um local específico e permitir
/// ao usuário reproduzir o áudio de Informações Gerais e Audiodescrição mesmo com app minimizado.
class PlacePage extends StatefulWidget {
  final Place place; // Entidade que contém as informações do local

  const PlacePage({Key? key, required this.place}) : super(key: key);

  @override
  _PlacePageState createState() => _PlacePageState();
}

class _PlacePageState extends State<PlacePage> {
  AudioPlayerType _selectedPlayer =
      AudioPlayerType.informacoesGerais; // Player inicial
  AudioPlayer? _activePlayer; // Player ativo para controle

  /// Função responsável por alternar entre os dois players de áudio, garantindo
  /// que o player anterior seja pausado e liberado antes de inicializar o novo.
  void _onAudioChanged(bool isGeneralInfo) {
    setState(() {
      // Alterna entre "Informações Gerais" e "Audiodescrição"
      _selectedPlayer = isGeneralInfo
          ? AudioPlayerType.informacoesGerais
          : AudioPlayerType.audiodescricao;

      // Pausar e liberar o player anterior
      if (_activePlayer != null) {
        _activePlayer!.stop(); // Pausa o áudio atual
        _activePlayer!.dispose(); // Libera o recurso do player
        _activePlayer = null; // Reseta o player ativo
      }
    });
  }

  /// Função que permite ao usuário abrir a localização no aplicativo de mapas de sua escolha.
  /// O MapLauncher lista os aplicativos de mapa disponíveis no dispositivo.
  Future<void> _openInMapLauncher(BuildContext context) async {
    final availableMaps = await MapLauncher.installedMaps;
    if (availableMaps.isNotEmpty) {
      await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Wrap(
                // Lista todos os aplicativos de mapas instalados no dispositivo
                children: availableMaps.map((map) {
                  return ListTile(
                    onTap: () {
                      // Abre o marcador no app de mapa escolhido
                      map.showMarker(
                        coords: Coords(
                          widget.place.coordinates.latitude,
                          widget.place.coordinates.longitude,
                        ),
                        title: widget.place.name,
                        description: widget.place.adress,
                      );
                      Navigator.pop(context);
                    },
                    title: Text(map.mapName),
                    leading: SvgPicture.asset(
                      map.icon, // Ícone do app de mapa
                      height: 30,
                      width: 30,
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        },
      );
    } else {
      // Exibe mensagem se nenhum aplicativo de mapas for encontrado
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nenhum aplicativo de mapas encontrado.'),
        ),
      );
    }
  }

  /// Build da interface da página. Exibe as informações do local, controla
  /// a alternância entre os players de áudio e oferece um botão para abrir a localização no mapa.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isDesktop = constraints.maxWidth >= 1024;
        bool isTablet =
            constraints.maxWidth >= 600 && constraints.maxWidth < 1024;

        double padding = isDesktop ? 32.0 : 16.0;
        double imageHeight = isDesktop ? 400 : (isTablet ? 300 : 250);
        double titleFontSize = isDesktop ? 28 : (isTablet ? 22 : 24);
        double subtitleFontSize = isDesktop ? 20 : 18;
        double descriptionFontSize = isDesktop ? 18 : 16;
        double buttonPadding = isDesktop ? 16 : 12;

        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Exibe a imagem do local com um botão para voltar
                Stack(
                  children: [
                    Image.network(
                      widget.place.imageUrl,
                      width: double.infinity,
                      height: imageHeight,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 40,
                      left: 16,
                      child: Semantics(
                        label: "Botão voltar",
                        hint: "Toque para voltar para a página anterior",
                        button: true,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.8),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.place.name, // Nome do local
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.place.adress, // Endereço do local
                        style: TextStyle(
                          fontSize: subtitleFontSize,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.place.description, // Descrição do local
                        style: TextStyle(
                          fontSize: descriptionFontSize,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // --------------- Início do Toggle button

                      // Toggle button para escolha entre "Informações Gerais" e "Audiodescrição"
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Semantics para "Informações Gerais"
                          Semantics(
                            label: "Informações Gerais",
                            selected: _selectedPlayer ==
                                AudioPlayerType.informacoesGerais,
                            hint: _selectedPlayer ==
                                    AudioPlayerType.informacoesGerais
                                ? "Selecionado, toque para alternar para Audiodescrição"
                                : "Toque para selecionar Informações Gerais",
                            button: true,
                            child: GestureDetector(
                              onTap: () => setState(() {
                                _selectedPlayer =
                                    AudioPlayerType.informacoesGerais;
                              }),
                              child: Text(
                                "Informações Gerais",
                                style: TextStyle(
                                  // fontSize: 15,
                                  fontWeight: _selectedPlayer ==
                                          AudioPlayerType.informacoesGerais
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: _selectedPlayer ==
                                          AudioPlayerType.informacoesGerais
                                      ? Colors.deepPurple
                                      : Colors.grey.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Container para o botão de alternância estilizado
                          GestureDetector(
                            onTap: () => setState(() {
                              _selectedPlayer = _selectedPlayer ==
                                      AudioPlayerType.informacoesGerais
                                  ? AudioPlayerType.audiodescricao
                                  : AudioPlayerType.informacoesGerais;
                            }),
                            child: Container(
                              width: 80,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Stack(
                                children: [
                                  // Alterna entre opções no toggle button
                                  AnimatedPositioned(
                                    duration: const Duration(milliseconds: 200),
                                    left: _selectedPlayer ==
                                            AudioPlayerType.informacoesGerais
                                        ? 4
                                        : 40,
                                    top: 2,
                                    child: Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: _selectedPlayer ==
                                                AudioPlayerType
                                                    .informacoesGerais
                                            ? const LinearGradient(
                                                colors: [
                                                  Color(0xFFFF9D44),
                                                  Color(0xFFFFC453)
                                                  // Color(0xFF804FB3),
                                                  // Color(0xFFB589D6)
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              )
                                            : const LinearGradient(
                                                colors: [
                                                  Color(0xFFFFDA59),
                                                  Color(0xFFFFE4AF)
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.25),
                                            blurRadius: 6,
                                            offset: const Offset(2, 1),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        _selectedPlayer ==
                                                AudioPlayerType
                                                    .informacoesGerais
                                            ? Icons.library_books
                                            : Icons.hearing,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Semantics para "Audiodescrição"
                          Semantics(
                            label: "Audiodescrição",
                            selected: _selectedPlayer ==
                                AudioPlayerType.audiodescricao,
                            hint: _selectedPlayer ==
                                    AudioPlayerType.audiodescricao
                                ? "Selecionado, toque para alternar para Informações Gerais"
                                : "Toque para selecionar Audiodescrição",
                            button: true,
                            child: GestureDetector(
                              onTap: () => setState(() {
                                _selectedPlayer =
                                    AudioPlayerType.audiodescricao;
                              }),
                              child: Text(
                                "Audiodescrição",
                                style: TextStyle(
                                  // fontSize: 15,
                                  fontWeight: _selectedPlayer ==
                                          AudioPlayerType.audiodescricao
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: _selectedPlayer ==
                                          AudioPlayerType.audiodescricao
                                      ? Colors.deepPurple
                                      : Colors.grey.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // --------------- Fim do botão de toggle

                      // const SizedBox(height: 24),

                      // Exibe o player de áudio correspondente ao que foi selecionado no Toggle Button
                      if (_selectedPlayer == AudioPlayerType.informacoesGerais)
                        SongPlayerWidget(
                          audioUrl: widget.place.audioPlaceInfoUrl,
                          audioTitle: 'Informações Gerais',
                          onPlayerInit: (player) {
                            _activePlayer =
                                player; // Passa o player que está ativo (lógica para termos o just_audio_background)
                          },
                          key: const Key('InformacoesGerais'), // Força rebuild
                        )
                      else
                        SongPlayerWidget(
                          audioUrl: widget.place.audioDescriptionUrl,
                          audioTitle: 'Audiodescrição',
                          onPlayerInit: (player) {
                            _activePlayer =
                                player; // Passa o player que está ativo
                          },
                          key: const Key('Audiodescricao'), // Força rebuild
                        ),

                      const SizedBox(height: 24),

                      // Botão para abrir a localização no mapa
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () => _openInMapLauncher(context),
                          icon: const Icon(Icons.map),
                          label: const Text('Abrir localização'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: buttonPadding,
                                vertical: buttonPadding / 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Enum para os diferentes tipos de players disponíveis.
enum AudioPlayerType {
  informacoesGerais, // Player de Informações Gerais
  audiodescricao, // Player de Audiodescrição
}
