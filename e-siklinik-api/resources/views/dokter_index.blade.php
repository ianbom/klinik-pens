<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Daftar Dokter</title>
</head>
<body>
    <h1>Daftar Dokter</h1>
    <table>
        <thead>
            <tr>
                <th>Nama</th>
                <th>Gender</th>
                <th>Tanggal Lahir</th>
                <th>Alamat</th>
                <th>Nomor HP</th>
                <th>Image</th>
            </tr>
        </thead>
        <tbody>
            @foreach($dokter as $d)
                <tr>
                    <td>{{ $d->nama }}</td>
                    <td>{{ $d->gender }}</td>
                    <td>{{ $d->tanggal_lahir }}</td>
                    <td>{{ $d->alamat }}</td>
                    <td>{{ $d->nomor_hp }}</td>
                    <td><img src="{{ url('storage/' . $d->image) }}"
                        alt=""></td>
                </tr>
            @endforeach
        </tbody>
    </table>
</body>
</html>
