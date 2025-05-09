import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ayarlar',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.dark(),
        useMaterial3: true,
      ),
      home: AyarlarSayfasi(),
    );
  }
}

class AyarlarSayfasi extends StatefulWidget {
  @override
  _AyarlarSayfasiState createState() => _AyarlarSayfasiState();
}

class _AyarlarSayfasiState extends State<AyarlarSayfasi> {
  bool koytema = true;
  bool bildirimler = true;
  bool sesliUyari = true;
  bool titresim = true;
  String siralama = "Bitiş Tarihine Göre";
  String gorunum = "Liste";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ayarlar"),
        backgroundColor: Colors.grey[900],
      ),
      body: ListView(
        children: [
          _bolumBaslik("Görünüm Ayarları"),
          SwitchListTile(
            title: Text("Koyu Tema", style: TextStyle(color: Colors.white)),
            subtitle: Text("Koyu arka plan, açık yazı", style: TextStyle(color: Colors.grey)),
            value: koytema,
            onChanged: (value) {
              setState(() => koytema = value);
            },
            activeColor: Colors.blue,
          ),
          _bolumBaslik("Bildirim Ayarları"),
          SwitchListTile(
            title: Text("Bildirimler", style: TextStyle(color: Colors.white)),
            subtitle: Text("Tüm bildirimleri aç/kapat", style: TextStyle(color: Colors.grey)),
            value: bildirimler,
            onChanged: (value) {
              setState(() {
                bildirimler = value;
                if (!value) {
                  sesliUyari = false;
                  titresim = false;
                }
              });
            },
            activeColor: Colors.blue,
          ),
          SwitchListTile(
            title: Text("Sesli Uyarı", style: TextStyle(color: Colors.white)),
            value: sesliUyari,
            onChanged: bildirimler
                ? (value) => setState(() => sesliUyari = value ?? false)
                : null,
            activeColor: Colors.blue,
          ),
          SwitchListTile(
            title: Text("Titreşim", style: TextStyle(color: Colors.white)),
            value: titresim,
            onChanged: bildirimler
                ? (value) => setState(() => titresim = value ?? false)
                : null,
            activeColor: Colors.blue,
          ),
          ListTile(
            title: Text("Bildirim Zamanlaması", style: TextStyle(color: Colors.white)),
            subtitle: Text("Sayaç dolmadan önce bildirim süresi", style: TextStyle(color: Colors.grey)),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
            onTap: bildirimler ? () {} : null,
            enabled: bildirimler,
          ),
          _bolumBaslik("Sayaç Görünüm Ayarları"),
          ListTile(
            title: Text("Görünüm Tipi", style: TextStyle(color: Colors.white)),
            subtitle: Text(gorunum, style: TextStyle(color: Colors.grey)),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
            onTap: _gorunumTipiSec,
          ),
          ListTile(
            title: Text("Sıralama", style: TextStyle(color: Colors.white)),
            subtitle: Text(siralama, style: TextStyle(color: Colors.grey)),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
            onTap: _siralamaSec,
          ),
          _bolumBaslik("Veri Yönetimi"),
          ListTile(
            title: Text("Verileri Yedekle", style: TextStyle(color: Colors.white)),
            leading: Icon(Icons.backup, color: Colors.blue),
            onTap: () {},
          ),
          ListTile(
            title: Text("Yedekten Geri Yükle", style: TextStyle(color: Colors.white)),
            leading: Icon(Icons.restore, color: Colors.blue),
            onTap: () {},
          ),
          ListTile(
            title: Text("Tüm Verileri Temizle", style: TextStyle(color: Colors.red)),
            leading: Icon(Icons.delete_forever, color: Colors.red),
            onTap: _veriTemizlemeOnay,
          ),
          _bolumBaslik("Hakkında"),
          ListTile(
            title: Text("Uygulama Sürümü", style: TextStyle(color: Colors.white)),
            subtitle: Text("1.0.0", style: TextStyle(color: Colors.grey)),
          ),
          ListTile(
            title: Text("Geri Bildirim Gönder", style: TextStyle(color: Colors.white)),
            leading: Icon(Icons.feedback, color: Colors.blue),
            onTap: () {},
          ),
          ListTile(
            title: Text("Geliştirici", style: TextStyle(color: Colors.white)),
            subtitle: Text("Eles Dev", style: TextStyle(color: Colors.grey)),
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _bolumBaslik(String baslik) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        baslik,
        style: TextStyle(
          color: Colors.blue,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _siralamaSec() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Sıralama Seç"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _siralamaTile("Bitiş Tarihine Göre"),
            _siralamaTile("İsme Göre (A-Z)"),
            _siralamaTile("Eklenme Tarihine Göre"),
          ],
        ),
      ),
    );
  }

  Widget _siralamaTile(String secenek) {
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
      builder: (_) => AlertDialog(
        title: Text("Görünüm Tipi Seç"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _gorunumTile("Liste"),
            _gorunumTile("Grid"),
            _gorunumTile("Kart"),
          ],
        ),
      ),
    );
  }

  Widget _gorunumTile(String secenek) {
    return ListTile(
      title: Text(secenek),
      onTap: () {
        setState(() => gorunum = secenek);
        Navigator.pop(context);
      },
    );
  }

  void _veriTemizlemeOnay() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
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
              // Veri temizleme işlemi
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
