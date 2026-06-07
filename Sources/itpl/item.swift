import iTunesLibrary

//
struct Item {
	var opts: Options
	var item: ITLibMediaItem
	var path: String = ""
	init(opts: Options, item: ITLibMediaItem) {
		self.opts = opts
		self.item = item
		self.path = formatPath(item.location!.path)
	}

	// format filepath base on option
	private func formatPath(_ path: String) -> String {
		var p = path
		if opts.nfc {
			p = p.nfc()
		}
		if opts.basePath != nil {
			p = p.removeBasePath(basePath: opts.basePath!)
		}
		if opts.escapeChar {
			p = p.escapeChar()
		}
		if opts.quoteDouble {
			p = p.quoteDouble()
		}
		if opts.quoteSingle {
			p = p.quoteSingle()
		}
		return p
	}
}

extension Item: CustomStringConvertible {
	var description: String {
		if opts.debug { return toStrDebug() }
		if opts.duplicate || opts.info { return toStrInfo() }
		return toStrPathOnly()
	}

	// for .m3u playlist
	private func toStrPathOnly() -> String {
		return path
	}

	private func toStrInfo() -> String {
		var str = ""
		str += "\(item.title) | "
		str +=
			"\((Double(item.fileSize) / 1024 / 1024).formatted(.number.precision(.fractionLength(1))))M | "
		str += "\(item.bitrate) | "
		str += path
		return str
	}

	private func toStrDebug() -> String {
		var str = ""
		str += "# ---\n"
		str += "# Title    : " + item.title + "\n"
		str += "# Kind     : " + item.kind! + "\n"
		if item.location != nil {
			let loc = item.location!
			str += "# Scheme   : " + loc.scheme! + "\n"
			str += "# Loc(STR) : " + loc.absoluteString + "\n"
			str += "# Path     : " + loc.path + "\n"
			var pathComponents = ""
			for p in loc.pathComponents {
				pathComponents += "|" + p
			}
			pathComponents += "|"
			str += "# PathComp : " + pathComponents
		}
		return str
	}
}

struct Items {
	var opts: Options
	var items: [Item] = []

	init(opts: Options, playlist: ITLibPlaylist) {
		self.opts = opts
		var tmp = playlist.items
		var out: [Item] = []
		if opts.duplicate || opts.sort {
			tmp = playlist.items.sorted(by: { lhs, rhs in lhs.title < rhs.title })
		}
		let count = tmp.count
		for i in 0..<count {
			if !opts.duplicate || (i > 0 && tmp[i].title == tmp[i - 1].title)
				|| (i < count - 1 && tmp[i].title == tmp[i + 1].title)
			{
				out.append(Item(opts: opts, item: tmp[i]))
			}
		}
		items = out
	}
}

extension Items: CustomStringConvertible {
	var description: String {
		var str = ""
		items.forEach({ i in
			str += i.description + "\n"
		})
		return str
	}
}
