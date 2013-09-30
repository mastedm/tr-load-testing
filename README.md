tr-load-testing
===============

Class DataCompress may to use for compress string by gzip/bzip2 library.
And you may to add a new filter.

Example with gzip:

require_relative 'compress'

data = DataCompress.new
data.init_file("access.log") # Load data from file
#data.init_string(str) # Load data from string

data.to_gzip # Compress using gzip

print data.stat # Print statistics

Example with bzip:

require_relative 'compress'

data = DataCompress.new
data.init_string(str) 

data.to_bzip2

print data.stat

Example with your filter and gzip:

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



Example statistic output:

 Filter | Input size (KB) | Output size (KB) | Input/Output size | Time (s)
 fltr 1 |           1.101 |            1.025 |              1.00 |   0.00
 fltr 2 |           1.025 |            0.049 |             21.00 |   0.00
   gzip |           0.049 |            0.057 |              0.00 |   0.00

