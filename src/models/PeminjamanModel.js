class PeminjamanModel {
    constructor(data = {}) {
        this.id_peminjaman = data.id_peminjaman;
        this.id_pelanggan = data.id_pelanggan;
        this.id_mobil = data.id_mobil;
        this.id_pembayaran = data.id_pembayaran;
        this.tanggal_rencana_kembali = data.tanggal_rencana_kembali;
        this.status = data.status;
        this.tanggal_dibuat = data.tanggal_dibuat;
        this.total_biaya = data.total_biaya;
        this.tanggal_pinjam = data.tanggal_pinjam;
        this.keterlambatan_hari = data.keterlambatan_hari;
        this.denda = data.denda;
        this.catatan = data.catatan;
    }
}

module.exports = PeminjamanModel;