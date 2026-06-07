extension String {
	// Escape characters
	func escapeChar() -> String {
		// Escape List: double quote, single quote, space, etc.
		let escapeCharList = "\"`'()[]<>&?$*|\\ "
		var tmpStr: String = ""
		for c in self {
			if escapeCharList.contains(c) {
				tmpStr += "\\\(c)"
			} else {
				tmpStr += "\(c)"
			}
		}
		return tmpStr
	}

	// Remove base path
	func removeBasePath(basePath: String) -> String {
		if self.hasPrefix(basePath) {
			let start = self.index(self.startIndex, offsetBy: basePath.count)
			let end = self.index(self.endIndex, offsetBy: 0)
			let range = start..<end
			return String(self[range])
		}
		// No change
		return basePath
	}

	// NFD To NFC(Linux)
	func nfc() -> String { return self.precomposedStringWithCanonicalMapping }

	// Encapsulate in double quote
	func quoteDouble() -> String { return "\"\(self)\"" }

	// Encapsulate in single quote
	func quoteSingle() -> String { return "\'\(self)\'" }

	// Source - https://stackoverflow.com/a/54794649
	// Posted by Danielvgftv, modified by community. See post 'Timeline' for change history
	// Retrieved 2026-06-06, License - CC BY-SA 4.0
	func trim() -> String { return self.trimmingCharacters(in: .whitespacesAndNewlines) }
}

// cspell:words Danielvgftv precomposed
