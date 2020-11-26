//
//  TableOfContentsMapper.swift
//  ContentMapping
//
//  Created by Kevin van den Hoek on 26/11/2020.
//

struct DocumentSection {
    
    let title: String
    let level: Int
    let subsections: [DocumentSection]
}

struct TableOfContentsMapper {
    
    /// Maps a document into sections, structured by given element types
    func map(elementTypes: [String], in document: Document) -> [DocumentSection] {
        
        let elementTypesWithLevel: [ElementTypeWithLevel] = elementTypes
            .enumerated()
            .map({ index, elementType in (elementType: elementType, level: index) })
        
        let elementsWithLevel: [ElementWithLevel] = document
            .query(elementTypes: elementTypes)
            .compactMap({ element -> ElementWithLevel? in
                guard let level = elementTypesWithLevel.level(of: element.type) else { return nil }
                return (element: element, level: level)
            })
        
        return getSections(at: 0, elementsWithLevel: elementsWithLevel)
    }
}

// MARK: Where magic happens
private extension TableOfContentsMapper {
    
    /// Recursively maps out all sections
    func getSections(at level: Int, elementsWithLevel: [ElementWithLevel]) -> [DocumentSection] {
        
        var subsectionLevel: Int = .max
        return elementsWithLevel
            .enumerated()
            .filter({ index, elementWithLevel in
                subsectionLevel = min(elementWithLevel.level, subsectionLevel)
                return elementWithLevel.level == subsectionLevel
            })
            .map({ index, elementWithLevel in
                return DocumentSection(
                    title: elementWithLevel.element.text,
                    level: elementWithLevel.level,
                    subsections: getSections(
                        at: level + 1,
                        elementsWithLevel: elementsWithLevel.subelements(at: elementWithLevel.level, offset: index)
                    )
                )
            })
    }
}

// MARK: ElementTypeWithLevel & Array helper
private typealias ElementTypeWithLevel = (elementType: String, level: Int)

private extension Array where Element == ElementTypeWithLevel {
    
    func level(of elementType: String) -> Int? {
        
        return first(where: { $0.elementType == elementType })?.level
    }
}

// MARK: ElementWithLevel & Array helper
private typealias ElementWithLevel = (element: Document.Element, level: Int)

private extension Array where Element == ElementWithLevel {
    
    /// Returns a slice of an array which contains all elements that are considered children (direct and indirect), from the given offset until the next element with the given level or lower is found.
    func subelements(at level: Int, offset: Int) -> [ElementWithLevel] {
        
        let slice = self[(offset + 1)..<count]
        
        if let nextSectionIndex = slice.firstIndex(where: { $0.level <= level }) {
            return self[(offset + 1)..<nextSectionIndex].toArray
        } else {
            return slice.toArray
        }
    }
}

// MARK: ArraySlice helper
extension ArraySlice {
    
    var toArray: Array<Element> { Array(self) }
}
