//
//  Document.swift
//  ContentMapping
//
//  Created by Kevin van den Hoek on 26/11/2020.
//

struct Document {
    
    struct Element {
        /// I.E. h2
        let type: String
        /// The text 'within the h2'
        let text: String
    }
    
    private let pageElements: [Element]
    
    init(with pageElements: [Element]? = nil) {
        self.pageElements = pageElements ?? [
            Element(type: "h1", text: "a"),
            Element(type: "h2", text: "b"),
            Element(type: "h3", text: "c"),
            Element(type: "h2", text: "d"),
            Element(type: "h1", text: "e"),
            Element(type: "h2", text: "f"),
            Element(type: "h2", text: "g"),
            Element(type: "h3", text: "h"),
            Element(type: "h2", text: "i"),
            Element(type: "h1", text: "j")
        ]
    }
    
    /// Returns all elements in the document that are any of the given elementTypes
    func query(elementTypes: [String]) -> [Element] {
        return pageElements
            .filter({ elementTypes.contains($0.type) })
    }
}
