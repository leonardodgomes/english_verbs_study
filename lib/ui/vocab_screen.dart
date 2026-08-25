import 'package:flutter/material.dart';
import '../state/vocab_notifier.dart';

class VocabScreen extends StatefulWidget {
  final VocabQuizNotifier vocabNotifier;

  const VocabScreen({super.key, required this.vocabNotifier});

  @override
  State<VocabScreen> createState() => _VocabScreenState();
}

class _VocabScreenState extends State<VocabScreen> {
  final TextEditingController _controller = TextEditingController();

  IconData _getIconData(String iconName) {
    switch (iconName) {
      // --- Animals ---
      case 'pets': return Icons.pets;
      case 'cruelty_free': return Icons.cruelty_free;
      case 'flutter_dash': return Icons.flutter_dash;
      case 'set_meal': return Icons.set_meal;
      case 'agriculture': return Icons.agriculture;
      case 'bug_report': return Icons.bug_report;
      case 'pest_control': return Icons.pest_control;

      // --- Food & Drinks ---
      case 'apple': return Icons.apple;
      case 'cake': return Icons.cake;
      case 'coffee': return Icons.coffee;
      case 'water_drop': return Icons.water_drop;
      case 'bakery_dining': return Icons.bakery_dining;
      case 'restaurant': return Icons.restaurant;
      case 'egg': return Icons.egg;
      case 'local_pizza': return Icons.local_pizza;
      case 'lunch_dining': return Icons.lunch_dining;
      case 'rice_bowl': return Icons.rice_bowl;
      case 'icecream': return Icons.icecream;
      case 'wine_bar': return Icons.wine_bar;
      case 'sports_bar': return Icons.sports_bar;
      case 'cookie': return Icons.cookie;
      case 'soup_kitchen': return Icons.soup_kitchen;
      case 'dinner_dining': return Icons.dinner_dining;
      case 'kebab_dining': return Icons.kebab_dining;
      case 'grain': return Icons.grain;
      case 'hive': return Icons.hive;
      case 'local_drink': return Icons.local_drink;

      // --- Transport ---
      case 'directions_car': return Icons.directions_car;
      case 'pedal_bike': return Icons.pedal_bike;
      case 'flight': return Icons.flight;
      case 'train': return Icons.train;
      case 'directions_bus': return Icons.directions_bus;
      case 'motorcycle': return Icons.motorcycle;
      case 'directions_boat': return Icons.directions_boat;
      case 'local_shipping': return Icons.local_shipping;
      case 'local_taxi': return Icons.local_taxi;
      case 'subway': return Icons.subway;
      case 'rocket_launch': return Icons.rocket_launch;
      case 'medical_services': return Icons.medical_services;
      case 'moped': return Icons.moped;

      // --- Technology ---
      case 'phone_android': return Icons.phone_android;
      case 'photo_camera': return Icons.photo_camera;
      case 'tv': return Icons.tv;
      case 'radio': return Icons.radio;
      case 'headphones': return Icons.headphones;
      case 'mouse': return Icons.mouse;
      case 'keyboard': return Icons.keyboard;
      case 'laptop': return Icons.laptop;
      case 'tablet_android': return Icons.tablet_android;
      case 'print': return Icons.print;
      case 'watch': return Icons.watch;
      case 'router': return Icons.router;
      case 'mic': return Icons.mic;

      // --- Nature & Space ---
      case 'nature': return Icons.nature;
      case 'wb_sunny': return Icons.wb_sunny;
      case 'dark_mode': return Icons.dark_mode;
      case 'cloud': return Icons.cloud;
      case 'star': return Icons.star;
      case 'local_florist': return Icons.local_florist;
      case 'water': return Icons.water;
      case 'terrain': return Icons.terrain;
      case 'waves': return Icons.waves;
      case 'ac_unit': return Icons.ac_unit;
      case 'air': return Icons.air;
      case 'cloud_queue': return Icons.cloud_queue;
      case 'public': return Icons.public;
      case 'local_fire_department': return Icons.local_fire_department;
      case 'holiday_village': return Icons.holiday_village;
      case 'forest': return Icons.forest;
      case 'landscape': return Icons.landscape;
      case 'grass': return Icons.grass;
      case 'eco': return Icons.eco;

      // --- Home & Furniture ---
      case 'home': return Icons.home;
      case 'chair': return Icons.chair;
      case 'bed': return Icons.bed;
      case 'table_restaurant': return Icons.table_restaurant;
      case 'window': return Icons.window;
      case 'desk': return Icons.desk;
      case 'lightbulb': return Icons.lightbulb;
      case 'bathroom': return Icons.bathroom;
      case 'crop_portrait': return Icons.crop_portrait;
      case 'schedule': return Icons.schedule;
      case 'kitchen': return Icons.kitchen;
      case 'key': return Icons.key;
      case 'wallpaper': return Icons.wallpaper;
      case 'house': return Icons.house;
      case 'layers': return Icons.layers;

      // --- Clothing & Fashion ---
      case 'checkroom': return Icons.checkroom;
      case 'ice_skating': return Icons.ice_skating;
      case 'face': return Icons.face;
      case 'shopping_bag': return Icons.shopping_bag;
      case 'horizontal_rule': return Icons.horizontal_rule;
      case 'front_hand': return Icons.front_hand;

      // --- Places & Buildings ---
      case 'school': return Icons.school;
      case 'store': return Icons.store;
      case 'local_hospital': return Icons.local_hospital;
      case 'local_library': return Icons.local_library;
      case 'park': return Icons.park;
      case 'account_balance': return Icons.account_balance;
      case 'hotel': return Icons.hotel;
      case 'local_airport': return Icons.local_airport;
      case 'movie': return Icons.movie;
      case 'museum': return Icons.museum;
      case 'work': return Icons.work;
      case 'church': return Icons.church;
      case 'beach_access': return Icons.beach_access;

      // --- Sports & Hobbies ---
      case 'sports_baseball': return Icons.sports_baseball;
      case 'sports_esports': return Icons.sports_esports;
      case 'music_note': return Icons.music_note;
      case 'book': return Icons.book;
      case 'piano': return Icons.piano;
      case 'sports_soccer': return Icons.sports_soccer;
      case 'sports_tennis': return Icons.sports_tennis;
      case 'directions_run': return Icons.directions_run;
      case 'pool': return Icons.pool;
      case 'palette': return Icons.palette;
      case 'celebration': return Icons.celebration;
      case 'extension': return Icons.extension;

      // --- People & Roles ---
      case 'person': return Icons.person;
      case 'child_care': return Icons.child_care;
      case 'child_friendly': return Icons.child_friendly;
      case 'local_police': return Icons.local_police;
      case 'group': return Icons.group;
      case 'family_restroom': return Icons.family_restroom;
      case 'time_to_leave': return Icons.time_to_leave;

      // --- Objects & Daily Tools ---
      case 'umbrella': return Icons.umbrella;
      case 'edit': return Icons.edit;
      case 'description': return Icons.description;
      case 'content_cut': return Icons.content_cut;
      case 'build': return Icons.build;
      case 'attach_money': return Icons.attach_money;
      case 'account_balance_wallet': return Icons.account_balance_wallet;
      case 'inventory_2': return Icons.inventory_2;
      case 'clean_hands': return Icons.clean_hands;
      case 'texture': return Icons.texture;
      case 'brush': return Icons.brush;
      case 'liquor': return Icons.liquor;
      case 'diamond': return Icons.diamond;
      case 'monetization_on': return Icons.monetization_on;
      case 'shopping_basket': return Icons.shopping_basket;

      // --- Abstract & Misc ---
      case 'favorite': return Icons.favorite;
      case 'access_time': return Icons.access_time;
      case 'translate': return Icons.translate;
      case 'history': return Icons.history;
      case 'science': return Icons.science;
      case 'calculate': return Icons.calculate;
      case 'health_and_safety': return Icons.health_and_safety;
      case 'pin': return Icons.pin;
      case 'abc': return Icons.abc;
      case 'bedtime': return Icons.bedtime;

      // --- Fallback Padrão ---
      default: return Icons.help_outline;
    }
  }

  void _submit() {
    if (_controller.text.isEmpty) return;
    widget.vocabNotifier.checkAnswer(_controller.text);
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vocabulary Builder'),
      ),
      body: ValueListenableBuilder<VocabQuizState>(
        valueListenable: widget.vocabNotifier,
        builder: (context, state, child) {
          final item = state.currentItem;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('🔥 Streak: ${state.score}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('🏆 Best: ${state.highestScore}', style: const TextStyle(fontSize: 18, color: Colors.amber, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 40),
                Icon(
                  _getIconData(item.iconName),
                  size: 100,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 20),
                Text(
                  item.hint,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 30),

                // NEW: Dynamic Correction Banner Feedback Card
                if (state.revealCorrection != null) ...[
                  Card(
                    color: Colors.red.shade50,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.red.shade200),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'Oops! The correct word was: ${state.revealCorrection}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.red.shade900,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'What is this called in English?',
                  ),
                  onSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _submit,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Check Word', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
