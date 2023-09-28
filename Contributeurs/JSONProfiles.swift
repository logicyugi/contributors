//
//  JSONProfiles.swift
//  Contributeurs
//
//  Created by Antoine El Samra on 28/09/2023.
//

import Foundation

struct JSONProfiles: Codable {
    let JSONProfile: [JSONProfile]
}

struct JSONProfile: Codable {
    
    let login: String?
    let id: Double?
    let node_id: String?
    let avatarURL: URL?
    let gravatar_id: String?
    let url: URL?
    let html_url: URL?
    let followers_url: URL?
    let following_url: URL?
    let gists_url: URL?
    let starred_url: URL?
    let subscriptions_url: URL?
    let organizations_url: URL?
}

