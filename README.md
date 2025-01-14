https://devpost.com/software/milk-trip

**Inspiration**

Why is everything so expensive now? With the economy changing left and right, prices of consumer goods are on the rise at unprecedented levels. However, manually searching for prices across different stores is time consuming and often feels like too much hassle for the savings. Currently, there’s no simple way to compare prices efficiently to maximize savings on your supermarket trips. Thus, we created Milk Trip, an iOS app to track and compare consumer goods prices across time and grocery store locations, making it easy to find the best deals and shop smarter.

**What it does**

Milk Trip collects real-time price data from your local grocery stores, providing users with up-to-date prices of various consumer goods, along with historical price trends. The app presents these insights in a stock chart-like format, allowing users to easily track how prices have changed over time. Milk Trip features budgeting tools to help you plan your grocery trips and maximize your savings, including product substitutions, comparison charts, and of course, AI insights.

**How we built it**

We built Milk Trip using Swift / SwiftUI and three (yes, three!) REST APIs. We used the Pinata File API to store our product and inflation data, the OpenAI API to provide AI recommendations, and a barcode scanner API to retrieve products from a consumer good database.

**Challenges we ran into**

One of the biggest challenges that we ran into was making our charts collect all of our data while being responsive and animated. We also ran into issues involving barcode scanning to retrieve online products not on the app; we eventually used Apple's Vision Kit paired with a 3rd party API to scan our barcodes, but it was a lot more difficult than we expected.

**Accomplishments that we're proud of**

Our proudest accomplishments include having responsive, animated charts with comparisons with multiple store locations as well as integrating a backend with Pinata. Our app's UI is also fluid, responsive, and intuitive, which was a tall task for all the features that we had. We managed to build a working barcode scanner as well to track different food items not listed on the app's database.

**What we learned**

During this hackathon, we learned plenty of technical skills, including file storage with Pinata, barcode scanning with Apple Vision, and how to use charts and animate them. On top of those skills, we learned plenty of valuable information relating to time management, delegating tasks between teammates, and persistence.

**What's next for Milk Trip**

We are hoping to publish Milk Trip on the Apple App Store for public use in the future!
