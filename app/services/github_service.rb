class GithubService
    attr_accessor :access_token

    def initialize(hash = nil) #hash default set to nil
        if hash #Or if hash !=nil
          @access_token = hash["access_token"]
        end
    end

    def authenticate!(client_id, client_secret, code)
        response = Faraday.post("https://github.com/login/oauth/access_token") do |req|
            req.body = { 'client_id': client_id, 'client_secret': client_secret, 'code': code }
            req.headers['Accept'] = 'application/json'
        end
        body = JSON.parse(response.body)
        self.access_token = body["access_token"]
    end

    def get_username
        user_resp = Faraday.get("https://api.github.com/user") do |req|
            req.headers['Accept'] = 'application/json'
            req.headers['Authorization'] = "token #{access_token}"
        end
        user = JSON.parse(user_resp.body)    
            user["login"]
    end

    def get_repos
        resp = Faraday.get("https://api.github.com/user/repos") do |req|
            req.headers['Accept'] = 'application/json'
            req.headers['Authorization'] = "token #{access_token}"
        end
        users = JSON.parse(resp.body)
            users.map do |user|
                GithubRepo.new(user)
            end
end

    def create_repo(name)
            Faraday.post("https://api.github.com/user/repos") do |req|
            req.body = { 'name': name}.to_json
            req.headers['Accept'] = 'application/json'
            req.headers['Authorization'] = "token #{access_token}"
        end
    end        
end
