module TasksHelper
  def users_info(user)
  	view_context.link_to("#{user.username} ", show_user_path(user.id))
  end
end
