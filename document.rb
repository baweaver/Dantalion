# Dantalian
# =========
#
# **Author**: Brandon Weaver
#
# **Description**: Borrowing from Mime program to rip documentation from the programs themselves for ease of use.
#
# **Full Description**: Dantalian is the logical successor to mime's documentation functionality. The purpose of this script is to be able to document EVERY type of scripting language
# in use by ops people. I've currently tested it on Ruby, Python, and Perl.
#
# **Usage**: document (script-name / all)
#
# **Type**: DOC

# Code
# ----

# Why yes, the documentation script documents itself.

# As such with this, you can use much of ANY markdown syntax in the comments and it will render
require 'github/markdown'

# Collection of all script objects for an index
$scripts = []

# Collect all the Gem files
$gems = []

# Categories of Scripts
$categories = []

# Create the Docs directory if it doesn't exist yet
Dir.mkdir('docs') unless Dir.exists? 'docs'

# A container for the meta-information
class Script
  attr_accessor :author, :name, :description, :usage, :type, :location, :anchor
  
  def initialize(name)
    @name = name.split('/')[-1]
    @location = name
    @author = "n/a"
    @description = ""
    @usage = ""
    @anchor = ''
  end
  
  # Categorical Sorting
  def <=> (o)
    "[#{self.type}] #{self.name}" <=> "[#{o.type}] #{o.name}"
  end
end

# Find out if we have an exception that needs extra line breaks
def list?(line)
  return line =~ /^# \* / ? '\n' : ''
end

# Category Anchors
def anchor(script)
  if script.type != $lasttype  
    $categories << (script.type != '' ? script.type : 'none')
    $lasttype = script.type
    script.anchor = "<a name='#{script.type != '' ? script.type : 'none'}' class='category'></a>" 
  end
end

# Generate Documentation based on comments from a Ruby file
def document(file_name)
  origin = File.open("#{file_name}",'r')
  docs   = File.open("docs/doc-#{file_name.split('/')[-1]}.html",'w')
  comment = true
  script = Script.new(file_name)
  
  # Need to refactor this into some form of a rules engine. It's getting a bit hairy
  str = origin.each_line.inject("") do |str, line|
    # Skip if it's a shebang
    if line =~ /^ *#!/
      str << ""
    
    # Blank Comment line, insert newline
    elsif line =~ /^ *# *$/
      comment = true
      str << "\n"
      
    # Evaluate as text if it's a comment with spaces prior
    elsif line =~ /^ *#/
      str << "\n" unless comment 
      comment = true
      
      # Find the meta-information in the comments and harvest it
      if line.include? '**Author**'
        script.author = line.gsub(/^.*: /,'').chomp
      elsif line.include? '**Description**'
        script.description = line.gsub(/^.*: /,'').chomp
      elsif line.include? '**Usage**'
        script.usage = line.gsub(/^.*: /,'').chomp
      elsif line.include? '**Type**'
        script.type = line.gsub(/^.*: /,'').chomp
      end
      
      str << "#{line.gsub(/^ *# /,'')}"
    
    # Find the Gems used
    elsif line =~ /^ *require /
      gemname = line.gsub(/^ *require /,'').delete("'").delete('"').gsub('/','-').chomp
      # Don't add it unless it's not there or it's an absolute path
      unless ($gems.include? gemname) or (gemname =~ /^[A-Za-z]\:/)
        $gems << gemname
      end
      
      str << "\n" if comment  
      comment = false
      str << "    #{line}"
    # Evaluate as a code block if it's code
    else
      str << "\n" if comment  
      comment = false
      str << "    #{line}"
    end
  end
  
  # Add the current script to the collection for indexing
  $scripts << script
  
  # The following outputs a complete documentation for each and every single script that's in the directory. Very useful if you remember to type them out properly, otherwise you get to spend a few hours fixing it. Do it right the first time, trust me.
  
  # Headers and style information
  docs.puts "<html>"
  docs.puts "<link rel='stylesheet' type='text/css' href='style.css' />"
  docs.puts "<body>"
  
  docs.puts "<a href='index.html'>( &#60;&#60; Back to Index )</a>"
  
  # Insert the string into the docs
  docs.puts GitHub::Markdown.render(str)
  
  docs.puts "<a href='index.html'>( &#60;&#60; Back to Index )</a>"
  docs.puts "</body></html>"
end

name = ARGV.shift

# If all is set, document every ruby file in the directory.
if name.eql? 'all'
  index = File.open("docs/index.html",'w')
  
  # Document Ruby Files
  rbfiles = File.join("**", "*.rb")
  Dir.glob(rbfiles){ |rb_file| document(rb_file) }
  
  # Document Text Files, as most are configs
  # txtfiles = File.join("**", "*.txt")
  # Dir.glob(txtfiles){ |rb_file| document(rb_file) unless (rb_file.include?('log') || rb_file.include?('test')) }
  
  # Document Perl Files, as a test
  # perl = File.join("**", "*.pl")
  # Dir.glob(perl){ |rb_file| document(rb_file) }
  
  # Document Python Files, as a test
  # python = File.join("**", "*.py")
  # Dir.glob(python){ |rb_file| document(rb_file) }
  
  # This will save you some headaches later on, especially if you're using the types tag properly
  $scripts.sort!
  
  # Add Categories to it.
  $scripts.each{ |script| anchor(script) }
  
  # This entire section will need to be drastically reworked later as there are FAR more efficient ways of doing this
  index.puts "<html><link rel='stylesheet' type='text/css' href='style.css' /><body>"
  index.puts "<h1>Documentation Index</h1>"
  
  # Some information on how to get a base install up and going
  index.puts "<p>All Ruby scripts in all sub directories of the scripts folder are documented here. Additional information can be readily found inside the scripts pages themselves for extra documentation and other useful information.</p>"
  index.puts "<p>Install Ruby 1.9.3 from <a href='http://rubyinstaller.org/'>RubyInstaller</a> to get started. It is also recommended to download <a href='http://notepad-plus-plus.org/'>Notepad++</a> as a text editor."
  
  index.puts "<p>Make SURE to read through the following to get a better grasp on Ruby, especially their Docs page:</p>"
  
  # Best Ruby sites I've seen around the block for newbies
  index.puts "<ul>"
  index.puts "  <li><a href='http://ruby-doc.org/'>Ruby Docs</a></li>"
  index.puts "  <li><a href='http://rubymonk.com/'>Ruby Monk</a></li>"
  index.puts "  <li><a href='http://tryruby.org/'>TryRuby</a></li>"
  index.puts "</ul>"
  
  # The gemset of all scripts currently in use. Don't believe me? Add 'require "blusterfooba"' and it'll appear in the gem set. Can't say your script will work too well though...
  index.puts "<h2>Gems</h2>"
  index.puts "<p>The current gemset for the documented scripts can be installed by executing:</p>"
  index.puts "<p class='gem'>gem install #{$gems.join(' ')}</p>"
  index.puts "<p>The <a href='http://rubyinstaller.org/downloads/'>DevKit</a> will be required to install some gems</p>"
  
  # Output all the Categories in a list
  index.puts "<h2>Categories</h2>"
  
  index.puts "<ul id='categories'>"
  
    $categories.each{ |cat| index.puts "<li><a href='##{cat}'>#{cat}</a></li>"}
    
  index.puts "</ul>"
  
  index.puts "<h2>Scripts</h2>"
  
  index.puts "<ul class='doc'>"
  
  $lasttype = ''
  
  # Adding attribute selectors is fairly trivial up above if you want more information. Really, I could get a gem set for each file as an example.
  $scripts.each do |script| 
    index.puts "  <li>#{script.anchor}<a href='doc-#{script.name}.html'>[#{script.type}] #{script.name}</a>"
    index.puts "    <ul>"
    index.puts "      <li><b>Author:</b> #{script.author}</li>"
    index.puts "      <li><b>Description:</b> #{script.description}</li>"
    index.puts "      <li><b>Usage:</b> #{script.usage}</li>"
    index.puts "      <li><b>Location:</b> #{script.location}</li>"
    index.puts "    </ul>"
    index.puts "  </li>"
  end
  
  index.puts "</ul>"
  
  index.puts "</body>"
  index.puts "</html>"
else
  eval "document('#{name}.rb')"
end
