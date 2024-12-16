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
                        // Generate key and IV
                        String paddedKey = secret.padRight(32, '0').substring(0, 32);
                        final key = encrypt.Key.fromUtf8(paddedKey);
                        final iv = encrypt.IV.fromLength(16);

                        // Encrypt the text
                        final encrypter = encrypt.Encrypter(encrypt.AES(key));
                        final encrypted = encrypter.encrypt(text, iv: iv);

                        setState(() {
                          encryptedText = "${encrypted.base64}:${iv.base64}";
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
                    labelText: "Enter the encrypted text (format: text:iv)",
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
                      if (secret1.isNotEmpty && decryptText.contains(":")) {
                        // Extract encrypted text and IV
                        final parts = decryptText.split(":");
                        final encryptedBase64 = parts[0];
                        final ivBase64 = parts[1];

                        // Generate key and IV
                        String paddedKey = secret1.padRight(32, '0').substring(0, 32);
                        final key = encrypt.Key.fromUtf8(paddedKey);
                        final iv = encrypt.IV.fromBase64(ivBase64);

                        // Decrypt the text
                        final encrypter = encrypt.Encrypter(encrypt.AES(key));
                        final decrypted = encrypter.decrypt(
                          encrypt.Encrypted.fromBase64(encryptedBase64),
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
                  "Hi, I'm VarunRaj Navuru",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Text(
                  "I developed a Flutter-based AES Encryption and Decryption app as part of my MSc project in university of Greenwich, under the guidance of my supervisor and mentor, Atif Siddiqui.",
                  style: TextStyle(
                            fontSize: 16,
                            // fontWeight: FontWeight.bold
                            ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 20),
                const Text(
                  "The app provides a secure method for encrypting and decrypting text using the AES encryption algorithm. Users can enter a text and a secret key to encrypt the text, which is then displayed in Base64 format. For decryption, users input the encrypted text and the same secret key to retrieve the original message. The app generates a 32-byte encryption key by combining the secret key with a constant string and uses a random Initialization Vector (IV). Key features include clipboard support, feedback notifications, and an intuitive UI. It leverages Flutter's material design package and the encrypt package for AES encryption",
                  style: TextStyle(
                            fontSize: 16,
                            // fontWeight: FontWeight.bold
                            ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Thank you",
                  style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                            ),
                  textAlign: TextAlign.center,
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
      const Tab(icon: Icon(Icons.info_outline), text: 'About'),
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