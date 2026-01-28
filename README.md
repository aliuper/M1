# Merdiven Takip Sistemi

Merdiven üretiminde kullanılan malzemeleri takip eden ve barkod ile hızlı erişim sağlayan Android uygulaması.

## 📱 Özellikler

### Ana Özellikler
- **🔍 Barkod Tarama**: Merdiven barkodunu okutarak gerekli malzemeleri anında görüntüleyin
- **🪜 Merdiven Modelleri**: Merdiven modellerini ekleyin, düzenleyin ve yönetin
- **📦 Malzeme Listesi**: Tüm malzemeleri fotoğraflı olarak kaydedin

### Detaylı Özellikler
- Malzeme ekleme (isim, açıklama, fotoğraf)
- Merdiven modeli ekleme (isim, barkod, açıklama, kullanılan malzemeler)
- Barkod tarama ile hızlı merdiven bulma
- Malzeme miktarı belirleme
- Veri kayıt yolu seçimi
- Modern ve kullanıcı dostu arayüz

## 🚀 Kurulum

### GitHub Actions ile APK Alma

1. Bu repository'yi fork edin
2. "Actions" sekmesine gidin
3. "Build Android APK" workflow'unu çalıştırın
4. Build tamamlandığında "Artifacts" bölümünden APK'yı indirin

### Yerel Geliştirme

```bash
# Repository'yi klonlayın
git clone https://github.com/[username]/merdiven.git
cd merdiven

# Bağımlılıkları yükleyin
flutter pub get

# Debug APK oluşturun
flutter build apk --debug

# Release APK oluşturun
flutter build apk --release
```

## 📋 Gereksinimler

- Flutter 3.16.0+
- Android SDK 21+
- Java 17+

## 🛠️ Teknolojiler

- **Framework**: Flutter
- **State Management**: Provider
- **Barkod Tarama**: mobile_scanner
- **Görsel Seçimi**: image_picker
- **Veri Depolama**: shared_preferences
- **UI**: Material Design 3, Google Fonts

## 📱 Ekran Görüntüleri

| Ana Sayfa | Barkod Tarama | Malzeme Listesi |
|-----------|---------------|-----------------|
| Modern ana sayfa | Kamera ile barkod okutma | Fotoğraflı malzeme listesi |

## 📁 Proje Yapısı

```
lib/
├── main.dart                    # Uygulama giriş noktası
├── models/
│   ├── material_item.dart       # Malzeme modeli
│   └── stair_model.dart         # Merdiven modeli
├── providers/
│   ├── material_provider.dart   # Malzeme state yönetimi
│   ├── stair_provider.dart      # Merdiven state yönetimi
│   └── settings_provider.dart   # Ayarlar state yönetimi
└── screens/
    ├── home_screen.dart         # Ana sayfa
    ├── material_list_screen.dart
    ├── add_material_screen.dart
    ├── material_detail_screen.dart
    ├── stair_list_screen.dart
    ├── add_stair_screen.dart
    ├── stair_detail_screen.dart
    ├── barcode_scanner_screen.dart
    └── settings_screen.dart
```

## 🔧 Kullanım

1. **Malzeme Ekle**: Ana sayfa → Malzeme Listesi → + butonu
2. **Merdiven Ekle**: Ana sayfa → Merdiven Modelleri → + butonu → Malzemeleri seç
3. **Barkod Tara**: Ana sayfa → Barkod Tara → Kamera ile barkod okut

## 📄 Lisans

Bu proje MIT lisansı altında lisanslanmıştır.

## 🤝 Katkıda Bulunma

1. Fork yapın
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Değişikliklerinizi commit edin (`git commit -m 'Add amazing feature'`)
4. Branch'e push edin (`git push origin feature/amazing-feature`)
5. Pull Request açın
