const express = require('express');

const pelangganRoutes = require('./routes/pelangganRoutes');
const mobilRoutes = require('./routes/mobilRoutes');
const pembayaranRoutes = require('./routes/pembayaranRoutes');
const peminjamanRoutes = require('./routes/peminjamanRoutes');

const app = express();

// Middleware untuk membaca JSON dari request
app.use(express.json());

// Route API
app.use('/api/pelanggan', pelangganRoutes);
app.use('/api/mobil', mobilRoutes);
app.use('/api/pembayaran', pembayaranRoutes);
app.use('/api/peminjaman', peminjamanRoutes);

// Route utama untuk mengecek server
app.get('/', (req, res) => {
    res.json({
        success: true,
        message: 'API Rental Mobil berjalan'
    });
});

// Menangani endpoint yang tidak ditemukan
app.use((req, res) => {
    res.status(404).json({
        success: false,
        message: 'Endpoint tidak ditemukan'
    });
});

// Menangani error
app.use((err, req, res, next) => {
    console.error(err);

    res.status(500).json({
        success: false,
        message: 'Terjadi kesalahan pada server',
        error: err.message
    });
});

module.exports = app;