Tugas 9

 1. Jelaskan mengapa kita perlu membuat model Dart saat mengambil/mengirim data JSON? Apa konsekuensinya jika langsung memetakan Map<String, dynamic> tanpa model (terkait validasi tipe, null-safety, maintainability)?
 2. Apa fungsi package http dan CookieRequest dalam tugas ini? Jelaskan perbedaan peran http vs CookieRequest.
 3. Jelaskan mengapa instance CookieRequest perlu untuk dibagikan ke semua komponen di aplikasi Flutter.
 4. Jelaskan konfigurasi konektivitas yang diperlukan agar Flutter dapat berkomunikasi dengan Django. Mengapa kita perlu menambahkan 10.0.2.2 pada ALLOWED_HOSTS, mengaktifkan CORS dan pengaturan SameSite/cookie, dan menambahkan izin akses internet di Android? Apa yang akan terjadi jika konfigurasi tersebut tidak dilakukan dengan benar?
 5. Jelaskan mekanisme pengiriman data mulai dari input hingga dapat ditampilkan pada Flutter.
 6. Jelaskan mekanisme autentikasi dari login, register, hingga logout. Mulai dari input data akun pada Flutter ke Django hingga selesainya proses autentikasi oleh Django dan tampilnya menu pada Flutter.
 7. Jelaskan bagaimana cara kamu mengimplementasikan checklist di atas secara step-by-step! (bukan hanya sekadar mengikuti tutorial).

 Ans:
 1. Dengan model Dart (misalnya NewsEntry), setiap field punya tipe yang jelas (String, int, bool, DateTime?, dll). Jika struktur JSON berubah atau ada field yang hilang, error akan muncul saat parsing atau saat compile/analysis, bukan tiba‑tiba runtime NoSuchMethodError karena salah akses key di Map. Null‑safety juga lebih terkontrol: kita bisa bedakan mana field wajib (required) dan mana yang opsional (String? thumbnail). Kalau semuanya Map<String,dynamic>, logika parsing, konversi tipe, dan pengecekan null sering tersebar di banyak tempat dan rawan bug.
 2. http
 - Package umum untuk melakukan GET, POST, dan HTTP request lain.
 - Bersifat stateless: setiap request berdiri sendiri, tidak otomatis menyimpan/menyertakan cookie atau session.
 - Cocok untuk endpoint publik atau resource yang tidak butuh autentikasi (misalnya fetch gambar, API eksternal lain).
 CookieRequest (dari pbp_django_auth)
 - Dibuat khusus untuk integrasi Flutter–Django.
 - Menangani session + cookie: saat login ke Django, CookieRequest menyimpan cookie (sessionid, csrftoken, dll), lalu otomatis menyertakannya di setiap request berikutnya.
 - Menyediakan helper seperti login, logout, get, postJson yang sudah di‑wrap supaya kompatibel dengan CSRF dan autentikasi Django.
 3. Kalau setiap widget membuat instance CookieRequest sendiri, masing‑masing tidak berbagi cookie, sehingga:
 - Halaman A sudah login tapi halaman B bisa belum login.
 - Cookie bisa tidak konsisten, dan request ke endpoint yang butuh autentikasi akan gagal.
 Dengan Provider<CookieRequest> di MyApp, semua widget memakai instance yang sama:
 - Setelah login sekali, semua halaman yang memanggil request.get(...) atau request.postJson(...) otomatis memakai session yang sama.
 - Saat logout, cukup panggil request.logout(...) dari mana pun; seluruh aplikasi otomatis keluar karena instance menghapus cookie yang sama.
 4. Di emulator Android, localhost komputer host direpresentasikan sebagai 10.0.2.2. Kalau tidak ditambahkan, Django akan me‑reject request dengan error “Invalid HTTP_HOST header” dan Flutter akan dapat error jaringan. Tanpa android.permission.INTERNET, aplikasi di emulator/device tidak bisa mengakses jaringan. Akibatnya, setiap http atau CookieRequest akan gagal dengan error koneksi (tidak bisa reach Django).
 5. Pengguna mengisi form di Flutter, lalu Form dan TextFormField memvalidasi input. Jika valid, Flutter membungkus data ke JSON dan mengirimkannya ke Django dengan request.postJson(...) (atau http.post). View Django membaca request.body, parse JSON, memvalidasi, lalu menyimpan ke database sebagai objek model. Untuk menampilkan, Flutter memanggil endpoint list (request.get(...)), menerima JSON, mengubahnya jadi list model Dart, lalu ListView.builder atau screen detail merender data tersebut di UI.
 6. Register: Flutter kirim username + password ke /auth/register/ via request.postJson, Django memakai UserCreationForm untuk validasi, membuat user baru jika valid, lalu kirim JSON status balik. Flutter tampilkan pesan dan kembali ke halaman login.
 Login: Flutter kirim username dan password ke /auth/login/ via request.login, Django authenticate + auth_login, set cookie session di response, CookieRequest menyimpan cookie ini dan menandai status login, lalu Flutter menavigasi ke MyHomePage.
 Logout: Flutter memanggil request.logout('/auth/logout/'), Django auth_logout, session dihapus dan mengirim JSON status. CookieRequest membuang cookie lokal, Flutter menampilkan pesan lalu mengarahkan user kembali ke halaman login.
 7. 
 - Tambahkan domain PBP dan 10.0.2.2 ke ALLOWED_HOSTS
 - Tambahkan django-cors-headers ke requirements.txt, aktifkan di INSTALLED_APPS dan MIDDLEWARE, serta atur CORS_ALLOW_ALL_ORIGINS, CORS_ALLOW_CREDENTIALS, dan konfigurasi cookie.
 - Tambah app authentication dengan view login, register, logout dan include auth/ di PreBuy/urls.py.
 - Jalankan migrasi django
 - Susun model News dengan field name, price, description, thumbnail, category, is_featured, news_views, created_at, dan relasi user.
 - migrate
 - buat view show_json untuk semua item dan show_json_by_id untuk detail satu item.
 - tambahkan show_user_json yang memfilter News dengan user=request.user sehingga hanya item milik user login yang dikirim ke Flutter.
 - Tambah create_news_flutter untuk menerima JSON dari Flutter dan membuat News baru.
 - update route di main/urls.py
 - Tambahkan file lib/models/news_entry.dart yang dihasilkan berdasarkan struktur JSON
 - Menambahkan dependency provider, pbp_django_auth, dan http di pubspec.yaml.
 - Buat file lib/utils/constants.dart untuk menyatukan baseUrl dan endpoint‑endpoint Django.
 - Ubah main.dart agar membungkus app dengan Provider<CookieRequest> dan menjadikan LoginPage sebagai home awal
 - Implementasikan LoginPage dengan form, validasi, dan pemanggilan request.login(loginUrl, ...). Jika sukses, navigasi ke MyHomePage.
 - Implementasikan RegisterPage yang memanggil request.postJson(registerUrl, ...) dan kembali ke login jika berhasil.
 - Tambahkan tombol Logout di LeftDrawer yang memanggil request.logout(logoutUrl) dan kembali ke LoginPage.
 - Di NewsEntryListPage, gunakan request.get(newsListUrl) untuk mengambil list item milik user login, lalu parse menjadi list NewsEntry.
 - Tampilkan list dengan ListView.separated, setiap item berupa ListTile/card yang menampilkan name, price, description, thumbnail, category, dan is_featured.
 - Tambahkan navigasi ke NewsDetailPage ketika card ditekan.
 - Di NewsListFormPage, buat form dengan beberapa TextFormField, DropdownButtonFormField, dan SwitchListTile untuk field model News.
 - Tangani respon: jika status == 'success', menampilkan SnackBar dan kembali ke MyHomePage. Jika gagal, menampilkan pesan error dari backend.




Tugas 8

 1. Jelaskan perbedaan antara Navigator.push() dan Navigator.pushReplacement() pada Flutter. Dalam kasus apa sebaiknya masing-masing digunakan pada aplikasi Football Shop kamu?

 2. Bagaimana kamu memanfaatkan hierarchy widget seperti Scaffold, AppBar, dan Drawer untuk membangun struktur halaman yang konsisten di seluruh aplikasi?

 3. Dalam konteks desain antarmuka, apa kelebihan menggunakan layout widget seperti Padding, SingleChildScrollView, dan ListView saat menampilkan elemen-elemen form? Berikan contoh penggunaannya dari aplikasi kamu.

 4. Bagaimana kamu menyesuaikan warna tema agar aplikasi Football Shop memiliki identitas visual yang konsisten dengan brand toko?

Ans:
1. Navigator.push():
    - Menambahkan halaman baru di atas stack navigasi
    - Halaman sebelumnya tetap ada di memori (di bawah halaman baru)
    - User dapat kembali ke halaman sebelumnya dengan tombol back
    - Cocok untuk navigasi sementara atau alur yang perlu kembali
    Kasus: Digunakan saat user tap grid menu agar user dapat kembali ke home setelah menambah produk atau melihat list.

    Navigator.pushReplacement():
    - Mengganti halaman saat ini dengan halaman baru di stack navigasi
    - Halaman sebelumnya dihapus dari stack
    - User tidak dapat kembali ke halaman sebelumnya dengan tombol back
    - Cocok untuk navigasi permanen atau saat tidak ingin user kembali
    Kasus: Digunakan di drawer karena saat berpindah antar menu utama (Home, Create Products, All Products), kita tidak ingin stack navigasi menumpuk. User tetap bisa akses menu lain melalui drawer tanpa harus back berkali-kali.

2. Scaffold - Foundation setiap halaman:
    - Menyediakan struktur dasar Material Design
    - Menampung AppBar, Drawer, dan Body
    Contoh pada code: 
    return Scaffold(
    // AppBar adalah bagian atas halaman yang menampilkan judul.
    appBar: AppBar(
      title: const Text(
        'Football News',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
    ),
    // Tambahkan drawer di sisi kiri untuk navigasi cepat.
    drawer: const LeftDrawer(),
   ...
    )

    AppBar - Header utama:
    - Setiap halaman punya AppBar dengan style yang sama (teks putih, bold, warna primary theme)
    - Memberikan konteks lokasi user di aplikasi
    Pada code:
    appBar: AppBar(
        title: const Text(
            'Add Product',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
    )

    Drawer - Navigasi global:
    - Digunakan di semua halaman utama
    - Memberikan akses cepat ke: Home, Create Products, All Products
    Pada code:
    drawer: const LeftDrawer(),

 3. Padding:
    - Mencegah elemen form menempel ke tepi layar
    - Membuat tampilan lebih rapi dan nyaman dibaca
    - Konsisten spacing di semua sisi (misal, 16px)
    Code:
    body: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(...),
    )

    SingleChildScrollView:
    - Konten dialog bisa scroll jika terlalu panjang
    - Mencegah overflow di layar kecil
    - Fleksibel untuk konten dengan panjang
    Code:
    content: SingleChildScrollView(
    child: ListBody(
        children: [
        Text('Name: ${product.name}'),
        Text('Price: ${product.price}'),
        // ... data produk lainnya
        ],
    ),
    )

    ListView:
    - Otomatis scrollable saat konten melebihi tinggi layar
    - Menghindari overflow error saat keyboard muncul
    - User bisa akses semua field form meski layar kecil
    Code:
    body: Form(
    key: _formKey,
    child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
        TextFormField(...),
        const SizedBox(height: 12),
        TextFormField(...),
        // ... banyak field lainnya
        ],
    ),
    )

 4. Cara agar tema Football Shop konsisten:
    Atur tema utama di MaterialApp:
    Misalnya di main.dart:
        theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        );

    Terapkan warna ini secara konsisten:
        AppBar - backgroundColor: Theme.of(context).colorScheme.primary, Drawer, Tombol utama (FilledButton, ikon penting) dengan colorScheme.primary.
    Selalu ambil dari Theme.of(context).

Tugas 7
 
 1. Jelaskan apa itu widget tree pada Flutter dan bagaimana hubungan parent-child (induk-anak) bekerja antar widget.
 2. Sebutkan semua widget yang kamu gunakan dalam proyek ini dan jelaskan fungsinya.
 3. Apa fungsi dari widget MaterialApp? Jelaskan mengapa widget ini sering digunakan sebagai widget root.
 4. Jelaskan perbedaan antara StatelessWidget dan StatefulWidget. Kapan kamu memilih salah satunya?
 5. Apa itu BuildContext dan mengapa penting di Flutter? Bagaimana penggunaannya di metode build?
 6. Jelaskan konsep "hot reload" di Flutter dan bagaimana bedanya dengan "hot restart".

 Ans:
 1. Widget tree adalah pohon yang berisi semua widget di layar. Setiap widget memiliki parent dan bisa mempunyai child. Parent mengatur tata letak dan konteks dan child menampilkan konten.

 2. MaterialAPP: Membungkus navigator, theme, routes, dan localization.
  ThemeData dan ColorScheme: Menentukan tema dan warna apps.
  Scaffold: Kerangka halaman material
  Appbar: Bar atas
  Padding: jarak tepi halaman
  Column: Menyusun vertikal konten
  Row: Menyusun horizontal konten
  SizedBox: Mengatus ukuran tetap dengan spasi kosong
  Center: Memusatkan konten
  GridView.count: Grid dengan jumlah kolom tetap
  Material: Latar dan radius sudut material
  InkWell: deteksi tap dan ripple untuk SnackBar
  Container: Padding
  Icon: Menampilkan icon konten
  Text: Text

  3. Menyediakan material design. Digunakan untuk root kareta banyak widget, contohnya Scaffold yang butuh context material. Sehingga, saat diletakkan di root, seluruh subtree mempunyai akses ke tema, navigator, dan default material.

  4. StatelessWidget
  Tidak punya state internal yang berubah seiring waktu.
  UI murni dari input & InheritedWidget (mis. Theme.of).
  Dipilih saat tampilan tidak bergantung pada perubahan variabel internal.
  
  StatefulWidget
  Punya objek State yang bisa berubah (counter, form input, animasi).
  Memanggil setState() untuk trigger rebuild.
  Dipilih saat ada interaksi/animasi/data async, toggle, dsb.

  5. BuildContext adalah pointer ke posisi widget di widget tree. Penting karena dipakai untuk mengakses suatu widget di tree.
  Di metode build, parameter BuildContext memberi tahu posisi widget di dalam widget tree.
  Dari context itu, user bisa mengambil data pewarisan seperti Theme, MediaQuery, Navigator, dan ScaffoldMessenger.
  Contohnya di kode: Theme.of(context).colorScheme.primary untuk warna AppBar, MediaQuery.of(context).size.width untuk lebar kartu, dan ScaffoldMessenger.of(context).showSnackBar(...) untuk menampilkan pesan.
  Pastikan context yang dipakai berada di bawah widget yang ingin diakses.

  6. Hot reload: Menyuntikkan perubahan kode ke Dart VM tanpa mengulang aplikasi.
  Hot restart: Mengulang dari main(), recreate seluruh widget tree sehingga semua state hilang.