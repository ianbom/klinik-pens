<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class KategoriObatSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $kategoriObat = [
            'Bebas',
            'Bebas Terbatas',
            'Keras',
            'Narkotika',
            'Jamu',
            'Herbal',
            'Farmatika'
        ];

        foreach ($kategoriObat as $namaKategori) {
            DB::table('kategori_obats')->insert([
                'nama_kategori' => $namaKategori,
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }
    }
}
