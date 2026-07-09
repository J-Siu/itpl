import ArgumentParser

struct Options: ParsableArguments {
	@Flag(name: .customShort("a"), help: "Check duplicate with artist")
	var artist = false

	@Flag(name: .customShort("b"), help: "Show original and lowercase + simplified chinese")
	var both = false

	@Option(name: .customShort("f"), help: ArgumentHelp("Filter by album, artist and title"))
	var filter: [String] = []

	@Flag(name: .customShort("i"), help: "Info mode")
	var info = false

	@Flag(name: .customShort("s"), help: "Sort by title")
	var sort = false

	@Flag(name: .customShort("d"), help: "List duplicate.")
	var duplicate = false

	@Option(
		name: .customShort("r"),
		help: ArgumentHelp(
			"Remove base path from item path output.",
			discussion: "Path output in full if it does not contain the provided base path.",
			valueName: "base path"))
	var basePath: String?

	@Flag(name: .customShort("e"), help: "Escape format.")
	var escapeChar = false

	@Flag(name: .customShort("n"), help: "Encode path in NFC(Linux) encoding.")
	var nfc = false

	@Option(name: .customLong("pr"), help: ArgumentHelp("Add prefix string to each line."))
	var prefixStr = ""

	@Option(name: .customLong("po"), help: ArgumentHelp("Add postfix string to each line."))
	var postfixStr = ""

	@Flag(name: .customLong("qd"), help: "Path in double quote.")
	var quoteDouble = false

	@Flag(name: .customLong("qs"), help: "Path in single quote.")
	var quoteSingle = false

	@Flag(name: .customLong("debug"), help: "Debug mode.")
	var debug = false

	@Flag(name: .customLong("not-found"), help: "Path not found.")
	var notFound = false

	@Flag(name: .customShort("v"), help: "Version")
	var ver = false

	@Argument(
		help: ArgumentHelp("Play list name", discussion: "List all play list if no name is provided."))
	var name: String?
}
let opts = Options.parseOrExit()
