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
        Schema::create('check_up_results', function (Blueprint $table) {
            $table->id();
            $table->foreignId('assesmen_id')->constrained('checkup_assesmens')->cascadeOnUpdate();
            $table->text('hasil_diagnosa');
            $table->string('url_file');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('check_up_results');
    }
};
