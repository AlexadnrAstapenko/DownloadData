//
//  Models.swift
//  DownloadImage
//
//  Created by Александр Астапенко on 15.04.22.
//

// MARK: - Users

struct Users: Codable {
    let id: Int?
    let name: String?
    let username: String?
    let email: String?
    let address: Address?
    let phone: String?
    let website: String?
    let company: Company?
}

// MARK: - Address

struct Address: Codable {
    let street: String?
    let suite: String?
    let city: String?
    let geo: Geo?
}

// MARK: - Geo

struct Geo: Codable {
    let lat: String?
    let lng: String?
}

// MARK: - Company

struct Company: Codable {
    let name: String?
    let catchPhrase: String?
    let bs: String?
}

// MARK: - Post

struct Post: Codable {
    let userId: Int?
    let id: Int?
    let title: String?
    let body: String?
}



// MARK: - Comments

struct Comments: Codable {
    let postId: Int?
    let id: Int?
    let name: String?
    let email: String?
    let body: String?
}

// MARK: - Album

struct Album: Codable {
    let userId: Int?
    let id: Int?
    let title: String?
}

// MARK: - Photo

struct Photo: Codable {
    let albumId: Int?
    let id: Int?
    let title: String?
    let url: String?
    let thumbnaiUrl: String?
}
