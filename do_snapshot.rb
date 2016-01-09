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
    Version.new(version.to_s) >= Version.new('1.9.3')
  end

  def modify_build_environment
    ruby = which 'ruby'
    return unless ruby

    ENV.prepend_path 'PATH', ruby.dirname
  end

  def message; <<-EOS.undent
    DoSnapshot requires Ruby >= 1.9.3
  EOS
  end
end

class DoSnapshot < Formula # rubocop:disable Style/Documentation
  homepage 'https://dosnapshot.merqlove.ru/'
  url 'http://assets.merqlove.ru.s3.amazonaws.com/do_snapshot/do_snapshot-0.6.1.tgz'
  sha256 '4f2f8501160a2f4baec41bf1de793064cd30620243d20695ce94c1774c5e7ef0'

  depends_on Ruby19

  def install
    libexec.install Dir['*']
    bin.write_exec_script libexec / 'bin/do_snapshot'
  end

  test do
    system "#{bin}/do_snapshot", 'version'
  end

  def caveats; <<-EOS.undent
    do_snapshot requires an installation of Ruby 1.9.3 or greater.
  EOS
  end
end
