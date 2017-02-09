module Publisher
  def subscribe(obj)
    @observers ||= []
    @observers << obj
  end

  def publish(message, *args)
    return if @observers.blank?
    @observers.each do |subscriber|
      subscriber.send(message, *args) if subscriber.respond_to?(message)
    end
  end
end

class Security
  include Publisher
  attr_reader :text

  def initialize(text)
    self.text = text
  end

  def text=(value)
    puts 'Helo==============='
    @text  = value.split(".").first
    validate_text(value)
  end

  private

  %w(encryption decryption).each do |method|
    define_method "perform_" + method do
      # If text include number
      # number_text = @text.scan(/\d+/).join

      begin
        if !@text
          publish("message=", "Couldn't find text :(")
          publish(:failure) and return
        end

        split_text = @text.delete('').upcase.split("")
        num_pad_hash = cipher_key
        @matched_list = []

        num_pad_hash.each do |num_pad_key, num_pad_val|
          num_pad_val.each.each do |num_pad_val|
            @matched_list << num_pad_val
          end
        end

        converted_text = perform_conversion!(method, split_text, num_pad_hash, @matched_list).join

        publish("message=", "Your Converted Text is <strong>#{converted_text}</strong>")
        publish("converted_text=", converted_text)
        publish(:success) and return
      rescue => e
        publish("message=", e.message)
        publish(:failure) and return
      end
    end
  end

  def validate_text value
    raise "Plain Text or Cipher Text is incorrect. Use your name instead" if is_number? value
  end

  def is_number? string
    if (string =~ /\d/).is_a? Integer then true else false end
  end


  def cipher_key
    {
        num_pad_1: ["A", "J", "S"],
        num_pad_2: ["B", "K", "T"],
        num_pad_3: ["C", "L", "U"],
        num_pad_4: ["D", "M", "V"],
        num_pad_5: ["E", "N", "W"],
        num_pad_6: ["F", "O", "X"],
        num_pad_7: ["G", "P", "Y"],
        num_pad_8: ["H", "Q", "Z"],
        num_pad_9: ["I", "R"]
    }
  end


  def perform_conversion!(method_type, split_text, num_pad_hash, matched_list)
    converted_text = []

    split_text.each_with_index do |s_text, index|
      for matched_val in matched_list
        if matched_val == s_text
          num_pad_hash.each do |num_pad_key, num_pad_val|
            num_pad_val.each_with_index do |value, index|

              if s_text == value
                conv_val_index = index
                if method_type == "encryption"
                  num_pad_number = num_pad_key.to_s.split("_").last.to_i
                  num_pad_number += 3

                  unless num_pad_number > 9
                    generate_key = "num_pad_#{num_pad_number}".to_sym
                    num_pad_hash[generate_key]
                  else
                    num_pad_number -= 9
                    generate_key = "num_pad_#{num_pad_number}".to_sym
                  end
                else
                  num_pad_number = num_pad_key.to_s.split("_").last.to_i
                  num_pad_number -= 3

                  if num_pad_number <= 0
                    num_pad_number += 9
                    generate_key = "num_pad_#{num_pad_number}".to_sym
                  else
                    generate_key = "num_pad_#{num_pad_number}".to_sym
                    num_pad_hash[generate_key]
                  end
                end

                converted_text << num_pad_hash[generate_key][conv_val_index]
              end
            end
          end
        end
      end
    end

    converted_text
  end
end