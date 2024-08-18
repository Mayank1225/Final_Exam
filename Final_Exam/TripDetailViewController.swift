import UIKit
import MapKit
import CoreLocation

class TripDetailViewController: UIViewController {
   
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var TripName: UILabel!
    @IBOutlet weak var TripDestination: UILabel!
    @IBOutlet weak var Slider: UISlider!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var wind: UILabel!
    @IBOutlet weak var Humidity: UILabel!
    @IBOutlet weak var weatherImg: UIImageView!
    @IBOutlet weak var Temp: UILabel!
    @IBOutlet weak var weather: UILabel!
    
    @IBOutlet weak var weatherDestination: UILabel!
    var trip: UserTrip?
    var startLocation: CLLocationCoordinate2D?
    var endLocation: CLLocationCoordinate2D?
    var currentTransportType: MKDirectionsTransportType = .automobile
    var currentLocation: CLLocationCoordinate2D?
    
    let weatherAPIKey = "a51cc8978987904af64cd7d31817bc48"
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mapView.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        if let trip = trip {
            TripName.text = trip.tripName
            TripDestination.text = trip.endLocation
            startDate.text = trip.startDate
            endDate.text = trip.endDate
            
            guard let startLocation = trip.startLocation, let endLocation = trip.endLocation else {
                showAlert(title: "Error", message: "Start or end location is missing")
                return
            }
            
            geocodeAddress(startLocation) { startCoord in
                if let startCoord = startCoord {
                    self.startLocation = startCoord
                    self.geocodeAddress(endLocation) { endCoord in
                        if let endCoord = endCoord {
                            self.endLocation = endCoord
                            self.displayRoute()
                            self.fetchWeatherData(for: endCoord)
                        } else {
                            self.showAlert(title: "Location Error", message: "End location not found.")
                            self.weatherDestination.text = "No location found for weather Data";
                        }
                    }
                } else {
                    self.showAlert(title: "Location Error", message: "Start location not found.")
                }
            }
        }
        
        Slider.minimumValue = 0.01
        Slider.maximumValue = 0.1
        Slider.value = 0.05
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           guard let location = locations.last else { return }
           currentLocation = location.coordinate
           locationManager.stopUpdatingLocation()
    }
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func geocodeAddress(_ address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        CLGeocoder().geocodeAddressString(address) { placemarks, error in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                completion(nil)
            } else if let placemark = placemarks?.first, let coordinate = placemark.location?.coordinate {
                completion(coordinate)
            } else {
                completion(nil)
            }
        }
    }
    
    private func displayRoute() {
        guard let startCoord = startLocation, let endCoord = endLocation else { return }
        
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        
        let startAnnotation = MKPointAnnotation()
        startAnnotation.coordinate = startCoord
        startAnnotation.title = "Start"
        
        let endAnnotation = MKPointAnnotation()
        endAnnotation.coordinate = endCoord
        endAnnotation.title = "Destination"
        
        mapView.addAnnotations([startAnnotation, endAnnotation])
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: startCoord))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: endCoord))
        request.transportType = currentTransportType
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            guard let route = response?.routes.first, error == nil else {
                self.showNoRouteAlert(for: self.currentTransportType)
                return
            }
            self.mapView.addOverlay(route.polyline)
            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
        }
    }
    
    private func fetchWeatherData(for coordinate: CLLocationCoordinate2D) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&units=metric&appid=\(weatherAPIKey)"
        
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                self.weatherDestination.text = "No location found"
                print("Failed to fetch weather data")
                return
            }
            
            do {
                let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                DispatchQueue.main.async {
                    self.updateWeatherUI(with: weatherData)
                }
            } catch {
                
                print("Failed to parse weather data: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    private func updateWeatherUI(with weatherData: WeatherData) {
        if let locationName = weatherData.name {
            weatherDestination.text = locationName
        }else {
            weatherDestination.text = "No Location Found"
        }
        if let temp = weatherData.main?.temp {
            Temp.text = "\(temp)°C"
        }
        if let humidity = weatherData.main?.humidity {
            Humidity.text = "Humidity: \(humidity)%"
        }
        if let windSpeed = weatherData.wind?.speed {
            wind.text = "Wind: \(windSpeed) m/s"
        }
        if let weatherElement = weatherData.weather?.first {
            weather.text = weatherElement.description
            
            if let icon = weatherElement.icon {
                let iconURL = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")
                if let iconURL = iconURL {
                    loadWeatherIcon(from: iconURL)
                }
            } else {
                weatherDestination.text =  "No Location Found"
            }
        }
    }

    private func loadWeatherIcon(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to load weather icon: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            DispatchQueue.main.async {
                self.weatherImg.image = UIImage(data: data)
            }
        }
        task.resume()
    }

    private func showNoRouteAlert(for transportType: MKDirectionsTransportType) {
        let alertTitle = transportType == .walking ? "No Walking Route" : "No Driving Route"
        let alertMessage = transportType == .walking ? "A walking route is not available for this destination." : "A driving route is not available for this destination."
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func onSlide(_ sender: UISlider) {
        let miles = Double(sender.value)
        if(miles != 0.0){
            let delta = 0.1 / (miles * 2)
            
            var currentRegion = self.mapView.region
            currentRegion.span = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
            self.mapView.region = currentRegion
        }
    }
    
    @IBAction func onCarTap(_ sender: Any) {
        currentTransportType = .automobile
        displayRoute()
    }
    
    @IBAction func onWalkTap(_ sender: Any) {
        currentTransportType = .walking
        displayRoute()
    }
    
    @IBAction func onAddExpense(_ sender: Any) {
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         if let expenseVC = storyboard.instantiateViewController(withIdentifier: "TripExpenseViewController") as? TripExpenceViewController {
             expenseVC.trip = trip
             navigationController?.pushViewController(expenseVC, animated: true)
         }
     }
}

extension TripDetailViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = currentTransportType == .automobile ? UIColor.blue : UIColor.green
            renderer.lineWidth = 5
            return renderer
        }
        return MKOverlayRenderer()
    }
}
