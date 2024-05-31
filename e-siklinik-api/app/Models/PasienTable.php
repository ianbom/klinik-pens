<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class PasienTable extends Model
{
    use HasFactory;

    protected $table = 'pasien';

    protected $fillable =[
        'nrp',
        'nama',
        'gender',
        'tanggal_lahir',
        'alamat',
        'nomor_hp',
        'nomor_wali',
        'prodi_id',
        'is_disabled',
        'image'
    ];
    public function pasienToProdi() {
        return $this->belongsTo(ProdiTable::class, 'prodi_id');
    }

    public function pasienToAntrian(){
        return $this->hasMany(AntrianTable::class, 'pasien_id');
    }
}
