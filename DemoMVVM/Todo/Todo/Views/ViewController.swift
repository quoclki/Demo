//
//  ViewController.swift
//  Todo
//
//  Created by Lu Kien Quoc on 25/12/2021.
//

import UIKit
import RxSwift
import GoogleMaps
import RxRelay

class ViewController: UIViewController {
    
    // MARK: - Outlet
    @IBOutlet weak var screenAView: UIView!
    @IBOutlet weak var pointALabel: UILabel!
    @IBOutlet weak var pointBLabel: UILabel!
    
    @IBOutlet weak var screenBView: UIView!
    @IBOutlet weak var gmsMapView: GMSMapView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var searchTextField: CustomUITextField!
    @IBOutlet weak var searchTableView: UITableView!
    
    @IBOutlet weak var screenCView: UIView!
    @IBOutlet weak var pointAResultLabel: UILabel!
    @IBOutlet weak var pointBResultLabel: UILabel!
    
    @IBOutlet weak var loadingView: LoadingView!
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private var manager: ViewControllerViewModel!
    private let locationManager = CLLocationManager()
    private var screenState = BehaviorRelay(value: EScreenState.screenA)
    private var isSetPointA: Bool = true
    private var searchedCaches = BehaviorRelay(value: [LocationData]())

    private var currentMarker: GMSMarker?
    private var selectedMarker: GMSMarker?
    private var selectedLocaltionData = BehaviorRelay<LocationData?>(value: nil)
    private var maxYOfBottomView: CGFloat = 0
    
    enum EScreenState {
        case screenA, screenB, screenC
    }
    
    // MARK: - Init
    
    // MARK: - UIViewController Mothod
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        binding()
        handleAction()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        handleKeyboard(register: false)
    }
    
    // MARK: - Binding
    func binding() {
        manager.isShowLoading.asObservable()
            .subscribe(onNext: { [weak self] value in
                guard let self = self else {
                    return
                }
                self.loadingView.showLoadingView(value)
                
            })
            .disposed(by: disposeBag)
        
        manager.error.asObservable()
            .subscribe(onNext: { [weak self] value in
                self?.manager.isShowLoading.onNext(false)
                guard let self = self else {
                    return
                }
                
                if (value as NSError).code == 200 {
                    return
                }
                
                self.showAlert("Warning", message: value.localizedDescription)
                
            })
            .disposed(by: disposeBag)
        
        screenState.asObservable()
            .subscribe(onNext: { [weak self] value in
                guard let self = self else {
                    return
                }
                
                self.screenAView.isHidden = true
                self.screenBView.isHidden = true
                self.screenCView.isHidden = true
                
                switch value {
                case .screenA:
                    self.screenAView.isHidden = false
                    
                case .screenB:
                    self.selectedLocaltionData.accept(nil)
                    if let marker = self.currentMarker {
                        self.setCameraOfGoogleMap(marker.position)
                    }
                    self.screenBView.isHidden = false
                    
                case .screenC:
                    self.screenCView.isHidden = false
                    
                }
                
            })
            .disposed(by: disposeBag)
        
        self.selectedLocaltionData.asObservable()
            .subscribe(onNext: { [weak self] value in
                guard let self = self else {
                    return
                }
                
                guard let latitude = value?.latitude,
                      let longitude = value?.longitude else {
                          self.selectedMarker?.map = nil
                          self.selectedMarker = nil
                          return
                      }
                
                self.selectedMarker = self.selectedMarker ?? GMSMarker()
                self.selectedMarker?.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                self.selectedMarker?.title = value?.locationNames.first ?? ""
                self.selectedMarker?.snippet = value?.locationNames[existAt: 1] ?? ""
                self.selectedMarker?.map = self.gmsMapView
                
            })
            .disposed(by: disposeBag)
        
        manager.pointA.asObservable()
            .subscribe(onNext: { [weak self] value in
                guard let self = self else {
                    return
                }
                
                self.pointALabel.text = "Set location for point A"
                self.pointAResultLabel.text = "Set location for point A"
                guard let latitude = value?.latitude,
                      let longitude = value?.longitude else {
                          return
                      }
                
                self.pointALabel.text = "Point A:\nLatitude: \( latitude.string )\nLongitude: \( longitude.string )"
                let locationName = value?.locationNames.joined(separator: ", ") ?? ""
                self.pointAResultLabel.text = "Point A:\nLatitude: \( latitude.string )\nLongitude: \( longitude.string )\nAqi: \( value?.airQuality?.aqi ?? 0 )\nLocation: \( locationName )"
                
            })
            .disposed(by: disposeBag)
        
        manager.pointB.asObservable()
            .subscribe(onNext: { [weak self] value in
                guard let self = self else {
                    return
                }
                
                self.pointBLabel.text = "Set location for point B"
                self.pointBResultLabel.text = "Set location for point B"
                guard let latitude = value?.latitude,
                      let longitude = value?.longitude else {
                          return
                      }
                let locationName = value?.locationNames.joined(separator: ", ") ?? ""
                self.pointBLabel.text = "Point B:\nLatitude: \( latitude.string )\nLongitude: \( longitude.string )"
                self.pointBResultLabel.text = "Point B:\nLatitude: \( latitude.string )\nLongitude: \( longitude.string )\nAqi: \( value?.airQuality?.aqi ?? 0 )\nLocation: \( locationName )"
                
            })
            .disposed(by: disposeBag)
        
        searchTextField.rx.text.orEmpty
            .throttle(.milliseconds(100), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { query -> Observable<[LocationData]> in
                if query.isEmpty {
                    return .just([])
                }
                return self.searchCaches(query)
                    .catchAndReturn([])
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { value in
                let maxRow: CGFloat = 3
                self.searchTableView.rowHeight = 44
                self.searchTableView.frame.size.height = min(self.searchTableView.rowHeight * CGFloat(value.count), self.searchTableView.rowHeight * maxRow)
                self.bottomView.frame.size.height = self.searchTableView.frame.size.height + self.searchTextField.frame.size.height
                self.searchTableView.frame.origin.y = 0
                self.bottomView.frame.origin.y = self.maxYOfBottomView - self.bottomView.frame.size.height
                self.searchedCaches.accept(value)
                                
            })
            .disposed(by: disposeBag)
        
        self.searchedCaches.asObservable()
            .bind(to: self.searchTableView.rx.items(cellIdentifier: "cellID")) {
                (index, locationData: LocationData, cell) in
                cell.contentView.backgroundColor = .white
                cell.textLabel?.textColor = .black
                cell.textLabel?.text = "\( locationData.locationNames.joined(separator: ", ") ) (\( locationData.latitude ?? 0 ), \( locationData.longitude ?? 0 ))"
                cell.textLabel?.font = UIFont.systemFont(ofSize: 12)
            }
            .disposed(by: self.disposeBag)

        Observable.zip(searchTableView.rx.itemSelected, searchTableView.rx.modelSelected(LocationData.self))
            .asObservable()
            .subscribe(onNext: { index, element in
                self.searchTableView.deselectRow(at: index, animated: true)
                self.selectedLocaltionData.accept(element)
                if let lat = element.latitude, let long = element.longitude {
                    self.setCameraOfGoogleMap(CLLocationCoordinate2D(latitude: lat, longitude: long))
                }
                self.resetText()
            })
            .disposed(by: disposeBag)
        
    }
    
    func resetText() {
        self.searchTextField.text = ""
        self.searchTextField.sendActions(for: .valueChanged)
        self.view.endEditing(true)
    }
    
    /// Search caches
    func searchCaches(_ query: String) -> Observable<[LocationData]> {
        let caches = self.manager.caches.value
        return Observable.create { observer in
            let data = caches.filter({ $0.locationNames.map({ $0.lowercased().folding }).joined(separator: ", ").contains(query.lowercased().folding) })
            observer.onNext(data)
            return Disposables.create()
        }
    }
    
    // MARK: - Config UI
    func configUI() {
        self.manager = ViewControllerViewModelImpl()
        self.requestLocationAuthorization()
        gmsMapView.delegate = self
        searchTextField.delegate = self
        handleKeyboard(register: true)
        searchTableView.backgroundColor = .white
        self.maxYOfBottomView = self.bottomView.frame.maxY
    }
    
    /// Request location authorization
    func requestLocationAuthorization() {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
    }
    
    // MARK: - Handle Action
    func handleAction() {
        
    }
    
    // MARK: - Screen A Action
    @IBAction func setButtonA_Pressed(_ sender: Any) {
        isSetPointA = true
        self.screenState.accept(.screenB)
        
    }
    
    @IBAction func setButtonB_Pressed(_ sender: Any) {
        isSetPointA = false
        self.screenState.accept(.screenB)
        
    }
    
    @IBAction func clearButton_Pressed(_ sender: Any) {
        self.manager.clearPoints()
        
    }
    
    // MARK: - Screen B Action
    @IBAction func setButton_Pressed(_ sender: Any) {
        view.endEditing(true)
        guard let locationData = selectedLocaltionData.value else {
            showAlert("Warning", message: "Set location by long press.")
            return
        }
        
        self.manager.updatePoint(isSetPointA, locationData: locationData)
        if self.manager.checkPointsAdded() {
            self.screenState.accept(.screenC)
            return
        }
        
        self.screenState.accept(.screenA)
        
    }
    
    // MARK: - Screen C Action
    @IBAction func backButton_Pressed(_ sender: Any) {
        manager.clearPoints()
        self.screenState.accept(.screenA)
    }
    
}

// MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first, currentMarker == nil else {
            return
        }
        
        setCameraOfGoogleMap(location.coordinate)
        
        // Creates a marker in the center of the map.
        currentMarker = GMSMarker()
        currentMarker?.position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        currentMarker?.map = gmsMapView
        
    }
    
    /// Set Camera View for Google map with coordinate
    func setCameraOfGoogleMap(_ coordinate: CLLocationCoordinate2D) {
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 14)
        gmsMapView.animate(to: camera)
    }
    
}

// MARK: - GMSMapViewDelegate
extension ViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        self.resetText()
        self.setCameraOfGoogleMap(coordinate)
        self.selectedLocaltionData.accept(LocationData(coordinate))
        self.manager.isShowLoading.onNext(true)
        self.manager.getAirQualityAndLocality(coordinate)
            .asObservable()
            .subscribe(onNext: { value in
                self.manager.isShowLoading.onNext(false)
                self.selectedLocaltionData.accept(value)
                
            })
            .disposed(by: disposeBag)
        
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        view.endEditing(true)
    }
    
}

// MARK: - UITextfieldDelegate
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

// MARK: - HandleKeyboardProtocol
extension ViewController: HandleKeyboardProtocol {
    
    func handleKeyboard(willShow notify: NSNotification) {
        //        print(#function)
        if let keyboardFrame: NSValue = notify.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            let safeAreaBottom = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
            UIView.animate(withDuration: 0.3) {
                self.bottomView.frame.origin.y = self.screenBView.frame.size.height - self.bottomView.frame.height - 8 - keyboardHeight + safeAreaBottom
                
            } completion: { fn in
                self.maxYOfBottomView = self.bottomView.frame.maxY
            }
        }
    }
    
    func handleKeyboard(willHide notify: NSNotification) {
        //        print(#function)
        UIView.animate(withDuration: 0.3) {
            self.bottomView.frame.origin.y = self.screenBView.frame.size.height - self.bottomView.frame.height - 8
            
        } completion: { fn in
            self.maxYOfBottomView = self.bottomView.frame.maxY

        }
    }
    
}
