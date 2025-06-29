//
//  Logger.swift
//  Cartella
//
//  Created by Anushka Samarasinghe on 2025-06-27.
//

import Foundation

enum LogType: String{
    case error
    case warning
    case success
    case info
    case action
    case canceled
}

class Logger{
    static func log( logType:LogType, message:String){
        switch logType {
        case LogType.error:
            print("\n Error ==========> \n\(message)\n <================== \n")
            
        case LogType.warning:
            print("\n Warning ========> \n\(message)\n <================== \n")
            
        case LogType.success:
            print("\n Success ========> \n\(message)\n <================== \n")
            
        case LogType.info:
            print("\n Info ===========> \n\(message)\n <================== \n")
            
        case LogType.action:
            print("\n Action =========> \n\(message)\n <================== \n")
            
        case LogType.canceled:
            print("\n Cancelled ======> \n\(message)\n <================== \n")
        }
    }
    
}
