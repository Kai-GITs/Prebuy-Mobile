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