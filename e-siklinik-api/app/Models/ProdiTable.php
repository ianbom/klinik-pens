<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ProdiTable extends Model
{
    use HasFactory;

    protected $table = 'prodi';

    protected $fillable = [
        'nama'
    ];
    public function prodiToPasien()
    {
        return $this->hasMany(PasienTable::class, 'prodi_id');
    }





}
