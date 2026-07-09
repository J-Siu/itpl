import iTunesLibrary

// ITLibMediaItem wrapper supporting
// - CustomStringConvertible
// - output options
struct Item: CustomStringConvertible {
	let item: ITLibMediaItem

	// -- CustomStringConvertible
	var description: String {
		if opts.debug { return toStrDebug() }
		if opts.duplicate || opts.info { return toStrInfo() }
		return toStrPathOnly()
	}

	// -- `get` only attributes
	var artist: String { return item.artist?.name ?? "" }
	var album: String { return item.album.title ?? "" }
	var bitrate: Int { return item.bitrate }
	var duration: String {
		return
			"\((Double(item.totalTime) / 1000 / 60).formatted(.number.precision(.fractionLength(2))))min"
	}
	var fileSize: String {
		return
			"\((Double(item.fileSize) / 1024 / 1024).formatted(.number.precision(.fractionLength(2))))M"
	}
	var path: String { return formatPath(item.location?.path ?? "") }
	var persistentID: String {
		return String(UInt(item.persistentID.uint64Value), radix: 16, uppercase: true)
	}
	var title: String { return item.title }
	var track: Int { return item.trackNumber }
	var trackCount: Int { return item.album.trackCount }

	// -- Private

	// format filepath base on option
	private func formatPath(_ path: String) -> String {
		var p = path
		// --
		if opts.basePath != nil { p = p.removeBasePath(basePath: opts.basePath!) }
		if opts.nfc { p = p.nfc() }
		// --
		if opts.escapeChar { p = p.escapeChar() }
		// --
		if opts.quoteDouble { p = p.quoteDouble() }
		if opts.quoteSingle { p = p.quoteSingle() }
		return p
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

	private func toStrInfo() -> String {
		if opts.both {
			return ""
				+ "\(title)|" + "\(title.t2s())|"
				+ "\(fileSize)|"
				+ "\(bitrate)|"
				+ "\(duration)|"
				+ "\(artist)|" + "\(artist.t2s())|"
				+ "\(album)|" + "\(album.t2s())|"
				+ path
		}
		return ""
			+ "\(title)|"
			+ "\(fileSize)|"
			+ "\(bitrate)|"
			+ "\(duration)|"
			+ "\(artist)|"
			+ "\(album)|"
			+ path
	}

	// for .m3u playlist
	private func toStrPathOnly() -> String { return path }
}

struct Items {
	var items: [Item] = []

	init(playlist: ITLibPlaylist) {
		let count = playlist.items.count
		var add: Bool = false
		var addNext: Bool = false
		var path: String
		var tmp: [ITLibMediaItem]

		if opts.duplicate || opts.sort {
			tmp = playlist.items.sorted(by: { lhs, rhs in lhs.title.t2s() < rhs.title.t2s() })
		} else {
			tmp = playlist.items
		}

		for i in 0..<count {
			path = tmp[i].location?.path ?? ""

			if !opts.duplicate || i < count - 1 && mediaItemEqual(item1: tmp[i], item2: tmp[i + 1]) {
				add = true
				addNext = true
			} else {
				add = false
			}

			if !(opts.notFound && (path == "" || FileManager.default.fileExists(atPath: path)))
				&& (add || addNext)
			{
				items.append(Item(item: tmp[i]))
				addNext = add && addNext
			}
		}
	}

	// base on opts.artist, check title equal or title+artist equal
	private func mediaItemEqual(item1: ITLibMediaItem, item2: ITLibMediaItem) -> Bool {
		if opts.artist {
			return item1.title.t2s() + (item1.artist?.name ?? "").t2s()
				== item2.title.t2s() + (item2.artist?.name ?? "").t2s()
		}
		return item1.title.t2s() == item2.title.t2s()
	}
}
