//
//  Handlers.swift
//  Cartella
//
//  Created by Anushka Samarasinghe on 2025-06-27.
//

import Foundation

public typealias CompletionHandlerBaseVM = (_ status: Bool, _ code: Int, _ message: String) -> ()
public typealias CompletionHandler = (_ status: Bool, _ message: String) -> ()
public typealias CompletionHandlerWithProgress = (_ status: Bool, _ progress: Double, _ message: String) -> ()
