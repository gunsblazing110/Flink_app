import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../models/user_model.dart';
import '../../theme/app_theme.dart';
import '../../widgets/role_guard.dart';

class RecipeManagementPage extends StatefulWidget {
  const RecipeManagementPage({super.key});

  @override
  State<RecipeManagementPage> createState() => _RecipeManagementPageState();
}

class _RecipeManagementPageState extends State<RecipeManagementPage> {
  int _selectedTab = 0;

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
                color: FlinkColors.pink,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.bolt, color: FlinkColors.white, size: 18),
            ),
            const SizedBox(width: 8),
            const Text(
              'Flinkcooks Admin',
              style: TextStyle(
                color: FlinkColors.pink,
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: FlinkColors.midGrey)),
            ),
            child: Row(
              children: [
                _TabButton(
                  label: 'Recipes',
                  index: 0,
                  selectedIndex: _selectedTab,
                  onTap: () => setState(() => _selectedTab = 0),
                ),
                _TabButton(
                  label: 'App Features',
                  index: 1,
                  selectedIndex: _selectedTab,
                  onTap: () => setState(() => _selectedTab = 1),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: FlinkColors.pink.withValues(alpha:0.05),
            child: Row(
              children: [
                const Icon(Icons.admin_panel_settings,
                    color: FlinkColors.pink, size: 16),
                const SizedBox(width: 6),
                Text(
                  'Signed in as ${auth.currentUser?.displayName ?? 'Admin'}'
                  ' · ${auth.currentUser?.roleLabel ?? 'HQ Admin'}',
                  style: const TextStyle(
                    color: FlinkColors.pink,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const _AdminStatsBar(),
          Expanded(
            child: _selectedTab == 0
                ? const _RecipesTab()
                : const _FeaturesTab(),
          ),
        ],
      ),
      floatingActionButton: _selectedTab == 0
          ? RoleGuard(
              role: UserRole.hqAdmin,
              child: FloatingActionButton.extended(
                onPressed: () => _showAddRecipeDialog(context),
                backgroundColor: FlinkColors.pink,
                icon: const Icon(Icons.add, color: FlinkColors.white),
                label: const Text(
                  'Add Recipe',
                  style: TextStyle(
                      color: FlinkColors.white, fontWeight: FontWeight.w700),
                ),
              ),
            )
          : null,
    );
  }

  void _showAddRecipeDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final categoryCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Add Recipe',
            style: TextStyle(fontWeight: FontWeight.w800)),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Recipe Name'),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: categoryCtrl,
                  decoration: const InputDecoration(labelText: 'Category'),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: descCtrl,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
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
              await FirebaseFirestore.instance.collection('recipes').add({
                'name': nameCtrl.text.trim(),
                'category': categoryCtrl.text.trim(),
                'description': descCtrl.text.trim(),
                'createdAt': FieldValue.serverTimestamp(),
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

class _TabButton extends StatelessWidget {
  final String label;
  final int index;
  final int selectedIndex;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = index == selectedIndex;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? FlinkColors.pink : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? FlinkColors.pink : FlinkColors.textGrey,
              fontWeight:
                  isSelected ? FontWeight.w700 : FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

class _RecipesTab extends StatelessWidget {
  const _RecipesTab();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('recipes')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: FlinkColors.pink));
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error loading recipes',
                style: TextStyle(color: Colors.red.shade400)),
          );
        }
        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.menu_book_outlined,
                    size: 64, color: FlinkColors.pink.withValues(alpha:0.35)),
                const SizedBox(height: 16),
                const Text('No recipes yet',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: FlinkColors.black)),
                const SizedBox(height: 8),
                const Text('Tap + Add Recipe to create your first recipe.',
                    style: TextStyle(color: FlinkColors.textGrey)),
              ],
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: docs.length,
          separatorBuilder: (ctx, i) => const SizedBox(height: 8),
          itemBuilder: (context, i) {
            final doc = docs[i];
            final data = doc.data() as Map<String, dynamic>;
            return _RecipeCard(doc: doc, data: data);
          },
        );
      },
    );
  }
}

class _RecipeCard extends StatelessWidget {
  final QueryDocumentSnapshot doc;
  final Map<String, dynamic> data;

  const _RecipeCard({required this.doc, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FlinkColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: FlinkColors.midGrey),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: FlinkColors.pink.withValues(alpha:0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child:
              const Icon(Icons.restaurant_menu, color: FlinkColors.pink),
        ),
        title: Text(
          data['name'] as String? ?? 'Unnamed Recipe',
          style: const TextStyle(
              fontWeight: FontWeight.w700, color: FlinkColors.black),
        ),
        subtitle: Text(
          data['category'] as String? ?? 'Uncategorized',
          style: const TextStyle(color: FlinkColors.textGrey, fontSize: 13),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined,
                  color: FlinkColors.textGrey, size: 20),
              onPressed: () => _showEditDialog(context),
              tooltip: 'Edit',
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline,
                  color: FlinkColors.pink, size: 20),
              onPressed: () => _confirmDelete(context),
              tooltip: 'Delete',
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final nameCtrl =
        TextEditingController(text: data['name'] as String? ?? '');
    final categoryCtrl =
        TextEditingController(text: data['category'] as String? ?? '');
    final descCtrl =
        TextEditingController(text: data['description'] as String? ?? '');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Edit Recipe',
            style: TextStyle(fontWeight: FontWeight.w800)),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Recipe Name'),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: categoryCtrl,
                  decoration: const InputDecoration(labelText: 'Category'),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: descCtrl,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
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
              await doc.reference.update({
                'name': nameCtrl.text.trim(),
                'category': categoryCtrl.text.trim(),
                'description': descCtrl.text.trim(),
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

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Recipe',
            style: TextStyle(fontWeight: FontWeight.w800)),
        content: Text(
          'Are you sure you want to delete "${data['name']}"?',
          style: const TextStyle(color: FlinkColors.textGrey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: FlinkColors.textGrey)),
          ),
          ElevatedButton(
            onPressed: () async {
              await doc.reference.delete();
              if (ctx.mounted) Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: FlinkColors.pink,
              minimumSize: const Size(80, 44),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _AdminStatsBar extends StatelessWidget {
  const _AdminStatsBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('recipes')
                  .snapshots(),
              builder: (context, snap) {
                final count = snap.data?.docs.length ?? 0;
                return _DashStatCard(
                  icon: Icons.restaurant_menu,
                  label: 'Total Recipes',
                  value: '$count',
                  color: FlinkColors.pink,
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('app_features')
                  .snapshots(),
              builder: (context, snap) {
                final docs = snap.data?.docs ?? [];
                final active = docs.where((d) {
                  final data = d.data() as Map<String, dynamic>;
                  return data['enabled'] == true;
                }).length;
                return _DashStatCard(
                  icon: Icons.toggle_on_outlined,
                  label: 'Features On',
                  value: '$active / ${docs.length}',
                  color: Colors.green.shade600,
                );
              },
            ),
          ),
        ],
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

class _FeaturesTab extends StatelessWidget {
  const _FeaturesTab();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('app_features').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: FlinkColors.pink));
        }
        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.toggle_on_outlined,
                    size: 64, color: FlinkColors.pink.withValues(alpha:0.35)),
                const SizedBox(height: 16),
                const Text('No app features configured',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: FlinkColors.black)),
                const SizedBox(height: 8),
                const Text(
                  'Add feature documents to the\napp_features collection in Firestore.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: FlinkColors.textGrey),
                ),
              ],
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: docs.length,
          separatorBuilder: (ctx, i) => const SizedBox(height: 8),
          itemBuilder: (context, i) {
            final doc = docs[i];
            final data = doc.data() as Map<String, dynamic>;
            final isEnabled = data['enabled'] as bool? ?? false;
            return Container(
              decoration: BoxDecoration(
                color: FlinkColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: FlinkColors.midGrey),
              ),
              child: SwitchListTile(
                title: Text(
                  data['name'] as String? ?? doc.id,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, color: FlinkColors.black),
                ),
                subtitle: Text(
                  data['description'] as String? ?? '',
                  style: const TextStyle(
                      color: FlinkColors.textGrey, fontSize: 13),
                ),
                value: isEnabled,
                activeThumbColor: FlinkColors.pink,
                onChanged: (val) => doc.reference.update({'enabled': val}),
              ),
            );
          },
        );
      },
    );
  }
}
