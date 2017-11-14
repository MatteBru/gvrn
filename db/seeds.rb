# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

PROPUBLICA_HEADERS = {"X-API-Key" => "Bi8jLFPUDEt743g2DnWFchat1WJPsYd5ainS1uD1"}
WIKIMEDIA_HEADERS = {"Api-User-Agent" => "gvrn/0.1 (bewguy101@gmail.com)"}
CURRENT_CONGRESS = "115"
STATES = {"AL"=>"Alabama", "AK"=>"Alaska", "AZ"=>"Arizona", "AR"=>"Arkansas", "CA"=>"California", "CO"=>"Colorado", "CT"=>"Connecticut", "DE"=>"Delaware", "DC"=>"District of Columbia", "FL"=>"Florida", "GA"=>"Georgia", "HI"=>"Hawaii", "ID"=>"Idaho", "IL"=>"Illinois", "IN"=>"Indiana", "IA"=>"Iowa", "KS"=>"Kansas", "KY"=>"Kentucky", "LA"=>"Louisiana", "ME"=>"Maine", "MD"=>"Maryland", "MA"=>"Massachusetts", "MI"=>"Michigan", "MN"=>"Minnesota", "MS"=>"Mississippi", "MO"=>"Missouri", "MT"=>"Montana", "NE"=>"Nebraska", "NV"=>"Nevada", "NH"=>"New Hampshire", "NJ"=>"New Jersey", "NM"=>"New Mexico", "NY"=>"New York", "NC"=>"North Carolina", "ND"=>"North Dakota", "OH"=>"Ohio", "OK"=>"Oklahoma", "OR"=>"Oregon", "PA"=>"Pennsylvania", "RI"=>"Rhode Island", "SC"=>"South Carolina", "SD"=>"South Dakota", "TN"=>"Tennessee", "TX"=>"Texas", "UT"=>"Utah", "VT"=>"Vermont", "VA"=>"Virginia", "WA"=>"Washington", "WV"=>"West Virginia", "WI"=>"Wisconsin","WY"=>"Wyoming"}

def create_states
  STATES.each do |a, n|
    State.find_or_create_by(abbreviation: a, name: n)
  end
end

def get_start_date(first_name, last_name)
  result_hash = HTTParty.get(
    "https://en.wikipedia.org/w/api.php?action=query&titles=#{first_name}%20#{last_name}&prop=revisions&rvprop=parsetree&format=json",
    :headers => WIKIMEDIA_HEADERS
  ).parsed_response
  random_string = result_hash["query"]["pages"].keys[0]
  xml_data = result_hash["query"]["pages"][random_string]["revisions"][0]["parsetree"]
  xml_doc  = Nokogiri::XML(xml_data)
  term_start = xml_doc.at('name:contains("term_start")')
  if !term_start
    result_hash = HTTParty.get(
      "https://en.wikipedia.org/w/api.php?action=query&titles=#{first_name}%20#{last_name}%20(politician)&prop=revisions&rvprop=parsetree&format=json",
      :headers => WIKIMEDIA_HEADERS
    ).parsed_response
    random_string = result_hash["query"]["pages"].keys[0]
    xml_data = result_hash["query"]["pages"][random_string]["revisions"][0]["parsetree"]
    xml_doc  = Nokogiri::XML(xml_data)
    term_start = xml_doc.at('name:contains("term_start")')
  end
  start_date = term_start.parent.children[2].children.text.strip
end

def get_bio(first_name, last_name)
  result_hash = HTTParty.get(
    "https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exintro=&explaintext=&titles=#{first_name}%20#{last_name}",
    :headers => WIKIMEDIA_HEADERS
  ).parsed_response
  random_string = result_hash["query"]["pages"].keys[0]
  bio = result_hash["query"]["pages"][random_string]["extract"]
  if bio.start_with?("#{first_name} #{last_name} may refer to:")
    result_hash = HTTParty.get(
      "https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exintro=&explaintext=&titles=#{first_name}%20#{last_name}%20(politician)",
      :headers => WIKIMEDIA_HEADERS
    ).parsed_response
    random_string = result_hash["query"]["pages"].keys[0]
    bio = result_hash["query"]["pages"][random_string]["extract"]
  end
  bio.gsub(/\(.*\) /, "")
end

def get_image(first_name, last_name)
  result_hash = HTTParty.get(
    "https://en.wikipedia.org/w/api.php?action=query&titles=#{first_name}%20#{last_name}&prop=pageimages&format=json", 
    :headers => WIKIMEDIA_HEADERS
  ).parsed_response
  random_string = result_hash["query"]["pages"].keys[0]
  image_string = result_hash["query"]["pages"][random_string]["pageimage"]
  # if at a disambiguation page, go to the politician's page
  if !image_string
    result_hash = HTTParty.get(
      "https://en.wikipedia.org/w/api.php?action=query&titles=#{first_name}%20#{last_name}%20(politician)&prop=pageimages&format=json", 
      :headers => WIKIMEDIA_HEADERS
    ).parsed_response
    random_string = result_hash["query"]["pages"].keys[0]
    image_string = result_hash["query"]["pages"][random_string]["pageimage"]
  end
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
end

def create_representative(representative_hash)
  rep_state = representative_hash["state"]
  representative = Representative.new(
    first_name: representative_hash["first_name"],
    middle_name: representative_hash["middle_name"],
    last_name: representative_hash["last_name"],
    image: get_image(representative_hash["first_name"], representative_hash["last_name"]),
    date_of_birth: Date.parse(representative_hash["date_of_birth"]),
    biography: get_bio(representative_hash["first_name"], representative_hash["last_name"]),
    party: representative_hash["party"],
    start_date: Date.parse(get_start_date(representative_hash["first_name"], representative_hash["last_name"])),
    leadership_role: representative_hash["leadership_role"],
    twitter_account: representative_hash["twitter_account"],
    facebook_account: representative_hash["facebook_account"],
    youtube_account: representative_hash["youtube_account"],
    url: representative_hash["url"],
    contact_form: representative_hash["contact_form"],
    in_office: representative_hash["in_office"],
    dw_nominate: representative_hash["dw_nominate"],
    next_election: representative_hash["next_election"],
    total_votes: representative_hash["total_votes"],
    missed_votes: representative_hash["missed_votes"],
    office: representative_hash["office"],
    phone: representative_hash["phone"],
    at_large: representative_hash["at_large"],
    district_id: nil,
    votes_with_party_pct: representative_hash["votes_with_party_pct"],
    gender: HTTParty.get(representative_hash["api_uri"], :headers => PROPUBLICA_HEADERS)["results"][0]["gender"]
  )
end

def lookup_senators
  senators = HTTParty.get("https://api.propublica.org/congress/v1/#{CURRENT_CONGRESS}/senate/members.json", :headers => PROPUBLICA_HEADERS)["results"][0]["members"]
  create_senator(senators.first)
end

def lookup_representatives
  representatives = HTTParty.get("https://api.propublica.org/congress/v1/#{CURRENT_CONGRESS}/house/members.json", :headers => PROPUBLICA_HEADERS)["results"][0]["members"]
  create_representative(representatives.first)
end

create_states
lookup_representatives
lookup_senators