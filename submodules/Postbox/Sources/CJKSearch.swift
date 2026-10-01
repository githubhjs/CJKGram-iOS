import Foundation

/// Utilities used by CJKGram's message search path.
///
/// The upstream full-text index is token based. CJK text usually has no spaces
/// between words, so splitting a query into individual CJK characters lets the
/// index match Chinese, Japanese and Korean messages without changing the
/// storage format or the user's message data.
enum CJKSearch {
    static func containsCJK(_ character: Character) -> Bool {
        for scalar in character.unicodeScalars {
            switch scalar.value {
            case 0x3400...0x4DBF, 0x4E00...0x9FFF, 0xF900...0xFAFF,
                 0x3040...0x30FF, 0xAC00...0xD7AF:
                return true
            default:
                continue
            }
        }
        return false
    }

    /// Returns terms that can be queried independently and intersected.
    /// Latin text stays grouped while CJK characters become one-character terms.
    static func terms(for query: String) -> [String] {
        var result: [String] = []
        var latin = ""

        func flushLatin() {
            if !latin.isEmpty {
                result.append(latin)
                latin.removeAll(keepingCapacity: true)
            }
        }

        for character in query {
            if containsCJK(character) {
                flushLatin()
                result.append(String(character))
            } else if character.isWhitespace || character.isPunctuation {
                flushLatin()
            } else {
                latin.append(character)
            }
        }
        flushLatin()

        // Preserve order while removing duplicate CJK terms.
        var unique: [String] = []
        var seen = Set<String>()
        for term in result where seen.insert(term).inserted {
            unique.append(term)
        }
        return unique
    }
}
