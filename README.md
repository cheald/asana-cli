# asana-cli

Command-line client for Asana

## Installation

Add this line to your application's Gemfile:

    gem 'asana-cli'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install asana-cli

## Usage

    Options:
               --list, -l:   List all workspaces
      --workspace, -w <s>:   Workspace
        --project, -p <s>:   Project
       --complete, -c <i>:   Complete a task
          --close, -o <i>:   Complete a task
         --create, -r <s>:   Create new task
        --message, -m <s>:   Comment on a task
           --task, -t <i>:   Task to operate on
            --key, -k <s>:   API key to use
        --keyfile, -e <s>:   API keyfile to use (default: ~/.asana_key)
               --help, -h:   Show this message

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
