# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# PROPUBLICA_HEADERS = {"X-API-Key" => "Bi8jLFPUDEt743g2DnWFchat1WJPsYd5ainS1uD1"}
# WIKIMEDIA_HEADERS = {"Api-User-Agent" => "gvrn/0.1 (bewguy101@gmail.com)"}

PROPUBLICA_HEADERS = {"X-API-Key" => ENV['propublica_key']}
WIKIMEDIA_HEADERS = {"Api-User-Agent" => ENV['wikimedia_user_agent']}


CURRENT_CONGRESS = "115"
STATES = {"AL"=>"Alabama", "AK"=>"Alaska", "AZ"=>"Arizona", "AR"=>"Arkansas", "CA"=>"California", "CO"=>"Colorado", "CT"=>"Connecticut", "DE"=>"Delaware", "FL"=>"Florida", "GA"=>"Georgia", "HI"=>"Hawaii", "ID"=>"Idaho", "IL"=>"Illinois", "IN"=>"Indiana", "IA"=>"Iowa", "KS"=>"Kansas", "KY"=>"Kentucky", "LA"=>"Louisiana", "ME"=>"Maine", "MD"=>"Maryland", "MA"=>"Massachusetts", "MI"=>"Michigan", "MN"=>"Minnesota", "MS"=>"Mississippi", "MO"=>"Missouri", "MT"=>"Montana", "NE"=>"Nebraska", "NV"=>"Nevada", "NH"=>"New Hampshire", "NJ"=>"New Jersey", "NM"=>"New Mexico", "NY"=>"New York", "NC"=>"North Carolina", "ND"=>"North Dakota", "OH"=>"Ohio", "OK"=>"Oklahoma", "OR"=>"Oregon", "PA"=>"Pennsylvania", "RI"=>"Rhode Island", "SC"=>"South Carolina", "SD"=>"South Dakota", "TN"=>"Tennessee", "TX"=>"Texas", "UT"=>"Utah", "VT"=>"Vermont", "VA"=>"Virginia", "WA"=>"Washington", "WV"=>"West Virginia", "WI"=>"Wisconsin","WY"=>"Wyoming"}

def create_states
  STATES.each do |a, n|
    State.find_or_create_by(abbreviation: a, name: n)
  end
end

def find_wikipedia_page(google_entity_id)
  google_entity_id == "/m/03whyr" ? g_id = "/m/04m7rg" : g_id = google_entity_id
  result_hash = HTTParty.get("https://kgsearch.googleapis.com/v1/entities:search?ids=#{g_id}&key=AIzaSyAbq12TpjfMtq1d4nn95MbeutoEF6Hso5Y").parsed_response
  begin
    url = result_hash["itemListElement"][0]["result"]["detailedDescription"]["url"]
  rescue
    begin
      url = result_hash["itemListElement"][0]["result"]["image"]["url"]
    rescue
      #byebug
      url = ""
    end
  end
  if !url.match(/https:\/\/en.wikipedia.org\//)
    begin
      name = result_hash["itemListElement"][0]["result"]["name"]
      slugified_name = name.gsub(" ", "_")
      url = "https://en.wikipedia.org/wiki/#{slugified_name}"
      begin
        target = find_target_from_wikipedia_page(url)
        get_bio(target)
      rescue
        url = "https://en.wikipedia.org/wiki/#{slugified_name}_(American_politician)"
        #byebug
      end
    rescue
      #byebug
    end
  end
  url
end

def find_target_from_wikipedia_page(url)
  matches = url.match(/https:\/\/en.wikipedia.org\/wiki\/(.+)/)
  begin
    target = matches.captures[0].gsub("_", "%20")
  rescue
    #byebug
  end
end

def get_start_date(target)
  result_hash = HTTParty.get(
    "https://en.wikipedia.org/w/api.php?action=query&titles=#{target}&prop=revisions&rvprop=parsetree&format=json&redirects",
    :headers => WIKIMEDIA_HEADERS
  ).parsed_response
  begin
    random_string = result_hash["query"]["pages"].keys[0]
    xml_data = result_hash["query"]["pages"][random_string]["revisions"][0]["parsetree"]
    xml_doc  = Nokogiri::XML(xml_data)
    term_start = xml_doc.at('name:contains("term_start")')
    start_date = term_start.parent.children[2].children.text.strip
    Date.parse(start_date)
  rescue
    #byebug
    nil
  end
end

def get_bio(target)
  result_hash = HTTParty.get(
    "https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exintro=&explaintext=&titles=#{target}&redirects",
    :headers => WIKIMEDIA_HEADERS
  ).parsed_response
  begin
    random_string = result_hash["query"]["pages"].keys[0]
    bio = result_hash["query"]["pages"][random_string]["extract"]
    bio.gsub(bio.match(/ (\([^\)]*\))/)[0], "")
  rescue
    #byebug
  end
end

def get_image(target)
  result_hash = HTTParty.get(
    "https://en.wikipedia.org/w/api.php?action=query&titles=#{target}&prop=pageimages&format=json&redirects",
    :headers => WIKIMEDIA_HEADERS
  ).parsed_response
  begin
    random_string = result_hash["query"]["pages"].keys[0]
    image_string = result_hash["query"]["pages"][random_string]["pageimage"]
    slugged_image_url = image_string.gsub("_", "%20").prepend("File:")
    get_image_from_slug(slugged_image_url)
  rescue
    #byebug
    nil
  end
end

def get_image_from_slug(slugged_image_url)
  if !slugged_image_url.ascii_only?
    url = Addressable::URI.parse("https://en.wikipedia.org/w/api.php?action=query&titles=#{slugged_image_url}&prop=imageinfo&iiprop=url&format=json").normalize.to_str
  else
    url = "https://en.wikipedia.org/w/api.php?action=query&titles=#{slugged_image_url}&prop=imageinfo&iiprop=url&format=json"
  end
  begin
    result_hash = HTTParty.get(url, :headers => WIKIMEDIA_HEADERS).parsed_response
    image_url = result_hash["query"]["pages"]["-1"]["imageinfo"][0]["url"]
  rescue
  end
end

def create_senator(senator_hash)
  if senator_hash["in_office"] == true
    senator = Senator.find_by(
      first_name: senator_hash["first_name"],
      last_name: senator_hash["last_name"],
      date_of_birth: Date.parse(senator_hash["date_of_birth"])
    )
    if !senator
      wikipedia_page = find_wikipedia_page(senator_hash["google_entity_id"])
      target = find_target_from_wikipedia_page(wikipedia_page)
      senator = Senator.create(
        first_name: senator_hash["first_name"],
        middle_name: senator_hash["middle_name"],
        last_name: senator_hash["last_name"],
        image: get_image(target),
        date_of_birth: Date.parse(senator_hash["date_of_birth"]),
        biography: get_bio(target),
        party: senator_hash["party"],
        start_date: get_start_date(target),
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
        state: State.find_by(abbreviation: senator_hash["state"]),
        state_rank: senator_hash["state_rank"],
        votes_with_party_pct: senator_hash["votes_with_party_pct"],
        gender: HTTParty.get(senator_hash["api_uri"], :headers => PROPUBLICA_HEADERS)["results"][0]["gender"],
        google_entity_id: senator_hash["google_entity_id"],
        wikipedia: wikipedia_page
      )
      puts "CREATED_SENATOR #{senator.full_name}, STATE #{senator.state.abbreviation}"
    else
      puts "Senator #{senator.full_name} has already been created."
    end
  else
    puts "Senator #{senator_hash["first_name"]} #{senator_hash["last_name"]} is no longer in office."
  end
end

def create_district(representative_hash)
  rep_state = State.find_by(abbreviation: representative_hash["state"])
  if rep_state
    rep_district = District.find_by(
      state_id: rep_state.id,
      name: representative_hash["district"]
    )
    if !rep_district
      rep_district = District.create(
        state_id: rep_state.id,
        name: representative_hash["district"]
      )
      rep_state.districts << rep_district
    end
    rep_district
  else
    #byebug
  end
end

def create_representative(representative_hash)
  if representative_hash["title"] == "Representative"
    if representative_hash["in_office"] == true
      representative = Representative.find_by(
        first_name: representative_hash["first_name"],
        last_name: representative_hash["last_name"],
        date_of_birth: Date.parse(representative_hash["date_of_birth"])
      )
      if !representative
        rep_district = create_district(representative_hash)
        if representative_hash["google_entity_id"]
          wikipedia_page = find_wikipedia_page(representative_hash["google_entity_id"])
        else
          if representative_hash["first_name"] == "John" && representative_hash["last_name"] == "Curtis"
            wikipedia_page = "https://en.wikipedia.org/wiki/John_Curtis_(American_politician)"
          else
            wikipedia_page = "https://en.wikipedia.org/wiki/#{representative_hash["first_name"]}_#{representative_hash["last_name"]}"
          end
        end
        target = find_target_from_wikipedia_page(wikipedia_page)
        representative = Representative.create(
          first_name: representative_hash["first_name"],
          middle_name: representative_hash["middle_name"],
          last_name: representative_hash["last_name"],
          image: get_image(target),
          date_of_birth: Date.parse(representative_hash["date_of_birth"]),
          biography: get_bio(target),
          party: representative_hash["party"],
          start_date: get_start_date(target),
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
          district_id: rep_district.id,
          votes_with_party_pct: representative_hash["votes_with_party_pct"],
          gender: HTTParty.get(representative_hash["api_uri"], :headers => PROPUBLICA_HEADERS)["results"][0]["gender"],
          google_entity_id: representative_hash["google_entity_id"],
          wikipedia: wikipedia_page
        )
        puts "CREATED_REP #{representative.full_name}, DISTRICT #{representative.district.name}, STATE #{representative.state.abbreviation}"
      else
        puts "#{representative.full_name} has already been created"
      end
    else
      puts "Representative #{representative_hash["first_name"]} #{representative_hash["last_name"]} is no longer in office."
    end
  else
    puts "#{representative_hash["first_name"]} #{representative_hash["last_name"]} does not represent one of the 50 states and will not be counted."
  end
end

def lookup_senators
  senators = HTTParty.get("https://api.propublica.org/congress/v1/#{CURRENT_CONGRESS}/senate/members.json", :headers => PROPUBLICA_HEADERS)["results"][0]["members"]
  senators.each do |senator|
    create_senator(senator)
  end
end

def lookup_representatives
  representatives = HTTParty.get("https://api.propublica.org/congress/v1/#{CURRENT_CONGRESS}/house/members.json", :headers => PROPUBLICA_HEADERS)["results"][0]["members"]
  representatives.each do |representative|
    create_representative(representative)
  end
end

create_states
lookup_senators
lookup_representatives
