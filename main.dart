import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Değişiklik 1: Shared Preferences eklendi

// Tema durumu yöneticisi
ValueNotifier<ThemeMode> _themeNotifier = ValueNotifier(ThemeMode.light);

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter binding başlatıldı
  final prefs = await SharedPreferences.getInstance(); // Değişiklik 2: Tercih nesnesi alındı
  final savedTheme = prefs.getString('themeMode') ?? 'light'; // Tercih varsa al, yoksa "light"
  _themeNotifier.value = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light; // Tema uygula
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _themeNotifier,
      builder: (context, ThemeMode currentMode, _) {
        return MaterialApp(
          title: 'Ayarlar',
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            colorScheme: ColorScheme.light(),
            useMaterial3: true,
            primaryColor: Colors.blue,
            appBarTheme: AppBarTheme(
              backgroundColor: const Color.fromARGB(255, 40, 158, 255),
              foregroundColor: Colors.black,
            ),
            textTheme: TextTheme(
              titleLarge: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              bodyMedium: TextStyle(color: Colors.black),
              titleMedium: TextStyle(color: Colors.grey[700]),
            ),
          ),
          darkTheme: ThemeData(
            scaffoldBackgroundColor: Colors.black,
            colorScheme: ColorScheme.dark(),
            useMaterial3: true,
            primaryColor: Colors.blue,
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.grey[900],
              foregroundColor: Colors.white,
            ),
            textTheme: TextTheme(
              titleLarge: TextStyle(
                color: Colors.blue,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              bodyMedium: TextStyle(color: Colors.white),
              titleMedium: TextStyle(color: Colors.grey),
            ),
          ),
          themeMode: currentMode,
          home: AyarlarSayfasi(),
        );
      },
    );
  }
}

class AyarlarSayfasi extends StatefulWidget {
  @override
  _AyarlarSayfasiState createState() => _AyarlarSayfasiState();
}

class _AyarlarSayfasiState extends State<AyarlarSayfasi> {
  bool bildirimler = true;
  bool sesliUyari = true;
  bool titresim = true;
  String siralama = "Bitiş Tarihine Göre";
  String gorunum = "Liste";

  @override
  Widget build(BuildContext context) {
    bool koyuTemaAktifMi = _themeNotifier.value == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(title: Text("Ayarlar")),
      body: ListView(
        children: [
          _bolumBaslik("Görünüm Ayarları"),
          SwitchListTile(
            title: Text("Koyu Tema"),
            subtitle: Text("Koyu arka plan, açık yazı"),
            value: koyuTemaAktifMi,
            onChanged: (bool value) async {
              setState(() {
                _themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
              });

              // Değişiklik 3: Tema tercihini kaydet
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('themeMode', value ? 'dark' : 'light');
            },
            activeColor: Theme.of(context).primaryColor,
          ),
          _bolumBaslik("Bildirim Ayarları"),
          SwitchListTile(
            title: Text("Bildirimler"),
            subtitle: Text("Tüm bildirimleri aç/kapat"),
            value: bildirimler,
            onChanged: (bool value) {
              setState(() {
                bildirimler = value;
                if (!value) {
                  sesliUyari = false;
                  titresim = false;
                }
              });
            },
            activeColor: Theme.of(context).primaryColor,
          ),
          SwitchListTile(
            title: Text("Sesli Uyarı"),
            value: sesliUyari,
            onChanged: bildirimler
                ? (bool? value) {
                    setState(() {
                      sesliUyari = value ?? false;
                    });
                  }
                : null,
            activeColor: Theme.of(context).primaryColor,
          ),
          SwitchListTile(
            title: Text("Titreşim"),
            value: titresim,
            onChanged: bildirimler
                ? (bool? value) {
                    setState(() {
                      titresim = value ?? false;
                    });
                  }
                : null,
            activeColor: Theme.of(context).primaryColor,
          ),
          _bolumBaslik("Sayaç Görünüm Ayarları"),
          ListTile(
            title: Text("Görünüm Tipi"),
            subtitle: Text(gorunum),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: _gorunumTipiSec,
          ),
          ListTile(
            title: Text("Sıralama"),
            subtitle: Text(siralama),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: _siralamaSec,
          ),
          _bolumBaslik("Veri Yönetimi"),
          ListTile(
            title: Text("Tüm Verileri Temizle", style: TextStyle(color: Colors.red)),
            leading: Icon(Icons.delete_forever, color: Colors.red),
            onTap: _veriTemizlemeOnay,
          ),
          _bolumBaslik("Hakkında"),
          ListTile(
            title: Text("Uygulama Sürümü"),
            subtitle: Text("1.0.0"),
            onTap: () => print("Sürüm bilgileri"),
          ),
          ListTile(
            title: Text("Geri Bildirim Gönder"),
            leading: Icon(Icons.feedback, color: Theme.of(context).primaryColor),
            onTap: () => print("Geri bildirim formu"),
          ),
          ListTile(
            title: Text("Geliştirici"),
            subtitle: Text("Muhammet Kırmızıkoç"),
            onTap: () => print("Geliştirici bilgileri"),
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _bolumBaslik(String baslik) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(baslik, style: Theme.of(context).textTheme.titleLarge),
    );
  }

  void _siralamaSec() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Sıralama Seç"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _secenek("Bitiş Tarihine Göre"),
              _secenek("İsme Göre (A-Z)"),
              _secenek("Eklenme Tarihine Göre"),
            ],
          ),
        );
      },
    );
  }

  Widget _secenek(String secenek) {
    return ListTile(
      title: Text(secenek),
      onTap: () {
        setState(() => siralama = secenek);
        Navigator.pop(context);
      },
    );
  }

  void _gorunumTipiSec() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Görünüm Tipi Seç"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _gorunumSec("Liste"),
              _gorunumSec("Grid"),
              _gorunumSec("Kart"),
            ],
          ),
        );
      },
    );
  }

  Widget _gorunumSec(String tip) {
    return ListTile(
      title: Text(tip),
      onTap: () {
        setState(() => gorunum = tip);
        Navigator.pop(context);
      },
    );
  }

  void _veriTemizlemeOnay() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Verileri Temizle"),
          content: Text("Tüm sayaçlar ve ayarlar silinecek. Bu işlem geri alınamaz. Devam etmek istiyor musunuz?"),
          actions: [
            TextButton(
              child: Text("İptal"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text("Temizle", style: TextStyle(color: Colors.red)),
              onPressed: () {
                print("Veriler temizlendi");
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
