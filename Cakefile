child_process = require 'child_process'
hound         = require 'hound'

task 'dev', 'Run spec', ->
    console.log 'Watching ./spec'
    watcher = hound.watch './spec'
    watcher.on 'change', (file, stats) ->
        return unless file.match /\.coffee$/
        test_runner = child_process.spawn './node_modules/.bin/mocha', [
            '--colors',
            '--compilers', 
            'coffee:coffee-script', 
            file
        ], stdio: 'inherit'

