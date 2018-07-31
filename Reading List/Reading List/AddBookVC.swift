import Foundation
import UIKit

class AddBookVC: UIViewController
{
	var controller:BookController!
	var book:Book?

	@IBOutlet weak var nameField: UITextField!
	@IBOutlet weak var reasonField: UITextField!

	override func viewWillAppear(_ animated: Bool)
	{
		super.viewWillAppear(animated)

		guard let book = book else { return }
		nameField.text = book.name
		reasonField.text = book.readingReason
	}


	@IBAction func addBook(_ sender: Any)
	{
		guard let name = nameField.text, name != "",
			let reason = reasonField.text, reason != ""
			else {return}

		if var book = book {
			controller.delete(book)
			book.name = name
			book.readingReason = reason
			controller.add(book)
		} else {
			controller.create(name, reason)
		}
		navigationController?.popViewController(animated: true)
	}
}
