import 'package:flutter/material.dart';

import 'gen/tempconv/v1/tempconv.pbgrpc.dart';
import 'grpc/channel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const backendUrl = String.fromEnvironment(
      'BACKEND_URL',
      defaultValue: 'http://localhost:8080',
    );

    return MaterialApp(
      title: 'TempConv',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: TempConvPage(backendUrl: backendUrl),
    );
  }
}

class TempConvPage extends StatefulWidget {
  const TempConvPage({super.key, required this.backendUrl});

  final String backendUrl;

  @override
  State<TempConvPage> createState() => _TempConvPageState();
}

class _TempConvPageState extends State<TempConvPage> {
  final _inputController = TextEditingController(text: '0');
  bool _cToF = true;
  bool _loading = false;
  String? _resultText;
  String? _errorText;

  late final TempConvServiceClient _client;

  @override
  void initState() {
    super.initState();
    final uri = Uri.parse(widget.backendUrl);
    final channel = createChannel(uri);
    _client = TempConvServiceClient(channel as dynamic);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('TempConv (gRPC-Web)'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Backend: ${widget.backendUrl}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _inputController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: _cToF ? 'Celsius' : 'Fahrenheit',
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(value: true, label: Text('C → F')),
                    ButtonSegment(value: false, label: Text('F → C')),
                  ],
                  selected: {_cToF},
                  onSelectionChanged: (s) {
                    setState(() {
                      _cToF = s.first;
                      _resultText = null;
                      _errorText = null;
                    });
                  },
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: _loading ? null : _convert,
                  child: _loading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Convert'),
                ),
                const SizedBox(height: 16),
                if (_resultText != null)
                  Text(
                    _resultText!,
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                if (_errorText != null)
                  Text(
                    _errorText!,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _convert() async {
    setState(() {
      _loading = true;
      _resultText = null;
      _errorText = null;
    });

    final input = double.tryParse(_inputController.text.trim());
    if (input == null) {
      setState(() {
        _loading = false;
        _errorText = 'Please enter a valid number.';
      });
      return;
    }

    try {
      final req = TemperatureRequest(value: input);
      final TemperatureReply resp = _cToF
          ? await _client.celsiusToFahrenheit(req)
          : await _client.fahrenheitToCelsius(req);

      setState(() {
        _loading = false;
        final unit = _cToF ? '°F' : '°C';
        _resultText = '${resp.value.toStringAsFixed(2)} $unit';
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _errorText = 'Request failed: $e';
      });
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }
}
