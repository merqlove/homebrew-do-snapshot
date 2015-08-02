# -*- encoding : utf-8 -*-
# Forked from: https://github.com/Homebrew/homebrew/blob/master/Library/Formula/heroku-toolbelt.rb
require 'formula'

class Ruby19 < Requirement # rubocop:disable Style/Documentation
  fatal true
  default_formula 'ruby'

  satisfy build_env: false do
    next unless which 'ruby'
    version = /\d\.\d/.match `ruby --version 2>&1`

    next unless version
    # noinspection RubyArgCount
    Version.new(version.to_s) >= Version.new('2.0')
  end

  def modify_build_environment
    ruby = which 'ruby'
    return unless ruby

    ENV.prepend_path 'PATH', ruby.dirname
  end

  def message; <<-EOS.undent
    DoSnapshot requires Ruby >= 2.0.0
  EOS
  end
end

class DoSnapshot < Formula # rubocop:disable Style/Documentation
  homepage 'https://dosnapshot.merqlove.ru/'
  url 'http://assets.merqlove.ru.s3.amazonaws.com/do_snapshot/do_snapshot-0.4.0.tgz'
  sha256 'd6acea887e57f1d9dd33af440ec48ca61910a6b4908c7c7331413b6962dd2db4'

  depends_on Ruby19

  def install
    libexec.install Dir['*']
    bin.write_exec_script libexec / 'bin/do_snapshot'
  end

  test do
    system "#{bin}/do_snapshot", 'version'
  end

  def caveats; <<-EOS.undent
    do_snapshot requires an installation of Ruby 2.0.0 or greater.
  EOS
  end
end
