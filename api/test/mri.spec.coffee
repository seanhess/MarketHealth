

mri = require('../model/mri')
should = require('should')


mockdb = 
    collection: ->
    mris: {} 

describe 'mris', ->
    it 'should return a min and max greater than zero', (done) ->
        mris = new mri.Mris(mockdb)

        mris.find = -> 
            { toArray: (cb) -> 
                process.nextTick ->
                    cb null, [{amount: 10}, {amount: 16}]
            }

        mris.findAllStats (err, minMax) ->
            if err? then return done err
            minMax.max.should.equal(16)
            minMax.min.should.equal(10)
            done()
        
        # asyncSpecWait()


        
describe 'mri', ->
    describe 'validate', ->
        it 'returns true if valid', ->
            m = new mri.Mri {amount: 10, state: "UT", doctor: "bob", city: "Provo", comments: "woot"}
            m.invalid().should.equal(false)
            # expect(m.invalid()).toBe(false)

        it 'returns false if invalid', ->
            m = new mri.Mri {state: "XX"}
            m.invalid().should.not.equal(false)
        
            m = new mri.Mri {state: "XX", amount: 10}
            m.invalid().should.not.equal(false)
            


    
    

