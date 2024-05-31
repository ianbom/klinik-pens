<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class JadwalDokter extends Model
{
    use HasFactory;
    protected $table = 'jadwal_dokters';

    protected $fillable = ['dokter_id',  'hari',  'jadwal_mulai_tugas', 'jadwal_selesai_tugas'];

    public function jadwalToDokter()
{
    return $this->belongsTo(Dokter::class, 'dokter_id');
}

}
