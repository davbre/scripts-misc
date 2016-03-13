require "pry"
require "net/http"
require "uri"
require "json"

gh_user = "davbre"
gh_repo = "mira"

commit_uri = URI.parse("https://api.github.com/repos/" + gh_user + "/" + gh_repo + "/commits")
response = Net::HTTP.get_response(commit_uri)
json_resp = JSON.parse(response.body)

abbr_commit_info = json_resp.map { |e|
  {
  	author: e["author"]["login"],
    date: e["commit"]["committer"]["date"],
  	message: e["commit"]["message"]
  }
}

binding.pry