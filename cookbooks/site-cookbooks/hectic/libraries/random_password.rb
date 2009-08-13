class Chef::Node
  def random_password(length=20)
    random_password = ''
    chars = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
    length.times { |i| random_password << chars[rand(chars.size-1)] }
    random_password
  end
end
