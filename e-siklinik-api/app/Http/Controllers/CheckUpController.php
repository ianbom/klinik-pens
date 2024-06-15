<?php

namespace App\Http\Controllers;

use App\Models\AntrianTable;
use App\Models\CheckupAssesmen;
use App\Models\CheckUpResult;
use App\Models\DetailResepObat;
use App\Models\Obat;
use Exception;
use Illuminate\Http\Request;
use function PHPUnit\Framework\isNull;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Psy\VersionUpdater\Checker;

class CheckUpController extends Controller
{
      /**
       * Display a listing of the resource.
       */

      // $results = CheckUpResult::with('checkUpResulToAssesmen')->with('checkUpResultToDetailResep')->get();

      // if($results->count()==0){
      //     return response()->json(['status' => 400, 'results' => 'Belum ada data']);
      // }
      // return response()->json(['status' => 200, 'results' => $results]);

      // $results = DB::table('check_up_results')
      //     ->select('check_up_results.*')
      //     ->join('checkup_assesmens', 'check_up_results.assesmen_id', '=', 'checkup_assesmens.id')
      //     ->addSelect('checkup_assesmens.*')
      //     ->join('dokter', 'checkup_assesmens.dokter_id', '=', 'dokter.id')
      //     ->addSelect('dokter.*')
      //     ->join('antrian', 'checkup_assesmens.antrian_id', '=', 'antrian.id')
      //     ->addSelect('antrian.*')
      //     ->join('pasien', 'antrian.pasien_id', '=', 'pasien.id')
      //     ->addSelect('pasien.*')
      //     ->join('prodi', 'pasien.prodi_id', '=', 'prodi.id')
      //     ->addSelect('prodi.*')
      //     ->join('detail_resep_obats', 'detail_resep_obats.checkup_id', '=', 'check_up_results.id')
      //     ->addSelect('detail_resep_obats.*')
      //     ->join('obats', 'detail_resep_obats.obat_id', '=', 'obats.id')
      //     ->addSelect('obats.*')
      //     ->join('kategori_obats', 'obats.kategori_id', '=', 'kategori_obats.id')
      //     ->addSelect('kategori_obats.*')
      //     ->get();

      // if ($results->isEmpty()) {
      //     return response()->json(['status' => 400, 'results' => 'Belum ada data']);
      // }

      // return response()->json(['status' => 200, 'results' => $results]);
      public function index()
      {

            $checkup = CheckUpResult::with(
                  'checkUpResulToAssesmen.assesmenToDokter',
                  'checkUpResulToAssesmen.assesmenToAntrian.antrianToPasien.pasienToProdi',
                  'checkUpResultToDetailResep.detailResepToObat'
            )->get();
            return response()->json(['status' => 200, 'checkup' => $checkup]);
      }

      public function indexTerbaru()
      {
            $checkup = CheckUpResult::with(
                  'checkUpResulToAssesmen.assesmenToDokter',
                  'checkUpResulToAssesmen.assesmenToAntrian.antrianToPasien.pasienToProdi',
                  'checkUpResultToDetailResep.detailResepToObat'
            )
                  ->orderBy('created_at', 'desc')
                  ->take(5)
                  ->get();

            return response()->json(['status' => 200, 'checkup' => $checkup]);
      }


      public function riwayatPasien(int $pasienId)
      {
            // Ambil data checkup berdasarkan pasien_id yang diberikan
            $checkup = CheckUpResult::with([
                  'checkUpResulToAssesmen.assesmenToDokter',
                  'checkUpResulToAssesmen.assesmenToAntrian.antrianToPasien.pasienToProdi',
                  'checkUpResultToDetailResep.detailResepToObat'
            ])->whereHas('checkUpResulToAssesmen.assesmenToAntrian.antrianToPasien', function ($query) use ($pasienId) {
                  $query->where('pasien_id', $pasienId);
            })->get();

            return response()->json(['status' => 200, 'checkup' => $checkup]);
      }

      public function riwayatDokter(int $dokterId)
      {
            // Ambil data checkup berdasarkan dokter_id yang diberikan
            $checkup = CheckUpResult::with([
                  'checkUpResulToAssesmen.assesmenToDokter',
                  'checkUpResulToAssesmen.assesmenToAntrian.antrianToPasien.pasienToProdi',
                  'checkUpResultToDetailResep.detailResepToObat'
            ])->whereHas('checkUpResulToAssesmen.assesmenToDokter', function ($query) use ($dokterId) {
                  $query->where('dokter_id', $dokterId);
            })->get();

            return response()->json(['status' => 200, 'checkup' => $checkup]);
      }



      /**
       * Display a listing of the resource.
       */
      public function indexAssesmens()
      {
            $response = DB::table('dokter')
                  ->select(
                        'dokter.id as dokter_id',
                        'dokter.nama as nama_dokter',
                        'checkup_assesmens.id as checkup_assesmen_id',
                        'antrian.id as antrian_id',
                        'antrian.no_antrian',
                        'pasien.nama as nama_pasien',
                        'prodi.nama as nama_prodi'
                  )
                  ->join('checkup_assesmens', 'dokter.id', '=', 'checkup_assesmens.dokter_id')
                  ->join('antrian', 'checkup_assesmens.antrian_id', '=', 'antrian.id')
                  ->join('pasien', 'antrian.pasien_id', '=', 'pasien.id')
                  ->join('prodi', 'pasien.prodi_id', '=', 'prodi.id')
                  ->leftJoin('check_up_results', 'checkup_assesmens.id', '=', 'check_up_results.assesmen_id')
                  ->whereNull('check_up_results.id')
                  ->addSelect('checkup_assesmens.*', 'antrian.*', 'pasien.*', 'prodi.nama')
                  ->get();
            if ($response->count() == 0) {
                  return response()->json(['status' => 400, 'results' => 'Belum ada data']);
            }
            return response()->json(['status' => 200, 'results' => $response]);
      }

      /**
       * Show the form for creating a new resource.
       */
      public function create()
      {
            //
      }

      /**
       * Store a newly created resource in storage.
       */
      public function store(Request $request)
      {
            try {
                  $file = $request->file('image');
                  $path = time() . '_' . $request->nama . '.' . $file->getClientOriginalExtension();

                  $uploadRes = Storage::disk('local')->put('public/' . $path, file_get_contents($file));

                  if ($uploadRes == false) {
                        throw new Exception("Upload gambar gagal", 500);
                  } else {
                        $response = CheckUpResult::create([
                              'assesmen_id' => $request->assesmen_id,
                              'hasil_diagnosa' => $request->hasil_diagnosa,
                              'url_file' => $path,
                        ]);

                        if ($response) {
                              return response()->json(["status" => 200, "message" => "Berhasil input hasil checkup"]);
                        } else {
                              throw new Exception();
                        }
                  }
            } catch (Exception $exception) {
                  return response()->json(["status" => 500, "messasge" => "Error: " . $exception]);
            }
      }
      /**
       * Store a CheckUpAssesment.
       */
      public function storeAssesmen(Request $request)
      {
            try {
                  $response = CheckupAssesmen::create([
                        'antrian_id' => $request->antrian_id,
                        'dokter_id' => $request->dokter_id,
                  ]);
                  if (isNull($response)) {

                        $res = AntrianTable::findOrFail($request->antrian_id);
                        $res->status = 'Sedang';
                        $res->save();
                        return response()->json(["status" => 200, "message" => "Berhasil input assesmen"]);
                  } else {
                        throw new Exception();
                  }
            } catch (Exception $exception) {
                  return response()->json(['message' => $exception->getMessage()]);
            }
      }

      /**
       * Display the specified resource.
       */
      public function show(string $id)
{
    $results = DB::table('check_up_results')
        ->select('check_up_results.*')
        ->join('checkup_assesmens', 'check_up_results.assesmen_id', '=', 'checkup_assesmens.id')
        ->addSelect('checkup_assesmens.*')
        ->join('dokter', 'checkup_assesmens.dokter_id', '=', 'dokter.id')
        ->addSelect('dokter.nama as nama_dokter, dokter.id as dokter_id, dokter.tanggal_lahir as tanggal_lahir_dokter, dokter.alamat as dokter_address, dokter.gender as dokter_gender, dokter.nomor_hp as dokter_phone_no, dokter.image as dokter_image, dokter.is_disabled as dokter_is_disabled ')
        ->join('antrian', 'checkup_assesmens.antrian_id', '=', 'antrian.id')
        ->addSelect('antrian.*')
        ->join('pasien', 'antrian.pasien_id', '=', 'pasien.id')
        ->addSelect(
            'pasien.nama as nama_pasien',
            'pasien.id as pasien_id',
            'pasien.gender as pasien_gender',
            'pasien.nrp as pasien_nrp',
            'pasien.tanggal_lahir as tanggal_lahir_pasien',
            'pasien.alamat as pasien_address',
            'pasien.nomor_hp as pasien_phone_no',
            'pasien.nomor_wali as pasien_wali_no',
            'pasien.prodi_id as pasien_prodi_id',
            'pasien.image as pasien_image',
            'pasien.is_disabled as pasien_is_disabled'
        )
        ->join('prodi', 'pasien.prodi_id', '=', 'prodi.id')
        ->addSelect('prodi.*')
        ->where('check_up_results.id', '=', $id)
        ->first();

    if ($results) {
        // Fetch detail_resep_obats related to this check_up_result
        $detailResepObats = DB::table('detail_resep_obats')
            ->join('obats', 'detail_resep_obats.obat_id', '=', 'obats.id')
            ->where('detail_resep_obats.checkup_id', '=', $id)
            ->select(
                'detail_resep_obats.id as detail_resep_obats_id',
                'detail_resep_obats.obat_id as detail_resep_obat_id',
                'detail_resep_obats.checkup_id as detail_resep_obats_checkup_id',
                'detail_resep_obats.jumlah_pemakaian as detail_jumlah_pemakaian',
                'detail_resep_obats.waktu_pemakaian as detail_waktu_pemakaian',
                'obats.nama_obat as nama_obat',
                'obats.tanggal_kadaluarsa as tanggal_kadaluarsa',
                'obats.stock as stock',
                'obats.harga as harga',
                'obats.image as obat_image'
            )
            ->get();

        $results->detail_resep_obats = $detailResepObats;

        return response()->json(['status' => 200, 'results' => $results]);
    }
    return response()->json(['status' => 400, 'results' => 'Belum ada data']);
}

      /**
       * Display the specified assesmen.
       */
      public function showAssesmen(string $id)
      {
            try {
                  $response = DB::table('dokter')
                        ->select(
                              'dokter.id as dokter_id',
                              'dokter.nama as nama_dokter',
                              'checkup_assesmens.id as checkup_assesmen_id',
                              'antrian.id as antrian_id',
                              'antrian.no_antrian',
                              'pasien.nama as nama_pasien',
                              'prodi.nama as nama_prodi'
                        )
                        ->join('checkup_assesmens', 'dokter.id', '=', 'checkup_assesmens.dokter_id')
                        ->join('antrian', 'checkup_assesmens.antrian_id', '=', 'antrian.id')
                        ->join('pasien', 'antrian.pasien_id', '=', 'pasien.id')
                        ->join('prodi', 'pasien.prodi_id', '=', 'prodi.id')
                        ->addSelect('checkup_assesmens.*', 'antrian.*', 'pasien.*', 'prodi.nama')
                        ->where('checkup_assesmens.id', '=', $id)
                        ->first();

                  if ($response) {
                        return response()->json(['status' => 200, 'results' => $response]);
                  } else {
                        return response()->json(['status' => 400, 'results' => 'Data not found']);
                  }
            } catch (Exception $exception) {
                  return response()->json(['message' => $exception->getMessage()]);
            }
      }


      /**
       * Show the form for editing the specified resource.
       */
      public function edit(string $id)
      {
            //
      }

      /**
       * Update the specified resource in storage.
       */
      public function update(Request $request, string $id)
      {
            //
      }

      /**
       * Remove the specified resource from storage.
       */
      public function destroy(string $id)
      {
            //
      }

      public function storeCheckupWithResepObat(Request $request)
{
    DB::beginTransaction();

    try {
        $path = null;
        if ($request->hasFile('image')) {
            $file = $request->file('image');
            $path = time() . '_' . $file->getClientOriginalExtension();
            $uploadRes = Storage::disk('local')->put('public/' . $path, file_get_contents($file));

            if ($uploadRes === false) {
                throw new Exception("Upload gambar gagal", 500);
            }
        }

        $checkupResult = CheckUpResult::create([
            'assesmen_id' => $request->assesmen_id,
            'hasil_diagnosa' => $request->hasil_diagnosa,
            'url_file' => $path,
        ]);

        if ($checkupResult) {
            $resepObatList = json_decode($request->resep_obat, true);

            foreach ($resepObatList as $resep) {
                // Find the obat record
                $obat = Obat::findOrFail($resep['obat_id']);
                    $obat->stock -= 1;

                    if ($obat->stock == 0 ){
                        $obat->is_disabled = true;
                  }

                  $obat->save();





                // Create the detail resep obat record
                DetailResepObat::create([
                    'obat_id' => $resep['obat_id'],
                    'checkup_id' => $checkupResult->id,
                    'jumlah_pemakaian' => $resep['jumlah_pemakaian'],
                    'waktu_pemakaian' => $resep['waktu_pemakaian'],
                ]);
            }

            DB::commit();
            $antrianId = DB::table('checkup_assesmens')
                ->where('checkup_assesmens.id', $request->assesmen_id)
                ->value('antrian_id'); // Use value() to directly get the antrian_id

            if ($antrianId) {
                // Find the corresponding antrian record and update its status
                $res = AntrianTable::findOrFail($antrianId);
                $res->status = 'Selesai';
                $res->save();
                return response()->json(["status" => 200, "message" => "Berhasil input hasil checkup dan resep obat"]);
            } else {
                throw new Exception("Gagal menyimpan hasil checkup");
            }
        }
    } catch (Exception $exception) {
        DB::rollBack();
        return response()->json(["status" => 500, "message" => "Error: " . $exception->getMessage()]);
    }
}

}
