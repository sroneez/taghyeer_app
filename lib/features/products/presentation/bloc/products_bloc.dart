import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taghyeer_app/features/products/presentation/bloc/product_state.dart';
import '../../domain/usecases/get_product_usecases.dart';
import 'products_event.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final GetProductsUseCase getProductsUseCase;
  static const int _limit = 10;

  ProductsBloc({required this.getProductsUseCase}) : super(const ProductsState()) {
    on<FetchProducts>(_onFetchProducts);
  }

  Future<void> _onFetchProducts(FetchProducts event, Emitter<ProductsState> emit) async {
    if (state.hasReachedMax) return;

    try {
      if (state.status == ProductsStatus.initial) {
        emit(state.copyWith(status: ProductsStatus.loading));

        final result = await getProductsUseCase(GetProductsParams(skip: 0, limit: _limit));

        result.fold(
              (failure) => emit(state.copyWith(status: ProductsStatus.failure, errorMessage: failure.message)),
              (products) => emit(state.copyWith(
            status: ProductsStatus.success,
            products: products,
            hasReachedMax: products.length < _limit,
            skip: _limit,
          )),
        );
        return;
      }

      final result = await getProductsUseCase(GetProductsParams(skip: state.skip, limit: _limit));

      result.fold(
            (failure) => emit(state.copyWith(status: ProductsStatus.failure, errorMessage: failure.message)),
            (products) {
          emit(products.isEmpty
              ? state.copyWith(hasReachedMax: true)
              : state.copyWith(
            status: ProductsStatus.success,
            products: List.of(state.products)..addAll(products),
            hasReachedMax: products.length < _limit,
            skip: state.skip + _limit,
          ));
        },
      );
    } catch (_) {
      emit(state.copyWith(status: ProductsStatus.failure, errorMessage: 'An unexpected error occurred.'));
    }
  }
}