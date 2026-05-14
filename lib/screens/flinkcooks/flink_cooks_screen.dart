import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'recipe_detail_screen.dart';
import 'recipes_data.dart';

class FlinkCooksScreen extends StatelessWidget {
  const FlinkCooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recipes = RecipesData.all;

    return Scaffold(
      backgroundColor: FlinkColors.lightGrey,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: (recipes.length / 2).ceil(),
                itemBuilder: (context, rowIndex) {
                  final left = rowIndex * 2;
                  final right = left + 1;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildRecipeCard(
                              context, recipes[left]),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: right < recipes.length
                              ? _buildRecipeCard(
                                  context, recipes[right])
                              : const SizedBox(),
                        ),
                      ],
                    ),
                  );
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
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      decoration: BoxDecoration(
        color: FlinkColors.white,
        border: Border(
          bottom: BorderSide(color: FlinkColors.midGrey, width: 0.8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Flink Cooks',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: FlinkColors.black,
                  letterSpacing: -0.5,
                ),
              ),
              const Text(
                '°',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: FlinkColors.pink,
                ),
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
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            '15-minute meals, delivered to your door.',
            style: TextStyle(
              fontSize: 14,
              color: FlinkColors.textGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeCard(BuildContext context, RecipeModel recipe) {
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
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: FlinkColors.midGrey),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
              child: Image.network(
                recipe.imageUrl,
                height: 110,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 110,
                  color: FlinkColors.lightGrey,
                  child: const Icon(Icons.restaurant,
                      color: FlinkColors.textGrey, size: 36),
                ),
              ),
            ),
            // Card content
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: FlinkColors.pink.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      recipe.category,
                      style: const TextStyle(
                        color: FlinkColors.pink,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    recipe.name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: FlinkColors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.access_time,
                              size: 12,
                              color: FlinkColors.textGrey),
                          SizedBox(width: 3),
                          Text(
                            '15 min',
                            style: TextStyle(
                              fontSize: 11,
                              color: FlinkColors.textGrey,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '€${recipe.totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: FlinkColors.pink,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}