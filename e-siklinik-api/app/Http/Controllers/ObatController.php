<?php

namespace App\Http\Controllers;

// use App\Models\Obat;

use App\Models\DetailResepObat;
use App\Models\KategoriObat;
use App\Models\Obat;
use App\Models\Dokter;
use Illuminate\Support\Facades\Storage;
use Exception;
use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;

use function PHPUnit\Framework\isNull;

class ObatController extends Controller
{
      /**
       * Display a listing of the resource.
       */
      public function index()
      {


            $obat = Obat::with('obatToKategoriObat')->where('is_disabled', '=', false)->get();
            return response()->json(['status' => 200, 'obats' => $obat]);
      }

      public function deletedObat()
      {
            $obat = Obat::with('obatToKategoriObat')->where('is_disabled', '=', true)->get();
            return response()->json(['status' => 200, 'obats' => $obat]);
      }
      /**
       * Store a newly created resource in storage.
       */

      // try {
      //     $file = $request->file('image');
      //     $path = time() . '_' . $request->nama . '.' . $file->getClientOriginalExtension();
      //     var_dump($path);

      //     $uploadRes = Storage::disk('local')->put('public/' . $path, file_get_contents($file));

      //     if ($uploadRes == false) {
      //         throw new Exception("Upload gambar gagal", 500);
      //     } else {
      //         $response = Obat::create([
      //             'nama_obat' => $request->nama,
      //             'tanggal_kadaluarsa' => $request->kadaluarsa,
      //             'stock' => $request->stock,
      //             'harga' => $request->harga,
      //             'kategori_id' => $request->kategoriId,
      //             'image' => $path,
      //         ]);
      //         if (isNull($response)) {
      //             return response()->json(["status" => 200, "message" => "Berhasil input obat", "obats" => $response]);
      //         } else {
      //             throw new Exception();
      //         }
      //     }
      // } catch (Exception $exception) {
      //     return response()->json(["status" => 500, "message" => "Error: " . $exception->getMessage()]);
      // }
      public function store(Request $request)
      {

            $file = $request->file('image');
            $path = time() . '_' . $request->name . '.' . $file->getClientOriginalExtension();

            Storage::disk('local')->put('public/' . $path, file_get_contents($file));

            $obats = Obat::create([
                  'nama_obat' => $request->nama_obat,
                  'tanggal_kadaluarsa' => $request->tanggal_kadaluarsa,
                  'stock' => $request->stock,
                  'harga' => $request->harga,
                  'kategori_id' => $request->kategori_id,
                  'image' => $path
            ]);

            return response()->json(['message' => 'Succes input obat', 'obats' => $obats]);
      }

      /**
       * Display the specified resource.
       */
      public function show(string $id)
      {
            $obat = Obat::with('obatToKategoriObat')->find($id);
            return response()->json(['status' => 200, 'obats' => $obat]);
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

            $obat = Obat::find($id);

            if (!$obat) {
                  return response()->json(['message' => 'Obat not found'], 404);
            }

            if ($request->hasFile('image')) {
                  $file = $request->file('image');
                  $path = time() . '_' . $request->nama . '.' . $file->getClientOriginalExtension();


                  $file->storeAs('public', $path);


                  if ($obat->image) {
                        Storage::disk('local')->delete('public/' . $obat->image);
                  }


                  $obat->image = $path;
            }

            if ($request->has('nama_obat')) {
                  $obat->nama_obat = $request->nama_obat;
            }

            if ($request->has('tanggal_kadaluarsa')) {
                  $obat->tanggal_kadaluarsa = $request->tanggal_kadaluarsa;
            }

            if ($request->has('stock')) {
                  $obat->stock = $request->stock;
            }

            if ($request->has('harga')) {
                  $obat->harga = $request->harga;
            }
            if ($request->has('kategori_id')) {
                  $obat->kategori_id = $request->kategori_id;
            }

            $obat->save();

            return response()->json(['message' => 'Succes update obat']);
      }

      /**
       * Remove the specified resource from storage.
       */
      public function destroy(string $id)
      {
            $obat = Obat::findOrFail($id);
            try {
                  $response = $obat->delete();
                  if ($response == true) {
                        return response()->json(["status" => 200, "message" => "Berhasil hapus obat"]);
                  } else {
                        throw new Exception("Data tidak ditemukan", 500);
                  }
            } catch (Exception $exception) {
                  return response()->json(["status" => 500, "messasge" => "Error: " . $exception]);
            }
      }

      /**
       * Show data kategori obat
       */
      public function getKategori()
      {
            $kategori = KategoriObat::with('kategoriObatToObat')->get();
            if ($kategori->isNotEmpty()) {
                  return response()->json(['message' => 'Data berhasil ditampilkan', 'kategori' => $kategori]);
            } else {
                  return response()->json(['message' => 'Belum ada data']);
            }
      }
      /**
       * Show data kategori obat
       */
      public function storeKategoriObat(Request $request)
      {
            try {
                  $response = KategoriObat::create([
                        'nama_kategori' => $request->nama
                  ]);
                  if (isNull($response)) {
                        return response()->json(['message' => 'Succes input kategori obat']);
                  } else {
                        throw new Exception();
                  }
            } catch (Exception $exception) {
                  return response()->json(["status" => 500, "messasge" => "Error: " . $exception]);
            }
      }
      public function updateKategoriObat(Request $request, int $id)
      {
            try {
                  $kategori = KategoriObat::find($id);
                  if ($kategori != null) {
                        $kategori->nama_kategori = $request->namaKategori;
                        $response = $kategori->save();
                        if ($response == true) {
                              return response()->json(["status" => 200, "message" => "Berhasil update kategori obat"]);
                        }
                  } else {
                        throw new Exception('Data kategori obat tidak ditemukan.');
                  }
            } catch (Exception $exception) {
                  return response()->json(["status" => 500, "messasge" => "Error: " . $exception]);
            }
      }
      /**
       * Delete data kategori obat
       */
      public function destroyKategoriObat(string $id)
      {
            $kategoriObat = KategoriObat::findOrFail($id);
            try {
                  $response = $kategoriObat->delete();
                  if ($response == true) {
                        return response()->json(["status" => 200, "message" => "Berhasil hapus kategori"]);
                  } else {
                        throw new Exception("Data tidak ditemukan", 500);
                  }
            } catch (Exception $exception) {
                  return response()->json(["status" => 500, "messasge" => "Error: " . $exception]);
            }
      }

      public function indexDetailResepObat()
      {
            $detailResep = DetailResepObat::with('detailResepToObat.obatToKategoriObat', 'detailResepToCheckUpResult.checkUpResulToAssesmen.assesmenToAntrian.antrianToPasien')->get();

            return response()->json(['message' => 'Data resep obat berhasil ditampilkan', 'detailResep' => $detailResep]);
      }


      public function disableObat($id)
      {
            $obat = Obat::find($id);
            if ($obat->is_disabled == false) {
                  $obat->is_disabled = true;
                  $obat->save();
                  return response()->json(['message' => 'Success disable data obat']);
            }
            if ($obat->is_disabled == true) {
                  $obat->is_disabled = false;
                  $obat->save();
                  return response()->json(['message' => 'Success aktifkan data obat']);
            }
      }
}

