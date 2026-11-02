# Arrow Out — Firebase Analytics

Android paket adı: `com.arusoft.arrowout`. Firebase proje kimliği: `arusoft-arrow-out`. Görünen ad: Arrow Out.

`google-services.json` yokken oyun açılır. Analytics sessizce kapalı kalır. Sahte dosya yazılmaz.

Ekranlar `FirebaseAnalytics` çağırmaz. Olaylar `lib/analytics/analytics_service.dart` üzerinden gider.

Otomatik GA4 olayları (`first_open`, `session_start`, `user_engagement` …) ayrıca gelir. Aşağıya yazılmaz. `screen_view` gönderilmez; ekran için `screen_open` kullanılır.

---

## 1. Konsolda bir kez yapılacaklar

### 1.1 Proje ve Android uygulaması

1. [Firebase Console](https://console.firebase.google.com/) → **Add project**.
2. Proje kimliği: `arusoft-arrow-out`. Görünen ad: `Arrow Out`.
3. Google Analytics’i aç ve bir GA4 property bağla.
4. **Add app → Android**. Paket adı: `com.arusoft.arrowout`.
5. İndirilen `google-services.json` dosyasını `android/app/` altına koy. Gradle eklentisi dosya varsa uygulanır.

### 1.2 Özel tanımlar

Firebase Console → **Analytics → Custom definitions → Create custom definition**.

DebugView kayıtsız parametreyi de gösterir. Standart raporlar ve keşifler için aşağıdaki kayıtlar gerekir. Adlar kodla birebir aynıdır.

**Event-scoped custom dimensions**

| Parametre | Açıklama | Örnek |
|---|---|---|
| `screen` | Açılan ekran | `home`, `play`, `settings`, `how_to_play` |
| `result` | Seviye sonucu | `clear`, `fail` |
| `from` | Bitmeden çıkışın yeri | `home`, `restart` |
| `source` | Ayarlar veya nasıl oynanırın açıldığı yer | `home`, `settings`, `play`, `first_run` |
| `setting` | Değişen ayar | `language`, `sound`, `haptics`, `reduce_motion` |
| `setting_value` | Ayarın yeni değeri | `tr`, `system`, `on`, `off` |

`value` kullanılmaz. GA4 bu adı etkinlik değeri (para) sanır ve metin gelince düşürür.

**Event-scoped custom metrics** (birim: Standard)

| Parametre | Açıklama |
|---|---|
| `level` | 1’den başlayan seviye numarası |
| `duration_sec` | Seviyenin saniye cinsinden süresi |
| `hearts_left` | Bitişte veya çıkışta kalan can (0–3) |
| `hints_used` | O denemede kullanılan ipucu (0–3) |
| `open_count` | Bu kurulumda kaçıncı açılış |

**User-scoped custom dimension**

| User property | Açıklama |
|---|---|
| `device_id` | Kurulumda üretilen anonim kimlik (36 karakter). Kişisel veri değil. |

Kod bunu `setUserProperty` ile yazar. Ayrı bir kullanıcı özelliği daha yok.

### 1.3 DebugView

```bash
adb shell setprop debug.firebase.analytics.app com.arusoft.arrowout
```

Kapatmak:

```bash
adb shell setprop debug.firebase.analytics.app .none.
```

Uygulamayı USB ile çalıştır. Firebase Console → **Analytics → DebugView**. Olaylar birkaç saniye içinde düşer.

```bash
adb shell setprop log.tag.FA VERBOSE
adb shell setprop log.tag.FA-SVC VERBOSE
adb logcat -v time -s FA FA-SVC
```

---

## 2. Olay kataloğu

Dokunuş, kare ve kaydırma başına olay yok.

| Olay | Ne zaman | Parametreler |
|---|---|---|
| `app_open` | Süreç açılışı, Analytics bağlandıktan sonra bir kez | `device_id`, `open_count` |
| `screen_open` | Home, oyun, ayarlar veya nasıl oynanır açılınca | `screen` |
| `play_tap` | Ana ekranda Oyna | `level` |
| `level_start` | Seviye denemesi başlayınca (ilk giriş, sonraki, yeniden dene, baştan) | `level` |
| `level_end` | Tahta temizlenince veya can bitince | `level`, `result`, `duration_sec`, `hearts_left`, `hints_used` |
| `level_quit` | Deneme bitmeden ana sayfaya dönünce veya baştan deyince | `level`, `duration_sec`, `hearts_left`, `from` |
| `settings_open` | Ayarlar açılınca | `source` |
| `how_to_play_open` | Nasıl oynanır açılınca | `source` |
| `settings_change` | Dil, ses, titreşim veya hareket değişince | `setting`, `setting_value` |

`result`: `clear` tahta bitti, `fail` can bitti.

`from`: `home` ana sayfa, `restart` duraklatmadaki baştan.

`source`: `home`, `settings`, `play` (duraklatma menüsü), `first_run` (ilk açılış dersi).

`setting` / `setting_value`:

| setting | setting_value |
|---|---|
| `language` | `en` `es` `pt` `zh` `ja` `de` `fr` `ko` `it` `tr` veya `system` |
| `sound` | `on` / `off` |
| `haptics` | `on` / `off` |
| `reduce_motion` | `system` / `on` / `off` |

Can bittikten sonraki “yeniden dene” yeni bir `level_start` açar; `level_quit` gitmez. Temizlenen seviyeden ana sayfaya dönüş de `level_quit` değildir.

---

## 3. Konsolda bakılacak huniler

Kayıtlı tanımlar geldikten sonra **Explore → Funnel**:

1. Açılış: `app_open` → `how_to_play_open` (`source` = `first_run`) → `play_tap` → `level_start` (`level` = 1).
2. Seviye: `level_start` → `level_end`, kırılım `result`. `level` ile seviye seviye clear oranı.
3. Bırakma: `level_start` olup `level_end` olmayanlar, `level_quit` ve `from`.
