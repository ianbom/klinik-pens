<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Obat extends Model
{
    use HasFactory;
    protected $table = 'obats';

    protected $fillable = ['nama_obat', 'tanggal_kadaluarsa', 'stock', 'harga', 'kategori_id', 'image', 'is_disabled'];

    public function obatToKategoriObat(){
        return $this->belongsTo(KategoriObat::class, 'kategori_id');
    }
    public function obatToResep(){
        return $this->hasMany(DetailResepObat::class);
    }
}
