//
//  APIHandler.swift
//  testHeads&Hands
//
//  Created by Yegitov Aleksey on 30.09.2021.
//

import Combine
import Foundation

struct Info: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

enum APIManagerError: Error {
    case invalidURL
    case invalidResponse(error: ErrorMessage)
    case apiError
    case noInternet
}

enum RequestType: String {
    case character = "character"
    case location = "location"
    case episode = "episode"
    case url = ""
}

struct ErrorMessage: Codable {
    let error: String
}

struct CharacterInfo: Codable {
    let info: Info
    let results: [Character]
}

struct LocationInfo: Codable {
    let info: Info
    let results: [Location]
}

struct EpisodeInfo: Codable {
    let info: Info
    let results: [Episode]
}

class APIManager: NSObject {
    private var baseURL: String = "https://rickandmortyapi.com/api/"

    private func callApi(requestType: RequestType, parameters: String = "", completion: @escaping (Result<Data, APIManagerError>) -> Void) {
        guard Reachability.isConnectedToNetwork() else {
            return completion(.failure(.noInternet))
        }
        var urlString = baseURL+requestType.rawValue
        if parameters != "", let temp = parameters.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            urlString = urlString+temp
        }
        if requestType == .url {
            urlString = parameters
        }
        if let url = URL(string: urlString) {
            let urlSession = URLSession.shared
            urlSession.dataTask(with: url) {
                switch $0 {
                case .success(let (response, data)):
                    guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                        completion(.failure(.invalidResponse(error: self.decodeError(data: data) ?? ErrorMessage(error: "invalidResponse"))))
                        return
                    }
                    completion(.success(data))
                case .failure( _):
                    completion(.failure(.apiError))
                }
            }.resume()
        } else {
            completion(.failure(.invalidURL))
        }
    }

    private func decodeJSONData<T: Codable>(data: Data) -> T? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(T.self, from: data)
            return decodedData
        } catch {
            print(error)
            return nil
        }
    }

    private func decodeError(data: Data) -> ErrorMessage? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ErrorMessage.self, from: data)
            return decodedData
        } catch {
            print(error)
            return nil
        }
    }
}

extension APIManager {
    public func getAllCharacters() -> Future <[Character], APIManagerError> {
        return Future() { promise in
            var allCharacters = [Character]()
            self.callApi(requestType: .character) {
                switch $0 {
                case .success(let data):
                    if let infoModel: CharacterInfo = self.decodeJSONData(data: data) {
                        allCharacters = infoModel.results
                        let charactersDispatchGroup = DispatchGroup()

                        for index in 2...infoModel.info.pages {
                            charactersDispatchGroup.enter()

                            self.callApi(requestType: .character, parameters: "/?page="+String(index)) {
                                switch $0 {
                                case .success(let data):
                                    if let infoModel: CharacterInfo = self.decodeJSONData(data: data) {
                                        allCharacters.append(contentsOf: infoModel.results)
                                        charactersDispatchGroup.leave()
                                    }
                                case .failure(let error):
                                    promise(.failure(error))
                                }
                            }
                        }
                        charactersDispatchGroup.notify(queue: DispatchQueue.main) {
                            promise(.success(allCharacters.sorted { $0.id < $1.id }))
                        }
                    }
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
    }

    public func getLocation(name: String) -> Future <Location, APIManagerError> {
        return Future() { promise in
            self.callApi(requestType: .location, parameters: "/?name=\(name)") {                switch $0 {
                case .success(let data):
                    if let infoModel: LocationInfo = self.decodeJSONData(data: data) {
                        guard let location = infoModel.results.first else {
                            promise(.failure(APIManagerError.invalidResponse(error: ErrorMessage(error: "No location with that name"))))
                            return
                        }
                        promise(.success(location))
                    }
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
    }

    public func getEpisode(url: String) -> Future <Episode, APIManagerError> {
        return Future() { promise in
            self.callApi(requestType: .url, parameters: url) {
                switch $0 {
                case .success(let data):
                    if let episode: Episode = self.decodeJSONData(data: data) {
                        promise(.success(episode))
                    } else {
                        promise(.failure(APIManagerError.invalidResponse(error: ErrorMessage(error: "No episode with that url"))))
                    }
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
    }
}

extension URLSession {
    func dataTask(with url: URL, result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: url) { (data, response, error) in
            if let error = error {
                result(.failure(error))
                return
            }
            guard let response = response, let data = data else {
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }
            result(.success((response, data)))
        }
    }
}
