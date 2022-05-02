//
//  URL.swift
//  DontForgetMe
//
//  Created by Michael Padilla on 3/13/22.
//

import Foundation

private let STAGE = "dev"
private let URL_BASE = "https://0fm6m54ra4.execute-api.us-east-1.amazonaws.com/\(STAGE)"

struct API {
    let URL_LOGIN = URL_BASE + "/login"
    let URL_USERS = URL_BASE + "/users"
    
    let URL_USER_BY_EMAIL = URL_BASE + "/user/"
    let URL_USER_BY_PERSONAL_INFO = URL_BASE + "/user/by/personal_info"
    
    let URL_CREATE_USER = URL_BASE + "/user/create"
    let URL_UPDATE_USER = URL_BASE + "/user/update/"
    let URL_DELETE_USER = URL_BASE + "/user/delete/"
}
