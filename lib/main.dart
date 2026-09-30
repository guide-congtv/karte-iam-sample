import 'package:flutter/material.dart';
import 'package:karte_core/karte_core.dart';

/// Minimal repro: rapid tab switching while a KARTE In-App Messaging popup
/// is (re)presented on every view event makes the Flutter UI stop responding
/// to touch.
///
/// Each tab button sends one `Tracker.view` event. Configure a campaign that
/// shows a popup on these view names, then tap the buttons quickly in a row.
void main() {
  runApp(const SampleApp());
}

class SampleApp extends StatelessWidget {
  const SampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'KARTE IAM Flutter Sample',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> _log = [];
  final ScrollController _scroll = ScrollController();
  int _tapCount = 0;

  // (label, view name, title) — one KARTE view event per tab.
  static const _tabs = [
    ('通常', 'order:new_normal:input', '新規注文_通常'),
    ('IFD', 'order:new_ifd:input', '新規注文_IFD'),
    ('OCO', 'order:new_oco:input', '新規注文_OCO'),
    ('IFDOCO', 'order:new_ifdoco:input', '新規注文_IFD-OCO'),
    ('トレール', 'order:new_trail:input', '新規注文_トレール'),
  ];

  @override
  void initState() {
    super.initState();
    _addLog('init — view(main) sent');
    Tracker.view('main');
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _sendView(String viewName, String title) {
    _tapCount++;
    _addLog('tap#$_tapCount view($viewName) sent');
    Tracker.view(viewName, title);
  }

  void _addLog(String message) {
    final ts = DateTime.now().toIso8601String().substring(11, 23);
    debugPrint('[sample] $ts $message');
    setState(() => _log.add('$ts  $message'));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) _scroll.jumpTo(_scroll.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('KARTE IAM Flutter Sample')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              'Tap the tabs quickly in a row while the popup is shown. '
              'The log below stops advancing once the UI is frozen.',
              style: TextStyle(fontSize: 12),
            ),
          ),
          Row(
            children: [
              for (final (label, viewName, title) in _tabs)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        textStyle: const TextStyle(fontSize: 11),
                      ),
                      onPressed: () => _sendView(viewName, title),
                      child: Text(label),
                    ),
                  ),
                ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              itemCount: _log.length,
              itemBuilder: (context, i) => Text(
                _log[i],
                style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
