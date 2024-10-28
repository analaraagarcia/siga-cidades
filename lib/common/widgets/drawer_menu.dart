import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sigacidades/presentation/home/bloc/home_bloc.dart';
import 'package:sigacidades/presentation/home/bloc/home_event.dart';
import 'package:sigacidades/presentation/home/bloc/home_state.dart';

class DrawerMenu extends StatelessWidget {
  final Function(String) onCitySelected;

  const DrawerMenu({
    super.key,
    required this.onCitySelected,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;

    return Drawer(
      child: Semantics(
        label: 'Menu lateral',
        child: Container(
          padding: EdgeInsets.only(
            top: isTablet ? 120 : 100,
            left: 16,
            right: 16,
            bottom: 24,
          ),
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                label: 'Título do aplicativo SIGA CIDADES',
                header: true,
                child: Text(
                  'SIGA CIDADES',
                  style: TextStyle(
                    color: const Color(0xFF080808),
                    fontSize: isTablet ? 28 : 24,
                    fontFamily: 'Sora',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Semantics(
                label: 'Selecione a cidade para explorar',
                child: BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCityOption(context, 'Bauru', isTablet),
                        const SizedBox(height: 24),
                        _buildCityOption(context, 'Botucatu', isTablet),
                        const SizedBox(height: 24),
                        _buildCityOption(
                            context, 'Presidente Prudente', isTablet),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCityOption(
      BuildContext context, String cityName, bool isTablet) {
    return Semantics(
      label: 'Cidade $cityName. Toque para selecionar',
      button: true,
      child: GestureDetector(
        onTap: () {
          context.read<CategoryBloc>().add(SelectCityEvent(cityName));
          onCitySelected(cityName);
          Navigator.pop(context);
        },
        child: Text(
          cityName,
          style: TextStyle(
            color: const Color(0xFF131313),
            fontSize: isTablet ? 20 : 18,
            fontFamily: 'Sora',
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
