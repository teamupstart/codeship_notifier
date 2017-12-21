class GithubWebhooksController < ApplicationController
  include GithubWebhook::Processor

  def github_pull_request(payload)
    action = payload["action"]

    if action.eql?("opened") || action.eql?("reopened") || action.eql?("synchronize")
      commit = payload["pull_request"]["head"]["sha"]

      build = Build.find_by_commit(commit) || Build.new
      build.commit = commit
      build.head_repository = payload["pull_request"]["head"]["repo"]["full_name"]
      build.base_repository = payload["pull_request"]["base"]["repo"]["full_name"]
      build.save!

      create_status_notification_if_build_exists(build)
    end
  end
end
