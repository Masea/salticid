#!/usr/bin/env ruby

require 'rubygems'
require 'bacon'
require File.expand_path("#{File.dirname(__FILE__)}/../lib/salticid")

describe "A Host" do
  @h = Salticid.new

  @h.role :awesome do
    task :setup do
      'awesome setup'
    end
  end

  @h.role :dreary do
    task :setup do
      'dreary setup'
    end

    task :clone do
      'a method name!'
    end
  end

  @h.host :localhost do
    user ENV['USER']
    role :awesome
    role :dreary
  end

  should 'resolve tasks in roles' do
    @h.host :localhost do
      awesome.setup.should == 'awesome setup'
      dreary.setup.should == 'dreary setup'
      lambda { setup }.should.raise
    end
  end

  should 'resolve methods which are ordinarily defined as tasks' do
    @h.host :localhost do
      dreary.clone.should == 'a method name!'
    end
  end

  should '#run' do
    @h.host :localhost do
      run(:dreary, :clone).should == 'a method name!'
    end
  end
end
