class CodeshipWebhooksController < ApplicationController
  def create
    notification_json = JSON.parse(request.raw_post)
    build = Build.find_by_commit(notification_json["build"]["commit_id"])
    if build
      update_build_status(build, notification_json["build"]["status"])
      create_status_notification(build)
    end

    head(:ok)
  end
end
