//
//  DataService.swift
//  AirQualityMonitor
//
//  Created by Neha Goel on 21/11/21.
//

import Foundation
import Starscream

class DataService{
    typealias DataUpdateHandler = ((_ aqiData: [AQIDataModel], _ error: Error?) -> Void)
    private let serverUrl = "ws://city-ws.herokuapp.com"
    private var webSocket: WebSocket?
    
    // Initialises Web Socket and subscribes to socket events
    func initialise(updateHandler: @escaping DataUpdateHandler){
        guard let url = URL(string: serverUrl) else{
            return
        }
        let request = URLRequest(url: url)
        webSocket = WebSocket(request: request)
        webSocket?.onEvent = { event in
            self.handle(event: event, updateHandler: updateHandler)
        }
        webSocket?.connect()
    }
    
    // Reconnects to WS
    func reconnect(){
        webSocket?.connect()
    }
    
    // Handles Various WS events
    func handle(event: WebSocketEvent, updateHandler: DataUpdateHandler){
        switch event {
        case .connected(let headers):
            Console.log("websocket is connected: \(headers)")
            break
        case .disconnected(let reason, let code):
            Console.log("websocket is disconnected: \(reason) with code: \(code)")
            break
        case .text(let string):
            Console.log("Received text: \(string)")
            let data = Data(string.utf8)
            do {
                let aqiData = try JSONDecoder().decode([AQIDataModel].self, from: data)
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
            break
        case .error(let error):
            updateHandler([], error)
            break
        }
    }
}

