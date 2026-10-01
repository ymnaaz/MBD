class PembayaranModel {
    constructor(data = {}) {
        this.id_pembayaran = data.id_pembayaran;
        this.metode_pembayaran = data.metode_pembayaran;
        this.tanggal_bayar = data.tanggal_bayar;
        this.jumlah = data.jumlah;
        this.status = data.status;
    }
}

module.exports = PembayaranModel;