/*
main.swift
itpl

Created by John Siu on 2020-04-01.

MIT License

Copyright (c) 2020

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import ArgumentParser
import Foundation
import iTunesLibrary

var itl = try ITLibrary(apiVersion: "*")

extension String {
	// Escape characters
	func escapeChar() -> String {
		// Escape List: double quote, single quote, space, etc.
		let escapeCharList = "\"`'()[]<>&?$*|\\ "
		var tmpStr: String = ""
		for c in self {
			if escapeCharList.contains(c) {
				tmpStr += "\\\(c)"
			}
			else {
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

	// NFD To NFC
	func nfc() -> String {
		//let nsStr = NSString(string: self)
		return NSString(string: self).precomposedStringWithCanonicalMapping
	}

	// Encapsulate in double quote
	func quoteDouble() -> String {
		return "\"\(self)\""
	}

	// Encapsulate in single quote
	func quoteSingle() -> String {
		return "\'\(self)\'"
	}
}

// Options:
// -r <path>
//		Provide base path to be removed.
// -p <prefix>
//		Add prefix, eg. "put "
// -d Debug info
// -e Escape char
// -n NFC(Linux) format
// --qd Path in double quote
// --qs Path in single quote
// play list name
struct ItplOptions: ParsableArguments {
	@Option(name:.customShort("r"),default:"",help:ArgumentHelp(
		"Remove base path from item path output.",
		discussion: "Path output in full if it does not contain the provided base path.",
		valueName: "base path"))
	var basePath: String?

	@Option(name:.customShort("p"),default:"",help:ArgumentHelp("Add prefix string to each line.", valueName: "prefix"))
	var prefixStr: String

	@Flag(name:.customShort("e"),help:"Escape format.")
	var escapeChar: Bool

	@Flag(name:.customShort("n"),help:"Encode path in NFC(Linux) encoding.")
	var nfc: Bool

	@Flag(name:.customLong("qd"),help:"Path in double quote.")
	var quoteDouble: Bool

	@Flag(name:.customLong("qs"),help:"Path in single quote.")
	var quoteSingle: Bool

	@Flag(name:.customShort("d"),help:"Debug mode.")
	var debug: Bool

	@Argument(help:ArgumentHelp("Play list name", discussion: "List all play list if no name is provided."))
	var name: String?
}

func printITunesApiVersion() {
	print("# iTunes API ver : \(itl.apiMajorVersion).\(itl.apiMinorVersion)")
	print("# iTunes version : \(itl.applicationVersion)")
}

func printArgs() {
	print("# ARGS : Start")
	for i in 0..<CommandLine.arguments.count {
		print("# " + CommandLine.arguments[i])
	}
	print("# ARGS : End")
}

// List All Playlist
func printAllPlaylists() {
	for pl in itl.allPlaylists {
		print(pl.name)
	}
}

// Print Item in Playlist
func printPlaylistItems(name: String) {
	for pl in itl.allPlaylists {
		if pl.name == name {
			for i in pl.items {

				if options.debug {
					print("# ---")
					print("# Title    : " + i.title)
					print("# Kind     : " + i.kind!)
				}

				if i.location != nil {
					let loc = i.location!

					if options.debug {
						print("# Scheme   : " + loc.scheme!)
						print("# Loc(STR) : " + loc.absoluteString)
						print("# Path     : " + loc.path)
						var pathComponents = ""
						for p in loc.pathComponents {
							pathComponents += "|" + p
						}
						pathComponents += "|"
						print("# PathComp : " + pathComponents)
					}

					if (loc.scheme != nil) && (loc.scheme! == "file") {

						var path = loc.path

						if options.nfc {
							path = path.nfc()
						}

						if options.basePath != nil {
							path = path.removeBasePath(basePath: options.basePath!)
						}

						if options.escapeChar {
							path = path.escapeChar()
						}

						if options.quoteDouble {
							path = path.quoteDouble()
						}

						if options.quoteSingle {
							path = path.quoteSingle()
						}

						print(options.prefixStr + path)
					}
				}
			}
		}
	}
}

let options = ItplOptions.parseOrExit()

if options.debug {
	printITunesApiVersion()
	printArgs()
}

//  printAllPlaylists()
if options.name == nil {
	printAllPlaylists()
}
else {
	printPlaylistItems(name: options.name!)
}
