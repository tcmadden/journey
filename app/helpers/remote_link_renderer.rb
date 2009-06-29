# app/helpers/remote_link_renderer.rb
# modified from http://weblog.redlinesoftware.com/2008/1/30/willpaginate-and-remote-links

class RemoteLinkRenderer < WillPaginate::LinkRenderer
  def prepare(collection, options, template)
    @remote = options.delete(:remote) || {}
    super
  end

protected
  def page_link(page, text, attributes = {})
    @template.link_to_remote(text, {:url => url_for(page), :method => :get}.merge(@remote), 
                             { :href => url_for(page) })
  end
end