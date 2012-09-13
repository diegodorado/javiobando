class Comercial < Article
  default_scope where('section=?', :co).order('published_at DESC')
end
