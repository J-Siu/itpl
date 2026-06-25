import iTunesLibrary

// An ITLibMediaItem wrapper support output option
struct Item {
	var item: ITLibMediaItem
	var opts: Options

	// `get` only
	var artist: String { return item.artist?.name ?? "" }
	var bitrate: Int { return item.bitrate }
	var fileSize: String {
		return
			"\((Double(item.fileSize) / 1024 / 1024).formatted(.number.precision(.fractionLength(1))))M"
	}
	var path: String { return formatPath(item.location?.path ?? "") }
	// var persistentID: NSNumber { return item.persistentID }
	var persistentID: String {
		return String(UInt(item.persistentID.uint64Value), radix: 16, uppercase: true)
	}
	// var persistentID: String { return String(UInt(item.persistentID.uintValue), radix: 16, uppercase: true) }
	// var persistentID: String { return String(format: "%016lX", item.persistentID.uint64Value) }
	// var persistentID: String { return String(format: "%016lX", item.persistentID.uintValue) }
	// var persistentID: String { return String(item.persistentID.uint64Value, radix: 16, uppercase: true) }
	// var persistentID: String { return String(item.persistentID.uintValue, radix: 16, uppercase: true) }
	var title: String { return item.title }

	init(opts: Options, item: ITLibMediaItem) {
		self.item = item
		self.opts = opts
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
	private func toStrPathOnly() -> String { return path }

	private func toStrInfo() -> String {
		return ""
			+ "\(title) | "
			+ "\(fileSize) | "
			+ "\(bitrate) | "
			+ "\(persistentID) | "
			+ "\(artist) | "
			+ path
	}

	private func toStrDebug() -> String {
		var str =
			""
			+ "# ---\n"
			+ "# Title    : " + title + "\n"
			+ "# Kind     : " + (item.kind ?? "") + "\n"
		if item.location != nil {
			let loc = item.location!
			str +=
				"# Scheme   : " + loc.scheme! + "\n"
				+ "# Loc(STR) : " + loc.absoluteString + "\n"
				+ "# Path     : " + loc.path + "\n"
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
	var items: [Item] = []
	var opts: Options

	init(opts: Options, playlist: ITLibPlaylist) {
		self.opts = opts
		var out: [Item] = []
		var tmp = playlist.items
		if opts.duplicate || opts.sort {
			tmp = playlist.items.sorted(by: { lhs, rhs in lhs.title < rhs.title })
		}
		let count = tmp.count
		for i in 0..<count {
			if !opts.duplicate
				|| (i > 0 && tmp[i].title == tmp[i - 1].title)
				|| (i < count - 1 && tmp[i].title == tmp[i + 1].title)
			{
				let item = Item(opts: opts, item: tmp[i])
				if !(opts.notFound
					&& (item.path == "" || FileManager.default.fileExists(atPath: item.path)))
				{
					out.append(item)
				}
			}
		}
		items = out
	}
}

extension Items: CustomStringConvertible {
	var description: String {
		var str = ""
		items.forEach({ i in
			if i.description.count > 0 {
				str += i.description + "\n"
			}
		})
		return str
	}
}
