//
//  URL.swift
//  DontForgetMe
//
//  Created by Michael Padilla on 3/13/22.
//

import Foundation

private let URL_BASE = "http://192.168.1.9:8000"

struct API {
    let URL_LOGIN = URL_BASE + "/login"
    let URL_USERS = URL_BASE + "/users"
    let URL_USER_BY_EMAIL = URL_BASE + "/user/"
    let URL_UPDATE_USER = URL_BASE + "/user/update/"
    let URL_DELETE_USER = URL_BASE + "/user/delete/"
}
