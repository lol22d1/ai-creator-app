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
      debugShowCheckedModeBanner: false,
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
  final TextEditingController prompt = TextEditingController();

  String output = "";
  bool loading = false;

  // API KEY da GitHub Secrets
  static const apiKey = String.fromEnvironment('API_KEY');

  // 🖼️ IMMAGINI (FLUX - consigliato)
  Future<void> generateImage() async {
    setState(() {
      loading = true;
      output = "";
    });

    final res = await http.post(
      Uri.parse("https://api.replicate.com/v1/predictions"),
      headers: {
        "Authorization": "Token $apiKey",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "version": "black-forest-labs/flux-schnell",
        "input": {
          "prompt": prompt.text,
        }
      }),
    );

    setState(() {
      loading = false;
      output = res.body;
    });
  }

  // 🎬 VIDEO (Stable Video Diffusion)
  Future<void> generateVideo() async {
    setState(() {
      loading = true;
      output = "";
    });

    final res = await http.post(
      Uri.parse("https://api.replicate.com/v1/predictions"),
      headers: {
        "Authorization": "Token $apiKey",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "version": "stability-ai/stable-video-diffusion",
        "input": {
          "prompt": prompt.text,
        }
      }),
    );

    setState(() {
      loading = false;
      output = res.body;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Creator"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: prompt,
              decoration: const InputDecoration(
                hintText: "Scrivi cosa vuoi creare...",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: [

                Expanded(
                  child: ElevatedButton(
                    onPressed: generateImage,
                    child: const Text("🖼️ Immagine"),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton(
                    onPressed: generateVideo,
                    child: const Text("🎬 Video"),
                  ),
                ),

              ],
            ),

            const SizedBox(height: 20),

            loading
                ? const CircularProgressIndicator()
                : Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        output,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),

          ],
        ),
      ),
    );
  }
}
