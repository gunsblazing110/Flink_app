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
        // 1 — Vegetarian Currywurst
        RecipeModel(
          name: 'Vegetarian Currywurst',
          category: 'Berlin Street Food',
          imageUrl:
              'https://www.themealdb.com/images/media/meals/sytuqu1511553755.jpg',
          description:
              'Experience the authentic taste of Berlin street food at home. Plant-based sausages smothered in our signature spicy curry sauce with crispy fries on the side.',
          steps: [
            'Pan-fry the veggie sausages for 6 minutes until golden brown on all sides.',
            'Bake the premium fries at 200°C for 12 minutes until crispy.',
            'In a small pan, heat the curry sauce on medium heat for 3 minutes.',
            'Slice the sausages diagonally and arrange on a plate with the fries.',
            'Smother everything generously in the heated curry sauce and serve hot.',
          ],
          ingredients: [
            RecipeIngredient(name: 'Veggie Sausages (250g)', price: 3.99),
            RecipeIngredient(name: 'Signature Curry Sauce', price: 2.49),
            RecipeIngredient(name: 'Premium Fries (500g)', price: 2.99),
            RecipeIngredient(name: 'Cooking Oil (100ml)', price: 1.29),
            RecipeIngredient(name: 'Curry Powder', price: 1.89),
            RecipeIngredient(name: 'Ketchup', price: 1.49),
          ],
        ),

        // 2 — Spaghetti Carbonara
        RecipeModel(
          name: 'Spaghetti Carbonara',
          category: 'Italian',
          imageUrl:
              'https://www.themealdb.com/images/media/meals/llcbn01574260722.jpg',
          description:
              'A classic Roman pasta dish made with eggs, Pecorino Romano, pancetta and black pepper. Rich, creamy and ready in 15 minutes.',
          steps: [
            'Cook spaghetti in salted boiling water for 8 minutes until al dente.',
            'Fry the pancetta in a pan on medium heat for 4 minutes until crispy.',
            'Whisk together eggs, Parmesan, salt and black pepper in a bowl.',
            'Drain pasta and immediately mix with pancetta off the heat.',
            'Pour egg mixture over pasta, toss quickly to create a creamy sauce and serve.',
          ],
          ingredients: [
            RecipeIngredient(name: 'Spaghetti (500g)', price: 1.89),
            RecipeIngredient(name: 'Pancetta (150g)', price: 3.49),
            RecipeIngredient(name: 'Parmesan (100g)', price: 2.99),
            RecipeIngredient(name: 'Free Range Eggs x4', price: 2.29),
            RecipeIngredient(name: 'Black Pepper', price: 0.99),
            RecipeIngredient(name: 'Sea Salt', price: 0.79),
          ],
        ),

        // 3 — Chicken Tikka Masala
        RecipeModel(
          name: 'Chicken Tikka Masala',
          category: 'Indian',
          imageUrl:
              'https://www.themealdb.com/images/media/meals/urzj1d1587670726.jpg',
          description:
              'Tender chicken pieces in a rich, creamy tomato-based sauce with aromatic spices. A beloved classic delivered to your door in minutes.',
          steps: [
            'Cut chicken into chunks and season with tikka spice mix.',
            'Fry chicken in oil on high heat for 5 minutes until lightly charred.',
            'Add tikka masala sauce to the pan and stir well.',
            'Simmer on medium heat for 8 minutes until sauce thickens.',
            'Serve over basmati rice with a sprinkle of fresh coriander.',
          ],
          ingredients: [
            RecipeIngredient(name: 'Chicken Breast (400g)', price: 4.99),
            RecipeIngredient(
                name: 'Tikka Masala Sauce (jar)', price: 2.49),
            RecipeIngredient(name: 'Basmati Rice (500g)', price: 2.19),
            RecipeIngredient(name: 'Tikka Spice Mix', price: 1.79),
            RecipeIngredient(name: 'Fresh Coriander', price: 0.99),
            RecipeIngredient(name: 'Cooking Oil (100ml)', price: 1.29),
          ],
        ),

        // 4 — Avocado Toast
        RecipeModel(
          name: 'Avocado Toast',
          category: 'Breakfast',
          imageUrl:
              'https://www.themealdb.com/images/media/meals/1550441882.jpg',
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
            RecipeIngredient(
                name: 'Cherry Tomatoes (250g)', price: 1.99),
            RecipeIngredient(name: 'Feta Cheese (100g)', price: 2.29),
            RecipeIngredient(name: 'Lemon', price: 0.49),
            RecipeIngredient(name: 'Olive Oil (100ml)', price: 1.99),
          ],
        ),

        // 5 — Greek Salad
        RecipeModel(
          name: 'Greek Salad',
          category: 'Mediterranean',
          imageUrl:
              'https://www.themealdb.com/images/media/meals/v3t6671592341360.jpg',
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
            RecipeIngredient(
                name: 'Kalamata Olives (jar)', price: 2.79),
            RecipeIngredient(name: 'Red Onion', price: 0.49),
            RecipeIngredient(name: 'Olive Oil (100ml)', price: 1.99),
          ],
        ),

        // 6 — Margherita Pizza
        RecipeModel(
          name: 'Margherita Pizza',
          category: 'Italian',
          imageUrl:
              'https://www.themealdb.com/images/media/meals/x0lk931587671540.jpg',
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
            RecipeIngredient(
                name: 'Pizza Base (ready-made)', price: 2.49),
            RecipeIngredient(
                name: 'San Marzano Tomato Sauce', price: 1.99),
            RecipeIngredient(
                name: 'Fresh Mozzarella (125g)', price: 2.29),
            RecipeIngredient(name: 'Fresh Basil', price: 0.99),
            RecipeIngredient(name: 'Olive Oil (100ml)', price: 1.99),
          ],
        ),
      ];
}