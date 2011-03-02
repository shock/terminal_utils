require 'rubygems'
require 'shellwords'
require 'appscript'

class Terminal
  include Appscript
  attr_reader :terminal, :current_window
  def initialize
    @terminal = app('Terminal')
    @current_window = terminal.windows.first
    yield self
  end

  def window(dir, command = nil)
    app('System Events').application_processes['Terminal.app'].keystroke('n', :using => :command_down)
    cd_and_run dir, command
  end

  def tab(dir, command = nil)
    app('System Events').application_processes['Terminal.app'].keystroke('t', :using => :command_down)
    cd_and_run dir, command
  end

  def cd_and_run(dir, command = nil)
    run "clear; cd #{dir.shellescape}"
    run command
  end

  def run(command)
    command = command.shelljoin if command.is_a?(Array)
    if command && !command.empty?
      terminal.do_script(command, :in => current_window.tabs.last)
    end
  end
end

