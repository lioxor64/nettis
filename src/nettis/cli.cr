require "commander"

module Nettis
  
  # Initialize a new command-line argumented interface. Use stdout as first tty
  # and extend Commander with available commands.
  class Cli

    # @return tty
    property  tty    = Commander::Command.new
    property scanner = Nettis::Scanner.new

    def initialize

      # Extend `stdout` with commands and main instance. Main instance can
      # contain a parent command. Spawned instance should parse automatically
      # given input. As such, just call `scanner` and appropriate method.
      tty = Commander::Command.new do |cmd|

        # Declare CLI.
        cmd.use  = Nettis::Kernel::APPLICATION_NAME
        cmd.long = Nettis::Kernel::APPLICATION_DESC

        #puts cmd.help

        cmd.run do |options, arguments|
          p arguments              # => Array(String)
          puts cmd.help             # => Render help screen
        end

        cmd.commands.add do |cmd|
          cmd.use = "status"
          
          cmd.short = "Show status about top-level domain [.BA]"
          cmd.long = cmd.short
          cmd.run do |options, arguments|
            @scanner.status
            arguments
          end
        end

        cmd.commands.add do |cmd|
          cmd.use = "last <#>"

          cmd.short = "Show last (max) 5 domains registered in zone."
          cmd.long = cmd.short
          cmd.run do |options, arguments|
            @scanner.get_domains 
            arguments
            #p Nettis::Scanner.get_domains
            #Nettis::Scanner.new.get_domains 
          end
        end

        cmd.commands.add do |cmd|
          cmd.use = "whois <domain>"

          cmd.short = "Execute a whois on domain and OCR-to-ASCII."
          cmd.long = cmd.short
          cmd.run do |options, arguments|
            Nettis::Scanner.new.get_whois(arguments[0])
          end
        end

        cmd.commands.add do |cmd|
          cmd.use = "about"

          cmd.short = "Show information about `nettis` and how it's used."
          cmd.long = cmd.short
          cmd.run do |options, arguments|
            arguments 
          end
        end
      end

      Commander.run(tty, ARGV)
    end

    def tty
      @tty
    end

  end
end
