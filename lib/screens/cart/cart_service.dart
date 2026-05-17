import 'package:flutter/material.dart';
import '../flinkcooks/recipes_data.dart';

class CartItem {
  final RecipeModel recipe;
  final List<RecipeIngredient> selectedIngredients;

  CartItem({
    required this.recipe,
    required this.selectedIngredients,
  });

  double get totalPrice {
    double total = 0;
    for (final i in selectedIngredients) {
      if (i.checked) total += i.price * i.qty;
    }
    return total;
  }

  int get totalItems {
    int total = 0;
    for (final i in selectedIngredients) {
      if (i.checked) total += i.qty;
    }
    return total;
  }
}

class CartService extends ChangeNotifier {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final List<CartItem> _items = [];
  bool shouldResetTab = false;

  List<CartItem> get items => List.unmodifiable(_items);
  bool get isEmpty => _items.isEmpty;

  double get subtotal {
    double total = 0;
    for (final item in _items) {
      total += item.totalPrice;
    }
    return total;
  }

  double get deliveryFee => 1.80;
  double get grandTotal => subtotal + deliveryFee;

  int get totalItemCount {
    return _items.fold(0, (sum, item) => sum + item.totalItems);
  }

  void addRecipe(
      RecipeModel recipe, List<RecipeIngredient> selectedIngredients) {
    _items.removeWhere((item) => item.recipe.name == recipe.name);
    _items.add(CartItem(
      recipe: recipe,
      selectedIngredients: selectedIngredients
          .where((i) => i.checked && i.qty > 0)
          .toList(),
    ));
    notifyListeners();
  }

  void removeRecipe(String recipeName) {
    _items.removeWhere((item) => item.recipe.name == recipeName);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    shouldResetTab = true;
    notifyListeners();
  }
}