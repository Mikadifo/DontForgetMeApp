//
//  User.swift
//  DontForgetMe
//
//  Created by Michael Padilla on 3/13/22.
//

import Foundation

struct User: Codable {
    var username: String
    var email: String
    var phone: String
    var password: String
    var things: [String]
    var emergencyContacts: [String]
    //var schedules: [String]
}

struct Response: Codable {
    var statusOk: Bool?
    var users: [User]?
    var user: User?
    var errorMessagge: String?
}

class UserService: ObservableObject {
    @Published var users = [User]()
    
    func userByEmail(email: String, completion: @escaping (Response) -> ()) {
        let url = URL(string: API().URL_USER_BY_EMAIL + email)!
        URLSession.shared.dataTask(with: url) { data, response, error in
            let responseData = try! JSONDecoder().decode(Response.self, from: data!)
            print(responseData)
            DispatchQueue.main.async {
                completion(responseData)
            }
        }.resume()
    }
    
    func login(username: String, password: String, completion: @escaping (Response) -> ()) {
        let body: [String: String] = ["username": username, "password": password]
        let finalBody = try? JSONSerialization.data(withJSONObject: body)
        
        let url = URL(string: API().URL_LOGIN)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            let responseData = try! JSONDecoder().decode(Response.self, from: data!)
            print(responseData)
            DispatchQueue.main.async {
                completion(responseData)
            }
        }.resume()
    }
    
    func updateUser(userEmail: String, newUser: User, completion: @escaping (Response) -> ()) {
        let finalBody = try? JSONEncoder().encode(newUser)
        
        let url = URL(string: API().URL_UPDATE_USER + userEmail)!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = finalBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            let responseData = try! JSONDecoder().decode(Response.self, from: data!)
            print("RES 1: \(responseData)")
            DispatchQueue.main.async {
                completion(responseData)
            }
        }.resume()
    }
}
