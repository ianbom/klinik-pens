<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class CheckupAssesmen extends Model {
    use HasFactory;
    protected $table = 'checkup_assesmens';
    protected $fillable = ['antrian_id', 'dokter_id'];

    public function assesmenToResult() {
        return $this->belongsTo(CheckUpResult::class, 'assesmen_id');
    }

    public function assesmenToAntrian() {
        return $this->hasOne(AntrianTable::class, 'id', 'antrian_id');
    }

    public function assesmenToDokter() {
        return $this->belongsTo(Dokter::class, 'dokter_id'); // Ubah dari belongTo menjadi belongsTo
    }
}
