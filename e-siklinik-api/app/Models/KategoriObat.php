<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class KategoriObat extends Model
{
    use HasFactory;
    protected $table = 'kategori_obats';
    protected $fillable = ['nama_kategori'];

    public function kategoriObatToObat(){
        return $this->hasMany(Obat::class, 'kategori_id');
    }
}
