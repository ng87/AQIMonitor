//
//  DataService.swift
//  AirQualityMonitor
//
//  Created by Neha Goel on 21/11/21.
//

import Foundation
import Starscream

class DataService{
    
    let serverUrl = "ws://city-ws.herokuapp.com"
    var isConnected = false
    var webSocket: WebSocket?
    
    func initialise(updateHandler: @escaping (_ aqiData: [AQIDataModel], _ error: Error?)->Void){
        guard let url = URL(string: serverUrl) else{
            return
        }
        let request = URLRequest(url: url)
        webSocket = WebSocket(request: request)
        webSocket?.onEvent = { event in
            switch event {
            case .connected(let headers):
                self.isConnected = true
                Console.log("websocket is connected: \(headers)")
                break
            case .disconnected(let reason, let code):
                self.isConnected = false
                Console.log("websocket is disconnected: \(reason) with code: \(code)")
                break
            case .text(let string):
                Console.log("Received text: \(string)")
                let data = Data(string.utf8)
                do {
                    let aqiData = try JSONDecoder().decode([AQIDataModel].self, from: data)
//                    self.webSocket?.disconnect()
//                    Timer.scheduledTimer(withTimeInterval: 30.0, repeats: false) { timer in
//                        self.webSocket?.connect()
//                        timer.invalidate()
//                    }
                    updateHandler(aqiData, nil)
                } catch let newError {
                    Console.log("\(newError)")
                }
            case .binary(let data):
                Console.log("Received data: \(data.count)")
                break
            case .ping(_):
                break
            case .pong(_):
                break
            case .viabilityChanged(_):
                break
            case .reconnectSuggested(_):
                break
            case .cancelled:
                self.isConnected = false
                break
            case .error(let error):
                self.isConnected = false
                updateHandler([], error)
                break
            }
        }
        webSocket?.connect()
    }
}

