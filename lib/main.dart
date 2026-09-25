import 'package:flutter/material.dart';

void main() {
  runApp(const PhoneCheckApp());
}

class PhoneCheckApp extends StatelessWidget {
  const PhoneCheckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'New Wave Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFB71C1C), // Deep Red Accent
          primary: const Color(0xFFB71C1C),
          secondary: Colors.black,
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          surfaceTintColor: Colors.white,
          shadowColor: Colors.black26,
          elevation: 2,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.grey.shade300, width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        useMaterial3: true,
      ),
      home: const MainHomeScreen(),
    );
  }
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;
  final List<Map<String, dynamic>> _history = [];

  final _inspectorController = TextEditingController();
  final _modelController = TextEditingController();

  final Map<String, List<String>> _sections = {
    '၁။ အပြင်ပိုင်း စစ်ဆေးခြင်း': [
      'CEIR (Blacklist အခွန်စာရင်း စစ်ရန်)',
      'OS Version (FRP စစ်ရန်)',
      'ဖုန်းကာဗာ/အပြင်ဘက် (အနာအဆာ၊ ပွန်းရာ)',
      'ခလုတ်များ (Power, Volume, Mute)',
      'မှန်ပြင် (အက်ကွဲကြောင်း၊ ပွန်းရာ)',
      'ဘောင် (ကွေးနေခြင်း၊ ဟနေခြင်း)',
      'မူရင်းပစ္စည်းများ (မှန်၊ ဘက်ထရီ၊ ကင်မရာ)',
      'ပြုပြင်ထားခြင်း (ရှိ/မရှိ)',
    ],
    '၂။ စနစ်ပိုင်း/အသေးစိတ် စစ်ဆေးခြင်း': [
      'Kernel စစ်ဆေးခြင်း (Hardware Test)',
      'LCD မှန်ပြင် (အဖြူရောင်မျက်နှာပြင်နှင့် စစ်ရန်)',
      'Touch အာရုံခံစနစ် (နေရာစုံ ထိကြည့်ရန်)',
      'စပီကာ (ဖုန်းမြည်သံ)',
      'နားစပီကာ (၁၁၂ ခေါ်ဆို စစ်ရန်)',
      'တုန်ခါမှုစနစ် (Vibrator)',
      'အာရုံခံစနစ်များ (Auto Rotate, Brightness)',
      'လက်ဗွေ / မျက်နှာပြင် သော့စနစ်',
      'မိုက်ခရိုဖုန်း (အဓိကမိုက်၊ အရန်မိုက်)',
      'ကင်မရာ (ရှေ့၊ နောက်၊ Focus၊ ဗီဒီယို)',
      'ဓါတ်မီး (Flashlight)',
      'ဝိုင်ဖိုင် (Wifi လိုင်းဆွဲအား)',
      'ဘလူးတု (Bluetooth ချိတ်ဆက်မှု)',
      'ဆင်းကဒ် (လိုင်းမိမှု၊ ဖုန်းခေါ်ဆိုမှု)',
      'ဘက်ထရီ သက်တမ်း (ဗီဒီယိုဖွင့် စစ်ရန်)',
      'အားသွင်းစနစ် (Fast/Turbo Charge)',
    ],
    '၃။ အပြီးသတ် စစ်ဆေးခြင်း': [
      'Factory Reset (ဒေတာများ ရှင်းထုတ်ခြင်း)',
      'FRP စစ်ဆေးခြင်း (Passcode, Gmail)',
      'LCD နှင့် Touch (နောက်ဆုံးတစ်ကြိမ် ပြန်စစ်ရန်)',
    ]
  };

  final Map<String, bool> _checkResults = {};
  final Map<String, TextEditingController> _remarkControllers = {};

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() {
    _sections.forEach((section, items) {
      for (var item in items) {
        _checkResults[item] = false;
        _remarkControllers[item] = TextEditingController();
      }
    });
  }

  void _resetChecklist() {
    setState(() {
      _checkResults.updateAll((key, value) => false);
      _remarkControllers.forEach((key, controller) => controller.clear());
    });
  }

  void _saveRecord() {
    if (_modelController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ကျေးဇူးပြု၍ ဖုန်း အမျိုးအစား ရေးထည့်ပါ'),
          backgroundColor: Color(0xFFB71C1C),
        ),
      );
      return;
    }

    final now = DateTime.now();
    final String formattedDate =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    final String formattedTime =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    Map<String, String> remarkData = {};
    _remarkControllers.forEach((key, controller) {
      if (controller.text.trim().isNotEmpty) {
        remarkData[key] = controller.text.trim();
      }
    });

    setState(() {
      _history.insert(0, {
        'inspector': _inspectorController.text.trim().isEmpty
            ? 'မဖော်ပြထားပါ'
            : _inspectorController.text.trim(),
        'model': _modelController.text.trim(),
        'date': formattedDate,
        'time': formattedTime,
        'checks': Map<String, bool>.from(_checkResults),
        'remarks': remarkData,
      });
      _modelController.clear();
      _inspectorController.clear();
      _resetChecklist();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('စစ်ဆေးချက် မှတ်တမ်း သိမ်းဆည်းပြီးပါပြီ!'),
        backgroundColor: Colors.black,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentIndex == 0 ? 'New Wave Mobile' : 'စစ်ဆေးခဲ့သော မှတ်တမ်းများ',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: _currentIndex == 0 ? _buildChecklistPage() : _buildHistoryPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFFB71C1C),
        unselectedItemColor: Colors.black54,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.fact_check),
            label: 'စစ်ဆေးရန်',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'မှတ်တမ်း',
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _inspectorController,
            decoration: InputDecoration(
              labelText: 'စစ်ဆေးသူ နာမည် (ဥပမာ - ကိုအောင်)',
              labelStyle: const TextStyle(color: Colors.black87),
              border: const OutlineInputBorder(),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFB71C1C), width: 2),
              ),
              prefixIcon: const Icon(Icons.person, color: Color(0xFFB71C1C)),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _modelController,
            decoration: InputDecoration(
              labelText: 'ဖုန်း အမျိုးအစား (ဥပမာ - iPhone 13 Pro / Samsung S21)',
              labelStyle: const TextStyle(color: Colors.black87),
              border: const OutlineInputBorder(),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFB71C1C), width: 2),
              ),
              prefixIcon: const Icon(Icons.phone_android, color: Color(0xFFB71C1C)),
            ),
          ),
          const SizedBox(height: 20),
          ..._sections.entries.map((entry) {
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFB71C1C),
                      ),
                    ),
                    const Divider(color: Colors.black12),
                    ...entry.value.map((item) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Column(
                          children: [
                            CheckboxListTile(
                              activeColor: const Color(0xFFB71C1C),
                              checkColor: Colors.white,
                              title: Text(
                                item,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              value: _checkResults[item] ?? false,
                              onChanged: (bool? val) {
                                setState(() {
                                  _checkResults[item] = val ?? false;
                                });
                              },
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 8.0, bottom: 8.0),
                              child: TextField(
                                controller: _remarkControllers[item],
                                decoration: InputDecoration(
                                  hintText:
                                      'မှတ်ချက် ရေးရန် (ဥပမာ- ရာခိုင်နှုန်း/အနာအဆာ)',
                                  hintStyle: TextStyle(
                                      color: Colors.grey.shade500, fontSize: 12),
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 8),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade300),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        color: Color(0xFFB71C1C)),
                                  ),
                                  fillColor: Colors.grey.shade50,
                                  filled: true,
                                ),
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _saveRecord,
              icon: const Icon(Icons.save),
              label: const Text(
                'မှတ်တမ်း သိမ်းဆည်းမည်',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB71C1C),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryPage() {
    return _history.isEmpty
        ? const Center(
            child: Text(
              'စစ်ဆေးထားသော မှတ်တမ်း မရှိသေးပါ။',
              style: TextStyle(color: Colors.black54),
            ),
          )
        : ListView.builder(
            itemCount: _history.length,
            itemBuilder: (context, index) {
              final item = _history[index];
              final Map<String, bool> checks =
                  Map<String, bool>.from(item['checks']);
              final Map<String, String> remarks =
                  Map<String, String>.from(item['remarks'] ?? {});
              final int passedCount =
                  checks.values.where((v) => v == true).length;
              final int totalCount = checks.length;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.black,
                    child: Icon(Icons.phone_android, color: Colors.white),
                  ),
                  title: Text(
                    item['model'] ?? 'မသိရှိသော ဖုန်းအမျိုးအစား',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  subtitle: Text(
                    'စစ်ဆေးသူ: ${item['inspector']}\nရက်စွဲ: ${item['date']} | အချိန်: ${item['time']}',
                    style: const TextStyle(color: Colors.black87),
                  ),
                  isThreeLine: true,
                  trailing: Chip(
                    label: Text(
                      '$passedCount/$totalCount စစ်ပြီး',
                      style: const TextStyle(
                          color: Colors.white, fontSize: 11),
                    ),
                    backgroundColor: passedCount == totalCount
                        ? const Color(0xFFB71C1C)
                        : Colors.black,
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Colors.white,
                        title: Text(
                          '${item['model']} စစ်ဆေးချက် အသေးစိတ်',
                          style: const TextStyle(
                              color: Color(0xFFB71C1C),
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        content: SizedBox(
                          width: double.maxFinite,
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              Text('စစ်ဆေးသူ: ${item['inspector']}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                              Text('ရက်စွဲ: ${item['date']} (${item['time']})',
                                  style: const TextStyle(color: Colors.black54)),
                              const Divider(color: Colors.black26),
                              ...checks.entries.map((entry) {
                                final String? remarkText = remarks[entry.key];
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      dense: true,
                                      title: Text(entry.key,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black)),
                                      trailing: Icon(
                                        entry.value
                                            ? Icons.check_circle
                                            : Icons.cancel,
                                        color: entry.value
                                            ? const Color(0xFFB71C1C)
                                            : Colors.grey,
                                      ),
                                    ),
                                    if (remarkText != null &&
                                        remarkText.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16.0, bottom: 8.0),
                                        child: Text(
                                          'မှတ်ချက်: $remarkText',
                                          style: const TextStyle(
                                              color: Colors.black87,
                                              fontStyle: FontStyle.italic,
                                              fontSize: 12),
                                        ),
                                      ),
                                    const Divider(height: 1, color: Colors.black12),
                                  ],
                                );
                              }),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('ပိတ်မည်',
                                style: TextStyle(
                                    color: Color(0xFFB71C1C),
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          );
  }
}
