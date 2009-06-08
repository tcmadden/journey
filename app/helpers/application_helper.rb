require 'journey_questionnaire'

# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def javascript(url)
    content_for :javascript do
      javascript_include_tag url
    end
  end
  
  def dynamic_stylesheet_link_tag(action, *args)
    stylesheet_link_tag(url_for(:controller => 'stylesheets', :action => action, :format => 'css'), *args)
  end

  def ellipsize(str, len)
    if str.length > len
      str[0,len-3] + "..."
    else
      str
    end
  end

  def icon_for(record_or_class)
    klass = SimplyHelpful::RecordIdentifier::singular_class_name(record_or_class)
    image_tag "icons/#{klass}.png", :alt => klass.humanize, :class => 'icon'
  end

  def create_form_dom_id(klass)
    "#{dom_id(klass)}_create_form"
  end
  
  def question_class_template(klass)
    "#{klass.name.demodulize.tableize.singularize}"
  end

  def render_question(question)
    @question = question
    
    value = ''
    if params[:controller] == "answer"
      answer = @resp.answer_for_question(question)
      if answer
        value = answer.value
      else
        value = @question.default_answer
      end
    end
    return render(:partial => "questions/" + question_class_template(question.class), :locals => { :value => value })
  rescue Exception => e
    return render(:inline => "<%= start_question @question %><b>Error rendering #{question.class.name.demodulize} \##{question.id} (#{h e.message})</b><%= end_question @question %>")
  end
  
  def render_answer(question, answer)
    @answer = answer
    @question = question
    value = if answer
      if not @editing
        answer.output_value
      else
        answer.value
      end
    else
      nil
    end
    return render(:partial => "answers/" + question_class_template(question.class), :locals => { :value => value })
  rescue Exception => e
    return "<b>Error rendering answer to #{@question.class.name.demodulize} \##{@question.id} (#{h e.message})</b>"
  end

  def start_question(question, options = {})
    options = {
      :is_radio_group => false,
      :is_display => false,
    }.update(options)
    return render(:partial => 'questions/questionstart', :locals => { :question => question }.update(options))
  end

  def end_question(question, options = {})
    options = {
      :is_radio_group => false,
      :is_display => false,
    }.update(options)
    return render(:partial => 'questions/questionend', :locals => { :question => question }.update(options))
  end
  
  def link_tab_class(action)
    if params[:action] == action
      'selected_link'
    else
      'link'
    end
  end
  
  def toplevel_link_tab_class(ctrlr, options={})
    if params[:controller] == ctrlr
      if options[:except].nil? or (not options[:except].include?(params[:action]))
        if options[:only].nil? or (options[:only].include?(params[:action]))
          return 'selected_link'
        end
      end
    end
    return 'link'
  end
  
  def user_options
    render :partial => "layouts/user_options"
  end
end
