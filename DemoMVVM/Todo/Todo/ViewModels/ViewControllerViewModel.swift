//
//  ViewControllerViewModel.swift
//  Todo
//
//  Created by Lu Kien Quoc on 26/12/2021.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation

protocol BaseProtocol {
    var isShowLoading: PublishSubject<Bool> { get }
    var error: BehaviorRelay<Error> {get}
}

protocol ViewControllerViewModel: BaseProtocol {
    var pointA: BehaviorRelay<LocationData?> { get } // Point A behavior
    var pointB: BehaviorRelay<LocationData?> { get } // Point B behavior
    var caches: BehaviorRelay<[LocationData]> { get } // Caches
    
    func updatePoint(_ isPointA: Bool, locationData: LocationData)
    func clearPoints()
    func checkPointsAdded() -> Bool
    func getAirQualityAndLocality(_ coordinate: CLLocationCoordinate2D) -> Observable<LocationData>
}

final class ViewControllerViewModelImpl: ViewControllerViewModel {
    
    // MARK: - Properties
    var error: BehaviorRelay<Error> = BehaviorRelay(value: NSError(domain: "", code: 200, userInfo: nil))
    var isShowLoading: PublishSubject<Bool> = PublishSubject()
    var caches: BehaviorRelay<[LocationData]> = BehaviorRelay(value: [])

    var pointA: BehaviorRelay<LocationData?> = BehaviorRelay(value: nil)
    var pointB: BehaviorRelay<LocationData?> = BehaviorRelay(value: nil)
    
    private var disposeBag = DisposeBag()
    private var network: Network = NetworkImpl()
    
    // MARK: - Function
    /// Update point
    func updatePoint(_ isPointA: Bool, locationData: LocationData) {
        if isPointA {
            self.pointA.accept(locationData)
        } else {
            self.pointB.accept(locationData)
        }
        
        self.updateCaches(locationData)
        
    }
    
    /// Update caches
    private func updateCaches(_ locationData: LocationData) {
        var caches = self.caches.value
        if !caches.filter({ $0.latitude == locationData.latitude && $0.longitude == locationData.longitude }).isEmpty {
            return
        }
        
        caches.appends(locationData)
        self.caches.accept(caches)
        
    }
    
    /// Clear points
    func clearPoints() {
        self.pointA.accept(nil)
        self.pointB.accept(nil)
    }
    
    /// Check points added
    func checkPointsAdded() -> Bool {
        return self.pointA.value != nil && self.pointB.value != nil
    }
    
    /// Gen Air Qualyty And Locality
    func getAirQualityAndLocality(_ coordinate: CLLocationCoordinate2D) -> Observable<LocationData> {
        return Observable.create { observer in
            let latitude = coordinate.latitude
            let longitude = coordinate.longitude
            
            let requestAqi = GeolocalizedFeedRequest(latitude, lng: longitude)
            requestAqi.token = Base.shared.AQI_TOKEN
            let requestLocality = LocalityRequest(latitude, longitude: longitude)
            
            return Observable.zip(self.network.geolocalizedFeed(requestAqi),
                                  self.network.locality(requestLocality))
                .subscribe(onNext: { aqiData, locality in
                    let data = LocationData(coordinate)
                    data.airQuality = aqiData.data
                    data.locality = locality
                    observer.onNext(data)
                    
                }, onError: { self.error.accept($0) }, onCompleted: observer.onCompleted)
            
        }
    }
        
}
