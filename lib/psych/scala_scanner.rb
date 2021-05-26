# Patch for a ruby issue when parses a YAML with comma separated integers
# https://github.com/ruby/psych/issues/273

Psych::ScalarScanner.send(:remove_const, "INTEGER")
Psych::ScalarScanner::INTEGER = /^(?:[-+]?0b[0-1_]+          (?# base 2)
                                    |[-+]?0[0-7_]+           (?# base 8)
                                    |[-+]?(?:0|[1-9][0-9_]*) (?# base 10)
                                    |[-+]?0x[0-9a-fA-F_]+    (?# base 16))$/x.freeze
