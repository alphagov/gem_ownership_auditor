require 'rest_client'
require 'pp'
require 'multi_json'

class GemOwnershipAuditor
  def initialize(main_owner)
    @main_owner = main_owner
  end

  def audit
    log "Fetching a list of all gems owned by '#{@main_owner}' user on rubygems..."
    gems = list_gems(@main_owner)
    log "Found #{gems.size} gems"
    log ""

    log "Checking ownership of each gem..."

    ownerships = gems.map do |gemname|
      puts "  #{gemname}"
      [gemname, list_owners(gemname)]
    end

    gems_by_owner = {}

    ownerships.each do |gemname, owners|
      owners.each do |owner|
        gems_by_owner[owner] ||= []
        gems_by_owner[owner] << gemname
      end
    end

    log ""
    log "List of all owners of any GOV.UK gem"
    log "------------------------------------"
    log ""

    gems_by_owner.sort_by {|k,v| k}.each do |owner, gems|
      log "#{owner}:"
      log "  #{gems.sort.join(", ")}"
    end
  end

  def list_gems(owner)
    fetch_json("owners/#{owner}/gems.json").map do |data|
      data["name"]
    end
  end

  def list_owners(gemname)
    fetch_json("gems/" + gemname + "/owners.json").map {|d| d['email']}
  end

  def log(message)
    puts message
  end


private
  def fetch_json(api_path)
    url = "https://rubygems.org/api/v1/" + api_path
    response = RestClient.get(url, {accept: :json})
    MultiJson.load(response)
  end
end

GemOwnershipAuditor.new("govuk").audit
