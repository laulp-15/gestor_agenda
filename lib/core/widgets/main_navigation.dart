import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../features/agenda/presentation/pages/agenda_list_page.dart';
import '../../features/auth/presentation/pages/profile_page.dart';

/// Envuelve las pantallas principales de la app (una vez logueado)
/// en una barra de navegación inferior flotante, para no tener que
/// hacer Navigator.push cada vez que se cambia de sección.
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}

class _MainNavigationState extends State<MainNavigation> {
  int _indiceActual = 0;

  // IndexedStack mantiene el estado de cada pestaña
  // (no se reconstruye la Agenda cada vez que vuelves a ella).
  final List<Widget> _paginas = const [
    AgendaListPage(),
    ProfilePage(),
  ];

  final List<_NavItem> _items = const [
    _NavItem(icon: Icons.event_note_outlined, label: 'Agenda'),
    _NavItem(icon: Icons.person_outline, label: 'Perfil'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _indiceActual,
        children: _paginas,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
          child: Container(
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.darkWine,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.22),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: List.generate(_items.length, (index) {
                final seleccionado = _indiceActual == index;
                final item = _items[index];

                return Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => setState(() => _indiceActual = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOut,
                      margin: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: seleccionado ? AppColors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(26),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            item.icon,
                            size: 22,
                            color: seleccionado ? AppColors.darkWine : Colors.white70,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.label,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: seleccionado ? FontWeight.bold : FontWeight.w500,
                              color: seleccionado ? AppColors.darkWine : Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}