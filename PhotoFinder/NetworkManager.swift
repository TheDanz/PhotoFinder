import UIKit
import Foundation
import Alamofire

class NetworkManager {
    
    private let session = URLSession.shared
    private let APIKey = "Y6ZYRokeiM5gNxeEgJEyioSx6-KIIRnLBuCwRxE-0-s"
    private let parser = JSONDecoder()
    
    func dataRequest(query: String, completion: @escaping ([Photo]) -> (Void)) {
        
        guard let url = URL(string: "https://api.unsplash.com/search/photos") else { return }
        
        var parameters: [String : Any] = [:]
        parameters["per_page"] = 20
        parameters["query"] = query
        parameters["client_id"] = APIKey
        
        AF.request(url, method: .get, parameters: parameters).response { response in
            
            guard let data = response.data else { return }
            let photoResults = try? self.parser.decode(PhotoResults.self, from: data)
            let photos = photoResults?.results ?? []
            completion(photos)
        }
    }
}
