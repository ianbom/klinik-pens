<?php

namespace Database\Seeders;

use App\Models\ProdiTable;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class ProdiSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        ProdiTable::create([
           'nama' => 'D3 Teknik Elektronika'
        ]);

        ProdiTable::create([
            'nama' => 'D3 Teknik Telekomunikasi'
         ]);

         ProdiTable::create([
            'nama' => 'D3 Teknik Elektro Industri'
         ]);
    }
}
