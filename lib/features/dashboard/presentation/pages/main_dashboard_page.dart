import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taghyeer_app/features/settings/presentation/pages/setting_page.dart';
import '../../../../injection_container.dart' as di;
import '../../../posts/presentation/bloc/post_bloc.dart';
import '../../../posts/presentation/pages/posts_page.dart';
import '../../../products/presentation/bloc/products_bloc.dart';
import '../../../products/presentation/pages/product_page.dart';
import '../bloc/navigation_cubit.dart';

class MainDashboardPage extends StatelessWidget {
  const MainDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NavigationCubit(),
      child: const DashboardView(),
    );
  }
}

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, int>(
      builder: (context, currentIndex) {
        return Scaffold(
          body: IndexedStack(
            index: currentIndex,
            children: [
              BlocProvider(
                create: (_) => di.sl<ProductsBloc>(),
                child: const ProductsPage(),
              ),

              BlocProvider(create: (_) => di.sl<PostsBloc>(), child: const PostsPage()),

              const SettingsPage(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) {
              context.read<NavigationCubit>().changeTab(index);
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag_outlined),
                activeIcon: Icon(Icons.shopping_bag),
                label: 'Products',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.article_outlined),
                activeIcon: Icon(Icons.article),
                label: 'Posts',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                activeIcon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          ),
        );
      },
    );
  }
}
