import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/services.dart';

void main() => runApp(const TabsApp());

class TabsApp extends StatelessWidget {
  const TabsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      home: const Tabs(),
    );
  }
}

class Tabs extends StatefulWidget {
  const Tabs({Key? key}) : super(key: key);

  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  String encryptedText = "";
  String text = "";
  String secret = "";
  String decryptText = "";
  String secret1 = "";
  String decryptedText = "";

  @override
  Widget build(BuildContext context) {
    final _kTabPages = <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Encrypt Your Data",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextField(
                  onChanged: (val) {
                    text = val;
                  },
                  decoration: InputDecoration(
                    labelText: "Enter the text to encrypt",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  onChanged: (sl) {
                    secret = sl;
                  },
                  decoration: InputDecoration(
                    labelText: "Enter the key to encrypt",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    if (secret.isNotEmpty) {
                      try {
                        String secretAdd = "saifjckjfklasjdhfljaskldjhflaksj";
                        final key = encrypt.Key.fromUtf8(secret +
                            secretAdd.substring(0, 32 - secret.length));
                        final iv = encrypt.IV.fromLength(16);
                        var encrypter = encrypt.Encrypter(encrypt.AES(key));
                        final encrypted = encrypter.encrypt(text, iv: iv);
                        setState(() {
                          encryptedText = encrypted.base64;
                        });
                      } catch (e) {
                        debugPrint("Encryption failed: $e");
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Encryption failed: Invalid input."),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text(
                    "Encrypt Text",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 20),
                SelectableText(
                  encryptedText,
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: encryptedText));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Text copied successfully"),
                      ),
                    );
                  },
                  child: const Center(
                    child: Text(
                      "Copy Encrypted Text",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Decrypt Your Data",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextField(
                  onChanged: (val) {
                    decryptText = val;
                  },
                  decoration: InputDecoration(
                    labelText: "Enter the encrypted text",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  onChanged: (val) {
                    secret1 = val;
                  },
                  decoration: InputDecoration(
                    labelText: "Enter the key to decrypt",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    try {
                      if (secret1.isNotEmpty) {
                        String secretAdd = "sailasdjfklasjdhfljaskldjhflaksj";
                        final key = encrypt.Key.fromUtf8(secret1 +
                            secretAdd.substring(0, 32 - secret1.length));
                        final iv = encrypt.IV.fromLength(16);
                        var encrypter = encrypt.Encrypter(encrypt.AES(key));
                        var decrypted = encrypter.decrypt(
                          encrypt.Encrypted.fromBase64(decryptText),
                          iv: iv,
                        );
                        setState(() {
                          decryptedText = decrypted;
                        });
                      }
                    } catch (e) {
                      debugPrint("Decryption failed: $e");
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              "Decryption failed: Invalid key or ciphertext."),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    "Decrypt Text",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 20),
                SelectableText(
                  decryptedText,
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
      ),
    ];

    final _kTabs = <Tab>[
      const Tab(icon: Icon(Icons.lock), text: 'Encrypt'),
      const Tab(icon: Icon(Icons.lock_open), text: 'Decrypt'),
    ];

    return DefaultTabController(
      length: _kTabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Secure Your Data",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          bottom: TabBar(
            tabs: _kTabs,
            // indicator: BoxDecoration(
            //   color: Colors.yellow,
            //   borderRadius: BorderRadius.circular(10),
            // ),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black,
            labelStyle:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.blueAccent,
        ),
        body: TabBarView(children: _kTabPages),
      ),
    );
  }
}
