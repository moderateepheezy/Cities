//
//  CityMapViewController.swift
//  Cities
//
//  Created by Afees Lawal on 25/08/2020.
//  Copyright © 2020 Afees Lawal. All rights reserved.
//

import UIKit
import MapKit

final class CityMapViewController: UIViewController {

    private let cityMap: CityMap
    private let mapView: MKMapView

    init(cityMap: CityMap) {
        self.cityMap = cityMap
        self.mapView = MKMapView()
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        view = mapView
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addTopView()
        centerMapOnLocation(coordinate: cityMap.coordinate)
    }

    private func centerMapOnLocation(coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009))
        DispatchQueue.main.async {
            self.mapView.setRegion(region, animated: true)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            self.mapView.addAnnotation(annotation)
        }
    }

    private func addTopView() {
        let topView = UIView()
        topView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(topView)

        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.topAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
}

