begin
  require 'ruby-debug'
  Debugger.settings[:autoeval] = true
rescue LoadError
  puts "could not load ruby-debug"
end