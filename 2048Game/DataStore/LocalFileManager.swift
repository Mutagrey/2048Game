//
//  LocalFileManagerNew.swift
//  MNotes
//
//  Created by Sergey Petrov on 16.03.2022.
//

import SwiftUI
import Combine

/// Class to manage Local files (JSON etc)
class LocalFileManager {
    /// Root URL  for `SearchPathDirectory` in `userDomainMask`
    static let rootURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    /// Work Queue
    static private let workQueue = DispatchQueue(label: "LocalFileManager.Work", qos: .userInitiated)
    /// Make it private
    private init() { }
    /// Errors
    enum Error: Swift.Error {
        case invalidURL
        case invalidData
        case unknownError(Swift.Error)
    }
    /// Creates folder if it doesnt exist
    private static func createFolderIfNeeded(url: URL) {
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
                print("[📂] Created folder: \(url.path)")
            } catch let error {
                print("[📂] Error creating folder: \(error.localizedDescription)")
            }
        }
    }
    /// Remove item at URL path
    static func removeURL(url: URL) {
        guard FileManager.default.fileExists(atPath: url.path) else { return }
        workQueue.async {
            do {
                try FileManager.default.removeItem(atPath: url.path)
            } catch {
                print("[❗️] Error to remove: \"\(url.path)\"")
            }
        }
    }
    // MARK: - SAVE ADN LOAD
    /// Save JSON
    @discardableResult
    static func saveJSON<T: Encodable>(to url: URL, data: T) -> Future<Bool, Swift.Error> {
        let future = Future<Bool, Swift.Error> { promise in
            workQueue.async {
                // 1. Creating folders if needed
                LocalFileManager.createFolderIfNeeded(url: url.deletingLastPathComponent())
                // 2. Saving data to JSON
                do {
                    let data = try JSONEncoder().encode(data)
                    try data.write(to: url)
                    print("[💾] Succseccfully saved data: [\(url.lastPathComponent)]")
                    promise(.success(true))
                } catch Error.invalidData {
                    print("[❗️🄹🅂🄾🄽] Error saving JSON [\(url.lastPathComponent)]")
                    promise(.failure(Error.invalidData))
                } catch {
                    print("\(error)")
                    promise(.failure(Error.unknownError(error)))
                }
            }
        }
        return future
    }
    /// Load JSON from local dirrectory
    static func getJSON(from url: URL) -> Future<Data, Swift.Error> {
        let future = Future<Data, Swift.Error> { promise in
            workQueue.async {
                do {
                    let data = try Data(contentsOf: url)
                    print("[💿] Succseccfully done loading local data: [\(url.lastPathComponent)]")
                    promise(.success(data))
                } catch Error.invalidURL {
                    print("[❗️] Invalid URL: \(url.path)")
                    promise(.failure(Error.invalidURL))
                } catch Error.invalidData {
                    print("[❗️] Error local Data [\(url.lastPathComponent)]")
                    promise(.failure(Error.invalidData))
                } catch {
                    print("\(error.localizedDescription)")
                    promise(.failure(Error.unknownError(error)))
                }
            }
        }
        return future
    }
    
}


