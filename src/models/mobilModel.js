class MobilModel {
    constructor(data = {}) {
        this.id_mobil = data.id_mobil;
        this.nomor_plat = data.nomor_plat;
        this.merk = data.merk;
        this.model = data.model;
        this.tahun_produksi = data.tahun_produksi;
        this.tarif_sewa_per_hari = data.tarif_sewa_per_hari;
        this.status = data.status;
        this.tanggal_ditambahkan = data.tanggal_ditambahkan;
    }
}

module.exports = MobilModel;