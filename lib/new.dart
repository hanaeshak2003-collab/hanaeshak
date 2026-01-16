import 'package:flutter/material.dart';

class MealScreen extends StatelessWidget {
  const MealScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          // removed const so children can include non-const scrollable widgets
          children: [
            // LEFT SIDE
            Expanded(child: Padding(padding: EdgeInsets.all(16), child: LeftPane())),
            // RIGHT SIDE
            Expanded(child: Padding(padding: EdgeInsets.all(16), child: SingleChildScrollView(child: RightPane()))),
          ],
        ),
      ),
    );
  }
}

// New: full-page wrapper for the left "Log Meal" column so it can be shown as its own route.
class LogMealPage extends StatelessWidget {
  const LogMealPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log Meal'), backgroundColor: Colors.green),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(child: LeftPane()),
        ),
      ),
    );
  }
}

// New: page wrapper so "See all" opens a dedicated Meat & Vegetables page
class MeatVegPage extends StatelessWidget {
  const MeatVegPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meat & Vegetables'), backgroundColor: Colors.green),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: MeatVegGrid(),
          ),
        ),
      ),
    );
  }
}

// LEFT SIDE COMPOSITES
class LeftPane extends StatelessWidget {
  const LeftPane({super.key});

  @override
  Widget build(BuildContext context) {
    // make the left side scrollable to prevent vertical overflow
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TopBar(),
          const SizedBox(height: 16),
          const CaloriesCardWidget(),
          const SizedBox(height: 16),
          const SearchBarWidget(),
          const SizedBox(height: 16),
          const FiltersWidget(),
          const SizedBox(height: 16),
          // SuggestedHeader is now interactive (non-const)
          SuggestedHeader(),
          const SizedBox(height: 12),
          // Updated: Grilled item now opens MealDetailsScreen (last page) when add icon is tapped
          MealItemWidget(
            title: "Grilled Meat & Vegetables",
            subtitle: "420 kcal • Protein-rich",
            onAdd: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MealDetailsScreen()));
            },
          ),
          const SizedBox(height: 8),
          const MealItemWidget(title: "Green Goddess Bowl", subtitle: "320 kcal • Vegan"),
          const MealItemWidget(title: "Green Goddess Bowl", subtitle: "450 kcal • Low carb"),
          const MealItemWidget(title: "Green Goddess Bowl", subtitle: "280 kcal • Breakfast"),
        ],
      ),
    );
  }
}

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text("Log Meal", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text("Help", style: TextStyle(color: Colors.green)),
      ],
    );
  }
}

class CaloriesCardWidget extends StatelessWidget {
  const CaloriesCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text("Calories Remaining", style: TextStyle(color: Colors.grey)),
          SizedBox(height: 8),
          Text("1,200 / 2,000 kcal", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
          SizedBox(height: 6),
          Text("Protein 45g left • Carbs 120g left • Fat 30g left", style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const TextField(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search),
        suffixIcon: Icon(Icons.mic),
        hintText: "Search meals",
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)), borderSide: BorderSide.none),
      ),
    );
  }
}

class FiltersWidget extends StatelessWidget {
  const FiltersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(spacing: 8, children: [
      Chip(backgroundColor: Colors.green, label: Text("Breakfast", style: TextStyle(color: Colors.white))),
      Chip(backgroundColor: Colors.grey.shade200, label: Text("High protein")),
      Chip(backgroundColor: Colors.grey.shade200, label: Text("Vegan")),
      Chip(backgroundColor: Colors.grey.shade200, label: Text("<400")),
    ]);
  }
}

// SuggestedHeader made tappable to open the MeatVegPage
class SuggestedHeader extends StatelessWidget {
  const SuggestedHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      const Text("Suggested for you", style: TextStyle(fontWeight: FontWeight.bold)),
      InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MeatVegPage()));
        },
        child: const Text("See all", style: TextStyle(color: Colors.green)),
      ),
    ]);
  }
}

class MealItemWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onAdd; // added callback

  const MealItemWidget({super.key, required this.title, required this.subtitle, this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Container(height: 40, width: 40, decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(8))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ]),
          ),
          // call onAdd when icon is tapped (if provided)
          GestureDetector(
            onTap: onAdd,
            child: const Icon(Icons.add_circle, color: Colors.green),
          ),
        ],
      ),
    );
  }
}

// RIGHT SIDE COMPOSITES
class RightPane extends StatelessWidget {
  const RightPane({super.key});

  @override
  Widget build(BuildContext context) {
    // removed const so MeatVegGrid (which now has tap handlers) can build
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // MeatVegGrid is still used inside the right pane (keeps same visuals)
      const MeatVegGrid(), // keep const here only if MeatVegGrid remains const; changed below to non-const so update if needed
      const SizedBox(height: 12),
      const Text("Grilled Meat & Vegetables", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      const SizedBox(height: 16),
      const TimeRowWidget(),
      const SizedBox(height: 16),
      const NutritionSection(),
      const SizedBox(height: 16),
      const IngredientsSection(),
      const SizedBox(height: 16),
      const PreparationSection(),
    ]);
  }
}

// Updated MeatVegGrid: tiles are tappable and push MealDetailsScreen
class MeatVegGrid extends StatelessWidget {
  const MeatVegGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final items = const [
      {'title': 'Grilled Steak', 'kcal': '420'},
      {'title': 'Roasted Veg', 'kcal': '180'},
      {'title': 'Mixed Skewers', 'kcal': '350'},
      {'title': 'Herb Chicken', 'kcal': '300'},
    ];

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 3 / 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: items.map((it) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MealDetailsScreen()));
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(8)),
                    child: const Center(child: Icon(Icons.image, size: 30)),
                  ),
                ),
                const SizedBox(height: 8),
                Text(it['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('${it['kcal']} kcal', style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class TimeRowWidget extends StatelessWidget {
  const TimeRowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
      _TimeCard("Breakfast"),
      _TimeCard("High Protein"),
      _TimeCard("Balanced"),
    ]);
  }
}

class NutritionSection extends StatelessWidget {
  const NutritionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionContainer(title: "Nutrition Breakdown", child: Column(children: const [
      _bar("Protein", 0.7),
      _bar("Carbs", 0.6),
      _bar("Fat", 0.4),
    ]));
  }
}

class IngredientsSection extends StatelessWidget {
  const IngredientsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionContainer(title: "Ingredients", child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
      Text("• Large Eggs (2)"),
      Text("• Sourdough Slice (1)"),
      Text("• Avocado (1/2)"),
      Text("• Chili Flakes"),
    ]));
  }
}

class PreparationSection extends StatelessWidget {
  const PreparationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionContainer(title: "Preparation", child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
      Text("1. Toast the bread until crispy."),
      Text("2. Poach the eggs for 3–4 minutes."),
      Text("3. Mash avocado and spread."),
      Text("4. Add eggs and chili flakes."),
    ]));
  }
}

class SectionContainer extends StatelessWidget {
  final String title;
  final Widget child;
  const SectionContainer({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        child,
      ]),
    );
  }
}

// small reusable widgets that were already present
class _TimeCard extends StatelessWidget {
  final String text;
  const _TimeCard(this.text);

  @override
  Widget build(BuildContext context) {
    return Column(children: [const Icon(Icons.timer, color: Colors.green), const SizedBox(height: 4), Text(text, style: const TextStyle(fontSize: 12))]);
  }
}

class _bar extends StatelessWidget {
  final String label;
  final double value;
  const _bar(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label),
      const SizedBox(height: 4),
      LinearProgressIndicator(value: value, backgroundColor: Colors.grey.shade300, color: Colors.green),
      const SizedBox(height: 8),
    ]);
  }
}

// New file content appended: MealDetailsScreen (detailed meal page)
class MealDetailsScreen extends StatelessWidget {
  const MealDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F5F1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _imageHeader(context),
              const SizedBox(height: 16),
              _titleSection(),
              const SizedBox(height: 16),
              _tags(),
              const SizedBox(height: 16),
              _timeCards(),
              const SizedBox(height: 20),
              _nutrition(),
              const SizedBox(height: 20),
              _ingredients(),
              const SizedBox(height: 20),
              _preparation(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Header Image
  Widget _imageHeader(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 220,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/meal.jpg"), // replace image
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 16,
          left: 16,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ],
    );
  }

  // 🔹 Title
  Widget _titleSection() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        "Grilled Meat &\nVegetables",
        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
      ),
    );
  }

  // 🔹 Tags
  Widget _tags() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8,
        children: [
          _tag("Breakfast"),
          _tag("High Protein"),
          _tag("Balanced"),
        ],
      ),
    );
  }

  Widget _tag(String text) {
    return Chip(
      backgroundColor: Colors.white,
      label: Text(text),
      shape: StadiumBorder(
        side: BorderSide(color: Colors.green.shade200),
      ),
    );
  }

  // 🔹 Time Cards
  Widget _timeCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          _InfoCard(icon: Icons.timer, label: "30 min"),
          _InfoCard(icon: Icons.local_fire_department, label: "30 min"),
          _InfoCard(icon: Icons.loop, label: "30 min"),
        ],
      ),
    );
  }

  // 🔹 Nutrition
  Widget _nutrition() {
    return _section(
      "Nutrition Breakdown",
      Column(
        children: const [
          _NutritionBar("Protein", 22),
          _NutritionBar("Carbs", 22),
          _NutritionBar("Protein", 22),
        ],
      ),
    );
  }

  // 🔹 Ingredients
  Widget _ingredients() {
    return _section(
      "Ingredients",
      Column(
        children: const [
          _IngredientTile("Large Eggs", "2"),
          _IngredientTile("Sourdough Slice", "1"),
          _IngredientTile("Avocado", "1/2"),
          _IngredientTile("Chili Flakes", "2"),
        ],
      ),
    );
  }

  // 🔹 Preparation
  Widget _preparation() {
    return _section(
      "Preparation",
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _StepItem("Step 1", "Toast the sourdough slice until golden brown."),
          _StepItem("Step 2", "Bring a pot of water & poach egg for 3–4 min."),
          _StepItem("Step 3", "Mash avocado with salt & lime juice and spread."),
          _StepItem("Step 4", "Top with egg, sprinkle chili flakes, serve."),
        ],
      ),
    );
  }

  // 🔹 Section Wrapper
  Widget _section(String title, Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

// 🔸 Components

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoCard({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.green.shade100),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.green),
          const SizedBox(height: 6),
          Text(label),
        ],
      ),
    );
  }
}

class _NutritionBar extends StatelessWidget {
  final String label;
  final int value;

  const _NutritionBar(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text("${value}g"),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: value / 30,
          color: Colors.green,
          backgroundColor: Colors.grey.shade300,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class _IngredientTile extends StatelessWidget {
  final String name;
  final String qty;

  const _IngredientTile(this.name, this.qty);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green.shade100),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name),
          Text(qty),
        ],
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final String step;
  final String text;

  const _StepItem(this.step, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black),
          children: [
            TextSpan(text: "$step\n", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
            TextSpan(text: text),
          ],
        ),
      ),
    );
  }
}

