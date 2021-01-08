//
//  CompletionBlock.swift
//  E2API
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-08.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import Foundation

public typealias VoidCompletionBlock = () -> Void
public typealias CompletionBlock = (_ error: NSError?) -> Void
public typealias StatusCompletionBlock = (_ status: Bool, _ error: NSError?) -> Void
public typealias ObjectCompletionBlock<T> = (_ object: T?, _ error: NSError?) -> Void
public typealias SimpleObjectCompletionBlock<T> = (_ object: T) -> Void
