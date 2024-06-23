#!/bin/bash
########
#
# Skrip ini digunakan untuk melakukan cracking password pada file ZIP menggunakan zip2john dan John The Ripper.
# 
# Penggunaan: bash czfwj.sh.sh <file_zip>
# 
# Contoh: bash czfwj.sh file.zip
#
#######

# Memeriksa jumlah argumen yang dimasukkan
if [[ "${#}" -ne 1 ]]; then
    echo "Penggunaan: ${0} <file_zip>"
    exit 1
fi

# Memeriksa apakah argumen yang dimasukkan adalah sebuah file
file_zip="${1}"
if [[ ! -f "${file_zip}" ]]; then
    echo "[ NG ] File '${file_zip}' tidak ditemukan."
    exit 1
fi

# Memeriksa apakah file yang dimasukkan adalah file ZIP
if [[ ! "${file_zip##*.}" == "zip" ]]; then
    echo "[ NG ] File '${file_zip}' bukan file ZIP."
    exit 1
fi

# Menyiapkan nama file untuk menyimpan hash dari file ZIP
hash_file="${file_zip}.hash"

# Membuat hash dari file ZIP menggunakan zip2john
echo "[ ** ] Membuat hash dari file ZIP '${file_zip}' menggunakan zip2john ..."
sleep 3
zip2john "${file_zip}" > "${hash_file}"
if [[ $? -ne 0 ]]; then
    echo "[ NG ] Gagal membuat hash dari file '${file_zip}' menggunakan zip2john ."
    exit 1
fi
echo "[ OK ] Hash telah berhasil dibuat menggunakan zip2john dan disimpan di file '${hash_file}'."

# Menentukan wordlist default yang akan digunakan untuk cracking password
wordlist="rockyou.txt"

# Menentukan format file ZIP untuk John The Ripper
format="zip"

# Menyimpan hasil cracking dari John The Ripper
output="Hasil_Cracking.txt"

# Menggunakan John The Ripper untuk meng-crack kata sandi file ZIP
echo "[ ** ] Mengcrack kata sandi file zip '${1}' menggunakan John The Ripper..."
sleep 3
john --wordlist="${wordlist}" --format="${format}" --pot="${output}" "${hash_file}"
if [[ $? -ne 0 ]]; then
    echo "[ NG ] Gagal meng-crack kata sandi file ZIP '${1}' menggunakan John The Ripper."
    exit 1
fi

# Menampilkan hasil cracking dari John The Ripper
echo "[ ** ] Menampilkan hasil proses Cracking dari John The Ripper..." 
sleep 3
john --show "${hash_file}"
