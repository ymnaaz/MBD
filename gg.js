const mysql = require('mysql2/promise');
require('dotenv').config();

(async () => {
    const c = await mysql.createConnection({
        host: process.env.DB_HOST,
        user: process.env.DB_USER,
        password: process.env.DB_PASSWORD,
        database: process.env.DB_NAME
    });

    await c.query('DELETE FROM peminjaman WHERE id_peminjaman > 10');
    await c.query("UPDATE mobil SET status = 'dipinjam' WHERE id_mobil IN (4,5,6,8,10,11)");
    await c.query("UPDATE mobil SET status = 'tersedia' WHERE id_mobil IN (1,2,3,9)");

    console.log('RESET OK');
    await c.end();
})();