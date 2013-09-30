require_relative 'compress'

data = DataCompress.new
data.init_file("access.log")
#data.init_string(str)

data.add_filter(
  proc {
    |str| str.force_encoding("ISO-8859-1").encode("utf-8", replace: nil).gsub(/(?:[0-9]{1,3}\.){3}[0-9]{1,3}/, "IP")
  }
)

data.add_filter(
  proc {
    |str| str[0 .. 50]
  }
)

data.do_filters

data.to_gzip

print data.stat

