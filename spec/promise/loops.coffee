should   = require 'should'
{defer}  = require 'when'
sequence = require 'when/sequence'

describe 'promise loops', -> 

    it 'a for loop in coffee-script returs an array', (done) -> 

        (
            for value in [0..9]
                value

        ).should.eql [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        done()


    it 'can build an array of functions', (done) -> 

        array = for value in [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
            -> value * value

        #
        # but...
        # 
        #   0 * 0 should equal 0
        # 

        firstFunction = array[  0  ]
        #firstFunction().should.equal 0

        # 
        # it does not:
        # 
        #   AssertionError: expected 81 to equal 0
        # 

        # 
        # By the time the function runs, `value` has
        # already been assigned from the last element 
        # in the array,
        #
        # To fix it we need to use a closure wrapper to
        # ensure each value remains referenced to the
        # value we want at the time,
        # 
        # Coffee-script has shorthand for this.
        #
        # 
        
        array = for value in [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

            do (value) -> 

                #
                # each value when used will now reference
                # the value as it was while the loop was
                # iterating
                #

                return -> value * value


        array[  0  ]().should.equal 0
                                    # 
                                    # good!
                                    # 

        done()





    it 'uses the coffee-script loop closure wrapper (see above) to perform a sequence of functions', (done) -> 


        doSomethingFunction = (arg) -> 

            promised = defer()
            setTimeout (-> 

                #
                # delay the result of doingSomething
                #

                promised.resolve arg * arg

            ), 50

            #
            # return the promise that something will be done
            #

            return promised.promise


        #
        # sequence expects an array of functions that each
        # return a promise, generate one.
        #

        sequence( 
            
            # for apiQuery in taskList
            for i in [0..9]

                do (i) -> -> doSomethingFunction i

        ).then( 

            (resolve) -> resolve[5].should.equal 25; done()
            (reject)  -> 
            (notify)  -> 

        )
                





