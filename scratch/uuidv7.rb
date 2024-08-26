
#
# uuidv7.rb


# https://antonz.org/uuidv7/

# ## Structure
#
# UUIDv7 looks like this when represented as a string:
#
# ```
# 0190163d-8694-739b-aea5-966c26f8ad91
# └─timestamp─┘ │└─┤ │└───rand_b─────┘
#              ver │var
#               rand_a
# ```
#
# The 128-bit value consists of several parts:
#
# > timestamp (48 bits) is a Unix timestamp in milliseconds.
# > ver (4 bits) is a UUID version (7).
# > rand_a (12 bits) is randomly generated.
# > var* (2 bits) is equal to 10.
# > rand_b (62 bits) is randomly generated.
#
# * In string representation, each symbol encodes 4 bits as a hex number, so the
#   a in the example is 1010, where the first two bits are the
#   fixed variant (10) and the next two are random. So the resulting hex number
#   can be either 8 (1000), 9 (1001), a (1010) or b (1011).
#
# See RFC 9652 for details.

# https://www.rfc-editor.org/rfc/rfc9562#name-uuid-version-7



# https://antonz.org/uuidv7/#ruby


require 'securerandom'
require 'time'

def uuidv7
  # random bytes
  value = SecureRandom.random_bytes(16).bytes

  # current timestamp in ms
  timestamp = (Time.now.to_f * 1000).to_i

  # timestamp
  value[0] = (timestamp >> 40) & 0xFF
  value[1] = (timestamp >> 32) & 0xFF
  value[2] = (timestamp >> 24) & 0xFF
  value[3] = (timestamp >> 16) & 0xFF
  value[4] = (timestamp >> 8) & 0xFF
  value[5] = timestamp & 0xFF

  # version and variant
  value[6] = (value[6] & 0x0F) | 0x70
  value[8] = (value[8] & 0x3F) | 0x80

  value
end

if __FILE__ == $0
  uuid_val = uuidv7
  puts uuid_val.pack('C*').unpack1('H*')
end

