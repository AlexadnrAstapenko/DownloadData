//
//  MapVC.swift
//  DownloadImage
//
//  Created by Александр Астапенко on 18.04.22.
//

import MapKit
import UIKit

// MARK: - MapViewController

class MapViewController: UIViewController {
    var lat: Double = 0.0
    var long: Double = 0.0
    var titleUser: String?

    @IBOutlet var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // 1. Реализуем делегат протокола MKMapViewDelegate в ViewController
        mapView.delegate = self
        // 2. Установите широту и долготу местоположения
        let sourceLocation = CLLocationCoordinate2D(latitude: lat, longitude: long)
        // 3. Создаем объект ориентира, содержащий координаты местоположения
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        // 5. Добавьте комментарий, чтобы показать название ориентира
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = titleUser
        // Если координаты объекта ориентира существуют, объясните координаты объекта, указывающего на точку МК
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }

        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = titleUser

        // 6. На карте отображается аннотация отметки
        self.mapView.showAnnotations([sourceAnnotation, destinationAnnotation], animated: true)
        self.mapView
    }
}

// MARK: MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    // функция для рендеринга наложения
    func mapView(_: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // Рисуем две линии:
        let routeLineView = MKPolylineRenderer(overlay: overlay)
        routeLineView.lineWidth = 4.0
        if overlay is MKPolyline {
            if overlay.title == "one" {
                routeLineView.strokeColor = UIColor.red
            } else
            if overlay.title == "two" {
                routeLineView.strokeColor = UIColor.green
            }
        }
        return routeLineView
    }
}
