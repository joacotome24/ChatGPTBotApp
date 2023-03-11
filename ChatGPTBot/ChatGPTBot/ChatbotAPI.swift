//
//  ChatbotAPI.swift
//  ChatGPTBot
//
//  Created by Joaquin Tome on 11/3/23.
//
import ChatGPTSwift
import Foundation

class ChatbotAPI {
    let api = ChatGPTAPI(apiKey: "INSERT API KEY")
    
    
    func getResponse(for message: String, completion: @escaping (String) -> Void) {
        Task {
            do {
                let response = try await api.sendMessage(text: message)
                completion(response)
            } catch {
                print(error.localizedDescription)
                completion("")
            }
        }
    }
}
