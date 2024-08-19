//
//  Network.swift
//  Snapchat
//
//  Created by Zafran Mac on 03/12/2023.
//

import UIKit
import SQLite3

class DatabaseManager {
    static let shared = DatabaseManager()

    private var database: OpaquePointer?

    private init() {
        openDatabase()
        createTableIfNotExists()
        createTable1IfNotExists()
        createTableIfNotExists2()
    }

    private func openDatabase() {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("profile.sqlite3")

        if sqlite3_open(fileURL.path, &database) != SQLITE_OK {
            print("Error opening database: \(String(cString: sqlite3_errmsg(database)!))")
        }
    }

    private func createTableIfNotExists() {
        let createTableQuery = """
            CREATE TABLE IF NOT EXISTS profiles (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                image BLOB
            );
        """

        if sqlite3_exec(database, createTableQuery, nil, nil, nil) != SQLITE_OK {
            print("Error creating table: \(String(cString: sqlite3_errmsg(database)!))")
        }
    }
    private func createTableIfNotExists2() {
        let createTableQuery = """
            CREATE TABLE IF NOT EXISTS Mainprofiles (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                image BLOB
            );
        """

        if sqlite3_exec(database, createTableQuery, nil, nil, nil) != SQLITE_OK {
            print("Error creating table: \(String(cString: sqlite3_errmsg(database)!))")
        }
    }
    private func createTable1IfNotExists() {
        let createTableQuery = """
            CREATE TABLE IF NOT EXISTS QRprofile (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                image BLOB
            );
        """

        if sqlite3_exec(database, createTableQuery, nil, nil, nil) != SQLITE_OK {
            print("Error creating table: \(String(cString: sqlite3_errmsg(database)!))")
        }
    }

    func saveImageToDatabase(table:String,imageData: Data, completion: @escaping (Bool) -> Void) {
        let timestamp = Int(Date().timeIntervalSince1970)
        let insertQuery = "INSERT OR REPLACE INTO \(table) (id, image) VALUES (?, ?);"

        if sqlite3_exec(database, "BEGIN TRANSACTION", nil, nil, nil) != SQLITE_OK {
            print("Failed to begin transaction: \(String(cString: sqlite3_errmsg(database)!))")
            completion(false)
            return
        }

        var stmt: OpaquePointer?

        if sqlite3_prepare_v2(database, insertQuery, -1, &stmt, nil) == SQLITE_OK {
            sqlite3_bind_int(stmt, 1, 1)
            sqlite3_bind_blob(stmt, 2, (imageData as NSData).bytes, Int32(imageData.count), nil)

            if sqlite3_step(stmt) != SQLITE_DONE {
                print("Error updating table: \(String(cString: sqlite3_errmsg(database)!))")
                sqlite3_exec(database, "ROLLBACK", nil, nil, nil)
                completion(false)
            } else {
                sqlite3_exec(database, "COMMIT", nil, nil, nil)
                completion(true)
            }

            sqlite3_finalize(stmt)
        } else {
            print("Failed to prepare statement: \(String(cString: sqlite3_errmsg(database)!))")
            sqlite3_exec(database, "ROLLBACK", nil, nil, nil)
            completion(false)
        }
    }
    func loadImageFromDatabase() -> Data? {
        var stmt: OpaquePointer?

        let selectQuery = "SELECT image FROM profiles LIMIT 1;"

        if sqlite3_prepare_v2(database, selectQuery, -1, &stmt, nil) == SQLITE_OK {
            if sqlite3_step(stmt) == SQLITE_ROW {
                if let imageData = sqlite3_column_blob(stmt, 0) {
                    let data = Data(bytes: imageData, count: Int(sqlite3_column_bytes(stmt, 0)))
                    sqlite3_finalize(stmt)
                    return data
                }
            }
        }

        sqlite3_finalize(stmt)
        return nil
    }
    func loadImageFromDatabase2() -> Data? {
        var stmt: OpaquePointer?

        let selectQuery = "SELECT image FROM Mainprofiles LIMIT 1;"

        if sqlite3_prepare_v2(database, selectQuery, -1, &stmt, nil) == SQLITE_OK {
            if sqlite3_step(stmt) == SQLITE_ROW {
                if let imageData = sqlite3_column_blob(stmt, 0) {
                    let data = Data(bytes: imageData, count: Int(sqlite3_column_bytes(stmt, 0)))
                    sqlite3_finalize(stmt)
                    return data
                }
            }
        }

        sqlite3_finalize(stmt)
        return nil
    }


    func loadImageFromDatabase1() -> Data? {
        var stmt: OpaquePointer?

        let selectQuery = "SELECT image FROM QRprofile LIMIT 1;"

        if sqlite3_prepare_v2(database, selectQuery, -1, &stmt, nil) == SQLITE_OK {
            if sqlite3_step(stmt) == SQLITE_ROW {
                if let imageData = sqlite3_column_blob(stmt, 0) {
                    let data = Data(bytes: imageData, count: Int(sqlite3_column_bytes(stmt, 0)))
                    sqlite3_finalize(stmt)
                    return data
                }
            }
        }

        sqlite3_finalize(stmt)
        return nil
    }

    deinit {
        sqlite3_close(database)
    }
}
