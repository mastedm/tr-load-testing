#encoding: UTF-8
require "zlib"
require 'bzip2'

class DataCompress

  def initialize
    @filters = []   
    @stat = []
    @data = ""    
  end    

  def init_file(filename)
    begin
      file = File.open(filename)
    rescue Exception => e
      puts e.message
    end

    @data = file.read()
  end

  def init_string(str)
    @data = str
  end

  def to_gzip
    b_size = @data.size
    b_time = Time.now
    zd = Zlib::Deflate.new(Zlib::BEST_COMPRESSION,
                              Zlib::MAX_WBITS,
                              Zlib::MAX_MEM_LEVEL,
                              Zlib::FILTERED)
    @data = zd.deflate(@data, Zlib::FINISH)    
    zd.close
    p_stat('gzip', b_size, @data.size, b_time)
  end

  def from_gzip
    zi = Zlib::Inflate.new               
                              
    @data = zi.inflate(@data)
    zi.finish
    zi.close
    
  end

  def to_s
    @data[0 ... 100]
  end

  def to_bzip2
    b_size = @data.size
    b_time = Time.now
    @data = Bzip2.compress(@data)
   
    p_stat('bzip2', b_size, @data.size, b_time)
  end

  def from_bzip2
    @data = Bzip2.uncompress(@data)
  end

  def stat
    str = " Filter | Input size (KB) | Output size (KB) | Input/Output size | Time (s)\n"    
    @stat.each do |st|
       str << "#{st}\n"
    end
    str
  end

  def add_filter(filter)
    @filters << filter
  end

  def do_filters 
    i = 1   
    @filters.each do |filter|
      b_size = @data.size
      b_time = Time.now
      @data = filter.call(@data)
      p_stat("fltr #{i}", b_size, @data.size, b_time)
      i += 1
    end
  end

private
  
  def p_stat(method, i_size, o_size, b_time)
    @stat << "#{"%7s" % method} | #{"%15.3f" % (i_size.to_f / 1024)} | #{"%16.3f" % (o_size.to_f / 1024)} | #{"%17.2f" % (i_size/o_size)} | #{"%6.2f" % (Time.now - b_time)} "
  end  

end


