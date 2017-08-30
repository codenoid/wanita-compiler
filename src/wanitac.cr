require "./wanitac/*"
require "option_parser"
require "yaml"

wlib, text = "", ""

OptionParser.parse! do |parser|
  parser.banner = "Usage: salute [arguments]"
  parser.on("-wlib", "--lib=LIB", "Language Library") { |v| wlib = v.to_s }
  parser.on("-c", "--c=C", "Woman language to use") { |v| text = v.to_s }
  parser.on("-h", "--help", "Show this help") { puts parser }
end

validator(wlib,text)

def validator(w = String,t = String)
  if w && t
    if mime(w,"wlib") && mime(t,"wlang")
      runner(w,t)
    else
      puts "File type not supported"
      exit 1
    end
  else
    puts "Input file must be given"
    exit 1
  end
end

def library(w= String)
  wlib = File.open(w, "r")
  wlib = YAML.parse wlib
  rlib = {} of String => String
  wlib["language"].each do |k, v|
    rlib[k.to_s] = v.to_s
  end
  return rlib
end

def runner(w= String, t=String)
  word_library = library(w)
  word = File.read(t)
  new_word = word.gsub(/\b\w+\b/) { |s| word_library.fetch(s) { s } }
  File.write("./result.txt", new_word, encoding = "utf-8")
end

def mime(file= String, mime= String)
  dirty_res = file.split(".").last
  if dirty_res != mime
    return false
  else
    return true
  end
end
