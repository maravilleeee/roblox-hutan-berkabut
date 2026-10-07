# Hutan Berkabut — Desain Game

**Genre:** petualangan, sedikit horor, ramah anak (tanpa darah, tanpa jumpscare keras).

## Loop utama
1. Jelajahi hutan berkabut.
2. Kumpulkan 5 lentera yang tersebar.
3. Hindari hantu imut yang patroli. Tertangkap = kembali ke checkpoint (tidak ada "mati").
4. Semua lentera terkumpul = menang.

## Aturan ramah anak
- Hantu lebih lambat dari pemain, dan ada jeda 5 detik setelah menangkap.
- Tidak ada damage dan tidak ada darah. Nuansa seram dari kabut, suara, dan gelap saja.
- Checkpoint sering supaya tidak frustrasi.

## Cara menyiapkan di Studio
Pakai tag lewat plugin Tag Editor (atau script):
- `Checkpoint`: Part pijakan.
- `Lantern`: Part bercahaya (tambah PointLight).
- `Ghost`: Model dengan Humanoid dan PrimaryPart.
