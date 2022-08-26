//
//  Array.swift
//  TestTaskNatife
//
//  Created by Tanya Koldunova on 25.08.2022.
//

import Foundation

extension Array
  {
     func uniqueValues<V:Equatable>( value:(Element)->V) -> [Element]
     {
        var result:[Element] = []
         self.forEach({ element in
             if !result.contains(where: { value($0) == value(element) })
            { result.append(element) }
         })
        return result
     }
  }

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
