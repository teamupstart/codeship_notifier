class CodeshipWebhooksController < ApplicationController
  def create
    append_to_log(request.raw_post)
    notification_json = JSON.parse(request.raw_post)
    build = Build.find_by_commit(notification_json["build"]["commit_id"])
    if build
      build.build_url ||= notification_json["build"]["build_url"]
      update_build_status(build, notification_json["build"]["status"])
      create_status_notification(build)
    end

    head(:ok)
  end
end
