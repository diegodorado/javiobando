class Portada < Article
  default_scope where('section=?', :po)
end
