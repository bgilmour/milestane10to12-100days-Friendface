//
//  FilteredList.swift
//  Friendface
//
//  Created by Bruce Gilmour on 2021-07-26.
//

import SwiftUI
import CoreData

struct FilteredList<T: NSManagedObject, Content: View>: View {
    var fetchRequest: FetchRequest<T>
    var results: FetchedResults<T> { fetchRequest.wrappedValue }
    let content: (T) -> Content

    init(
        filterKey: String,
        filterValue: String,
        predicate: PredicateOp,
        negate: Bool = false,
        caseSensitive: Bool = true,
        sortDescriptors: [NSSortDescriptor] = [],
        @ViewBuilder content: @escaping (T) -> Content) {

        fetchRequest = FetchRequest<T>(
            entity: T.entity(),
            sortDescriptors: sortDescriptors,
            predicate: filterKey.isEmpty ? nil : NSPredicate(format: "\(negate ? "not " : "")%K \(predicate.rawValue)\(caseSensitive ? "" : "[c]") %@", filterKey, filterValue)
        )
        self.content = content
    }

    var body: some View {
        List(results, id: \.self) { result in
            content(result)
        }
    }
}

enum PredicateOp: String, CaseIterable {
    case equals = "=="
    case lessThan = "<"
    case lessThanEquals = "<="
    case greaterThan = ">"
    case greaterThanEquals = ">="
    case contains
    case beginsWith
    case endsWith
}
