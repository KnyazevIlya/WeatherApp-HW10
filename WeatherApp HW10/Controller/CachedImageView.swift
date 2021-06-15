//
//  CashedImageView.swift
//  WeatherApp HW10
//
//  Created by admin2 on 15.06.2021.
//

import UIKit

class CachedImageView: UIImageView {
    
    func fetchImage(with url: String?) {
        guard let url = url else { return }
        guard let imageUrl = url.getURL() else {
            self.image = #imageLiteral(resourceName: "picture")
            return
        }
        
        if let cacheImage = getCashedImage(url: imageUrl) {
            image = cacheImage
            return
        }
        
        URLSession.shared.dataTask(with: imageUrl) { data, response, error in
            if error != nil {
                return
            }
            
            guard let data = data, let response = response else { return }
            guard let responseURL = response.url else { return }
            
            if responseURL.absoluteString != url { return }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
            
            self.cacheImage(data: data, response: response)
            
        }.resume()
        
    }
    
    private func cacheImage(data: Data, response: URLResponse) {
        guard let responseURL = response.url else { return }
        let cacheResponse = CachedURLResponse(response: response, data: data)
        
        URLCache.shared.storeCachedResponse(cacheResponse, for: URLRequest(url: responseURL))
    }
    
    private func getCashedImage(url: URL) -> UIImage? {
        if let cacheResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            return UIImage(data: cacheResponse.data)
        }
        return nil
    }
}

fileprivate extension String {
    func getURL() -> URL? {
        guard let url = URL(string: self) else { return nil }
        return url
    }
}
