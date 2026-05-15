import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'recipe_detail_screen.dart';
import 'recipes_data.dart';

class FlinkCooksScreen extends StatelessWidget {
  final VoidCallback? onCartUpdated;
  const FlinkCooksScreen({super.key, this.onCartUpdated});
  
  @override
  Widget build(BuildContext context) {
    final recipes = RecipesData.all;

    return Scaffold(
      backgroundColor: FlinkColors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.80,
                ),
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  return _buildRecipeCard(
                      context, recipes[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: FlinkColors.white,
        border: Border(
          bottom: BorderSide(
              color: FlinkColors.midGrey, width: 0.8),
        ),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Row(
                children: [
                  Text(
                    'Flink Cooks',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: FlinkColors.black,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    '°',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: FlinkColors.pink,
                    ),
                  ),
                ],
              ),
              Text(
                '15-minute meals, delivered to your door.',
                style: TextStyle(
                  fontSize: 12,
                  color: FlinkColors.textGrey,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: FlinkColors.pink.withOpacity(0.10),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              '15 min',
              style: TextStyle(
                color: FlinkColors.pink,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeCard(
      BuildContext context, RecipeModel recipe) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => RecipeDetailScreen(recipe: recipe),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: FlinkColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: FlinkColors.midGrey, width: 0.8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Square image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Image.network(
                  recipe.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: FlinkColors.lightGrey,
                    child: const Icon(
                      Icons.restaurant,
                      color: FlinkColors.textGrey,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),

            // Info below image
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category
                    Text(
                      recipe.category,
                      style: const TextStyle(
                        color: FlinkColors.textGrey,
                        fontSize: 10,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    // Recipe name — bigger font
                    Text(
                      recipe.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: FlinkColors.black,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    // Price and + button
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      crossAxisAlignment:
                          CrossAxisAlignment.center,
                      children: [
                        Text(
                          '€${recipe.totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: FlinkColors.black,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            color: FlinkColors.pink,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add,
                            color: FlinkColors.white,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}