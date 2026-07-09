import iTunesLibrary

let itLib = try ITLibrary(apiVersion: "*")

func printVersion() {
	print("itpl version: \(Version)")
}

if opts.debug {
	printVersion()
	print("# iTunes API ver : \(itLib.apiMajorVersion).\(itLib.apiMinorVersion)")
	print("# iTunes version : \(itLib.applicationVersion)")
	print("# -- ARGS : Start")
	CommandLine.arguments.forEach { arg in print(arg) }
	print("# -- ARGS : End")
	print()
}

if opts.ver {
	printVersion()
} else if opts.name == nil {  // all playlists
	var pl = itLib.allPlaylists
	if opts.sort { pl.sort(by: { lhs, rhs in lhs.name < rhs.name }) }
	pl.forEach({ pl in print(pl.name) })
} else {
	itLib.allPlaylists.forEach { pl in
		if pl.name.lowercased() == opts.name?.lowercased() {
			Items(playlist: pl).items.forEach({ i in
				if i.description.count > 0 {
					print(opts.prefixStr + String(describing: i) + opts.postfixStr)
				}
			})
		}
	}
}
