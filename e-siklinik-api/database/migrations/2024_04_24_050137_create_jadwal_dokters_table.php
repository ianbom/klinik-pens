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
            Schema::create('jadwal_dokters', function (Blueprint $table) {
                  $table->id();
                  $table->string('hari');
                  $table->time('jadwal_mulai_tugas');
                  $table->time('jadwal_selesai_tugas');
                  $table->foreignId('dokter_id')->constrained('dokter')->cascadeOnUpdate()->cascadeOnDelete();
                  $table->timestamps();
            });
      }

      /**
       * Reverse the migrations.
       */
      public function down(): void
      {
            Schema::dropIfExists('jadwal_dokters');
      }
};
