# Include hook code here
require 'gruff_template'
ActionView::Template.register_template_handler :gruff, GruffTempPlugin::Template
