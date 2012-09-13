class Personal < Article
  default_scope where('section=?', :pe).order('published_at DESC')
end
