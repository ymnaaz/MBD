class PelangganModel {
    constructor(data = {}) {
        this.id_pelanggan = data.id_pelanggan;
        this.nama = data.nama;
        this.nomor_telepon = data.nomor_telepon;
        this.alamat = data.alamat;
        this.tanggal_dibuat = data.tanggal_dibuat;
    }
}

module.exports = PelangganModel; 