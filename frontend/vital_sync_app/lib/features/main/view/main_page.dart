import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vital_sync_app/features/about/view/about_page.dart';
import 'package:vital_sync_app/features/home/view/home_page.dart';
import 'package:vital_sync_app/features/main/bloc/navigation_cubit.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  static final List<Widget> _pages = [HomePage(), AboutPage(), AboutPage()];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NavigationCubit(),
      child: BlocBuilder<NavigationCubit, int>(
        builder: (context, index) {
          return Scaffold(
            appBar: AppBar(
              title: Image.asset('assets/images/logo.png', height: 40),
            ),
            body: _pages[index],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: index,
              onTap: (i) => context.read<NavigationCubit>().changeTab(i),
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  label: 'Heart',
                ),
                BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
              ],
            ),
          );
        },
      ),
    );
  }
}
