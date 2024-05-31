<?php

namespace App\Http\Controllers;

use App\Models\DetailResepObat;
use Exception;
use Illuminate\Http\Request;
Use Illuminate\Support\Facades\DB;
use App\Models\Obat;

use function PHPUnit\Framework\isNull;

class DetailResepObatController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $response = DB::table('detail_resep_obats')->addSelect('detail_resep_obats.*')->join('obats', 'detail_resep_obats.obat_id', '=', 'obats.id')->addSelect('obats.*')->join('kategori_obats', 'obats.kategori_id', '=', 'kategori_obats.id')->addSelect('kategori_obats.*')->join('check_up_results', 'detail_resep_obats.checkup_id', '=', 'check_up_results.id')->addSelect('check_up_results.*')->get();
        if($response->isEmpty()){
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
        try{
            $response = DetailResepObat::create([
                'obat_id'=>$request->obat_id,
                'checkup_id'=>$request->checkup_id,
                'jumlah_pemakaian'=>$request->jumlah_pemakaian,
                'waktu_pemakaian'=>$request->waktu_pemakaian
            ]);
            if (isNull($response)) {
                //$this->decreaseStock($request->jumlah_pemakaian, $request->obat_id);
                return response()->json(["status" => 200, "message" => "Berhasil input resep obat"]);
            } else {
                throw new Exception();
            }
        }catch(Exception $exception){
            return response()->json(['status' => 500, 'message' => "Error: $exception"]);
        }
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $response = DB::table('detail_resep_obats')->addSelect('detail_resep_obats.*')->join('obats', 'detail_resep_obats.obat_id', '=', 'obats.id')->addSelect('obats.*')->join('kategori_obats', 'obats.kategori_id', '=', 'kategori_obats.id')->addSelect('kategori_obats.*')->join('check_up_results', 'detail_resep_obats.checkup_id', '=', 'check_up_results.id')->addSelect('check_up_results.*')->where('detail_resep_obats.id', '=', $id)->first();
        if($response){

            return response()->json(['status' => 200, 'results' => $response]);
        }
        return response()->json(['status' => 400, 'results' => 'Belum ada data']);
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
        $detailResep = DetailResepObat::findOrFail($id);
        try {
            $response = $detailResep->delete();
            if ($response == true) {
                return response()->json(["status" => 200, "message" => "Berhasil hapus resep obat"]);
            } else {
                throw new Exception("Data tidak ditemukan", 500);
            }
        } catch (Exception $exception) {
            return response()->json(["status" => 500, "messasge" => "Error: " . $exception]);
        }
    }

    // private function decreaseStock(int $obat_id):void{
    //     $obat = Obat::find($obat_id);
    //     $currentStock = $obat->stock - 1;
    //     $obat->update([
    //         'stock' => $currentStock
    //     ]);
    // }
}
