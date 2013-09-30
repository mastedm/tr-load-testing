tr-load-testing
===============

Class DataCompress may to use for compress string by gzip/bzip2 library.
And you may to add a new filter.

#Example with gzip, init from file:

require_relative 'compress'

data = DataCompress.new
data.init_file("access.log") # Load data from file

data.to_gzip # Compress using gzip

print data.stat # Print statistics

#Example with bzip, init from string:

require_relative 'compress'

data = DataCompress.new
data.init_string("118.42.132.85 - - [18/May/2013:11:14:47 +0400] "GET / HTTP/1.0" 502 173") 

data.to_bzip2

print data.stat

#Example with your filter and gzip:

require_relative 'compress'

data = DataCompress.new

data.init_file("access.log")

data.add_filter( 
  proc {
    |str| str.force_encoding("ISO-8859-1").encode("utf-8", replace: nil).gsub(/(?:[0-9]{1,3}\.){3}[0-9]{1,3}/, "IP")
  }
)

data.do_filters # Run filters

data.to_gzip 

print data.stat 



