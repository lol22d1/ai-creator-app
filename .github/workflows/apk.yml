import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController prompt = TextEditingController();
  String output = "";
  bool loading = false;

  Future<void> generate() async {
    setState(() {
      loading = true;
    });

    final res = await http.post(
      Uri.parse("https://api.replicate.com/v1/predictions"),
      headers: {
        "Authorization": "Token ${const String.fromEnvironment('API_KEY')}",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "version": "MODEL_ID",
        "input": {"prompt": prompt.text}
      }),
    );

    setState(() {
      output = res.body;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Creator")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: prompt),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: generate,
              child: const Text("Genera"),
            ),
            const SizedBox(height: 20),
            loading
                ? const CircularProgressIndicator()
                : Expanded(child: SingleChildScrollView(child: Text(output))),
          ],
        ),
      ),
    );
  }
}
