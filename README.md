# WTF Chord?

‘WTF Chord?’ is the Ruby guitar chords generator library & cli tool, which also contains some abstraction for musical mathematics. Chords generator is a common but a not only mission, the library is ready for extending for generating scales.

Some features:

* Tones math methods.
* Finding chords by names with many variants of fingering.
* CLI tool `wtfchord` to quickly find chord and draw it's fingerings to your terminal.
* Extendable rules (pending).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'wtf_chord'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wtf_chord

## CLI-tool usage

For example, to print two fingering variants of the `Dm` chord, just run:

    $ wtfchord Dm 2

And you'll get the visual presentation of chords' fingerings:

    [ ×  ×  0  2  3  1 ]
     ––––––––––––––––––
      |  |  |  |  |  •
      |  |  |  •  |  |
      |  |  |  |  •  |
      |  |  |  |  |  |
      |  |  |  |  |  |
      |  |  |  |  |  |
     ––––––––––––––––––
            D  A  D  F

    [ ×  5  7  7  6  5 ]
     ––––––––––––––––––
      |  •  |  |  |  •    V
      |  |  |  |  •  |
      |  |  •  •  |  |
      |  |  |  |  |  |
      |  |  |  |  |  |
      |  |  |  |  |  |
     ––––––––––––––––––
         D  A  D  F  A

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment. Run `bundle exec wtf_chord` to use the gem in this directory, ignoring other installed copies of this gem.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/estum/wtf_chord.
