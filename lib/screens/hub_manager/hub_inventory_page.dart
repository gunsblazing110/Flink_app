import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';

class HubInventoryPage extends StatefulWidget {
  const HubInventoryPage({super.key});

  @override
  State<HubInventoryPage> createState() => _HubInventoryPageState();
}

class _HubInventoryPageState extends State<HubInventoryPage> {
  @override
  void initState() {
    super.initState();
    _seedDemoDataIfEmpty();
  }

  Future<void> _seedDemoDataIfEmpty() async {
    final snap = await FirebaseFirestore.instance
        .collection('hub_inventory')
        .limit(1)
        .get();
    if (snap.docs.isNotEmpty) return;
    final batch = FirebaseFirestore.instance.batch();
    final col = FirebaseFirestore.instance.collection('hub_inventory');
    for (final item in _demoInventory) {
      batch.set(col.doc(), {
        'name': item['name'],
        'quantity': item['quantity'],
        'threshold': item['threshold'],
        'unit': item['unit'],
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
    await batch.commit();
  }

  static final _demoInventory = <Map<String, dynamic>>[
    {'name': 'Avocados', 'quantity': 30, 'threshold': 10, 'unit': 'pcs'},
    {'name': 'Cherry Tomatoes', 'quantity': 8, 'threshold': 5, 'unit': 'packs'},
    {'name': 'Cucumber', 'quantity': 20, 'threshold': 5, 'unit': 'pcs'},
    {'name': 'Feta Cheese', 'quantity': 12, 'threshold': 4, 'unit': 'packs'},
    {'name': 'Fresh Basil', 'quantity': 4, 'threshold': 3, 'unit': 'bunches'},
    {'name': 'Fresh Mozzarella', 'quantity': 11, 'threshold': 5, 'unit': 'packs'},
    {'name': 'Kalamata Olives', 'quantity': 7, 'threshold': 3, 'unit': 'jars'},
    {'name': 'Lemons', 'quantity': 25, 'threshold': 8, 'unit': 'pcs'},
    {'name': 'Olive Oil', 'quantity': 3, 'threshold': 5, 'unit': 'bottles'},
    {'name': 'Pizza Base', 'quantity': 2, 'threshold': 5, 'unit': 'packs'},
    {'name': 'Red Onion', 'quantity': 18, 'threshold': 6, 'unit': 'pcs'},
    {'name': 'San Marzano Sauce', 'quantity': 9, 'threshold': 4, 'unit': 'jars'},
    {'name': 'Sourdough Bread', 'quantity': 15, 'threshold': 5, 'unit': 'loaves'},
    {'name': 'Vine Tomatoes', 'quantity': 6, 'threshold': 8, 'unit': 'packs'},
  ];

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<FlinkcooksAuthProvider>();

    return Scaffold(
      backgroundColor: FlinkColors.white,
      appBar: AppBar(
        backgroundColor: FlinkColors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                  color: FlinkColors.pink, shape: BoxShape.circle),
              child:
                  const Icon(Icons.bolt, color: FlinkColors.white, size: 18),
            ),
            const SizedBox(width: 8),
            const Text(
              'Hub Inventory',
              style: TextStyle(
                  color: FlinkColors.pink,
                  fontWeight: FontWeight.w800,
                  fontSize: 20),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () => context.go('/home'),
            icon: const Icon(Icons.storefront_outlined,
                color: FlinkColors.pink, size: 18),
            label: const Text('View App',
                style: TextStyle(color: FlinkColors.pink, fontSize: 13)),
          ),
          IconButton(
            onPressed: () => auth.signOut(),
            icon: const Icon(Icons.logout_outlined,
                color: FlinkColors.textGrey, size: 22),
            tooltip: 'Sign out',
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: FlinkColors.pink.withValues(alpha:0.05),
            child: Row(
              children: [
                const Icon(Icons.inventory_2_outlined,
                    color: FlinkColors.pink, size: 16),
                const SizedBox(width: 6),
                Text(
                  'Signed in as ${auth.currentUser?.displayName ?? 'Manager'}'
                  ' · ${auth.currentUser?.roleLabel ?? 'Hub Manager'}',
                  style: const TextStyle(
                      color: FlinkColors.pink,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: const Color(0xFFFFF8E1),
            child: Row(
              children: [
                Icon(Icons.info_outline,
                    color: Colors.amber.shade700, size: 16),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Recipe editing is restricted to HQ Admins. '
                    'Tap "Browse Recipes" for read-only access.',
                    style: TextStyle(
                        color: Colors.amber.shade900, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const _HubDashboard(),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text(
              'Stock Inventory',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: FlinkColors.black),
            ),
          ),
          const Expanded(child: _InventoryList()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddItemDialog(context),
        backgroundColor: FlinkColors.pink,
        icon: const Icon(Icons.add, color: FlinkColors.white),
        label: const Text(
          'Add Item',
          style:
              TextStyle(color: FlinkColors.white, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  void _showAddItemDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final qtyCtrl = TextEditingController();
    final thresholdCtrl = TextEditingController();
    final unitCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Add Stock Item',
            style: TextStyle(fontWeight: FontWeight.w800)),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Item Name'),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: qtyCtrl,
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(labelText: 'Quantity'),
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: unitCtrl,
                        decoration:
                            const InputDecoration(labelText: 'Unit (kg, pcs…)'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: thresholdCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Low Stock Threshold',
                    helperText: 'Alert when quantity falls below this value',
                  ),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Required' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: FlinkColors.textGrey)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              await FirebaseFirestore.instance.collection('hub_inventory').add({
                'name': nameCtrl.text.trim(),
                'quantity': int.tryParse(qtyCtrl.text) ?? 0,
                'threshold': int.tryParse(thresholdCtrl.text) ?? 0,
                'unit': unitCtrl.text.trim(),
                'updatedAt': FieldValue.serverTimestamp(),
              });
              if (ctx.mounted) Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: FlinkColors.pink,
              minimumSize: const Size(80, 44),
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

class _InventoryList extends StatelessWidget {
  const _InventoryList();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('hub_inventory')
          .orderBy('name')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: FlinkColors.pink));
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error loading inventory',
                style: TextStyle(color: Colors.red.shade400)),
          );
        }
        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.inventory_2_outlined,
                    size: 64, color: FlinkColors.pink.withValues(alpha:0.35)),
                const SizedBox(height: 16),
                const Text('No inventory items yet',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: FlinkColors.black)),
                const SizedBox(height: 8),
                const Text('Tap + Add Item to add stock.',
                    style: TextStyle(color: FlinkColors.textGrey)),
              ],
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
          itemCount: docs.length,
          separatorBuilder: (ctx, i) => const SizedBox(height: 10),
          itemBuilder: (context, i) {
            final doc = docs[i];
            final data = doc.data() as Map<String, dynamic>;
            return _InventoryCard(doc: doc, data: data);
          },
        );
      },
    );
  }
}

class _InventoryCard extends StatelessWidget {
  final QueryDocumentSnapshot doc;
  final Map<String, dynamic> data;

  const _InventoryCard({required this.doc, required this.data});

  @override
  Widget build(BuildContext context) {
    final qty = data['quantity'] as int? ?? 0;
    final threshold = data['threshold'] as int? ?? 0;
    final unit = data['unit'] as String? ?? '';
    final isLow = qty <= threshold;

    return Container(
      decoration: BoxDecoration(
        color: FlinkColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isLow ? Colors.red.shade200 : FlinkColors.midGrey,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    data['name'] as String? ?? 'Unknown Item',
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: FlinkColors.black),
                  ),
                ),
                if (isLow)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.warning_amber_rounded,
                            size: 12, color: Colors.red.shade700),
                        const SizedBox(width: 4),
                        Text(
                          'Low Stock',
                          style: TextStyle(
                              color: Colors.red.shade700,
                              fontSize: 11,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _StockChip(
                  label: 'Quantity',
                  value: '$qty${unit.isNotEmpty ? ' $unit' : ''}',
                  color: isLow ? Colors.red.shade600 : FlinkColors.pink,
                ),
                const SizedBox(width: 8),
                _StockChip(
                  label: 'Threshold',
                  value: '$threshold${unit.isNotEmpty ? ' $unit' : ''}',
                  color: FlinkColors.textGrey,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton.icon(
                onPressed: () => _showEditDialog(context),
                icon: const Icon(Icons.edit_outlined,
                    size: 16, color: FlinkColors.pink),
                label: const Text(
                  'Update Stock',
                  style: TextStyle(color: FlinkColors.pink, fontSize: 13),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: FlinkColors.pink),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final qty = data['quantity'] as int? ?? 0;
    final threshold = data['threshold'] as int? ?? 0;
    final qtyCtrl = TextEditingController(text: '$qty');
    final thresholdCtrl = TextEditingController(text: '$threshold');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Update ${data['name']}',
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: qtyCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Current Quantity'),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Required';
                  if (int.tryParse(v) == null) return 'Enter a valid number';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: thresholdCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Low Stock Threshold',
                  helperText: 'Alert when below this level',
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Required';
                  if (int.tryParse(v) == null) return 'Enter a valid number';
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: FlinkColors.textGrey)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              await doc.reference.update({
                'quantity': int.parse(qtyCtrl.text),
                'threshold': int.parse(thresholdCtrl.text),
                'updatedAt': FieldValue.serverTimestamp(),
              });
              if (ctx.mounted) Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: FlinkColors.pink,
              minimumSize: const Size(80, 44),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class _HubDashboard extends StatelessWidget {
  const _HubDashboard();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('hub_inventory')
          .orderBy('name')
          .snapshots(),
      builder: (context, snap) {
        final docs = snap.data?.docs ?? [];
        final items =
            docs.map((d) => d.data() as Map<String, dynamic>).toList();
        final total = items.length;
        final lowStock = items.where((item) {
          final qty = item['quantity'] as int? ?? 0;
          final threshold = item['threshold'] as int? ?? 0;
          return qty <= threshold;
        }).length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: _DashStatCard(
                      icon: Icons.inventory_2_outlined,
                      label: 'Total Items',
                      value: '$total',
                      color: FlinkColors.pink,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _DashStatCard(
                      icon: Icons.warning_amber_rounded,
                      label: 'Low Stock',
                      value: '$lowStock',
                      color: lowStock > 0
                          ? Colors.red.shade600
                          : Colors.green.shade600,
                    ),
                  ),
                ],
              ),
            ),
            if (items.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
                child: Row(
                  children: [
                    const Text(
                      'Stock Levels',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: FlinkColors.black,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 14,
                      height: 2,
                      color: Colors.orange.shade400,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'threshold',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.orange.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              _StockBarChart(items: items),
              const SizedBox(height: 4),
            ],
          ],
        );
      },
    );
  }
}

class _StockBarChart extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const _StockBarChart({required this.items});

  @override
  Widget build(BuildContext context) {
    final maxQty = items.fold<int>(1, (prev, item) {
      final qty = item['quantity'] as int? ?? 0;
      return qty > prev ? qty : prev;
    });

    const barAreaHeight = 80.0;
    const barWidth = 52.0;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: items.map((item) {
          final qty = item['quantity'] as int? ?? 0;
          final threshold = item['threshold'] as int? ?? 0;
          final name = item['name'] as String? ?? '';
          final unit = item['unit'] as String? ?? '';
          final isLow = qty <= threshold;
          final fillRatio = (qty / maxQty).clamp(0.0, 1.0);
          final thresholdRatio = (threshold / maxQty).clamp(0.0, 1.0);
          final barColor = isLow ? Colors.red.shade400 : FlinkColors.pink;

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$qty${unit.isNotEmpty ? ' $unit' : ''}',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: barColor,
                  ),
                ),
                const SizedBox(height: 3),
                SizedBox(
                  width: barWidth,
                  height: barAreaHeight,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        width: barWidth,
                        height: barAreaHeight,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                              color: Colors.grey.shade200, width: 0.5),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOut,
                        width: barWidth,
                        height: (barAreaHeight * fillRatio).clamp(
                            fillRatio > 0 ? 4.0 : 0.0, barAreaHeight),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              barColor.withValues(alpha: 0.65),
                              barColor,
                            ],
                          ),
                        ),
                      ),
                      if (threshold > 0)
                        Positioned(
                          bottom: barAreaHeight * thresholdRatio,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 2,
                            decoration: BoxDecoration(
                              color: Colors.orange.shade500,
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: barWidth,
                  child: Text(
                    name.length > 7 ? '${name.substring(0, 6)}…' : name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 10,
                      color: FlinkColors.textGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _DashStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _DashStatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: color,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: FlinkColors.textGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StockChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StockChip(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha:0.09),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  color: color, fontSize: 10, fontWeight: FontWeight.w600)),
          Text(value,
              style: TextStyle(
                  color: color, fontSize: 14, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
