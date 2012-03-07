# Nutrasuite
A low-calorie sweetener for your minitests.

## Purpose

We really like using Minitest, and really didn't like the fact that
contexts for your tests weren't built in. So we wrote Nutrasuite.

### OH NO ANOTHER TEST FRAMEWORK WHY ARGHUBUGAJKGAaSDFAWEGSGA

Nope. Just something to make working with minitest a little easier.

### Why don't you just use RSpec or Minitest::Spec?

Because monkeying with the object namespace just to write tests makes us feel dirty in all the wrong ways.

### Why don't you just use shoulda-context?

Because it pretty much seems to have been deprecated, so we'd rather take a few
minutes to put something together that we can maintain.

### Why haven't you used [something else]?

Because we haven't heard of it, or it didn't work, or it wasn't available as a
proper gem anymore.

## Usage

Although there may be some more niceties added in the future, right now
Nutrasuite is all about contexts. Write your tests like so:

    require 'nutrasuite'
    class SomeTest < MiniTest::Unit::TestCase
      a "newly instantiated test object" do
        before do
          some_setup_stuff
        end

        it "tests for stuff" do
          assert true
        end

        after do
          some_teardown_stuff
        end
      end
    end

All of your other minitest stuff should work normally. Context
before/after blocks are executed once for each test, so the randomization built into
minitest will still work as you'd expect.

`a`, `an`, `and_also`, `the`, and `that` all define contexts, so you can build
readable sentences like "_a_ user _that_ has an expired password _and_also_ a bad
email address" or "_the_ singleton."

`it` defines tests; `it_eventually` defines tests that are to be skipped.

## Get it

It's a gem named nutrasuite. Install it and make it available however
you prefer.

If you want to use it you'll at least need Ruby 1.9. Other than that it should
be compatible with anything that works with MiniTest; we're not currently aware
of any conflicts.

## Contributions

If Nutrasuite interests you and you think you might want to contribute, hit me up
over Github. You can also just fork it and make some changes, but there's a
better chance that your work won't be duplicated or rendered obsolete if you
check in on the current development status first.
Gem requirements/etc. should be handled by Bundler.

### Contributors

Alan Johnson (commondream)

## License
Copyright (C) 2012 by Tommy Morgan

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
