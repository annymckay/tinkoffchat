//
//  MultipeerCommunicator.swift
//  TinkoffChat
//
//  Created by Анна Лихтарова on 01.04.2018.
//  Copyright © 2018 Анна Лихтарова. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity

class MultipeerCommunicator : NSObject, Communicator {
    
    private let myPeerId = MCPeerID(displayName: (UIDevice.current.identifierForVendor?.uuidString)!)
    private let serviceType : String = "tinkoff-chat"
    private var discoveryInfo = ["userName" : String((UIDevice.current.identifierForVendor?.uuidString.suffix(4))!)]
    private var usersMCPeerID : [String : MCPeerID] = [:]
    var sessions : [MCPeerID : MCSession] = [:]
    
    var serviceAdvertiser : MCNearbyServiceAdvertiser
    var serviceBrowser : MCNearbyServiceBrowser
    var delegate: CommunicatorDelegate?
    
    var online: Bool
    var model : ConversationsModel? {
        didSet {
            self.delegate = CommunicationManager(model: self.model!)
        }
    }
    override init() {
       // print(#function)
        self.online = true
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: discoveryInfo, serviceType: serviceType)
        self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)
        self.serviceAdvertiser.startAdvertisingPeer()
        self.serviceBrowser.startBrowsingForPeers()
        super.init()
        self.serviceAdvertiser.delegate = self
        self.serviceBrowser.delegate = self
    }
    deinit {
        //print(#function)
        self.serviceAdvertiser.stopAdvertisingPeer()
        self.serviceBrowser.stopBrowsingForPeers()
    }
    
    func sendMessage(string: String, to userID: String, completionHandler: ((Bool, Error?) -> ())?) {
        //print(#function)
        let jsonMessage = serializeMessage(text: string)
        do {
            if let mcPeerId = usersMCPeerID[userID] {
                if (sessions[mcPeerId] != nil) {
                    try sessions[mcPeerId]!.send(jsonMessage!, toPeers: sessions[mcPeerId]!.connectedPeers, with: .reliable)
                    if let completionHandler = completionHandler {
                        completionHandler(true, nil)
                    }
                }
            }
        } catch let error {
            //print(error)
            if let completionHandler = completionHandler {
                completionHandler(false, error)}
        }
        
    }
    
    func parseMessage(data : Data) -> [String : String]? {
        let jsonMessage = try? JSONSerialization.jsonObject(with: data, options: [])
        let textMessage = jsonMessage as? [String : String]
        return textMessage
    }
    func serializeMessage(text: String) -> Data? {
        var message : [String : String] = [:]
        message["messageId"] = generateMessageId()
        message["text"] = text
        message["eventType"] = "TextMessage"
        let data = try? JSONSerialization.data(withJSONObject: message, options: .prettyPrinted)
        return data
    }
    func generateMessageId() -> String {
        let string =  "\(arc4random_uniform(UINT32_MAX))+\(Date.timeIntervalSinceReferenceDate)+\(arc4random_uniform(UINT32_MAX))"
            .data(using: .utf8)?.base64EncodedString()
        return string!
    }
    
}

extension MultipeerCommunicator : MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate, MCSessionDelegate {
    
    //advertiser
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didNotStartAdvertisingPeer error: Error) {
        // online = false
        //print(#function)
        delegate?.failedToStartAdvertising(error: error)
    }
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
       // print(#function)
        if sessions[peerID] == nil {
            //print("reciving invintation")
            sessions[peerID] = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: .required)
            sessions[peerID]!.delegate = self
            invitationHandler(true, sessions[peerID])
            return
        }
        if sessions[peerID]!.connectedPeers.contains(peerID) {
            //print("already in session")
            invitationHandler(true, sessions[peerID])
        } else {
            //print(sessions[peerID]!.connectedPeers)
            invitationHandler(false, nil)
        }
    }
    
    //browser
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        //print(#function)
       // print("foundPeer: \(peerID)")
        usersMCPeerID[peerID.displayName] = peerID
        if (sessions[peerID] == nil) {
            sessions[peerID] = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: .required)
            sessions[peerID]!.delegate = self
            //print("sending invintation")
            browser.invitePeer(peerID, to: sessions[peerID]!, withContext: nil, timeout: 2)
        }
       // print("already invited")
        delegate?.didFoundUser(userID: peerID.displayName, userName: info?["userName"])
    }
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        //print(#function)
        sessions[peerID] = nil
        delegate?.didLostUser(userID: peerID.displayName)
    }
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        //print(#function)
        delegate?.failedToStartBrowsingForUsers(error: error)
    }
    
    //session
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
       /* if (state == .connected) {
            print("\(#function), peer: \(peerID.displayName), state .connected")
        }
        if (state == .connecting) {
            print("\(#function), peer: \(peerID.displayName), state .connecting")
        }*/
        if (state == .notConnected) {
            //print("\(#function), peer: \(peerID.displayName), state .notConnected")
            sessions[peerID] = nil
            delegate?.didLostUser(userID: peerID.displayName)
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
       // print(#function)
        let message = parseMessage(data: data)
        if let text = message?["text"] {
            delegate?.didReceiveMessage(text: text, fromUser: peerID.displayName, toUser: myPeerId.displayName)
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
       // print(#function)
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
       // print(#function)
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
       // print(#function)
        
    }
    
}
protocol Communicator {
    func sendMessage(string: String, to userID: String, completionHandler: (( _ success: Bool, _ error : Error?) -> ())? )
    weak var delegate : CommunicatorDelegate? {get set}
    var online : Bool {get set}
}

