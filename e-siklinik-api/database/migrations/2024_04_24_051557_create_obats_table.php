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
            Schema::create('obats', function (Blueprint $table) {
                  $table->id();
                  $table->string('nama_obat');
                  $table->date('tanggal_kadaluarsa');
                  $table->integer('stock');
                  $table->bigInteger('harga');
                  $table->string('image');
                  $table->foreignId('kategori_id')->constrained('kategori_obats')->cascadeOnUpdate()->cascadeOnDelete();
                  $table->timestamps();
            });
      }

      /**
       * Reverse the migrations.
       */
      public function down(): void
      {
            Schema::dropIfExists('obats');
      }
};
