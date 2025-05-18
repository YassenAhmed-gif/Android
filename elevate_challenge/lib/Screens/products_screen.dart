import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elevate_challenge/shared/Cubit/products_cubit.dart';
import 'package:elevate_challenge/shared/utils/product_card.dart';

class products_screen extends StatelessWidget {
  const products_screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Products'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => context.read<ProductsCubit>().getAllProducts(),
            ),
          ],
        ),
        body: BlocConsumer<ProductsCubit, ProductsState>(
          listener: (context, state) {
            // You can add snackbars or navigation here based on state changes
            if (state is ProductsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is ProductsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProductsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<ProductsCubit>().getAllProducts(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is ProductsLoaded) {
              if (state.products.isEmpty) {
                return const Center(child: Text('No products available'));
              }

              return Padding(
                padding: const EdgeInsets.all(20),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      child: product_card(product: state.products[index]),
                      onTap: () {},
                    );
                  },
                ),
              );
            }
            // Initial state
            return const Center(child: Text('Pull to refresh products'));
          }
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.read<ProductsCubit>().getAllProducts(),
          child: const Icon(Icons.refresh),
        ),
    );
  }
}
