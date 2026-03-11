import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';

enum ProductsStatus { initial, loading, success, failure }

class ProductsState extends Equatable {
  final ProductsStatus status;
  final List<Product> products;
  final bool hasReachedMax;
  final String errorMessage;
  final int skip;

  const ProductsState({
    this.status = ProductsStatus.initial,
    this.products = const <Product>[],
    this.hasReachedMax = false,
    this.errorMessage = '',
    this.skip = 0,
  });

  ProductsState copyWith({
    ProductsStatus? status,
    List<Product>? products,
    bool? hasReachedMax,
    String? errorMessage,
    int? skip,
  }) {
    return ProductsState(
      status: status ?? this.status,
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
      skip: skip ?? this.skip,
    );
  }

  @override
  List<Object> get props => [status, products, hasReachedMax, errorMessage, skip];
}