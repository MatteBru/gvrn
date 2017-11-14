# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'HTTParty'
require 'byebug'
require 'nokogiri'

PROPUBLICA_HEADERS = {"X-API-Key" => "Bi8jLFPUDEt743g2DnWFchat1WJPsYd5ainS1uD1"}
WIKIMEDIA_HEADERS = {"Api-User-Agent" => "gvrn/0.1 (bewguy101@gmail.com)"}
CURRENT_CONGRESS = "115"

def get_start_date(first_name, last_name)
  result_hash = HTTParty.get(
    "https://en.wikipedia.org/w/api.php?action=query&titles=#{first_name}%20#{last_name}&prop=revisions&rvprop=parsetree&format=json",
    :headers => WIKIMEDIA_HEADERS
  ).parsed_response
  random_string = result_hash["query"]["pages"].keys[0]
  xml_data = result_hash["query"]["pages"][random_string]["revisions"][0]["parsetree"]
  xml_doc  = Nokogiri::XML(xml_data)
  xml_doc.at('name:contains("term_start")').parent.children[2].children.text.strip
end

def get_bio(first_name, last_name)
  result_hash = HTTParty.get(
    "https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exintro=&explaintext=&titles=#{first_name}%20#{last_name}",
    :headers => WIKIMEDIA_HEADERS
  ).parsed_response
  random_string = result_hash["query"]["pages"].keys[0]
  bio = result_hash["query"]["pages"][random_string]["extract"]
  bio.gsub(/\(.*\) /, "")
end

def get_image(first_name, last_name)
  result_hash = HTTParty.get(
    "https://en.wikipedia.org/w/api.php?action=query&titles=#{first_name}%20#{last_name}&prop=pageimages&format=json", 
    :headers => WIKIMEDIA_HEADERS
  ).parsed_response
  random_string = result_hash["query"]["pages"].keys[0]
  image_string = result_hash["query"]["pages"][random_string]["pageimage"]
  slugged_image_url = image_string.gsub("_", "%20").prepend("File:")
  get_image_from_slug(slugged_image_url)
end

def get_image_from_slug(slugged_image_url)
  result_hash = HTTParty.get(
    "https://en.wikipedia.org/w/api.php?action=query&titles=#{slugged_image_url}&prop=imageinfo&iiprop=url&format=json", 
    :headers => WIKIMEDIA_HEADERS
    ).parsed_response
  image_url = result_hash["query"]["pages"]["-1"]["imageinfo"][0]["url"]
end


def create_senator(senator_hash)
  senator = Senator.new(
    first_name: senator_hash["first_name"],
    middle_name: senator_hash["middle_name"],
    last_name: senator_hash["last_name"],
    image: get_image(senator_hash["first_name"], senator_hash["last_name"]),
    date_of_birth: Date.parse(senator_hash["date_of_birth"]),
    biography: get_bio(senator_hash["first_name"], senator_hash["last_name"]),
    party: senator_hash["party"],
    start_date: Date.parse(get_start_date(senator_hash["first_name"], senator_hash["last_name"])),
    leadership_role: senator_hash["leadership_role"],
    twitter_account: senator_hash["twitter_account"],
    facebook_account: senator_hash["facebook_account"],
    youtube_account: senator_hash["youtube_account"],
    url: senator_hash["url"],
    contact_form: senator_hash["contact_form"],
    in_office: senator_hash["in_office"],
    dw_nominate: senator_hash["dw_nominate"],
    next_election: senator_hash["next_election"],
    total_votes: senator_hash["total_votes"],
    missed_votes: senator_hash["missed_votes"],
    office: senator_hash["office"],
    phone: senator_hash["phone"],
    state_id: nil,
    # state: State.find_by(abbreviation: senator_hash["state"]),
    state_rank: senator_hash["state_rank"],
    votes_with_party_pct: senator_hash["votes_with_party_pct"],
    gender: HTTParty.get(senator_hash["api_uri"], :headers => PROPUBLICA_HEADERS)["results"][0]["gender"]
  )
  byebug
  "end"
end

def lookup_senators
  senators = HTTParty.get("https://api.propublica.org/congress/v1/#{CURRENT_CONGRESS}/senate/members.json", :headers => PROPUBLICA_HEADERS)["results"][0]["members"]
  create_senator(senators.first)
end

lookup_senators