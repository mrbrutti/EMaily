module EMaily
  class CSV
    def self.parse(file)
      list = []
      f = File.open(file, "r")
      lines = f.readlines
      fields = lines[0].downcase.strip.split(",")
      lines.delete(lines[0])
      lines.each_with_index do |line, i|
        list[i] = {}
        line.chop.split(",").each_with_index do |val, idx|
          list[i][fields[idx].strip.to_sym] = val.strip
        end
      end
      list
    end
  end
end

