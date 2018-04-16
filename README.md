# GVRN

Despite its intentionally goofy startup name, GVRN is designed to address the serious issue of high barriers to communnication between constituents and their representatives. It gives users a brief non-partisan overview of their reps and senators, including social media accounts and wikipedia entries. Once you've decided to make your voice heard GVRN allows users to schedule calls with their rep's office without paying a dime.

+ Created a detailed database of representatives, districts, states, and users, and phone calls using Rails/ActiveRecord and PostgreSQL hosted on Heroku

+ Combined numerous API’s and scraped resources to collate info on each representative and district

+ Used Geocoding, Google Civics API and custom ESRI maps to give accurate user district data

+ Used Twilio and delayed_job to allow users to call, or schedule a call with their representative
