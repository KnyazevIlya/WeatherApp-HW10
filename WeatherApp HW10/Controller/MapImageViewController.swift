//
//  MapImageViewController.swift
//  WeatherApp HW10
//
//  Created by admin2 on 15.06.2021.
//

import UIKit
import Alamofire

class MapImageViewController: UIViewController {
    //MARK: - outlets
    
    @IBOutlet var mapImage: CachedImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    private let imageUrl = "https://www.researchgate.net/profile/Fabio-Micale/publication/222261692/figure/fig1/AS:305302009335809@1449801079591/Map-of-average-temperature-at-1200-hours-GMT-in-May-C-The-red-points-indicate-the.png"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        mapImage.fetchImage(with: imageUrl)
        self.activityIndicator.stopAnimating()
    }
}
