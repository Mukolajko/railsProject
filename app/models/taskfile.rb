class Taskfile < ActiveRecord::Base
	belongs_to :task
	has_attached_file :file, :styles => {:medium => "250x250"}

	validates_attachment_content_type :file, :content_type => /.(?:jpe?g|png|gif)$/
end
