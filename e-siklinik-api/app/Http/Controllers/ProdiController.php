<?php

namespace App\Http\Controllers;

use App\Models\ProdiTable;
use Illuminate\Http\Request;

class ProdiController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $prodi = ProdiTable::with('prodiToPasien')->get();

        return response()->json(['message' => 'Succes tampil Prodi', 'prodi'=> $prodi]);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        $prodi = ProdiTable::all();

        return response()->json(['message' => 'Succes tampil Prodi', 'prodi'=> $prodi]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $prodi = ProdiTable::create([
            'nama' => $request->nama
        ]);

        $prodi = ProdiTable::all();
        return response()->json(['message' => 'Succes input Prodi', 'prodi'=> $prodi]);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $prodi_id)
    {
        $prodi = ProdiTable::find($prodi_id);

        return response()->json(['message' => 'Succes show Prodi', 'prodi'=> $prodi]);
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit($id)
{
    $prodi = ProdiTable::find($id);

        return response()->json(['message' => 'Succes show Prodi', 'prodi'=> $prodi]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
{
    $request->validate([
        'nama' => 'required'
    ]);

    $prodi = ProdiTable::findOrFail($id);
    $prodi->update([
        'nama' => $request->nama
    ]);

        return response()->json(['message' => 'Succes update Prodi', 'prodi'=> $prodi]);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        $prodi = ProdiTable::find($id);
        $prodi->delete();
        return response()->json(['message' => 'Succes tampil Prodi']);
    }
}
