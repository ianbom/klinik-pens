<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class CheckUpResult extends Model
{
    use HasFactory;

    protected $table = 'check_up_results';

    protected $fillable = ['assesmen_id', 'hasil_diagnosa', 'url_file'];

    public function checkUpResulToAssesmen(){
        return $this->belongsTo(CheckupAssesmen::class, 'assesmen_id');
    }
    public function checkUpResultToDetailResep(){
        return $this->hasMany(DetailResepObat::class, 'checkup_id');
    }
}
