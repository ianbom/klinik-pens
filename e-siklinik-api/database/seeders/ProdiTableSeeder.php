<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class ProdiTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $prodi = [
            'D3 Teknik Elektronika',
            'D3 Teknik Telekomunikasi',
            'D3 Teknik Elektro Industri',
            'D3 Teknik Informatika',
            'D3 Teknologi Multimedia Broadcasting',
            'D3 Teknik Informatika Kampus Lamongan',
            'D3 Teknologi Multimedia Broadcasting Kampus Lamongan',
            'D3 Teknik Informatika Kampus Sumenep',
            'D3 Teknologi Multimedia Broadcasting Kampus Sumenep',
            'D3 PJJ Teknik Informatika',
            'D3 Teknik Elektronika',
            'D4 Teknik Telekomunikasi',
            'D4 Teknik Elektro Industri',
            'D4 Teknik Informatika',
            'D4 Teknik Mekatronika',
            'D4 Teknik Komputer',
            'D4 Sistem Pembangkitan Energi',
            'D4 Teknologi Game',
            'D4 Teknologi Rekayasa Internet',
            'D4 Teknologi Rekayasa Multimedia',
            'D4 Sains Data Terapan',
            'D4 PJJ Teknik Telekomunikasi',
            'S2 Teknik Elektro',
            'S2 Teknik Informatika dan Komputer'
        ];

        foreach ($prodi as $namaProdi) {
            DB::table('prodi')->insert([
                'nama' => $namaProdi,
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }
    }
}
