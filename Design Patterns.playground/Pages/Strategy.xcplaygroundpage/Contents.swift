/*:
 # Strategy
 - - - - - - - - - -
 ![Strategy Diagram](Strategy_Diagram.png)
 
 The strategy pattern defines a family of interchangeable objects.
 
 This pattern makes apps more flexible and adaptable to changes at runtime, instead of requiring compile-time changes.
 
 ## Code Example
 */
import UIKit

protocol MovieRatingStrategy {
    var ratingServiceName: String { get }
    
    func fetchRating(for movieTitle: String, success: (_ rating: String, _ review: String) -> ())
}

class RottenTomatoesClient: MovieRatingStrategy {
    let ratingServiceName = "Rotten Tomatoes"
    
    func fetchRating(
        for movieTitle: String,
        success: (_ rating: String, _ review: String) -> ()) {
        
        let rating = "95%"
        let review = "It rocked!"
        success(rating, review)
    }
}

class IMDbClient: MovieRatingStrategy {
    let ratingServiceName = "IMDb"
    
    func fetchRating(
        for movieTitle: String,
        success: (_ rating: String, _ review: String) -> ()) {
        
        let rating = "3 / 10"
        let review =  """
                      It was terrible! The audience was throwing rotten
                      tomatoes!
                      """
        success(rating, review)
    }
}

class MoviewRatingViewController: UIViewController {
    var movieRatingClient: MovieRatingStrategy!
    
    @IBOutlet  var movieTitleTextField: UITextField!
    @IBOutlet  var ratingServiceNameLabel: UILabel!
    @IBOutlet  var ratingLabel: UILabel!
    @IBOutlet  var reviewLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ratingServiceNameLabel.text = movieRatingClient.ratingServiceName
    }
    
    @IBAction  func searchButtonPressed(sender: Any) {
        guard let movieTitle = movieTitleTextField.text
        else { return }
        
        movieRatingClient.fetchRating(for: movieTitle) { (rating, review) in
            self.ratingLabel.text = rating
            self.reviewLabel.text = review
        }
    }
}
