//
//  MapVC.swift
//  eLegionTest
//
//  Created by Albert Garipov on 14.03.2023.
//

import UIKit
import MapKit
import CoreLocation

final class MapVC: UIViewController {

    // MARK: - Properties

    var data = [Person]()
    var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var searchInputView: SearchInputView!
    var selectedAnnotation: MKAnnotation?

    private enum Constant {
        static let buttonText = "location-arrow-flat"
    }

    let centerMapButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(imageLiteralResourceName: Constant.buttonText).withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCenterLocation), for: .touchUpInside)
        return button
    }()

    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        configureViewComponents()

        Service.shared.fetchPeople { persons in
            self.data = persons
            self.searchInputView.data = persons
            self.displayPins()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let coordinates = CLLocationCoordinate2D(latitude: 59.9375, longitude: 30.3086)
        let spanDegree = MKCoordinateSpan(latitudeDelta: 0.10, longitudeDelta: 0.10)
        let region = MKCoordinateRegion(center: coordinates, span: spanDegree)
        mapView.setRegion(region, animated: true)
    }

    // MARK: - Selectors

    @objc func handleCenterLocation() {
        centerMap()
    }

    // MARK: - Helper Functions

    func configureViewComponents() {
        configureMapView()
        searchInputView = SearchInputView()
        searchInputView.delegate = self

        view.addSubview(searchInputView)
        searchInputView.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: -(view.frame.height - 88), paddingRight: 0, width: 0, height: view.frame.height)

        view.addSubview(centerMapButton)
        centerMapButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 30, height: 30)
    }

    func configureMapView() {
        mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.delegate = self
        view.addSubview(mapView)
        mapView.addConstraintsToFillView(view: view)
    }

    func displayPins() {
        mapView.removeAnnotations(mapView.annotations)

        for pin in data {
            let annotation = PersonPointAnnotation()
            annotation.title = pin.name
            let location = CLLocation(latitude: pin.latitude, longitude: pin.longitude)
            annotation.coordinate = location.coordinate
            annotation.identifier = pin.id
            mapView.addAnnotation(annotation)
        }
    }

    func centerMap() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 5000, longitudinalMeters: 5000)
            mapView.setRegion(region, animated: true)
        }
    }
}

// MARK: - MKMapViewDelegate

extension MapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        searchInputView.userLocation = userLocation.location
    }
}

// MARK: - SearchInputViewDelegate

extension MapVC: SearchInputViewDelegate {
    func selectedPerson(person: Person) {
        for annotaion in mapView.annotations {
            if let personAnnotation = annotaion as? PersonPointAnnotation, personAnnotation.identifier == person.id {
                self.mapView.selectAnnotation(annotaion, animated: true)
            }
        }
    }

    func hideCenterMapButton(hideButton: Bool) {
        if hideButton {
            centerMapButton.isHidden = true
        }
        else {
            centerMapButton.isHidden = false
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension MapVC: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied {
            let vc = LocationRequestVC()
            self.present(vc, animated: true, completion: nil)
        }
    }
}
