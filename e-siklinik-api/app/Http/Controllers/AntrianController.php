<?php

namespace App\Http\Controllers;

use App\Models\AntrianTable;
use Illuminate\Support\Facades\DB;
use Exception;
use Illuminate\Http\Request;

class AntrianController extends Controller
{
      /**
       * Display a listing of the resource.
       */
      public function index()
      {
            $antrian = AntrianTable::with('antrianToPasien')->get();
            return response()->json(['message' => 'Succes tampil antrian', 'antrian' => $antrian]);
      }

      /**
       * Show the form for creating a new resource.
       */
      public function create()
      {
            $antrian = AntrianTable::all();
            return response()->json(['message' => 'Succes input antrian', 'antrian' => $antrian]);
      }

      /**
       * Store a newly created resource in storage.
       */
      public function store(Request $request)
      {


            try {
                  AntrianTable::create([
                        'pasien_id' => $request->pasien_id,
                        'no_antrian' => $request->no_antrian,
                        'status' => 'Belum'
                  ]);
                  return response()->json(["status" => 200, "messasge" => "Nomor antrian "]);
            } catch (Exception $exception) {
                  return response()->json(["status" => 500, "messasge" => "Error: " . $exception]);
            }
      }

      /**
       * Display the specified resource.
       */
      public function show(string $id)
      {
            try {
                  $response = DB::table('antrian')->join('pasien', 'antrian.pasien_id', '=', 'pasien.id')->where('antrian.id', '=', $id)->get();
                  return response()->json(["status" => 200, "antrian" => $response]);
            } catch (Exception $exception) {
                  return response()->json(["status" => 500, "messasge" => "Error: " . $exception]);
            }
      }

      /**
       * Show the form for editing the specified resource.
       */
      public function finishedAssesmen()
      {
            $response = DB::table('antrian')
                  ->select(
                        'antrian.id',
                        'antrian.no_antrian',
                        'pasien.nama as nama_pasien',
                        'prodi.nama as nama_prodi'
                  )
                  ->join('checkup_assesmens', 'checkup_assesmens.antrian_id', '=', 'antrian.id')
                  ->join('check_up_results', 'checkup_assesmens.id', '=', 'check_up_results.assesmen_id')
                  ->join('pasien', 'antrian.pasien_id', '=', 'pasien.id')
                  ->join('prodi', 'pasien.prodi_id', '=', 'prodi.id')
                  ->addSelect('checkup_assesmens.*', 'antrian.*', 'pasien.*', 'prodi.nama')
                  ->orderBy('antrian.no_antrian', 'asc')
                  ->get();

            if ($response->count() == 0) {
                  return response()->json(['status' => 200, 'results' => []]);
            }

            return response()->json(['status' => 200, 'results' => $response]);
      }
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

      private function nomorAntrianChecker(): int
      {
            $latestAntrian = AntrianTable::latest()->first();
            $latestAntrianDate = '';
            if ($latestAntrian !== null) {
                  $latestAntrianDate = date("Y-m-d", strtotime($latestAntrian->created_at));
            }

            if ($latestAntrian === null || date('Y-m-d') > $latestAntrianDate) {
                  $nomorAntrian = 1;
                  return $nomorAntrian;
            } else if ($latestAntrian === null || date('Y-m-d') < $latestAntrianDate) {
                  return 0;
            } else {
                  $nomorAntrian = $latestAntrian->no_antrian + 1;
                  return $nomorAntrian;
            }
      }
}
