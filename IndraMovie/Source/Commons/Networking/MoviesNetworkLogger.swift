//
//  MeliNetworkLogger.swift
//
//  Created by Jordy Aguilar on 28/12/21.
//

import Foundation
import Alamofire

class MoviesNetworkLogger: EventMonitor {
    func requestDidFinish(_ request: Request) {
        print(request.description)
    }
    func request<Value>(_ request: DataRequest,
                        didParseResponse response: DataResponse<Value, AFError>){
        guard let data = response.data else {
                   return
               }
        if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
                    print(json)
        }else {
            print("MeliNetworkLogger: json no correct format")
        }
    }
}
