//
//  KeychainHelper.swift
//  Runner
//
//  Created by Mykola Mieshkov on 05.06.2024.
//

import Foundation
import Security

class KeychainHelper {
    static func update(data: Data, forService service: String, account: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data
        ]
        
        let attributesToUpdate: [String: Any] = [
            kSecValueData as String: data
        ]
        
        let status = SecItemUpdate(
            query as CFDictionary,
            attributesToUpdate as CFDictionary
        )
        return status == errSecSuccess
    }
    
    static func put(data: Data, forService service: String, account: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    static func get(forService service: String, account: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true, // Return the data itself
            kSecMatchLimit as String: kSecMatchLimitOne  // Only return a single result
        ]
        
        var result: AnyObject? = nil
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        // Check the status and extract the data
        guard status == errSecSuccess else {
            return nil // No data found or an error occurred
        }
        
        guard let retrievedData = result as? Data,
              let dataString = String(data: retrievedData, encoding: .utf8) else {
            return nil // Data is not in String format
        }
        
        return dataString
    }
    
    static func delete(forService service: String, account: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
}
