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

    Usage: wtfchord [options] name

    Finds fingerings of the requested chord.

    v0.3.1

    Options:
        -h, --help                       Show command line help
            --version                    Show help/version info
        -n, --amount N                   Amount of fingering variants to output.
                                         (default: 5)
        -o, --output FORMAT              Output format.
                                         (default: default)
        -R, --[no-]rates                 Output fingering complexity rates
            --log-level LEVEL            Set the logging level
                                         (debug|info|warn|error|fatal)
                                         (Default: info)

    Arguments:

        name
            Chord name to find.

For example, to print two fingering variants of the `Dm` chord, just run:

    $ wtfchord Dm -n 2

And you'll get the visual presentation of chords' fingerings:

    [ ×  ×  0  2  3  1 ]
     ——————————————————
      |  |  |  |  |  ◉
      |  |  |  ◉  |  |
      |  |  |  |  ◉  |
      |  |  |  |  |  |
      |  |  |  |  |  |
      |  |  |  |  |  |
     ——————————————————
            D  A  D  F

    [ ×  5  7  7  6  5 ]
     ——————————————————
      |  ◉  |  |  |  ◉   ← V
      |  |  |  |  ◉  |
      |  |  ◉  ◉  |  |
      |  |  |  |  |  |
      |  |  |  |  |  |
      |  |  |  |  |  |
     ——————————————————
         D  A  D  F  A

You can get simpler output, using the `--output` option:

    $ wtfchord Dm -n 10 --output=simple
    Dm (D - F - A)

    [ × × 0 2 3 1 ]
    [ × 5 3 2 3 1 ]
    [ × 5 3 2 3 5 ]
    [ × 5 3 7 3 5 ]
    [ × 5 7 7 6 5 ]
    [ 10 8 7 7 6 10 ]
    [ 10 8 7 7 10 10 ]

Starting with 0.7.0, we have the very nice piano formatting:

    $ wtfchord Fdim -n 2 --output=piano
    F1 - G♯1 - B1
    ┌─┬─┬┬─┬─┬─┬─┬┬─┬┬─┬─┐
    │ │ ││ │ │ │ ││█││ │ │
    │ └┬┘└┬┘ │ └┬┘└┬┘└┬┘ │
    │  │  │  │▐▌│  │  │▐▌│
    └──┴──┴──┴──┴──┴──┴──┘
     ↑
     Ⅰ


    G♯1 - B1 - F2
    ┌─┬─┬┬─┬─┬─┬─┬┬─┬┬─┬─┬─┬─┬┬─┬─┬─┬─┬┬─┬┬─┬─┐
    │ │ ││ │ │ │ ││█││ │ │ │ ││ │ │ │ ││ ││ │ │
    │ └┬┘└┬┘ │ └┬┘└┬┘└┬┘ │ └┬┘└┬┘ │ └┬┘└┬┘└┬┘ │
    │  │  │  │  │  │  │▐▌│  │  │  │▐▌│  │  │  │
    └──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┘
     ↑                    ↑
     Ⅰ                    Ⅱ

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment. Run `bundle exec wtf_chord` to use the gem in this directory, ignoring other installed copies of this gem.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/estum/wtf_chord.
