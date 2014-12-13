

set(:ruby_role, :app)


namespace :ruby do

    task :defaults do
        set(:ruby_packages, %w[
          autoconf
          bind9-host
          bison
          build-essential
          curl
          daemontools
          dnsutils
          ed
          git
          imagemagick
          iputils-tracepath
          libcurl4-openssl-dev
          libevent-dev
          libglib2.0-dev
          libjpeg-dev
          libjpeg62
          libpng12-0
          libpng12-dev
          libmagickcore-dev
          libmagickwand-dev
          libmcrypt-dev
          libmysqlclient-dev
          libpq-dev
          libsqlite3-dev
          libssl-dev
          libssl0.9.8
          libxml2-dev
          libxslt-dev
          mercurial
          netcat-openbsd
          ruby2.1-dev
          ruby2.1
          socat
          sqlite3
          telnet
          zlib1g-dev
          jpegoptim
          libv8-dev
          unattended-upgrades
        ])
    end

    task :sources do

      role = fetch(:ruby_role)

      key =  "#{role}" == "all"  ? :"ubuntu_packages" :  :"ubuntu_packages_for_#{role}"

      packages = fetch(key,[])
      packages += fetch(:ruby_packages)
      set(key, packages)


      key =  "#{role}" == "all"  ? :"ubuntu_software_sources" :  :"ubuntu_software_sources_for_#{role}"

      sources = fetch(key,[])
      sources += %w[ ppa:brightbox/ruby-ng ]
      set(key, sources)

    end


    task :install_gems do
      on roles(fetch(:ruby_role)) do
        if test "[ ! -f /etc/gemrc ]"
          upload_as :root, StringIO.new("install: --no-rdoc --no-ri\nupdate:  --no-rdoc --no-ri"), "/etc/gemrc"
          sudo :chmod, '0644', "/etc/gemrc"
        end

        if test "[ -z $(which bundler) ]"
          sudo :gem, 'install', 'bundler'
        end

      end
    end




end


after "load:defaults", "ruby:defaults"
before "ubuntu:update_sources", "ruby:sources"
after "ubuntu:install_packages", "ruby:install_gems"
