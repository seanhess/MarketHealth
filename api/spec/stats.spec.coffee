

mri = require('../model/mri')

describe 'mris', ->
    it 'should return a min and max greater than zero', ->
        mris = new mri.Mris()

        mris.find = -> 
            { toArray: (cb) -> 
                process.nextTick ->
                    cb null, [{amount: 10}, {amount: 16}]
            }

        mris.findAllStats (err, minMax) ->
            expect(minMax).not.toBeNull()
            expect(minMax.max).toBe(16)
            expect(minMax.min).toBe(10)
            asyncSpecDone()
        
        asyncSpecWait()

