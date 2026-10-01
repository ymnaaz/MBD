const fs = require('fs');
const path = require('path');
const mysql = require('mysql2/promise');
require('dotenv').config();

const MIGRATIONS_DIR = path.join(__dirname, '../src/migrations');

const DB_HOST = process.env.DB_HOST || 'localhost';
const DB_USER = process.env.DB_USER || 'root';
const DB_PASSWORD = process.env.DB_PASSWORD || '';
const DB_PORT = Number(process.env.DB_PORT) || 3306;
const DB_NAME = process.env.DB_NAME || 'rental_mobil';

/**
 * Memisahkan SQL berdasarkan DELIMITER.
 * Dibutuhkan untuk FUNCTION, PROCEDURE, dan TRIGGER.
 */
function splitSqlStatements(sql) {
    const lines = sql.split(/\r?\n/);

    const statements = [];
    let buffer = '';
    let delimiter = ';';

    for (const line of lines) {
        const trimmed = line.trim();

        // Membaca perintah DELIMITER
        if (trimmed.toUpperCase().startsWith('DELIMITER ')) {
            delimiter = trimmed.substring(10).trim();
            continue;
        }

        buffer += line + '\n';

        // Jika statement sudah selesai sesuai delimiter
        if (buffer.trimEnd().endsWith(delimiter)) {
            const statement = buffer
                .trimEnd()
                .slice(0, -delimiter.length)
                .trim();

            if (statement) {
                statements.push(statement);
            }

            buffer = '';
        }
    }

    // Jika masih ada sisa statement
    if (buffer.trim()) {
        statements.push(buffer.trim());
    }

    return statements;
}

/**
 * Menjalankan satu file migration.
 */
async function runMigration(connection, filename) {
    const filePath = path.join(MIGRATIONS_DIR, filename);
    const sql = fs.readFileSync(filePath, 'utf8');

    const statements = splitSqlStatements(sql);

    console.log(`\nRUN  ${filename}`);

    for (const statement of statements) {
        try {
            await connection.query(statement);
        } catch (error) {
            console.error(`GAGAL menjalankan ${filename}`);
            console.error(error.message);
            throw error;
        }
    }

    console.log(`DONE ${filename}`);
}

/**
 * Main migration runner.
 */
async function migrate() {
    let connection;

    try {
        // =================================================
        // 1. Koneksi tanpa memilih database terlebih dahulu
        // =================================================
        connection = await mysql.createConnection({
            host: DB_HOST,
            user: DB_USER,
            password: DB_PASSWORD,
            port: DB_PORT
        });

        console.log('Terhubung ke MySQL.');

        // =================================================
        // 2. Membuat database jika belum ada
        // =================================================
        const safeDbName = `\`${DB_NAME.replace(/`/g, '``')}\``;

        await connection.query(`
            CREATE DATABASE IF NOT EXISTS ${safeDbName}
        `);

        console.log(`Database "${DB_NAME}" siap digunakan.`);

        // =================================================
        // 3. Menggunakan database
        // =================================================
        await connection.changeUser({
            database: DB_NAME
        });

        // =================================================
        // 4. Membuat tabel pencatat migration
        // =================================================
        await connection.query(`
            CREATE TABLE IF NOT EXISTS schema_migrations (
                id INT AUTO_INCREMENT PRIMARY KEY,
                migration VARCHAR(255) NOT NULL UNIQUE,
                executed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        `);

        // =================================================
        // 5. Membaca semua file migration
        // =================================================
        if (!fs.existsSync(MIGRATIONS_DIR)) {
            throw new Error(
                `Folder migration tidak ditemukan: ${MIGRATIONS_DIR}`
            );
        }

        const migrationFiles = fs
            .readdirSync(MIGRATIONS_DIR)
            .filter(file => file.endsWith('.sql'))
            .sort((a, b) => a.localeCompare(b, undefined, {
                numeric: true
            }));

        if (migrationFiles.length === 0) {
            console.log('Tidak ada file migration.');
            return;
        }

        // =================================================
        // 6. Mendapatkan migration yang sudah dijalankan
        // =================================================
        const [executedRows] = await connection.query(`
            SELECT migration
            FROM schema_migrations
        `);

        const executedMigrations = new Set(
            executedRows.map(row => row.migration)
        );

        // =================================================
        // 7. Menjalankan migration satu per satu
        // =================================================
        for (const filename of migrationFiles) {
            if (executedMigrations.has(filename)) {
                console.log(`SKIP ${filename} (sudah dijalankan)`);
                continue;
            }

            await connection.beginTransaction();

            try {
                await runMigration(connection, filename);

                await connection.query(`
                    INSERT INTO schema_migrations (migration)
                    VALUES (?)
                `, [filename]);

                await connection.commit();

                console.log(`MIGRATION ${filename} berhasil.`);
            } catch (error) {
                await connection.rollback();
                throw error;
            }
        }

        console.log('\n====================================');
        console.log('Semua migration selesai.');
        console.log('====================================\n');

    } catch (error) {
        console.error('\nMigration gagal.');
        console.error(error.message);
        process.exitCode = 1;

    } finally {
        if (connection) {
            await connection.end();
        }
    }
}

migrate();