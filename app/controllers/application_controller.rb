require "net/http"

class ApplicationController < ActionController::Base
  def webhook_secret(payload)
    ENV["GITHUB_WEBHOOK_SECRET"]
  end

  protected

  def pull_codeship_builds_json
    http = Net::HTTP.new("codeship.com", 443)
    http.use_ssl = true
    response = http.request_get("/api/v1/projects.json?api_key=#{ENV["CODESHIP_API_KEY"]}")
    JSON.parse(response.body)
  end

  def create_status_notification_if_build_exists(build)
    codeship_json = pull_codeship_builds_json

    codeship_json["projects"].each do |project_json|
      project_json["builds"].each do |build_json|
        if build_json["commit_id"].eql?(build.commit)
          build.build_url = "https://codeship.com/projects/#{project_json["id"]}/builds/#{build_json["id"]}"
          update_build_status(build, build_json["status"])
          create_status_notification(build)
        end
      end
    end
  end

  def update_build_status(build, status)
    if status.eql?("testing") || status.eql?("waiting")
      build.last_status = "pending"
      build.message = "keep calm and carry on"
    elsif status.eql?("error") || status.eql?("stopped") || status.eql?("infrastructure_failure")
      build.last_status = "failure"
      build.message = "Fail! :-("
    elsif status.eql?("success")
      build.last_status = "success"
      build.message = "Hurray!"
    else
      build.last_status = "error"
      build.message = "unexpected status received #{status}, please alert @guimonz"
    end
    build.save!
  end

  def create_status_notification(build)
    client = Octokit::Client.new(:access_token => ENV["GITHUB_ACCESS_KEY"])
    description_hash = {}
    description_hash[:target_url] = build.build_url
    description_hash[:context] = "Upstart codeship"
    description_hash[:description] = build.message
    client.create_status(build.head_repository, build.commit, build.last_status, description_hash)
    client.create_status(build.base_repository, build.commit, build.last_status, description_hash)
  end
end
