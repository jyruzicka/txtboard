# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "txtboard"
  s.version = File.read("version.txt")
  
  s.summary = "A tiny text-based kanban board using rubyfocus."
  s.description = "Check on the progress of your projects from the command-line, while using OmniFocus to actually do things."
  s.licenses = "mit"
  
  s.author = "Jan-Yves Ruzicka"
  s.email = "jan@1klb.com"
  s.homepage = "https://github.com/jyruzicka/txtboard"
  
  s.files = File.read("Manifest").split("\n").select{ |l| !l.start_with?("#") && l != ""}
  s.require_paths << "lib"
  s.bindir = "bin"
  s.executables << "txtboard"
  s.extra_rdoc_files = ["README.md"]

  # Add runtime dependencies here
  s.add_runtime_dependency "rubyfocus", "~> 0.3.0"
  s.add_runtime_dependency "trollop", "~> 2.1.2"
end
