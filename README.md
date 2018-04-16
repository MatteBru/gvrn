# GVRN

Despite its somewhat satirical startup-y name, GVRN is designed to address the very serious issue of high barriers to communnication between constituents and their representatives. It gives users a brief non-partisan overview of their reps and senators, including social media accounts and wikipedia entries. Once you've decided to make your voice heard GVRN allows users to schedule calls with their rep's office without paying a dime.

GVRN is designed as with a fairly traditional rails app structure:

+ The views are built on ERB files with Semantic UI as a CSS framework, SCSS, minimal JQuery for animations
+ It uses a PostgreSQL database
+ Congressional seed data is pulled from Propublica's Congress API, Google's Knowledge Graph API, and Wikimedia's API/Wikipedia
+ Users' congressional district data is pulled from the Google Civics API
+ Calling functionality and reminder texts to users use Twilio asynchronously through [delayed_job](https://github.com/collectiveidea/delayed_job)
+ District maps were created as a customized GIS map through [Esri's ArcGis](http://www.arcgis.com/home/index.html "ArcGis")



