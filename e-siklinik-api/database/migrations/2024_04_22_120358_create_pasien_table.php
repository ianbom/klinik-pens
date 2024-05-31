<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
      /**
       * Run the migrations.
       */
      public function up(): void
      {
            Schema::create('pasien', function (Blueprint $table) {
                  $table->id();
                  $table->string('nrp');
                  $table->string('nama');
                  $table->string('gender');
                  $table->date('tanggal_lahir');
                  $table->string('alamat');
                  $table->string('nomor_hp');
                  $table->string('nomor_wali');
                  $table->string('image');
                  $table->foreignId('prodi_id')->constrained('prodi')->cascadeOnUpdate()->cascadeOnDelete();
                  $table->boolean('is_disabled')->default(false);
                  $table->timestamps();
            });
      }

      /**
       * Reverse the migrations.
       */
      public function down(): void
      {
            Schema::dropIfExists('pasien');
      }
};
