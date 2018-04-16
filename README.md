# GVRN

Despite its somewhat satirical startup-y name, GVRN is designed to address the very serious issue of high barriers to communnication between constituents and their representatives. It gives users a brief non-partisan overview of their reps and senators, including social media accounts and wikipedia entries. Once you've decided to make your voice heard GVRN allows users to schedule calls with their rep's office without paying a dime.

GVRN is designed as with a fairly traditional rails app structure:

+ The views are built on ERB files with Semantic UI as a CSS framework, SCSS, minimal JQuery for animations
+ It uses a PostgreSQL database
+ Congressional seed data is pulled from Propublica's Congress API, Google's Knowledge Graph API, and Wikimedia's API/Wikipedia
+ Users' congressional district data is pulled from the Google Civics API
+ Calling functionality and reminder texts to users use Twilio asynchronously through [delayed_job](https://github.com/collectiveidea/delayed_job)
+ District maps were created as [a customized GIS map](http://www.arcgis.com/home/webmap/viewer.html?webmap=a8c6586acb5f44738ebbf9e86b477084) through [Esri's ArcGis](http://www.arcgis.com/home/index.html "ArcGis")

# Usage

To set up GVRN you will first need to clone it to your machine:


```git clone git@github.com:MatteBru/gvrn.git```


Install its gems:


```bundle-install```


To create and seed the database, you must have PostgreSQL installed, then run:


```rake db:setup```


**Note: Seeding will take quite some time, also some members of congress have changed since the exception handling in the seed file was created, so there may be some weirdness with the data pulled from Wikipedia**


Once that is done, you should be able to run the development server by running:


```rails s```


It should open on port 3000, so if you visit http://localhost:3000/ you should see the landing page



