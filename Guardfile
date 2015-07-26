guard :shell do
  watch /Rakefile|.*\.rb/ do |x|
    raise x.to_s if x.size != 1
    p 123
    system 'rake'
  end
end
