# iOS Uygulaması Yükleme Rehberi (Windows)

Mac bilgisayarınız olmadığı için, GitHub üzerinde oluşturduğumuz `.ipa` dosyasını telefonunuza "Sideload" yöntemiyle yükleyeceğiz.

## Gerekli Araçlar
Aşağıdakilerden **birini** bilgisayarınıza kurun:

1.  **Sideloadly (Önerilen - Daha Kolay)**: [sideloadly.io](https://sideloadly.io/)
2.  **AltStore**: [altstore.io](https://altstore.io/)

*Not: Bilgisayarınızda iTunes ve iCloud (Microsoft Store versiyonu DEĞİL, web sitesinden indirilen versiyonu) kurulu olmalıdır.*

## Adım Adım Yükleme (Sideloadly ile)

1.  **IPA Dosyasını İndirin:**
    *   GitHub'da **Actions** sekmesine gidin.
    *   Son başarılı (yeşil) "Build iOS App" işleminin içine girin.
    *   En altta **Artifacts** kısmında `SpamOnleyici-IPA` dosyasını bulun ve indirin.
    *   İnen `.zip` dosyasını açın, içinden `SpamOnleyici.ipa` çıkacak.

2.  **Telefonu Bağlayın:**
    *   iPhone'unuzu kabloyla bilgisayara bağlayın.
    *   Telefonda "Bu bilgisayara güven" uyarısı çıkarsa **Güven** deyin.

3.  **Sideloadly'i Açın:**
    *   **iDevice:** kısmında telefonunuzun göründüğünden emin olun.
    *   **IPA:** kısmına indirdiğiniz `SpamOnleyici.ipa` dosyasını sürükleyip bırakın.
    *   **Apple ID:** kısmına kendi Apple ID'nizi yazın.

4.  **Başlatın:**
    *   **Start** butonuna basın.
    *   Sizden Apple ID şifrenizi isteyecektir. (Bu işlem güvenlidir, Sideloadly sunucularına değil Apple sunucularına gönderilir).
    *   İşlem bitince telefonda uygulama belirecek.

5.  **Güven Ayarı (Telefonda):**
    *   Uygulamayı açmaya çalışırsanız "Güvenilmeyen Geliştirici" hatası verir.
    *   Telefonda **Ayarlar > Genel > VPN ve Cihaz Yönetimi** kısmına gidin.
    *   Kendi mail adresinize tıklayıp **"Güven"** deyin.

6.  **Kullanıma Hazır!**
    *   Artık uygulamayı açabilirsiniz.
    *   **Önemli:** Ayarlar > Mesajlar > Bilinmeyen ve İstenmeyen kısmından **SpamÖnleyici**'yi aktif etmeyi unutmayın.
