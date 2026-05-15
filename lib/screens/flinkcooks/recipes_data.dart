class RecipeIngredient {
  final String name;
  final double price;
  bool checked;
  int qty;

  RecipeIngredient({
    required this.name,
    required this.price,
    this.checked = true,
    this.qty = 1,
  });

  RecipeIngredient copy() => RecipeIngredient(
        name: name,
        price: price,
        checked: checked,
        qty: qty,
      );
}

class RecipeModel {
  final String name;
  final String category;
  final String imageUrl;
  final String description;
  final List<String> steps;
  final List<RecipeIngredient> ingredients;

  RecipeModel({
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.description,
    required this.steps,
    required this.ingredients,
  });

  double get totalPrice {
    double total = 0;
    for (final i in ingredients) {
      if (i.checked) total += i.price * i.qty;
    }
    return total;
  }

  RecipeModel copyWith() => RecipeModel(
        name: name,
        category: category,
        imageUrl: imageUrl,
        description: description,
        steps: steps,
        ingredients: ingredients.map((i) => i.copy()).toList(),
      );
}

class RecipesData {
  static List<RecipeModel> get all => [
        RecipeModel(
          name: 'Avocado Toast',
          category: 'Breakfast',
          imageUrl:
              'https://www.eatingbirdfood.com/wp-content/uploads/2023/12/avocado-toast-hero-cropped.jpg',
          description:
              'Creamy smashed avocado on toasted sourdough topped with cherry tomatoes, feta and a drizzle of olive oil. Quick, healthy and delicious.',
          steps: [
            'Toast the sourdough slices until golden and crispy.',
            'Halve the avocados, remove the stone and scoop the flesh into a bowl.',
            'Mash the avocado with a fork, add lemon juice, salt and pepper.',
            'Spread the avocado mixture generously over the toast.',
            'Top with halved cherry tomatoes, crumbled feta and a drizzle of olive oil.',
          ],
          ingredients: [
            RecipeIngredient(name: 'Sourdough Bread (loaf)', price: 3.29),
            RecipeIngredient(name: 'Ripe Avocados x2', price: 2.49),
            RecipeIngredient(name: 'Cherry Tomatoes (250g)', price: 1.99),
            RecipeIngredient(name: 'Feta Cheese (100g)', price: 2.29),
            RecipeIngredient(name: 'Lemon', price: 0.49),
            RecipeIngredient(name: 'Olive Oil (100ml)', price: 1.99),
          ],
        ),

        RecipeModel(
          name: 'Greek Salad',
          category: 'Mediterranean',
          imageUrl:
              'https://www.theendlessmeal.com/wp-content/uploads/2017/08/greek-salad-3-1.jpg',
          description:
              'A fresh and vibrant salad with juicy tomatoes, crisp cucumber, kalamata olives, red onion and generous chunks of authentic feta cheese.',
          steps: [
            'Chop the tomatoes into large wedges and place in a big bowl.',
            'Slice the cucumber into half-moons and add to the bowl.',
            'Thinly slice the red onion and add along with the olives.',
            'Cut the feta into thick slices and place on top.',
            'Drizzle generously with olive oil, add dried oregano and serve.',
          ],
          ingredients: [
            RecipeIngredient(name: 'Vine Tomatoes (500g)', price: 2.49),
            RecipeIngredient(name: 'Cucumber', price: 0.99),
            RecipeIngredient(name: 'Feta Cheese (200g)', price: 3.29),
            RecipeIngredient(name: 'Kalamata Olives (jar)', price: 2.79),
            RecipeIngredient(name: 'Red Onion', price: 0.49),
            RecipeIngredient(name: 'Olive Oil (100ml)', price: 1.99),
          ],
        ),

        RecipeModel(
          name: 'Margherita Pizza',
          category: 'Italian',
          imageUrl:
              'https://lilluna.com/wp-content/uploads/2025/10/margherita-pizza-resize-8-1.jpg',
          description:
              'A timeless Neapolitan pizza with San Marzano tomato sauce, fresh mozzarella and basil leaves on a thin crispy base. Simple perfection.',
          steps: [
            'Preheat your oven to 220°C and place a baking tray inside to heat up.',
            'Spread tomato sauce evenly over the pizza base leaving a 1cm border.',
            'Tear mozzarella into pieces and scatter over the sauce.',
            'Slide pizza onto the hot tray and bake for 10 minutes until crust is golden.',
            'Remove from oven, top with fresh basil leaves and drizzle with olive oil.',
          ],
          ingredients: [
            RecipeIngredient(name: 'Pizza Base (ready-made)', price: 2.49),
            RecipeIngredient(name: 'San Marzano Tomato Sauce', price: 1.99),
            RecipeIngredient(name: 'Fresh Mozzarella (125g)', price: 2.29),
            RecipeIngredient(name: 'Fresh Basil', price: 0.99),
            RecipeIngredient(name: 'Olive Oil (100ml)', price: 1.99),
          ],
        ),
      ];
}