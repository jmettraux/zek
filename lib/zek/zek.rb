
module Zek

  class << self

    def repo_path

      ENV['ZEK_REPO_PATH'] ||
      fail('Please set $ZEK_REPO_PATH env var')
    end

    def monow

      Process.clock_gettime(Process::CLOCK_MONOTONIC)
    end

    # https://antonz.org/uuidv7/#ruby
    #
    # ```
    # 0190163d-8694-739b-aea5-966c26f8ad91
    # └─timestamp─┘ │└─┤ │└───rand_b─────┘
    #              ver │var
    #               rand_a
    # ```
    #
    def _uuid

      i = SecureRandom.random_bytes(16).bytes

      # current timestamp in ms

      ts = (Time.now.to_f * 1000).to_i

      # timestamp

      i[0] = (ts >> 40) & 0xFF
      i[1] = (ts >> 32) & 0xFF
      i[2] = (ts >> 24) & 0xFF
      i[3] = (ts >> 16) & 0xFF
      i[4] = (ts >> 8) & 0xFF
      i[5] = ts & 0xFF

      # version and variant

      i[6] = (i[6] & 0x0F) | 0x70
      i[8] = (i[8] & 0x3F) | 0x80

      i
    end

    def uuid_to_path(u)

      File.join(*[ u[-2, 2], u[-4, 2] ])
    end

    def uuid

      # TODO
    end
  end
end

