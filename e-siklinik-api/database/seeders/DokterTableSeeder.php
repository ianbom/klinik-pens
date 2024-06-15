<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Faker\Factory as Faker;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Http;

class DokterTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $faker = Faker::create('id_ID');

        for ($i = 0; $i < 10; $i++) {
            // Generate random user image from RandomUser.me
            $response = Http::get('https://randomuser.me/api/');
            $imageData = $response->json();
            $imageUrl = $imageData['results'][0]['picture']['large'];

            // Get the image contents
            $imageContents = file_get_contents($imageUrl);

            // Define the image path
            $imageName = basename($imageUrl);
            $imagePath = 'dokter_images/' . $imageName;

            // Store the image in the public storage
            Storage::disk('public')->put($imagePath, $imageContents);

            // Insert the data into the 'dokter' table
            DB::table('dokter')->insert([
                'nama' => $faker->name,
                'gender' => $faker->randomElement(['Laki-Laki', 'Perempuan']),
                'tanggal_lahir' => $faker->date,
                'alamat' => $faker->address,
                'nomor_hp' => $faker->phoneNumber,
                'is_disabled' => 0,
                'image' => $imagePath,// Store relative path
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }
    }
}
