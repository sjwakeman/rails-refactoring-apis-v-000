class GithubRepos 
    attr_reader :name, :html_url
    def initialize(hash)
        binding.pry
        @name = hash["name"],
        @url = hash["html_url"]

    end
end