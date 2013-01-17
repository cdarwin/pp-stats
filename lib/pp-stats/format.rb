module PPStats
  module Format
    def self.warnf(msg)
      warn("Warning: #{msg}".yellow)
    end

    def self.errorf(msg)
      warn("Error: #{msg}".red)
    end

    def self.green(msg)
      msg.green
    end

    def self.blue(msg)
      msg.blue
    end

    def self.magenta(msg)
      msg.magenta
    end

    def self.cyan(msg)
      msg.cyan
    end

    def self.gray(msg)
      msg.gray
    end

  end
end

class String
  require 'Win32/Console/ANSI' if RbConfig::CONFIG['host_os'] =~ /mswin|win32|dos|mingw|cygwin/i

  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def red
    colorize(31)
  end

  def green
    colorize(32)
  end

  def yellow
    colorize(33)
  end

  def blue
    colorize(34)
  end

  def magenta
    colorize(35)
  end

  def cyan
    colorize(36)
  end

  def gray
    colorize(37)
  end
end