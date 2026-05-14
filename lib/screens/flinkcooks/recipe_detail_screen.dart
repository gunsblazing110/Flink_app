Widget _buildIngredientRow(int index, RecipeIngredient item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: item.checked
            ? FlinkColors.white
            : FlinkColors.lightGrey,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: FlinkColors.midGrey),
      ),
      child: Row(
        children: [
          // Checkbox
          GestureDetector(
            onTap: () {
              setState(() {
                _ingredients[index].checked =
                    !_ingredients[index].checked;
                if (!_ingredients[index].checked) {
                  _ingredients[index].qty = 0;
                } else {
                  _ingredients[index].qty = 1;
                }
              });
            },
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: item.checked
                    ? FlinkColors.pink
                    : FlinkColors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: item.checked
                      ? FlinkColors.pink
                      : FlinkColors.midGrey,
                  width: 1.5,
                ),
              ),
              child: item.checked
                  ? const Icon(Icons.check,
                      color: FlinkColors.white, size: 14)
                  : null,
            ),
          ),

          const SizedBox(width: 10),

          // Name and price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: item.checked
                        ? FlinkColors.black
                        : FlinkColors.textGrey,
                  ),
                ),
                Text(
                  '€${item.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: item.checked
                        ? FlinkColors.pink
                        : FlinkColors.textGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Quantity controls — always shown
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (_ingredients[index].qty > 1) {
                      _ingredients[index].qty--;
                    } else {
                      _ingredients[index].qty = 0;
                      _ingredients[index].checked = false;
                    }
                  });
                },
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    border: Border.all(color: FlinkColors.midGrey),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.remove,
                      size: 16, color: FlinkColors.black),
                ),
              ),
              Container(
                width: 32,
                alignment: Alignment.center,
                child: Text(
                  '${item.qty}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: FlinkColors.black,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _ingredients[index].qty++;
                    _ingredients[index].checked = true;
                  });
                },
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: FlinkColors.pink,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.add,
                      size: 16, color: FlinkColors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }