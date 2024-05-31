import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';

class Box extends StatelessWidget {
  final String bgimage;
  final String title;
  final String desc;
  final Widget icon;
  final VoidCallback onTapBox;
  const Box(
      {super.key,
      required this.title,
      required this.desc,
      required this.bgimage,
      required this.icon,
      required this.onTapBox});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTapBox,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.all(15),
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    offset: const Offset(-1, 2),
                    blurRadius: 3,
                    spreadRadius: 0,
                  ),
                ],
                image: DecorationImage(
                    image: AssetImage(bgimage), fit: BoxFit.fill)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      child: icon,
                    ),
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        desc,
                        style: const TextStyle(fontWeight: FontWeight.w300),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        )
      ],
    );
  }
}

class BoxSearchPage extends StatelessWidget {
  final VoidCallback onTapBox;
  final String nama;
  final String nrp;
  final Widget icon;
  final Widget prodi;

  const BoxSearchPage({
    super.key,
    required this.onTapBox,
    required this.nama,
    required this.nrp,
    required this.icon,
    required this.prodi,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTapBox,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.all(15),
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  offset: const Offset(-1, 2),
                  blurRadius: 3,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: icon,
                ),
                const SizedBox(
                  width: 15,
                ),
                SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        nama,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        nrp,
                        style: const TextStyle(fontWeight: FontWeight.w300),
                      ),
                      prodi
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        )
      ],
    );
  }
}

class BoxPasien extends StatelessWidget {
  final VoidCallback onTapBox;
  final VoidCallback onTapPop;
  final String nama;
  final String nrp;
  final String icon;
  final Widget prodi;

  const BoxPasien({
    super.key,
    required this.onTapBox,
    required this.nama,
    required this.nrp,
    required this.icon,
    required this.prodi,
    required this.onTapPop,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTapBox,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(15),
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  offset: const Offset(-1, 2),
                  blurRadius: 3,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 35,
                      height: 35,
                      decoration: ShapeDecoration(
                          image: DecorationImage(
                              image: NetworkImage(icon), fit: BoxFit.fill),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          color: const Color(0xFFDDEAFF)),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            nama,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            nrp,
                            style: const TextStyle(fontWeight: FontWeight.w300),
                          ),
                          prodi
                        ],
                      ),
                    ),
                  ],
                ),
                Center(
                  child: IconButton(
                      onPressed: onTapPop, icon: const Icon(Icons.more_vert)),
                )
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        )
      ],
    );
  }
}

class BoxDokter extends StatelessWidget {
  final VoidCallback onTapBox;
  final VoidCallback onTapPop;
  final String icon;
  final String nama;
  const BoxDokter(
      {super.key,
      required this.onTapBox,
      required this.icon,
      required this.nama,
      required this.onTapPop});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTapBox,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(15),
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  offset: const Offset(-1, 2),
                  blurRadius: 3,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          image: DecorationImage(
                              image: NetworkImage(icon), fit: BoxFit.fill),
                          color: const Color(0xFFDDEAFF)),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      nama,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 20),
                    )
                  ],
                ),
                IconButton(
                    onPressed: onTapPop, icon: const Icon(Icons.more_vert)),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        )
      ],
    );
  }
}

class BoxRiwayat extends StatelessWidget {
  final VoidCallback onTapBox;
  final String tanggal;
  final String nama;
  final String no;
  const BoxRiwayat(
      {super.key,
      required this.onTapBox,
      required this.tanggal,
      required this.nama,
      required this.no});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTapBox,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.all(15),
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  offset: const Offset(-1, 2),
                  blurRadius: 3,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFFB7D1FF),
                  radius: 25,
                  child: Icon(
                    Icons.person_outline,
                    color: Color(0xFF234DF0),
                    size: 40,
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'No. Antrian: $no',
                      style: TextStyle(fontSize: 13),
                    ),
                    Text(
                      nama,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    Text(
                      "Tanggal : $tanggal",
                      style: const TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 13),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        )
      ],
    );
  }
}

class BoxJadwal extends StatelessWidget {
  final String dokter;
  final String jadwal;
  final VoidCallback onTapPop;

  const BoxJadwal(
      {super.key,
      required this.dokter,
      required this.jadwal,
      required this.onTapPop});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(15),
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                offset: const Offset(-1, 2),
                blurRadius: 3,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    backgroundColor: Color(0xFFB7D1FF),
                    radius: 20,
                    child: Icon(
                      Entypo.back_in_time,
                      color: Color(0xFF234DF0),
                      size: 25,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        jadwal,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                      Text(
                        dokter,
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 15),
                      )
                    ],
                  )
                ],
              ),
              IconButton(
                  onPressed: onTapPop, icon: const Icon(Icons.more_vert)),
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        )
      ],
    );
  }
}

class BoxAssesment extends StatelessWidget {
  final String no;
  final String pasien;
  final String dokter;
  final VoidCallback onTapBox;
  const BoxAssesment(
      {super.key,
      required this.no,
      required this.pasien,
      required this.dokter,
      required this.onTapBox});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTapBox,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.all(15),
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  offset: const Offset(-1, 2),
                  blurRadius: 3,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Nomor Antrean : $no",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Text(
                  "$pasien",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  "$dokter",
                  style: TextStyle(fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class BoxRiwayatDokter extends StatelessWidget {
  final VoidCallback onTapBox;
  final String nama;
  final String nrp;
  final String no;
  final Widget icon;
  final Widget tanggal;

  const BoxRiwayatDokter({
    super.key,
    required this.onTapBox,
    required this.nama,
    required this.nrp,
    required this.icon,
    required this.tanggal,
    required this.no,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTapBox,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.all(15),
            width: double.infinity,
            height: 110,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  offset: const Offset(-1, 2),
                  blurRadius: 3,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: icon,
                ),
                const SizedBox(
                  width: 15,
                ),
                SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No. Antrian: $no',
                        style: TextStyle(fontSize: 13),
                      ),
                      Text(
                        nama,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        nrp,
                        style: const TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 12),
                      ),
                      tanggal
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        )
      ],
    );
  }
}
