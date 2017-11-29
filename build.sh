gem uninstall -a rule-interface
rm rule-interface-*
gem build rule-interface.gemspec
gem install rule-interface-*
