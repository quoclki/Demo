//
//  Network.swift
//  Todo
//
//  Created by Lu Kien Quoc on 30/11/2021.
//

import Foundation
import RxSwift
import Alamofire

protocol Network {
    func geolocalizedFeed(_ request: GeolocalizedFeedRequest) -> Observable<GeolocalizedFeedResponse>
    func locality(_ request: LocalityRequest) -> Observable<LocalityResponse>

}

class NetworkImpl: Network {
        
    // MARK: - Properties
    private var AQI_API = "https://api.waqi.info/feed/geo:10.3;20.7/"
    private var LOCALITY_API = "https://api.bigdatacloud.net/data/reverse-geocode-client"
        
    // MARK: - Function
    /// GET
    private func get(_ url: String, parameters: Parameters? = nil) -> Observable<Data?> {
        return Observable.create { (observer) -> Disposable in
            AF.request(url, method: .get, parameters: parameters)
                .response(completionHandler: { response in
                    switch response.result {
                    case .success( _):
                        observer.onNext(response.data)
                        observer.onCompleted()
                        
                    case .failure(let error):
                        observer.onError(error)
                    }
                })
            
            return Disposables.create()
        }
    }
    
    /// POST
    private func post(_ url: String, parameters: Parameters? = nil) -> Observable<Data?> {
        return Observable.create { (observer) -> Disposable in
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .response(completionHandler: { (response) in
                    switch response.result {
                    case .success( _):
                        observer.onNext(response.data)
                        observer.onCompleted()

                    case .failure(let error):
                        observer.onError(error)
                    }
                })

            return Disposables.create()
        }
    }

    /// Request Geolocalized Feed
    func geolocalizedFeed(_ request: GeolocalizedFeedRequest) -> Observable<GeolocalizedFeedResponse> {
        let parameter = request.toData()?.toDictionary()
        return Observable.create { observer in
            return self.get(self.AQI_API, parameters: parameter)
                .subscribe(onNext: { value in
                    if let data: GeolocalizedFeedResponse = value?.decode() {
                        observer.onNext(data)
                    }
                    
                }, onError: observer.onError, onCompleted: observer.onCompleted)
        }
    }
    
    /// Request Locality
    func locality(_ request: LocalityRequest) -> Observable<LocalityResponse> {
        let parameter = request.toData()?.toDictionary()
        return Observable.create { observer in
            return self.get(self.LOCALITY_API, parameters: parameter)
                .subscribe(onNext: { value in
                    if let data: LocalityResponse = value?.decode() {
                        observer.onNext(data)
                    }
                    
                }, onError: observer.onError, onCompleted: observer.onCompleted)
        }

    }

    
}
