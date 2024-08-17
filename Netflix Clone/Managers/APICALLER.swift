//
//  APICALLER.swift
//  Netflix Clone
//
//  Created by MAC on 14/8/2024.
//

import Foundation
struct Constant {
    static let API_KEY = "9aaf9d6d0d4372faaed3c63af2eb8dc5"
    static let baseURL = "https://api.themoviedb.org"
    static let API_KEY_YT = "AIzaSyDMfdR9ra6B5zCsoTLK4vBLybnzGykkEtQ"
    static let yt_baseUrl = "https://www.googleapis.com/youtube/v3"
}

enum APIError: Error {
    case failedTogetData
}

class APICaller {
    static let shared = APICaller()

    func getTrendingMovies(completion : @escaping (Result<[Movie], Error>) -> Void){
        guard let url = URL(string: "\(Constant.baseURL)/3/trending/movie/day?api_key=\(Constant.API_KEY)")else{return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)){data, _,error in
            guard let data = data, error == nil else {
                return
            }
            do{
                let results = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(error))
            }
            
        }
        task.resume()
    }
    
    func getTrendingTv(completion: @escaping (Result<[Tv], Error>) -> Void){
        guard let url = URL(string:
            "\(Constant.baseURL)/3/trending/tv/day?api_key=\(Constant.API_KEY)")else{return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)){data, _,error in
            guard let data = data, error == nil else{
                return
            }
            do{
                let results = try JSONDecoder().decode(TrendingTvResponse.self, from: data)
               
                completion(.success(results.results))
            }catch{
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func getUpcomingMovies(completion: @escaping (Result<[Movie], Error>) -> Void){
        guard let url = URL(string: "\(Constant.baseURL)/3/movie/upcoming?api_key=\(Constant.API_KEY)&language=en-US&page=1")else{return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)){data, _,error in
            guard let data = data, error == nil else{
                return
            }
            do{
                let results = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func getPopular(completion: @escaping (Result<[Movie], Error>) -> Void){
        guard let url = URL(string: "\(Constant.baseURL)/3/movie/popular?api_key=\(Constant.API_KEY)&language=en-US&page=1")else{return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)){data, _,error in
            guard let data = data, error == nil else{
                return
            }
            do{
                let results = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func getTopRated(completion: @escaping (Result<[Movie], Error>) -> Void){
        guard let url = URL(string: "\(Constant.baseURL)/3/movie/top_rated?api_key=\(Constant.API_KEY)&language=en-US&page=1")else{return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)){data, _,error in
            guard let data = data, error == nil else{
                return
            }
            do{
                let results = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func getDiscoverMovies(completion: @escaping (Result<[Movie], Error>) -> Void){
        guard let url = URL(string: "\(Constant.baseURL)/3/movie/top_rated?api_key=\(Constant.API_KEY)&language=en-US&page=1")else{return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)){data, _,error in
            guard let data = data, error == nil else{
                return
            }
            do{
                let results = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(error))
            }
        }
        task.resume()
    } 
    
    func search(with query: String, completion: @escaping (Result<[Movie], Error>) -> Void){
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        
        guard let url = URL(string: "\(Constant.baseURL)/3/search/movie?query=\(query)&api_key=\(Constant.API_KEY)")else{return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)){data, _,error in
            guard let data = data, error == nil else{
                return
            }
            do{
                let results = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func getMovie(with query: String, completion: @escaping (Result<VideoElement, Error>) -> Void){
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "\(Constant.yt_baseUrl)/search?q=\(query)&key=\(Constant.API_KEY_YT)") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)){data, _,error in
            guard let data = data, error == nil else{
                return
            }
            do{
                let results = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                completion(.success(results.items[0]))
              
            }catch{
                completion(.failure(error))
            }
        }
        task.resume()
        
    }
    
    
}
