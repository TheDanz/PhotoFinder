class PhotoResults: Codable {
    let total: Int?
    let total_pages: Int?
    let results: [Photo]?
}

class Photo: Codable {
    let id: String?
    let created_at: String?
    let width: Int?
    let height: Int?
    let urls: URLs?
}

class URLs: Codable {
    let raw: String?
    let full: String?
    let regular: String?
    let small: String?
    let thumb: String?
    let small_s3: String?
}
