//
//  FunctionCache.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 30.08.2021.
//

import Foundation

class FunctionCache<TSource: Hashable, TResult> {
    
    private let function: (TSource) -> TResult
    private var cache = [TSource : TResult]()
    
    init (_ function: @escaping (TSource) -> TResult = { _ in fatalError("Unspecified function") }) {
        self.function = function
    }
    
    subscript(_ i: TSource) -> TResult {
        get {
            if !cache.keys.contains(i) {
                cache[i] = function(i)
            }
            
            return cache[i]!
        }
    }
}
