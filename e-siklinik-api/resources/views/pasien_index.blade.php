<!-- resources/views/pasien_index.blade.php -->

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Daftar Pasien</title>
</head>
<body>
    <h1>Daftar Pasien</h1>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>NRP</th>
                <th>Nama</th>
                <th>Gender</th>
                <th>Tanggal Lahir</th>
                <th>Alamat</th>
                <th>Nomor HP</th>
                <th>Nomor Wali</th>
                <th>Prodi</th>
                <th>Created At</th>
                <th>Updated At</th>
            </tr>
        </thead>
        <tbody>
            @foreach ($pasien as $p)
            <tr>
                <td>
                    @if ($p->image)
                    <img src="{{ url('storage/' . $p->image) }}"
                    alt="">
                    @else
                        <span>No Image</span>
                    @endif
                </td>
                <td>{{ $p->id }}</td>
                <td>{{ $p->nrp }}</td>
                <td>{{ $p->nama }}</td>
                <td>{{ $p->gender }}</td>
                <td>{{ $p->tanggal_lahir }}</td>
                <td>{{ $p->alamat }}</td>
                <td>{{ $p->nomor_hp }}</td>
                <td>{{ $p->nomor_wali }}</td>
                <td>{{ $p->pasienToProdi->nama }}</td> <!-- Menampilkan nama prodi -->
                <td>{{ $p->created_at }}</td>
                <td>{{ $p->updated_at }}</td>
            </tr>
            @endforeach
        </tbody>
    </table>
</body>
</html>
