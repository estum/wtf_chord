require 'optparse'
require 'methadone'

module WTFChord
  class CLI
    include Methadone::Main
    include Methadone::CLILogging

    main do |name|
      chord     = WTFChord.chord(name)
      formatter = WTFChord::Formatter.new(options['output'], options['rates'])

      debug { "Output using formatter: #{formatter.formatter.to_s}\n" }

      options['amount'] = 1 if options['output'] == 'piano1'

      collector =
        case formatter.name when 'piano', 'piano1'
          Collectors::Piano
        else
          Collectors::Guitar
        end

      fingerings = chord.fingerings(options['amount'], collector: collector)
      puts formatter[*fingerings].uniq * formatter.separator
    end

    version VERSION

    description "Finds fingerings of the requested chord."


    ##
    # Arguments
    #
    arg :name, "Chord name to find."


    ##
    # Options
    #
    options['amount'] = 5
    options['output'] = 'default'
    options['rates']  = false

    on "-n N",      "--amount N",      Integer, "Amount of fingering variants to output."
    on "-o FORMAT", "--output FORMAT",          "Output format."
    on "-R",        "--[no-]rates",             "Output fingering complexity rates"

    use_log_level_option
  end
end