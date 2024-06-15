<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Faker\Factory as Faker;
use Illuminate\Support\Facades\Storage;

class ObatTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $faker = Faker::create('id_ID');
        $obatNames = [
            'Paracetamol', 'Amoxicillin', 'Ibuprofen', 'Aspirin', 'Ciprofloxacin',
            'Metformin', 'Omeprazole', 'Simvastatin', 'Amlodipine', 'Metronidazole',
            'Cetirizine', 'Salbutamol', 'Diclofenac', 'Ranitidine', 'Lorazepam',
            'Diazepam', 'Prednisolone', 'Levothyroxine', 'Gabapentin', 'Azithromycin'
        ];

        for ($i = 0; $i < 20; $i++) {
            // Generate a fake image using Faker's built-in image method
            $image = $faker->image(null, 640, 480, 'medicine', true, true, 'Faker');

            // Define the image path
            $imageName = basename($image);
            $imagePath = 'obat_images/' . $imageName;

            // Move the generated image to the public storage
            Storage::disk('public')->put('obat_images', $image, $imageName);

            // Insert the data into the 'obats' table
            DB::table('obats')->insert([
                'nama_obat' => $faker->randomElement($obatNames),
                'tanggal_kadaluarsa' => $faker->dateTimeBetween('now', '+2 years')->format('Y-m-d'),
                'stock' => $faker->numberBetween(10, 100),
                'harga' => $faker->numberBetween(5000, 100000),
                'kategori_id' => $faker->numberBetween(1, 7),
                'image' => 'image',
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }
    }
}
