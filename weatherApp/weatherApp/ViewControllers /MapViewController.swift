//
//  MapViewController.swift
//  weatherApp
//
//  Created by Eldar Garbuzov on 25.06.22.
//

import UIKit
import GoogleMaps


class MapViewController: UIViewController {
    
    @IBOutlet weak var borderViewForMap: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let camera = GMSCameraPosition.camera(withLatitude: 54.029, longitude: 27.597, zoom: 5.0)
        let mapView = GMSMapView.map(withFrame: borderViewForMap.bounds, camera: camera)
       mapView.delegate = self
        borderViewForMap.addSubview(mapView)
    } // конец дид вью дид лод
    



} // конец класса

extension MapViewController: GMSMapViewDelegate {
     func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
//         stackWithLables.isHidden = false
//         latitudeLable.text = "\(coordinate.latitude)"
//         longtituteLable.text = "\(coordinate.longitude)"
         
    }
}
