# Dokumentasi API Qrion

Dokumen ini menyediakan panduan lengkap untuk menggunakan API Qrion, yang dirancang untuk Single Sign-On (SSO) dan berbagai modul terkait lainnya. Dokumentasi ini mencakup detail _endpoint_, metode HTTP, parameter yang diperlukan, contoh _body request_ dan _response_, serta informasi otorisasi.

**Penting:**

- Untuk _endpoint_ yang menerima data **selain file**, semua contoh _body request_ akan menggunakan format **JSON** (`Content-Type: application/json`).
- Untuk _endpoint_ yang **melibatkan pengiriman file**, format yang digunakan adalah **`multipart/form-data`**. Dalam kasus ini, parameter akan dijelaskan dalam bentuk tabel karena `multipart/form-data` secara teknis tidak memiliki struktur JSON untuk _body_ utamanya, melainkan kumpulan bagian dengan `key-value` yang berbeda.

## URL Dasar (Base URLs)

API ini menggunakan URL dasar yang berbeda untuk lingkungan pengembangan dan produksi. Pastikan Anda mengonfigurasi variabel lingkungan di Docusaurus atau Postman Anda (`{{dev-url}}` dan `{{prod-url}}`) agar sesuai.

- **URL Dasar Pengembangan:** `{{dev-url}}` (Contoh: `http://localhost:3001` atau `http://localhost:3003`)
- **URL Dasar Produksi:** `{{prod-url}}`

## Konsep Penting

- **Token Akses (Access Token):** Sebagian besar _endpoint_ yang memerlukan otentikasi akan membutuhkan token akses. Token ini diperoleh setelah berhasil login dan harus disertakan dalam _header_ `Authorization` dengan format `Bearer <YOUR_ACCESS_TOKEN>`.
- **UUID (Universally Unique Identifier):** Banyak sumber daya di API ini diidentifikasi menggunakan UUID, yaitu string unik yang tidak berulang (contoh: `bfbc36df-1bd6-4f80-9fa0-fa71900f8b59`).
- **Content-Type:** Selalu sertakan _header_ `Content-Type` yang sesuai dengan format _body request_ Anda (`application/json` atau `multipart/form-data`).

---

## Modul SSO (Single Sign-On)

Modul SSO bertanggung jawab atas semua fungsionalitas otentikasi, otorisasi, dan manajemen pengguna dalam sistem Qrion.

### 1. Autentikasi & Pengguna (Auth & User)

Bagian ini mencakup _endpoint_ untuk pendaftaran pengguna, login, pembaruan data pengguna, manajemen sesi, dan verifikasi token.

#### 1.1. Pendaftaran Pengguna Baru (`/auth/register`)

Membuat akun pengguna baru dalam sistem Qrion. Endpoint ini **wajib** menggunakan `multipart/form-data` karena mendukung pengunggahan file (avatar dan cover).

- **URL:** `http://localhost:3001/auth/register`
- **Metode:** `POST`
- **Content-Type:** `multipart/form-data`

**Parameter (Form Data):**

| Kunci         | Tipe     | Contoh Nilai                 | Deskripsi                                        |
| :------------ | :------- | :--------------------------- | :----------------------------------------------- |
| `first_name`  | Text     | `pcpexpress`                 | Nama depan pengguna.                             |
| `last_name`   | Text     | ` `                          | Nama belakang pengguna (opsional, bisa kosong).  |
| `username`    | Text     | `pcpexpress`                 | Nama pengguna unik untuk login.                  |
| `email`       | Text     | `egooktafanda1097@gmail.com` | Alamat email pengguna.                           |
| `password`    | Text     | `password@pcp`               | Kata sandi untuk akun pengguna.                  |
| `avatar`      | **File** | (File gambar)                | Gambar profil pengguna (opsional).               |
| `cover`       | **File** | (File gambar)                | Gambar sampul pengguna (opsional).               |
| `user_istype` | Text     | `COMPANY_ADMIN`              | Tipe pengguna (contoh: `COMPANY_ADMIN`, `USER`). |

#### 1.2. Login Pengguna (`/auth`)

Melakukan otentikasi pengguna dan mengembalikan token akses yang diperlukan untuk permintaan API selanjutnya.

- **URL:** `{{dev-url}}/auth`
- **Metode:** `POST`
- **Content-Type:** `application/json`

**Contoh Body Request (JSON):**

```json
{
  "username": "super_admin",
  "password": "qrion@password"
}
```

**Contoh Response Sukses (Status: `200 OK`) untuk Login:**

```json
{
  "statusCode": 200,
  "message": "Login berhasil!",
  "data": {
    "user": {
      "id": 1,
      "uuid": "836e1471-a5ad-471a-b800-df1b3c518bab",
      "name": "Super",
      "username": "super_adminX",
      "email": "super_admin@qrion.com",
      "avatar": null,
      "cover": null,
      "role": {
        "id": 1,
        "name": "SUPER-ADMIN",
        "uuid": "SUPER-ADMIN",
        "description": "Administrator"
      },
      "institution_id": null,
      "user_isType": "SUPER-ADMIN",
      "institution": {}
    },
    "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vbG9jYWxob3N0OjMwMDMvYXV0aC9sb2dpbiIsImlhdCI6MTcyMDY3MTMwMSwiZXhwIjoxNzIwNjcxNDYxLCJuYmYiOjE3MjA2NzEzMDEsImp0aSI6ImFZM0d2b1JzMW1kYjQxOWQxMDZmOWY4NiIsInN1YiI6MSwicHJ2IjoiMjNiZDVjYmQwMDViYjBhZGY5MGU1YTczNjJkNzIwODc5MjM0MWRiYiJ9.eNZW7F6M4WeUdB8P5TszUkXvQ0Q1GqzGrz_jDkLXmPL-T01b3CFCzf02JO5jM9c-MUT5P08dGNTqpCT1JyIeHM_HdJROgEdN6Z30E1XwK0I_sf2oaIT1vT8D4a56hAITX1DkY9YU5d8N0_AUM_U9p_jtPl23IIDd67gN7g7nCvak_jPWhyK24f-K1i1C08HtCpDHk30534iA4BhRyITAqBSk2BeNk1XqTKrOPPE8EOByrLcjAg1gxIE1Wnnt-Xp4jDcPQ4RJK7U5APcJuBG0PBFgcWs"
  }
}
```

#### 1.3. Memperbarui Data Pengguna (`/auth/<user_uuid>`)

Memungkinkan pembaruan informasi pengguna yang sudah ada. Membutuhkan otorisasi dengan token akses. Endpoint ini **wajib** menggunakan `multipart/form-data` karena mendukung pengunggahan file (avatar dan cover).

- **URL:** `{{dev-url}}/auth/<user_uuid>` (Ganti `<user_uuid>` dengan UUID pengguna yang ingin diperbarui, contoh: `{{dev-url}}/auth/409a427e-421a-4c7e-ab78-585cc46305e2`)
- **Metode:** `POST`
- **Otorisasi:** `Bearer <ACCESS_TOKEN>`
- **Content-Type:** `multipart/form-data`

**Parameter (Form Data):**

| Kunci        | Tipe     | Contoh Nilai                 | Deskripsi                                                                     |
| :----------- | :------- | :--------------------------- | :---------------------------------------------------------------------------- |
| `first_name` | Text     | `pcpexpress`                 | Nama depan yang diperbarui.                                                   |
| `last_name`  | Text     | `x`                          | Nama belakang yang diperbarui.                                                |
| `username`   | Text     | `pcpexpress`                 | Nama pengguna (biasanya tidak diubah di sini, bisa dinonaktifkan di Postman). |
| `email`      | Text     | `egooktafanda1097@gmail.com` | Email pengguna (biasanya tidak diubah di sini).                               |
| `password`   | Text     | `password@pcp`               | Kata sandi baru (opsional, jika ingin mengganti).                             |
| `avatar`     | **File** | (File gambar)                | Gambar avatar baru (opsional).                                                |
| `cover`      | **File** | (File gambar)                | Gambar sampul baru (opsional).                                                |
| `isactive`   | Text     | `true`                       | Status akun pengguna (`true` atau `false`).                                   |

#### 1.4. Mendapatkan Informasi Pengguna Saat Ini (`/auth/me`)

Mengambil detail profil pengguna yang sedang login berdasarkan token akses yang diberikan.

- **URL:** `{{dev-url}}/auth/me`
- **Metode:** `GET`
- **Otorisasi:** `Bearer <ACCESS_TOKEN>`
- **Parameter Query:** Tidak ada.

#### 1.5. Logout Pengguna (`/auth/logout`)

Mengakhiri sesi pengguna yang aktif dan membatalkan token akses mereka.

- **URL:** `{{dev-url}}/auth/logout`
- **Metode:** `GET`
- **Otorisasi:** `Bearer <ACCESS_TOKEN>` (Disarankan untuk mengidentifikasi sesi yang akan di-_logout_)
- **Parameter Query:** Tidak ada.

#### 1.6. Lupa Kata Sandi (`/auth/forgot-password`)

Memulai proses pemulihan kata sandi. Sistem akan mengirimkan instruksi atau kode OTP ke alamat email yang terdaftar.

- **URL:** `{{dev-url}}/auth/forgot-password`
- **Metode:** `POST`
- **Content-Type:** `application/json`

**Contoh Body Request (JSON):**

```json
{
  "email": "user@example.com"
}
```

#### 1.7. Reset Kata Sandi (`/auth/forgot-password`)

Menetapkan kata sandi baru menggunakan informasi yang dikirimkan (email, OTP, newPassword).

- **URL:** `{{dev-url}}/auth/forgot-password`
- **Metode:** `POST` (Sesuai rekomendasi, Postman Collection Anda menunjukkan `GET` namun ini lebih tepat `POST`.)
- **Content-Type:** `application/json`

**Contoh Body Request (JSON):**

```json
{
  "newPassword": "newStrongPassword",
  "email": "user@example.com",
  "otp": "123456"
}
```

#### 1.8. Verifikasi Token (`/auth/verify-token`)

Memeriksa validitas dan integritas token otentikasi.

- **URL:** `{{prod-url}}/auth/verify-token`
- **Metode:** `POST`
- **Otorisasi:** `Bearer <TOKEN_YANG_AKAN_DIVERIFIKASI>`
- **Content-Type:** `application/json`

**Contoh Body Request (JSON):**

```json
{}
```

#### 1.9. JWKS Public (JSON Web Key Set - `/.well-known/jwks.json`)

Mengambil JWKS yang berisi kunci publik untuk memverifikasi tanda tangan JWT (JSON Web Token) yang dikeluarkan oleh layanan SSO.

- **URL:** `{{dev-url}}/.well-known/jwks.json`
- **Metode:** `GET`
- **Parameter Query:** Tidak ada.

### 2. Instalasi (Install)

#### 2.1. Jalankan Inisialisasi (`/install`)

Menginisialisasi atau menyiapkan sistem Qrion. Biasanya dijalankan sekali saat deployment awal.

- **URL:** `{{dev-url}}/install`
- **Metode:** `GET`
- **Parameter Query:** Tidak ada.

### 3. Institusi (Institution)

Mengelola data institusi seperti sekolah, universitas, atau organisasi.

#### 3.1. Memperbarui Institusi (`/company`)

Memperbarui detail informasi institusi yang sudah ada.

- **URL:** `{{dev-url}}/company`
- **Metode:** `POST`
- **Otorisasi:** `Bearer <ACCESS_TOKEN>`
- **Content-Type:** `application/json`

**Contoh Body Request (JSON):**

```json
{
  "address1": "US",
  "institution_name": "Nama Institusi Baru"
  // Sertakan bidang lain yang ingin diperbarui di sini
}
```

- **Catatan:** Contoh _body_ ini menunjukkan pembaruan parsial. Anda bisa mengirimkan bidang lain yang ingin diperbarui.

#### 3.2. Menambahkan Institusi Baru (`/auth/add-new-institution`)

Mendaftarkan institusi baru ke dalam sistem Qrion, bersama dengan pembuatan pengguna administrator utama untuk institusi tersebut. Endpoint ini **wajib** menggunakan `multipart/form-data` karena mendukung pengunggahan file (avatar dan cover).

- **URL:** `http://localhost:3003/auth/add-new-institution`
- **Metode:** `POST`
- **Otorisasi:** `Bearer <ACCESS_TOKEN>` (Kemungkinan token dari super admin atau pengguna yang berhak menambah institusi)
- **Content-Type:** `multipart/form-data`

**Parameter (Form Data):**

| Kunci              | Tipe     | Contoh Nilai               | Deskripsi                                               |
| :----------------- | :------- | :------------------------- | :------------------------------------------------------ |
| `username`         | Text     | `pesantrendemo`            | Nama pengguna untuk administrator utama institusi baru. |
| `email`            | Text     | `pesantrendemo@qrion.com`  | Alamat email untuk administrator utama institusi baru.  |
| `password`         | Text     | `123qweasd`                | Kata sandi untuk administrator utama institusi baru.    |
| `institution_name` | Text     | `Pesantren Demo`           | Nama resmi institusi baru.                              |
| `address1`         | Text     | `Jl. Merdeka No. 1`        | Baris pertama alamat institusi.                         |
| `address2`         | Text     | `Kel. Pusat Kota`          | Baris kedua alamat institusi (opsional).                |
| `address3`         | Text     | `Kec. Kebayoran`           | Baris ketiga alamat institusi (opsional).               |
| `zipcode`          | Text     | `12345`                    | Kode pos institusi.                                     |
| `telephone1`       | Text     | `+6281234567890`           | Nomor telepon utama institusi.                          |
| `telephone2`       | Text     | `+6221123456`              | Nomor telepon sekunder institusi (opsional).            |
| `fax`              | Text     | `+6221987654`              | Nomor faks institusi (opsional).                        |
| `website`          | Text     | `http://www.pesantren.com` | URL situs web institusi (opsional).                     |
| `avatar`           | **File** | (File gambar)              | Gambar avatar untuk institusi (opsional).               |
| `cover`            | **File** | (File gambar)              | Gambar sampul untuk institusi (opsional).               |
| `institution_code` | Text     | `467.598.080`              | Kode unik atau identifikasi untuk institusi.            |

#### 3.3. Membaca Data Institusi (`/companies`)

Mengambil satu atau daftar data institusi. (Perlu konfirmasi URL dan parameter lebih lanjut karena di Postman Collection tidak lengkap, `read` hanya URL kosong.)

- **URL:** `{{dev-url}}/companies` (Kemungkinan untuk daftar semua) atau `{{dev-url}}/companies/<institution_id>` (Untuk satu institusi spesifik)
- **Metode:** `GET`
- **Otorisasi:** `Bearer <ACCESS_TOKEN>`
- **Parameter Query:** (Mungkin untuk paginasi, pencarian, atau filter)

### 4. Penyedia Layanan (Service Provider)

Mengelola daftar penyedia layanan yang terintegrasi dengan Qrion.

#### 4.1. Menambahkan Penyedia Layanan (`/service-providers`)

Mendaftarkan penyedia layanan baru.

- **URL:** `{{dev-url}}/service-providers`
- **Metode:** `POST`
- **Otorisasi:** `Bearer <ACCESS_TOKEN>`
- **Content-Type:** `application/json`

**Contoh Body Request (JSON):**

```json
{
  "name": "ORDERDOM-SERVICEX",
  "description": "SERVICE ORDERDOM APPS"
}
```

#### 4.2. Mendapatkan Semua Penyedia Layanan (Terpaginasi) (`/service-providers`)

Mengambil daftar semua penyedia layanan dengan dukungan paginasi (halaman).

- **URL:** `{{dev-url}}/service-providers` (Mungkin dengan parameter query seperti `?page=1&limit=10` untuk paginasi.)
- **Metode:** `GET`
- **Otorisasi:** `Bearer <ACCESS_TOKEN>`
- **Parameter Query:** (Mungkin untuk paginasi: `page`, `limit`, `search`, `sort`)

### 5. Hubungan Perusahaan & Layanan (Company & Service)

Mengelola asosiasi antara institusi (perusahaan) dan penyedia layanan.

#### 5.1. Menambahkan Layanan ke Perusahaan (`/company-service-providers`)

Menghubungkan penyedia layanan tertentu dengan sebuah institusi.

- **URL:** `{{dev-url}}/company-service-providers`
- **Metode:** `POST`
- **Otorisasi:** `Bearer <ACCESS_TOKEN>`
- **Content-Type:** `application/json`

**Contoh Body Request (JSON):**

```json
{
  "company_id": 7,
  "service_provider_id": 3
}
```

#### 5.2. Menghapus Layanan dari Perusahaan (`/company-service-providers/<id>`)

Memutus hubungan antara penyedia layanan dan institusi.

- **URL:** `{{dev-url}}/company-service-providers/<id_hubungan_perusahaan_layanan>` (Ganti `<id_hubungan_perusahaan_layanan>` dengan ID unik dari hubungan tersebut, contoh: `{{dev-url}}/company-service-providers/1`)
- **Metode:** `DELETE`
- **Otorisasi:** `Bearer <ACCESS_TOKEN>`

#### 5.3. Mendapatkan Layanan Perusahaan (`/company-service-providers/<company_id>`)

Mengambil informasi tentang penyedia layanan yang terkait dengan institusi tertentu.

- **URL:** `{{dev-url}}/company-service-providers/<company_id>` (Ganti `<company_id>` dengan ID institusi.)
- **Metode:** `GET`
- **Otorisasi:** `Bearer <ACCESS_TOKEN>`

### 6. Peran (Role)

Mengelola peran pengguna dalam sistem, yang menentukan hak akses.

#### 6.1. Membuat Peran Baru (`/roles`)

Membuat definisi peran baru dengan kode referensi unik, nama, dan deskripsi.

- **URL:** `{{dev-url}}/roles`
- **Metode:** `POST`
- **Otorisasi:** `Bearer <ACCESS_TOKEN>`
- **Content-Type:** `application/json`

**Contoh Body Request (JSON):**

```json
{
  "reference_code": "HOST",
  "name": "HOST",
  "description": "developers"
}
```

#### 6.2. Mengatur Peran Pengguna (`/auth/set-user-role/<user_uuid>`)

Menetapkan peran tertentu kepada pengguna yang sudah ada.

- **URL:** `{{dev-url}}/auth/set-user-role/<user_uuid>` (Ganti `<user_uuid>` dengan UUID pengguna.)
- **Metode:** `POST`
- **Otorisasi:** `Bearer <ACCESS_TOKEN>`
- **Content-Type:** `application/json`

**Contoh Body Request (JSON):**

```json
{
  "role_id": 5
}
```

#### 6.3. Mendapatkan Semua Peran (`/roles`)

Mengambil daftar semua peran yang terdaftar dalam sistem.

- **URL:** `{{dev-url}}/roles`
- **Metode:** `GET`
- **Otorisasi:** `Bearer <ACCESS_TOKEN>`

#### 6.4. Mendapatkan Peran Berdasarkan ID (`/roles/<role_id>`)

Mengambil detail peran spesifik berdasarkan ID-nya. (Catatan: URL di Postman collection adalah umum, biasanya akan ada ID peran di URL.)

- **URL:** `{{dev-url}}/roles/<role_id>` (Asumsi struktur URL yang lebih RESTful)
- **Metode:** `GET`
- **Otorisasi:** `Bearer <ACCESS_TOKEN>`

### 7. Izin (Permission)

Mengelola hak akses (izin) dalam sistem dan hubungannya dengan peran.

#### 7.1. Membuat Master Izin Layanan (`/permissions/<service_uuid>/service`)

Membuat izin master yang terkait dengan penyedia layanan. Endpoint ini menggunakan `formdata` di Postman Collection Anda, namun karena tidak ada file yang diunggah, diasumsikan bisa menggunakan JSON. Jika ada properti tambahan yang diharapkan sebagai bagian dari body JSON, perlu dikonfirmasi.

- **URL:** `{{dev-url}}/permissions/<service_uuid>/service` (Ganti `<service_uuid>` dengan UUID penyedia layanan.)
- **Metode:** `POST`
- **Otorisasi:** `Bearer <ACCESS_TOKEN>`
- **Content-Type:** `application/json`

**Contoh Body Request (JSON):**

```json
{
  "permission_name": "create_service_resource",
  "description": "Izin untuk membuat sumber daya layanan",
  "resource_type": "service",
  "action": "create"
  // Sesuaikan dengan struktur data izin Anda jika ada properti lain
}
```

- **Catatan:** Postman Collection Anda hanya menunjukkan `X-access-token` di _formdata_ untuk _endpoint_ ini. Contoh JSON di atas adalah asumsi struktur untuk mendefinisikan izin.

#### 7.2. Mengatur Izin Peran (`/role-permissions`)

Menghubungkan izin spesifik dengan peran tertentu, memberikan peran tersebut hak akses yang didefinisikan oleh izin.

- **URL:** `{{dev-url}}/role-permissions`
- **Metode:** `POST`
- **Otorisasi:** `Bearer <ACCESS_TOKEN>`
- **Content-Type:** `application/json`

**Contoh Body Request (JSON):**

```json
{
  "role_id": "172",
  "permission_id": "23"
}
```

#### 7.3. Mendapatkan Izin Peran Pengguna (`/role-permissions/<permission_id>/role/<role_id>/user`)

Mengambil daftar izin yang dimiliki oleh peran tertentu untuk konteks pengguna. (Struktur URL ini sangat spesifik, menunjukkan kombinasi ID izin, ID peran, dan konteks pengguna.)

- **URL:** `{{dev-url}}/role-permissions/<permission_id>/role/<role_id>/user` (Contoh: `{{dev-url}}/role-permissions/15/role/2/user`)
- **Metode:** `GET`
- **Otorisasi:** `Bearer <ACCESS_TOKEN>`

#### 7.4. Mendapatkan Semua Izin (`/permissions`)

Mengambil daftar semua izin yang tersedia dalam sistem.

- **URL:** `{{dev-url}}/permissions`
- **Metode:** `GET`
- **Otorisasi:** `Bearer <ACCESS_TOKEN>`

### 8. User (User Management)

Ini adalah _endpoint_ untuk manajemen pengguna secara umum (kemungkinan oleh administrator).

#### 8.1. Menyimpan Pengguna (Store User - `/users/`)

Membuat akun pengguna baru. Ini mungkin berbeda dari `register user` dan digunakan oleh administrator untuk menambahkan pengguna secara manual. Endpoint ini **wajib** menggunakan `multipart/form-data` karena mendukung pengunggahan file (avatar dan cover).

- **URL:** `{{dev-url}}/users/`
- **Metode:** `POST`
- **Otorisasi:** `Bearer <ACCESS_TOKEN>`
- **Content-Type:** `multipart/form-data`

**Parameter (Form Data):**

| Kunci      | Tipe     | Contoh Nilai              | Deskripsi                          |
| :--------- | :------- | :------------------------ | :--------------------------------- |
| `username` | Text     | `host.it_kuansing`        | Nama pengguna unik.                |
| `email`    | Text     | `host.it_kuansing@ac.com` | Alamat email pengguna.             |
| `password` | Text     | `password`                | Kata sandi pengguna.               |
| `avatar`   | **File** | (File gambar)             | Gambar profil pengguna (opsional). |
| `cover`    | **File** | (File gambar)             | Gambar sampul pengguna (opsional). |
| `name`     | Text     | `ego oktafanda host`      | Nama lengkap pengguna.             |

---

## Modul QMS (Quality Management System)

Modul QMS menangani data terkait siswa, individu umum (non-siswa), dan fungsionalitas pembayaran.

### 1. Siswa (Student)

Mengelola data pribadi dan status siswa.

#### 1.1. Membuat Data Siswa (Person Siswa - `/api/v1/persons/students`)

Mendaftarkan data siswa baru ke dalam sistem.

- **URL:** `http://localhost:3003/api/v1/persons/students`
- **Metode:** `POST`
- **Otorisasi:** `Bearer <ACCESS_TOKEN>`
- **Content-Type:** `application/json`

**Contoh Body Request (JSON):**

```json
{
  "nis": "123",
  "name": "dr. ego oktafanda, M.Kom",
  "gender": "L",
  "place_of_birth": "Jakarta",
  "date_of_birth": "1997-01-01",
  "religion": "Islam",
  "full_address": "Jl. Contoh No. 123, Jakarta",
  "parent_name": "Budi Oktafanda",
  "parent_phone": "08123456789",
  "student_status": null
}
```

#### 1.2. Memperbarui Data Siswa (`/api/v1/persons/students/<student_uuid>`)

Memperbarui informasi siswa yang sudah ada berdasarkan UUID siswa.

- **URL:** `http://localhost:3003/api/v1/persons/students/<student_uuid>` (Ganti `<student_uuid>` dengan UUID siswa, contoh: `http://localhost:3003/api/v1/persons/students/c661acef-0287-4237-8fdf-aeaecec52506`)
- **Metode:** `PUT`
- **Otorisasi:** `Bearer <ACCESS_TOKEN>`
- **Content-Type:** `application/json`

**Contoh Body Request (JSON):**

```json
{
  "nis": "123",
  "name": "prof. ego oktafanda, M.Kom",
  "gender": "L",
  "place_of_birth": "Jakarta",
  "date_of_birth": "1997-01-01",
  "religion": "Islam",
  "full_address": "Jl. Contoh No. 123, Jakarta",
  "parent_name": "Budi Oktafanda",
  "parent_phone": "08123456789",
  "student_status": null
}
```

#### 1.3. Menghapus Data Siswa (`/api/v1/persons/students/<student_uuid>`)

Menghapus catatan siswa dari sistem berdasarkan UUID siswa.

- **URL:** `http://localhost:3003/api/v1/persons/students/<student_uuid>` (Ganti `<student_uuid>` dengan UUID siswa.)
- **Metode:** `DELETE`
- **Otorisasi:** `Bearer <ACCESS_TOKEN>`

#### 1.4. Mendapatkan Semua Data Siswa (`/api/v1/persons/students`)

Mengambil daftar semua catatan siswa yang terdaftar.

- **URL:** `http://localhost:3003/api/v1/persons/students`
- **Metode:** `GET`
- **Otorisasi:** `Bearer <ACCESS_TOKEN>`

#### 1.5. Mendapatkan Data Siswa Berdasarkan UUID (`/api/v1/persons/students/<student_uuid>`)

Mengambil detail siswa spesifik berdasarkan UUID-nya.

- **URL:** `http://localhost:3003/api/v1/persons/students/<student_uuid>` (Contoh: `http://localhost:3003/api/v1/persons/students/7431a4b7-64df-4804-9297-f9066897523b`)
- **Metode:** `GET`
- **Otorisasi:** `Bearer <ACCESS_TOKEN>` (Disarankan)

#### 1.6. Import dari Oncard (`/api/v1/persons/distributions/<distribution_id>`)

Mengimpor data siswa dari sumber "Oncard" berdasarkan ID distribusi.

- **URL:** `http://localhost:3003/api/v1/persons/distributions/<distribution_id>` (Ganti `<distribution_id>` dengan ID distribusi.)
- **Metode:** `GET`
- **Otorisasi:** `Bearer <ACCESS_TOKEN>` (Disarankan)

### 2. Umum (General Person)

Mengelola data individu umum (misalnya staf, karyawan non-siswa).

#### 2.1. Membuat Data Orang Umum (General Person - `/api/v1/persons/generals`)

Mendaftarkan catatan individu umum baru.

- **URL:** `http://localhost:3003/api/v1/persons/generals`
- **Metode:** `POST`
- **Otorisasi:** `Bearer <ACCESS_TOKEN>`
- **Content-Type:** `application/json`

**Contoh Body Request (JSON):**

```json
{
  "nip": "1234567890",
  "name": "prof. ego oktafanda, PhD",
  "gender": "L",
  "place_of_birth": "Jakarta",
  "date_of_birth": "1997-01-01",
  "religion": "Islam",
  "full_address": "Jl. Contoh No. 123, Jakarta",
  "phone": "08123456789"
}
```

#### 2.2. Memperbarui Data Orang Umum (`/api/v1/persons/generals/<person_uuid>`)

Memperbarui informasi individu umum yang sudah ada berdasarkan UUID-nya.

- **URL:** `http://localhost:3003/api/v1/persons/generals/<person_uuid>` (Ganti `<person_uuid>` dengan UUID individu umum, contoh: `http://localhost:3003/api/v1/persons/generals/8fcfd67a-bd90-4bb6-9ad0-6fe539bfc23c`)
- **Metode:** `PUT`
- **Otorisasi:** `Bearer <ACCESS_TOKEN>`
- **Content-Type:** `application/json`

**Contoh Body Request (JSON):**

```json
{
  "nip": "1234567890",
  "name": "prof. ego oktafanda, S.Kom, M.Kom",
  "gender": "L",
  "place_of_birth": "Jakarta",
  "date_of_birth": "1997-01-01",
  "religion": "Islam",
  "full_address": "Jl. Contoh No. 123, Jakarta Pusat",
  "phone": "08123456789"
}
```

#### 2.3. Menghapus Data Orang Umum (`/api/v1/persons/general/<person_uuid>`)

Menghapus catatan individu umum dari sistem berdasarkan UUID-nya.

- **URL:** `http://localhost:3003/api/v1/persons/general/<person_uuid>` (Ganti `<person_uuid>` dengan UUID individu umum.)
- **Metode:** `DELETE`
- **Otorisasi:** `Bearer <ACCESS_TOKEN>`

#### 2.4. Mendapatkan Semua Data Orang Umum (`/api/v1/persons/general`)

Mengambil daftar semua catatan individu umum.

- **URL:** `http://localhost:3003/api/v1/persons/general`
- **Metode:** `GET`
- **Otorisasi:** `Bearer <ACCESS_TOKEN>`

#### 2.5. Mendapatkan Data Orang Umum Berdasarkan UUID (`/api/v1/persons/general/<person_uuid>`)

Mengambil detail individu umum spesifik berdasarkan UUID-nya.

- **URL:** `http://localhost:3003/api/v1/persons/general/<person_uuid>` (Contoh: `http://localhost:3003/api/v1/persons/general/7431a4b7-64df-4804-9297-f9066897523b`)
- **Metode:** `GET`
- **Otorisasi:** `Bearer <ACCESS_TOKEN>` (Disarankan)

### 3. QPay (Pembayaran)

Mengelola fungsionalitas terkait pembayaran.

#### 3.1. Membuat Vito (Virtual Account - `/api/v1/payments/open-vito`)

Membuka Virtual Account (Vito) untuk pengguna dengan detail transaksi tertentu.

- **URL:** `http://localhost:3003/api/v1/payments/open-vito`
- **Metode:** `POST` (Metode `GET` untuk operasi ini di Postman Collection kurang tepat secara RESTful. Kami mengubahnya menjadi `POST` sesuai standar untuk operasi _create_ dengan _body_.)
- **Otorisasi:** `Bearer <ACCESS_TOKEN>`
- **Content-Type:** `application/json`

**Contoh Body Request (JSON):**

```json
{
  "user": "bfbc36df-1bd6-4f80-9fa0-fa71900f8b59", // UUID pengguna, username, atau nomor akun
  "open_trx_type": "TOPUP", // Tipe transaksi pembukaan (misalnya "TOPUP")
  "open_by": "QRION-MOBILE", // Sumber pembukaan transaksi (misalnya aplikasi seluler)
  "channel": "BRKS-MOBILE", // Saluran transaksi
  "provider": "BRKS", // Penyedia layanan pembayaran
  "amount": 100000000, // Jumlah transaksi (dalam unit terkecil, misal sen/rupiah tanpa koma)
  "open_trx_props": {} // Properti tambahan spesifik transaksi (objek JSON kosong atau detail lain)
}
```

---

## Penanganan Kesalahan Umum

API ini menggunakan kode status HTTP standar untuk menunjukkan keberhasilan atau kegagalan permintaan API. Berikut adalah beberapa respons kesalahan umum yang mungkin Anda temui:

- **`200 OK`**: Permintaan berhasil diproses.
- **`201 Created`**: Sumber daya baru berhasil dibuat.
- **`400 Bad Request`**: Permintaan tidak valid, parameter hilang, atau format tidak sesuai. Periksa _body request_ dan parameter Anda.
- **`401 Unauthorized`**: Otentikasi diperlukan atau gagal (misalnya, token akses tidak ada, tidak valid, atau kedaluwarsa). Pastikan Anda mengirim token Bearer yang benar.
- **`403 Forbidden`**: Pengguna yang terautentikasi tidak memiliki izin yang cukup untuk mengakses sumber daya ini atau melakukan tindakan ini.
- **`404 Not Found`**: Sumber daya yang diminta tidak ditemukan di server. Periksa URL Anda.
- **`405 Method Not Allowed`**: Metode HTTP yang digunakan tidak diizinkan untuk _endpoint_ tersebut (misalnya, mencoba `GET` pada _endpoint_ `POST`).
- **`409 Conflict`**: Terjadi konflik dengan status sumber daya saat ini (misalnya, mencoba membuat sumber daya yang sudah ada).
- **`500 Internal Server Error`**: Terjadi kesalahan tak terduga di sisi server. Hubungi administrator sistem jika masalah ini berlanjut.

---

Baik, saya paham sekarang. Anda ingin teks dokumentasi API Kalender QMS Qrion yang sudah saya berikan sebelumnya, tetapi dalam format Markdown (`.md`) murni, tanpa dibungkus dalam tag `<immersive>` atau instruksi tambahan lainnya yang ditujukan untuk _canvas_.

Berikut adalah teks lengkapnya dalam format Markdown murni yang siap Anda salin ke file `.md` Anda:

````markdown
# Dokumentasi API Kalender QMS Qrion

Dokumen ini menjelaskan _endpoint_ API untuk mengelola acara kalender dalam modul Quality Management System (QMS) Qrion. Anda dapat membuat, memperbarui, melihat, dan mengelola acara kalender.

## URL Dasar

Untuk _endpoint_ Kalender, URL dasar yang digunakan adalah:

`http://localhost:3003/api/v1`

## Otentikasi

Semua _endpoint_ Kalender memerlukan otentikasi menggunakan **Bearer Token**. Pastikan Anda menyertakan _header_ `Authorization` dengan format `Bearer <YOUR_ACCESS_TOKEN>` dalam setiap permintaan yang diautentikasi. Token akses ini diperoleh setelah berhasil login ke sistem Qrion.

---

## Endpoint Kalender

### 1. Membuat Acara Kalender Baru (`/calendar-events`)

Menyimpan acara kalender baru ke dalam sistem.

- **URL:** `http://localhost:3003/api/v1/calendar-events`
- **Metode:** `POST`
- **Content-Type:** `application/json`
- **Otorisasi:** `Bearer Token`

**Contoh Body Request (JSON):**

```json
{
  "title": "Project Meeting",
  "start": "2025-06-03T10:00:00",
  "end": "2025-06-03T11:30:00",
  "type": "meeting",
  "backgroundColor": "#1890ff"
}
```
````

**Detail Properti Request:**

| Properti          | Tipe   | Deskripsi                                                           |
| :---------------- | :----- | :------------------------------------------------------------------ |
| `title`           | String | Judul acara kalender.                                               |
| `start`           | String | Waktu mulai acara (format ISO 8601, contoh: `YYYY-MM-DDTHH:mm:ss`). |
| `end`             | String | Waktu berakhir acara (format ISO 8601).                             |
| `type`            | String | Tipe acara (misalnya: "meeting", "task", "holiday").                |
| `backgroundColor` | String | Warna latar belakang acara (format Hex, contoh: "#RRGGBB").         |

**Contoh Body Response Sukses (Status: `201 Created`):**

```json
{
  "message": "Calendar event created successfully",
  "data": {
    "title": "Project Meeting",
    "start": "2025-06-03T10:00:00",
    "end": "2025-06-03T11:30:00",
    "type": "meeting",
    "institution_id": 1,
    "user_id": 5,
    "backgroundColor": "#1890ff"
  }
}
```

### 2. Memperbarui Acara Kalender (`/calendar-events/<id>`)

Memperbarui detail acara kalender yang sudah ada.

- **URL:** `http://localhost:3003/api/v1/calendar-events/<id_acara>` (Ganti `<id_acara>` dengan ID numerik acara yang ingin diperbarui, contoh: `http://localhost:3003/api/v1/calendar-events/1`)
- **Metode:** `POST` (Catatan: Meskipun `POST` digunakan di Postman, untuk operasi _update_ biasanya `PUT` atau `PATCH` lebih RESTful. Konfirmasikan dengan implementasi API.)
- **Content-Type:** `application/json`
- **Otorisasi:** `Bearer Token`

**Contoh Body Request (JSON):**

```json
{
  "title": "Project Meeting x",
  "start": "2025-06-03T10:00:00",
  "end": "2025-06-03T11:30:00",
  "type": "meeting",
  "backgroundColor": "#1890ff"
}
```

**Detail Properti Request:**
Sama dengan properti saat membuat acara, Anda hanya perlu mengirim properti yang ingin Anda ubah.

**Contoh Body Response Sukses (Status: `200 OK`):**

```json
{
  "message": "Calendar event updated successfully",
  "data": {
    "id": 1,
    "uuid": "20f61cd3-b8fc-42b2-8b62-6c734fd7cb57",
    "title": "Project Meeting x",
    "start": "2025-06-03T03:00:00.000Z",
    "end": "2025-06-03T04:30:00.000Z",
    "type": "meeting",
    "institution_id": 1,
    "user_id": 5,
    "backgroundColor": "#1890ff",
    "created_at": "2025-06-09T07:35:09.114Z",
    "updated_at": "2025-06-09T07:36:53.812Z"
  }
}
```

### 3. Menampilkan Semua Acara Kalender Berdasarkan Autentikasi (`/calendar-events`)

Mengambil daftar semua acara kalender yang terkait dengan pengguna yang sedang login (berdasarkan token autentikasi).

- **URL:** `http://localhost:3003/api/v1/calendar-events`
- **Metode:** `GET`
- **Otorisasi:** `Bearer Token`
- **Parameter Query:** Tidak ada.

**Contoh Body Response Sukses (Status: `200 OK`):**

```json
[
  {
    "id": 1,
    "uuid": "20f61cd3-b8fc-42b2-8b62-6c734fd7cb57",
    "title": "Project Meeting x",
    "start": "2025-06-03T03:00:00.000Z",
    "end": "2025-06-03T04:30:00.000Z",
    "type": "meeting",
    "institution_id": 1,
    "user_id": 5,
    "backgroundColor": "#1890ff",
    "created_at": "2025-06-09T07:35:09.114Z",
    "updated_at": "2025-06-09T07:36:53.812Z"
  }
  // ... acara kalender lainnya
]
```

### 4. Mendapatkan Acara Kalender Berdasarkan ID (`/calendar-events/<id>`)

Mengambil detail acara kalender spesifik berdasarkan ID-nya.

- **URL:** `http://localhost:3003/api/v1/calendar-events/<id_acara>` (Ganti `<id_acara>` dengan ID numerik acara yang ingin diambil, contoh: `http://localhost:3003/api/v1/calendar-events/1`)
- **Metode:** `GET`
- **Otorisasi:** `Bearer Token`
- **Parameter Query:** Tidak ada.

**Contoh Body Response Sukses (Status: `200 OK`):**

```json
{
  "id": 1,
  "uuid": "20f61cd3-b8fc-42b2-8b62-6c734fd7cb57",
  "title": "Project Meeting x",
  "start": "2025-06-03T03:00:00.000Z",
  "end": "2025-06-03T04:30:00.000Z",
  "type": "meeting",
  "institution_id": 1,
  "user_id": 5,
  "backgroundColor": "#1890ff",
  "created_at": "2025-06-09T07:35:09.114Z",
  "updated_at": "2025-06-09T07:36:53.812Z"
}
```

---

## Penanganan Kesalahan Umum

API ini menggunakan kode status HTTP standar untuk menunjukkan keberhasilan atau kegagalan permintaan API. Berikut adalah beberapa respons kesalahan umum yang mungkin Anda temui:

- **`200 OK`**: Permintaan berhasil diproses.
- **`201 Created`**: Sumber daya baru berhasil dibuat.
- **`400 Bad Request`**: Permintaan tidak valid, parameter hilang, atau format tidak sesuai. Periksa _body request_ dan parameter Anda.
- **`401 Unauthorized`**: Otentikasi diperlukan atau gagal (misalnya, token akses tidak ada, tidak valid, atau kedaluwarsa). Pastikan Anda mengirim token Bearer yang benar.
- **`403 Forbidden`**: Pengguna yang terautentikasi tidak memiliki izin yang cukup untuk mengakses sumber daya ini atau melakukan tindakan ini.
- **`404 Not Found`**: Sumber daya yang diminta tidak ditemukan di server (misalnya, ID acara kalender tidak valid).
- **`500 Internal Server Error`**: Terjadi kesalahan tak terduga di sisi server. Hubungi administrator sistem jika masalah ini berlanjut.

---

Untuk pertanyaan atau bantuan lebih lanjut, silakan hubungi tim dukungan teknis Qrion.

**Terima kasih telah menggunakan API Qrion!**

```

```
