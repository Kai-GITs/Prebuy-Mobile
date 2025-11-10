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