import ArgumentParser

struct Options: ParsableArguments {
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

	@Option(
		name: .customShort("p"),
		help: ArgumentHelp("Add prefix string to each line.", valueName: "prefix"))
	var prefixStr = ""

	@Flag(name: .customShort("e"), help: "Escape format.")
	var escapeChar = false

	@Flag(name: .customShort("n"), help: "Encode path in NFC(Linux) encoding.")
	var nfc = false

	@Flag(name: .customLong("qd"), help: "Path in double quote.")
	var quoteDouble = false

	@Flag(name: .customLong("qs"), help: "Path in single quote.")
	var quoteSingle = false

	@Flag(name: .customLong("debug"), help: "Debug mode.")
	var debug = false

	@Flag(name: .customLong("not-found"), help: "Path not found.")
	var notFound = false

	@Flag(name: .customLong("not-found-remove"), help: "Path not found.")
	var notFoundRemove = false

	@Argument(
		help: ArgumentHelp("Play list name", discussion: "List all play list if no name is provided."))
	var name: String?
}
let opts = Options.parseOrExit()
