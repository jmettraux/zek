
#
# zek/cmd_visbn.rb

# The International Standard Book Number (ISBN) is a unique numeric commercial
# book identifier. There are two standards in use currently, ISBN-10 and
# ISBN-13.
#
# **ISBN-10** consists of 10 characters in the following format:
#
# ```
# X-XXXX-XXXX-X
#```
#
# - The first part is a single digit representing the language group.
# - The second part can be up to 5 digits long and is the publisher code.
# - The third part is the title identifier and can be up to 5 digits long.
# - The final part is a single check digit, which can be a number from 0 to 9
#   or an 'X' representing 10.
#
# **ISBN-13** consists of 13 characters in the following format:
#
# ```
# xxx-X-XXXX-XXXX-X
# ```
#
# - The first part is a 3-digit EAN (European Article Number) prefix, usually
#   978 or 979.
# - The second part is a single digit representing the language group.
# - The third part can be up to 5 digits long and is the publisher code.
# - The fourth part is the title identifier and can be up to 5 digits long.
# - The final part is a single check digit, which can only be a number from 0
#   to 9.
#
# The digits in the ISBN are separated by either hyphens or spaces. Both
# formats use check digits, which are calculated using a specific mathematical
# formula and are used to validate the integrity of the number.

module Zek::CmdVisbn; class << self

  def execute(args, lines)

    a0 = args[0].to_s

    fail "invalid chars in ISBN #{args[0].inspect}" \
      if a0.match?(/[^-0-9X]/)

    i = a0.gsub(/[^\dX]/, '')

    if i.length == 10

      cs = i.chars
      c = cs.pop; c = c == 'X' ? c : c.to_i

      s = cs.each_with_index.inject(0) { |s, (n, i)| s + n.to_i * (i + 1) } % 11
      s = (s == 10) ? 'X' : s

      if s == c
        # X-XXXX-XXXX-X
        puts "#{i[0, 1]}-#{i[1, 4]}-#{i[5, 4]}-#{i[9, 1]}"
      else
        fail "invalid ISBN10 >#{args[0]}<"
      end

    elsif i.length == 13

      s = i
        .chars
        .each_with_index
        .inject(0) { |s, (n, i)| s + n.to_i * (i % 2 == 0 ? 1 : 3) }

      if s % 10 == 0
        # xxx-X-XXXX-XXXX-X
        puts "#{i[0, 3]}-#{i[3, 1]}-#{i[4, 4]}-#{i[8, 4]}-#{i[12, 1]}"
      else
        fail "invalid ISBN13 >#{args[0]}<"
      end

    else

      fail "not an ISBN #{args[0].inspect}"
    end
  end

  protected
end; end

