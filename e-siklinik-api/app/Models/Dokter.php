<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Dokter extends Model {
    use HasFactory;
    protected $table = 'dokter';
    protected $fillable = ['nama', 'gender', 'tanggal_lahir', 'alamat', 'nomor_hp', 'is_disabled','image'];

    public function dokterToAssesmen() {
        return $this->hasMany(CheckupAssesmen::class, 'dokter_id');
    }

    public function dokterToJadwal() {
        return $this->hasMany(JadwalDokter::class, 'dokter_id');
    }
}
