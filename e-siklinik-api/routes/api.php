<?php

use App\Http\Controllers\AntrianController;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\CheckUpController;
use App\Http\Controllers\DetailResepObatController;
use App\Http\Controllers\DokterController;
use App\Http\Controllers\ObatController;
use App\Http\Controllers\PasienController;
use App\Http\Controllers\ProdiController;
use App\Models\CheckUpResult;
use App\Models\DetailResepObat;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
      return $request->user();
});

//AUTH

Route::get('/user', [AuthController::class, 'index']);
Route::post('/register', [AuthController::class, 'Register']);
Route::post('/login', [AuthController::class, 'login']);
Route::put('/user/{id}', [AuthController::class, 'Edit']);



//PASIEN
Route::get('/pasien', [PasienController::class, 'index'])->name('pasien.index');
Route::post('/pasien/create', [PasienController::class, 'store'])->name('pasien.store');
Route::put('/pasien/disabled/{id}', [PasienController::class, 'disablePasien'])->name('pasien.disabled');
Route::post('/pasien/aktif/{id}', [PasienController::class, 'aktifPasien'])->name('pasien.aktif');
Route::get('/pasien/show/{id}', [PasienController::class, 'show'])->name('pasien.show');
Route::post('/pasien/update/{id}', [PasienController::class, 'update'])->name('pasien.update');
Route::delete('/pasien/delete/{id}', [PasienController::class, 'destroy'])->name('pasien.destroy');

// PRODI
Route::get('/prodi', [ProdiController::class, 'index'])->name('prodi.create');
Route::post('/prodi/create', [ProdiController::class, 'store'])->name('prodi.store');
Route::get('/prodi/show/{id}', [ProdiController::class, 'show'])->name('prodi.show');
Route::post('/prodi/update/{id}', [ProdiController::class, 'update'])->name('prodi.update');
Route::delete('/prodi/delete/{id}', [ProdiController::class, 'destroy'])->name('prodi.destroy');

//ANTRIAN
Route::get('/antrian', [AntrianController::class, 'index'])->name('antrian.index');
Route::get('/antrian/show/{id}', [AntrianController::class, 'show'])->name('antrian.show');
Route::post('/antrian/create', [AntrianController::class, 'store'])->name('antrian.store');
Route::get('/antrian/finished-assesmen', [AntrianController::class, 'finishedAssesmen']);
//Route::post('/antrian', [AntrianController::class, 'upadte'])->name('antrian.upadte');

//DOKTER
Route::get('/dokter', [DokterController::class, 'index'])->name('dokter.index');
Route::post('/dokter/create', [DokterController::class, 'store'])->name('dokter.store');
Route::put('/dokter/disabled/{id}', [DokterController::class, 'disabledDokter'])->name('dokter.disabled');
Route::get('/dokter/show/{id}', [DokterController::class, 'show'])->name('dokter.show');
Route::post('/dokter/update/{id}', [DokterController::class, 'update'])->name('dokter.update');
Route::delete('/dokter/delete/{id}', [DokterController::class, 'destroy'])->name('dokter.destroy');

//JADWAL DOKTER
Route::get('/jadwal_dokter', [DokterController::class, 'indexJadwal'])->name('jadwal_dokter.index');
Route::get('/jadwal_dokter/today/{day}', [DokterController::class, 'jadwalToday']);
Route::post('/jadwal_dokter/create', [DokterController::class, 'storeJadwal'])->name('jadwal_dokter.store');
Route::post('/jadwal_dokter/update/{id}', [DokterController::class, 'updateJadwal']);
Route::delete('/jadwal_dokter/delete/{id}', [DokterController::class, 'deleteJadwal'])->name('jadwal_dokter.destroy');

//OBAT Controller
Route::get('/obat', [ObatController::class, 'index'])->name('obat.index');
Route::get('/kategori-obat', [ObatController::class, 'getKategori']);
Route::post('/obat/insert', [ObatController::class, 'store'])->name('obat.store');
Route::post('/kategori-obat/insert', [ObatController::class, 'storeKategoriObat']);
Route::get('/obat/{id}/show', [ObatController::class, 'show'])->name('obat.show');
Route::post('/obat/{id}/update', [ObatController::class, 'update'])->name('obat.update');
Route::put('/kategori-obat/{id}/update', [ObatController::class, 'updateKategoriObat']);
Route::delete('/obat/{id}/delete', [ObatController::class, 'destroy'])->name('obat.destroy');
Route::delete('/kategori-obat/{id}/delete', [ObatController::class, 'destroyKategoriObat']);
Route::get('/detail-resep', [ObatController::class, 'indexDetailResepObat']);


// Checkup Result
Route::get('/checkup-result', [CheckUpController::class, 'index']);
Route::get('/checkup-result-terbaru', [CheckUpController::class, 'indexTerbaru']);
Route::get('/riwayat-pasien/{id}', [CheckUpController::class, 'riwayatPasien']);
Route::get('/riwayat-dokter/{id}', [CheckUpController::class, 'riwayatDokter']);
Route::get('/checkup-result/show/{id}', [CheckUpController::class, 'show']);
Route::get('/checkup-assesmen', [CheckUpController::class, 'indexAssesmens']);
Route::get('/checkup-assesmen/show/{id}', [CheckUpController::class, 'showAssesmen']);
Route::post('/checkup-result/insert', [CheckUpController::class, 'store']);
Route::post('/checkup-assesmen/insert', [CheckUpController::class, 'storeAssesmen']);
Route::get('/detail-resep-obat', [DetailResepObatController::class, 'index']);
Route::post('/detail-resep-obat/insert', [DetailResepObatController::class, 'store']);
Route::get('/detail-resep-obat/show/{id}', [DetailResepObatController::class, 'show']);
Route::delete('/detail-resep-obat/{id}/delete', [DetailResepObatController::class, 'destroy']);
Route::post('/checkup-obat/insert', [CheckUpController::class, 'storeCheckupWithResepObat']);
