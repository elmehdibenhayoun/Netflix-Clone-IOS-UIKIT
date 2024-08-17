//
//  DataPersistanceManager.swift
//  Netflix Clone
//
//  Created by MAC on 17/8/2024.
//

import Foundation
import UIKit
import CoreData

class DataPersistanceManager {
    
    enum Database: Error {
        case failedToSaveData
        case failedtoFetchData
        case failedtoDeleteData
    }
    
    static let shared = DataPersistanceManager()
    
    func downloadTitleWith(model: Movie, completion: @escaping (Result<Void, Error>) -> Void ) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let item = TitleItem(context: context)
        
        item.original_title = model.original_title
        item.id = Int64(model.id)
        item.title = model.title
        item.overview = model.overview
        item.poster_path = model.poster_path
        item.release_date = model.release_date
        item.vote_average = model.vote_average
        item.vote_count = Int64(model.vote_count)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(Database.failedToSaveData))
        }
    }
    
    func fetchingTitleFromDataBase(completion: @escaping (Result<[TitleItem], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<TitleItem>
        request = TitleItem.fetchRequest()
        
        do {
            let movies = try context.fetch(request)
            completion(.success(movies))
        } catch {
            completion(.failure(Database.failedtoFetchData))
        }
    }
    
    func deleteTitleWith(model: TitleItem, completion: @escaping (Result<Void, Error>) -> Void ) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(Database.failedtoDeleteData))
        }
    }
}
