import Foundation

class BookController
{
	var books:[Book] = []

	var unreadBooks:[Book] = []
	var readBooks:[Book] = []

	init() {
		load()
	}

	func add(_ book:Book)
	{
		books.append(book)
		sortBooks()
	}

	@discardableResult
	func create(_ name:String, _ reason:String) -> Book
	{
		let b = Book(name:name, readingReason:reason, read:false)
		add(b)
		return b
	}

	func markRead(_ book:Book, state:Bool)
	{
		guard let index = books.index(of:book) else {return}
		books[index].read = state
		sortBooks()
	}

	func delete(_ book:Book)
	{
		guard let index = books.index(of:book) else {return}
		books.remove(at: index)
		sortBooks()
	}

	func sortBooks()
	{
		unreadBooks.removeAll(keepingCapacity: true)
		readBooks.removeAll(keepingCapacity: true)
		for book in books {
			if book.read {
				readBooks.append(book)
			} else {
				unreadBooks.append(book)
			}
		}

		unreadBooks.sort()
		readBooks.sort()
		save()
	}

	func getDefaultPersistURL() -> URL
	{
		return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Books.plist")
	}

	func save()
	{
		do {
			let enc = PropertyListEncoder()
			let data = try enc.encode(books)
			try data.write(to: getDefaultPersistURL())
		} catch {
			print("Failed to write to default persist URL: ", getDefaultPersistURL())
		}
	}

	func load()
	{
		let url = getDefaultPersistURL()
		let fm = FileManager.default
		if !fm.fileExists(atPath: url.path) {
			return
		}

		do {
			let data = try Data(contentsOf: getDefaultPersistURL())
			let dec = PropertyListDecoder()
			books = try dec.decode([Book].self, from: data)
		} catch {
			print("Failed to load from default persist URL: ", url)
		}
	}

}
