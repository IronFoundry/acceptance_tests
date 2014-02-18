class Class
  def env_accessor(*symbols)
    symbols.each do |s|
      self.class_eval %Q{
        def #{s}
          key = "IF_#{s.to_s.upcase}"
          return ENV[key] if ENV.key?(key)
          @#{s}
        end

        def #{s}=(value)
          @#{s}=value
        end
      }
    end
  end
end