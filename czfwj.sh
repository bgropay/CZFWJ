#!/bin/bash

# Memeriksa jumlah argumen yang dimasukkan
if [[ "${#}" -ne 1 ]]; then
    echo "Penggunaan: ${0} <file_zip>"
    exit 1
fi

# Memeriksa apakah argumen yang dimasukkan adalah sebuah file
if [[ ! -f "${1}" ]]; then
    echo "Kesalahan: File '${1}' tidak ditemukan."
    exit 1
fi

# Memeriksa apakah file yang dimasukkan adalah file ZIP
if [[ ! "${1##*.}" == "zip" ]]; then
    echo "Kesalahan: '${1}' bukan file ZIP."
    exit 1
fi

# Menyiapkan nama file untuk menyimpan hash dari file ZIP
nfh="${1}.hash"

# Membuat hash dari file ZIP menggunakan zip2john
echo "[ ** ] Membuat hash dari file ZIP '${1}'..."
sleep 3
zip2john "${1}" > "${nfh}"
echo "[ OK ] Hash telah berhasil dibuat dan disimpan di file '${nfh}'."

# Menentukan wordlist default yang akan digunakan untuk cracking password
w="rockyou.txt"

# Menentukan format file ZIP untuk John The Ripper
f="PKZIP"

# Menyimpan hasil cracking dari John The Ripper
o="Hasil Cracking.txt"

echo "[ ** ] Menjalankan John The Ripper..."
sleep 3
john --wordlist="${w}" --format="${f}" --pot="${o}" "${nfh}"

echo "[ ** ] Menampilkan hasil proses Cracking John The Ripper..." 
sleep 3
john --show "{nfh}"
