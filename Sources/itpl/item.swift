import iTunesLibrary

// ITLibMediaItem wrapper supporting
// - CustomStringConvertible
// - output options
struct Item: CustomStringConvertible {
	let item: ITLibMediaItem

	init(item: ITLibMediaItem) {
		self.item = item
		albumSC = (item.album.title ?? "").t2s()
		artistSC = (item.artist?.name ?? "").t2s()
		titleSC = (item.title).t2s()
	}

	// -- CustomStringConvertible
	var description: String {
		if opts.debug { return toStrDebug() }
		if opts.duplicate || opts.info { return toStrInfo() }
		return toStrPathOnly()
	}

	// -- `get` only attributes
	var album: String { return item.album.title ?? "" }
	let albumSC: String
	var artist: String { return item.artist?.name ?? "" }
	let artistSC: String
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
	let titleSC: String
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
		var tmpItems: [Item] = []

		playlist.items.forEach({ i in tmpItems.append(Item(item: i)) })

		if opts.duplicate || opts.sort {
			tmpItems = tmpItems.sorted(by: { lhs, rhs in lhs.titleSC < rhs.titleSC })
		}

		for i in 0..<count {
			if !opts.duplicate
				|| i < count - 1 && mediaItemEqual(item1: tmpItems[i], item2: tmpItems[i + 1])
			{
				add = true
				addNext = true
			} else {
				add = false
			}

			if !(opts.notFound
				&& (tmpItems[i].path == "" || FileManager.default.fileExists(atPath: tmpItems[i].path)))
				&& (add || addNext)
			{
				items.append(tmpItems[i])
				addNext = add && addNext
			}
		}
	}

	private func mediaItemEqual(item1: Item, item2: Item) -> Bool {
		if opts.artist { return item1.titleSC + item1.artistSC == item2.titleSC + item2.artistSC }
		return item1.titleSC == item2.titleSC
	}
}
