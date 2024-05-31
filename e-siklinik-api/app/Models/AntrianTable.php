<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class AntrianTable extends Model
{
      use HasFactory;

      protected $table = 'antrian';

      protected $fillable = [
            'pasien_id',
            'no_antrian',
            'status'
      ];

      public function antrianToPasien()
      {
            return $this->belongsTo(PasienTable::class, 'pasien_id');
      }


      public function antrianToAssesmen()
      {
            return $this->belongsTo(CheckupAssesmen::class, 'antrian_id', 'id');
      }
}
