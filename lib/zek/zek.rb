
module Zek

  class << self

    def repo_path

      ENV['ZEK_REPO_PATH'] ||
      fail('Please set $ZEK_REPO_PATH env var')
    end

    def path(*a)

      File.join(repo_path, *a)
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
    def _uuid(t=Time.now)

      id = SecureRandom.random_bytes(16).bytes

      # current timestamp in ms

      ts = (t.to_f * 1000).to_i

      # timestamp

      id[0] = (ts >> 40) & 0xFF
      id[1] = (ts >> 32) & 0xFF
      id[2] = (ts >> 24) & 0xFF
      id[3] = (ts >> 16) & 0xFF
      id[4] = (ts >> 8) & 0xFF
      id[5] = ts & 0xFF

      # version and variant

      id[6] = (id[6] & 0x0F) | 0x70
      id[8] = (id[8] & 0x3F) | 0x80

      id.pack('C*').unpack1('H*')
    end

    def uuid_to_path(u, *rest)

      Zek.path(u[-2, 2], u[-4, 2], *rest)
    end
    alias uuid_path uuid_to_path

    # Checks that the uuid is unused before returning it...
    #
    def uuid

      1_000.times do

        u = _uuid

        return u if Dir[uuid_to_path(u, "n_#{u}_*.md")].empty?
      end

      fail "couldn't find a free UUIDv7 :-("
    end

    def extract_uuid(s)

      m = s.to_s.downcase.match(/([a-f0-9]{32})/)
      m ? m[1] : nil
    end

    def uuid_to_time(u)

      u = extract_uuid(u); return nil unless u

      Time.at(u[0, 12].to_i(16).to_f / 1000)
    end
  end
end

