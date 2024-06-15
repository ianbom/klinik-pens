<?php

namespace Database\Seeders;

// use Illuminate\Database\Console\Seeds\WithoutModelEvents;

use App\Models\PasienTable;
use App\Models\ProdiTable;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        $this->call([
            KategoriObatSeeder::class,
            DokterTableSeeder::class,
            ProdiTableSeeder::class,
            PasienTableSeeder::class,
            ObatTableSeeder::class,
        ]);
    }
}
