module ApplicationHelper
  def sortable(column, title = nil)
  	title ||= column.titleize
  	css_class = column == sort_column ? "current #{sort_direction}" : nil
  	direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
  	link_to title, {:sort => column, :direction => direction}, {:class => css_class}
  end

  def link_to_add_user(name, f, assosiation)
  	new_object = f.object.class.reflect_on_association(assosiation).klass.new
  	fields = f.fields_for(assosiation, new_object, :child_index => "new_#{assosiation}") do |builder|
  			render('add_user_field', :f => builder)
  	  end
  	link_to_function(name, "add_user_field(this, \"#{assosiation}\", \"#{escape_javascript(fields)}\")")
  end
end
 