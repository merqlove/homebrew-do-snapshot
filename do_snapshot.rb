# -*- encoding : utf-8 -*-
# Forked from: https://github.com/Homebrew/homebrew/blob/master/Library/Formula/heroku-toolbelt.rb
require 'formula'

class Ruby20 < Requirement # rubocop:disable Style/Documentation
  fatal true

  satisfy build_env: false do
    next unless which 'ruby'
    version = /\d\.\d/.match `ruby --version 2>&1`

    next unless version
    # noinspection RubyArgCount
    Version.new(version.to_s) >= Version.new('2.0.0')
  end

  def modify_build_environment
    ruby = which 'ruby'
    return unless ruby

    ENV.prepend_path 'PATH', ruby.dirname
  end

  def message; <<-EOS
    DoSnapshot requires Ruby >= 2.0.0
  EOS
  end
end

class DoSnapshot < Formula # rubocop:disable Style/Documentation
  homepage 'https://dosnapshot.merqlove.ru/'
  url 'http://s3.amazonaws.com/assets.merqlove.ru/do_snapshot/do_snapshot-1.0.2.tgz'
  sha256 '798141ce1ca34ab74d5fefaa84646fb12072ec560c18e4e1c3cf9f590498679a'

  depends_on Ruby20

  def install
    libexec.install Dir['*']
    bin.write_exec_script libexec / 'bin/do_snapshot'
  end

  test do
    system "#{bin}/do_snapshot", 'version'
  end

  def caveats; <<-EOS
    do_snapshot requires an installation of Ruby 2.0.0 or greater.
  EOS
  end
end
