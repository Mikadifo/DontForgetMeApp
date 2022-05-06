//
//  URL.swift
//  DontForgetMe
//
//  Created by Michael Padilla on 3/13/22.
//

import Foundation

public var API_URL: String? {
    ProcessInfo.processInfo.environment["API_URL"]
}

private let URL_BASE = API_URL ?? "https://localhost:8000"

struct API {
    let URL_LOGIN = URL_BASE + "/login"
    let URL_USERS = URL_BASE + "/users"
    
    let URL_USER_BY_EMAIL = URL_BASE + "/user/"
    let URL_USER_BY_PERSONAL_INFO = URL_BASE + "/user/by/personal_info"
    
    let URL_CREATE_USER = URL_BASE + "/user/create"
    let URL_UPDATE_USER = URL_BASE + "/user/update/"
    let URL_DELETE_USER = URL_BASE + "/user/delete/"
}
