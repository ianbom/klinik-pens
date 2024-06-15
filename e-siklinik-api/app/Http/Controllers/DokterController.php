<?php

namespace App\Http\Controllers;

use App\Models\Dokter;
use App\Models\JadwalDokter;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\DB;

use Exception;

class DokterController extends Controller
{
      /**
       * Display a listing of the resource.
       */
      public function index()
      {
            $dokter = Dokter::with('dokterToJadwal')->where('is_disabled', '=', false)->get();

            //return view('dokter_index')->with('dokter', $dokter);

            return response()->json(['message' => 'Succes tampil dokter', 'dokter' => $dokter]);
      }

      public function deletedDokter()
      {
            $dokter = Dokter::with('dokterToJadwal')->where('is_disabled', '=', true)->get();
            return response()->json(['message' => "Data dokter yang terhapus", 'dokter' => $dokter]);
      }

      /**
       * Show the form for creating a new resource.
       */
      public function create()
      {
            $dokter = Dokter::all();

            return response()->json(['message' => 'Succes tampil dokter', 'dokter' => $dokter]);
      }

      /**
       * Store a newly created resource in storage.
       */
      public function store(Request $request)
      {
            $file = $request->file('image');
            $path = time() . '_' . $request->name . '.' . $file->getClientOriginalExtension();

            Storage::disk('local')->put('public/' . $path, file_get_contents($file));

            $dokter = Dokter::create([
                  'nama' => $request->nama,
                  'gender' => $request->gender,
                  'tanggal_lahir' => $request->tanggal_lahir,
                  'alamat' => $request->alamat,
                  'nomor_hp' => $request->nomor_hp,
                  'image' => $path

            ]);

            return response()->json(['message' => 'Succes inpurt dokter', 'dokter' => $dokter]);
      }

      /**
       * Display the specified resource.
       */
      public function show(string $id)
      {
            $dokter = Dokter::with('dokterToJadwal')->find($id);

            return response()->json(['message' => 'Success tampil data dokter', 'dokter' => $dokter]);
      }

      /**
       * Show the form for editing the specified resource.
       */
      public function edit(string $id)
      {
            $dokter = Dokter::find($id);

            return response()->json(['message' => 'Success tampil data dokter', 'dokter' => $dokter]);
      }

      /**
       * Update the specified resource in storage.
       */
      public function update(Request $request, $id)
      {

            $dokter = Dokter::find($id);

            if (!$dokter) {
                  return response()->json(['message' => 'Dokter not found'], 404);
            }

            if ($request->hasFile('image')) {
                  $file = $request->file('image');
                  $path = time() . '_' . $request->name . '.' . $file->getClientOriginalExtension();


                  $file->storeAs('public', $path);


                  if ($dokter->image) {
                        Storage::disk('local')->delete('public/' . $dokter->image);
                  }


                  $dokter->image = $path;
            }

            if ($request->has('nama')) {
                  $dokter->nama = $request->nama;
            }

            if ($request->has('gender')) {
                  $dokter->gender = $request->gender;
            }

            if ($request->has('tanggal_lahir')) {
                  $dokter->tanggal_lahir = $request->tanggal_lahir;
            }

            if ($request->has('alamat')) {
                  $dokter->alamat = $request->alamat;
            }

            if ($request->has('nomor_hp')) {
                  $dokter->nomor_hp = $request->nomor_hp;
            }

            $dokter->save();

            return response()->json(['message' => 'Success update data Dokter', 'dokter' => $dokter]);
      }

      /**
       * Remove the specified resource from storage.
       */
      public function destroy(string $id)
      {
            $dokter = Dokter::findOrFail($id);
            $dokter->is_disabled = true;
            $dokter->save();
            return response()->json(['message' => 'Success delete data dokter']);
      }

      // Jadwal Dokter

      public function indexJadwal()
{
    $jadwal_dokter = JadwalDokter::with(['jadwalToDokter' => function ($query) {
        $query->where('is_disabled', false);
    }])
    ->whereHas('jadwalToDokter', function ($query) {
        $query->where('is_disabled', false);
    })
    ->get();

    return response()->json(['message' => 'Success tampil jadwal dokter', 'jadwal_dokter' => $jadwal_dokter]);
}

      public function jadwalToday(String $day)
      {
            try {
                  $jadwal_dokter = DB::table('jadwal_dokters')->select('jadwal_dokters.id', 'jadwal_dokters.hari', 'jadwal_dokters.jadwal_mulai_tugas', 'jadwal_dokters.jadwal_selesai_tugas', 'jadwal_dokters.dokter_id', 'jadwal_dokters.created_at', 'jadwal_dokters.updated_at')
                        ->join('dokter', 'jadwal_dokters.dokter_id', '=', 'dokter.id')
                        ->addSelect('dokter.*')
                        ->where('jadwal_dokters.hari', $day)->get();
                  if (sizeof($jadwal_dokter) > 0) {
                        return response()->json(['status' => 200, 'message' => 'Success tampil jadwal dokter', 'jadwal_dokter' => $jadwal_dokter]);
                  } else {
                        return response()->json(['status' => 200, 'message' => 'Success tampil jadwal dokter', 'jadwal_dokter' => []]);
                  }
            } catch (Exception $exception) {
                  return response()->json(['status' => 500, 'message' => 'Error: ' . $exception]);
            }
      }

      public function updateJadwal(int $id, Request $request)
      {
            try {
                  $jadwalDokter = JadwalDokter::find($id);
                  $jadwalDokter->hari = $request->hari;
                  $jadwalDokter->jadwal_mulai_tugas = $request->jadwal_mulai_tugas;
                  $jadwalDokter->jadwal_selesai_tugas = $request->jadwal_selesai_tugas;
                  $jadwalDokter->save();

                  return response()->json(['status' => 200, 'message' => 'Berhasil update jadwal dokter']);
            } catch (Exception $exception) {
                  return response()->json(['status' => 500, 'message' => 'Gagal update jadwal dokter']);
            }
      }


      public function storeJadwal(Request $request)
      {

            $jadwal_dokter = JadwalDokter::create([
                  'dokter_id' => $request->dokter_id,
                  'hari' => $request->hari,
                  'jadwal_mulai_tugas' => $request->jadwal_mulai_tugas,
                  'jadwal_selesai_tugas' => $request->jadwal_selesai_tugas
            ]);

            return response()->json(['message' => 'Succes input jadwal dokter', 'jadwal_dokter' => $jadwal_dokter]);
      }

      public function deleteJadwal($id)
      {
            $jadwal_dokter = JadwalDokter::find($id);
            $jadwal_dokter->delete();
            return response()->json(['message' => 'Success delete data jadwal dokter']);
      }

      public function aktifDokter($id)
      {
            $dokter = Dokter::find($id);
            if ($dokter->is_disabled == true) {
                  $dokter->is_disabled = false;
                  $dokter->save();
                  return response()->json(['message' => 'Success aktifkan data dokter']);
            }
      }

      public function disabledDokter($id)
      {
            $dokter = Dokter::find($id);
            if ($dokter->is_disabled == false) {
                  $dokter->is_disabled = true;
                  $dokter->save();
                  return response()->json(['message' => 'Success disable data dokter']);
            }
      }
}
