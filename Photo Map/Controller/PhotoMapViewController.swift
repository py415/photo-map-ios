//
//  PhotoMapViewController.swift
//  Photo Map
//
//  Created by Nicholas Aiwazian on 10/15/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

/* -- Comment -- */

import UIKit
import MapKit

class PhotoMapViewController: UIViewController, UINavigationControllerDelegate, MKMapViewDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var cameraButton: UIButton!
    
    // MARK: - Properties
    
    // Store picked image
    private var pickedImage: UIImage!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Set properties for button
        cameraButton.makeCircular()
        
        // Set class as delegate
        mapView.delegate = self
        
        // One degree of latitude is approximately 111 kilometers (69 miles) at all times.
        // San Francisco Lat, Long = latitude: 37.783333, longitude: -122.416667
        let mapCenter = CLLocationCoordinate2D(latitude: 37.783333, longitude: -122.416667)
        let mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: mapCenter, span: mapSpan)
        // Set animated property to true to animate the transition to the region
        mapView.setRegion(region, animated: false)
        
    }
    
    // MARK: - IBAction Section
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        
        print("Camera button tapped...")
        
        // Open photo library or camera
        selectPhoto()
        
    }
    
    // MARK: - Private Functions Section
    
    // Instantiate Image Picker and set delegate to this view controller
    private func selectPhoto() {
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        // Present camera, if available
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            imagePicker.sourceType = .camera
            
            // Present photo library
        } else {
            print("Camera 🚫 available so we will use photo library instead")
            imagePicker.sourceType = .photoLibrary
            // Present imagePicker source type (either camera or library)
        }
        
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    // Add pin to map
    private func addPin(atLat latitude: CLLocationDegrees, andLong longitude: CLLocationDegrees) {
        
        let annotation = MKPointAnnotation()
        let locationCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        annotation.coordinate = locationCoordinate
        annotation.title = "Latitude: \(latitude), Longitude: \(longitude)"
        
        mapView.addAnnotation(annotation)
        
    }
    
    internal func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if let annotation = view.annotation {
            if let title = annotation.title! {
                print("Tapped \(title) pin")
            }
        }
        
    }
    
    /* ----- TODO: Customize mapview to add custom map notations */
    
    // MARK: - Helper Functions Section
    
    // Helper function inserted by Swift 4.2 migrator.
    private func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
        
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    private func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        
        return input.rawValue
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let locationsViewController = segue.destination as! LocationsViewController
        
        locationsViewController.delegate = self
        
    }
    
}

extension PhotoMapViewController: UIImagePickerControllerDelegate {
    
    // MARK: - UIImagePickerControllerDelegate Section
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        // Get the image captured by the UIImagePickerController
        _ = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage
        let editedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as! UIImage
        
        // Do something with the images (based on your use case)
        pickedImage = editedImage
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "tagSegue", sender: nil)
        
    }
    
}

extension PhotoMapViewController: LocationsViewControllerDelegate {
    
    func locationsPickedLocation(controller: LocationsViewController, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        
        print("Location picked")
        
        addPin(atLat: latitude, andLong: longitude)
        
    }
    
}
