# -*- encoding: utf-8 -*-
# stub: psych 3.0.2 java lib

Gem::Specification.new do |s|
  s.name = "psych".freeze
  s.version = "3.0.2"
  s.platform = "java".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Aaron Patterson".freeze, "SHIBATA Hiroshi".freeze, "Charles Oliver Nutter".freeze]
  s.date = "2017-12-04"
  s.description = "Psych is a YAML parser and emitter. Psych leverages libyaml[http://pyyaml.org/wiki/LibYAML]\nfor its YAML parsing and emitting capabilities. In addition to wrapping libyaml,\nPsych also knows how to serialize and de-serialize most Ruby objects to and from the YAML format.\n".freeze
  s.email = ["aaron@tenderlovemaking.com".freeze, "hsbt@ruby-lang.org".freeze, "headius@headius.com".freeze]
  s.extra_rdoc_files = ["CHANGELOG.rdoc".freeze, "README.md".freeze]
  s.files = ["CHANGELOG.rdoc".freeze, "README.md".freeze]
  s.homepage = "https://github.com/ruby/psych".freeze
  s.licenses = ["MIT".freeze]
  s.rdoc_options = ["--main".freeze, "README.md".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.2.2".freeze)
  s.requirements = ["jar org.yaml:snakeyaml, 1.18".freeze]
  s.rubygems_version = "2.6.14.1".freeze
  s.summary = "Psych is a YAML parser and emitter".freeze

  s.installed_by_version = "2.6.14.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake-compiler>.freeze, [">= 0.4.1"])
      s.add_development_dependency(%q<minitest>.freeze, ["~> 5.0"])
      s.add_runtime_dependency(%q<jar-dependencies>.freeze, [">= 0.1.7"])
      s.add_development_dependency(%q<ruby-maven>.freeze, [">= 0"])
    else
      s.add_dependency(%q<rake-compiler>.freeze, [">= 0.4.1"])
      s.add_dependency(%q<minitest>.freeze, ["~> 5.0"])
      s.add_dependency(%q<jar-dependencies>.freeze, [">= 0.1.7"])
      s.add_dependency(%q<ruby-maven>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<rake-compiler>.freeze, [">= 0.4.1"])
    s.add_dependency(%q<minitest>.freeze, ["~> 5.0"])
    s.add_dependency(%q<jar-dependencies>.freeze, [">= 0.1.7"])
    s.add_dependency(%q<ruby-maven>.freeze, [">= 0"])
  end
end
