--[[----------------------------------------------------------------------------
   
  Application Name:
  DynamicFlow                                                                                                               
                                                                                              
  Summary:
  Creates and controls a Flow over the Flow API
   
  Description:
  This sample is based on the ControlFlow sample as creates the same flow with it,
  but creates and controls it using the Flow API
  Introduction sample for creating and controling flows using the Flow API.
  The sample first loads an existing flow out of a flow file.
  In this flow, an output state is changed, depending on the state of two input ports. 
  Via the API, a delay of 1s before setting the DigitalOut is added.  
   
  How to run:
  The state of the Input ports can be toggled using the keyboard key "1" and "2" 
  inside the Emulator tab.
  See the console for the DigitalOutput state.
      
------------------------------------------------------------------------------]]

--loading a flow from the flow-file  in the resources 
handle = Flow.create()
assert(handle)
assert(handle:load("resources/ControlFlow.cflow"))
assert(handle:start())
handle:stop()
assert(handle:start())

-- List the content:
print("Blocks: ", unpack(handle:listBlocks()))
local linksFrom, linksTo = handle:listLinks()
print("Links from Block:", unpack(linksFrom))
print("Links to   Block:", unpack(linksTo))

-- Remove link between "and" and "output" block
assert(handle:removeLink("myAnd", "setOutput"))

-- Add a delay block between the "and" and digital out port:
assert(not handle:hasBlock("myDelay"))
assert(handle:addBlock("myDelay", "DigitalLogic.Delay.delay"))
assert(handle:setInitialParameter("myDelay", "DelayTime", 5000))

-- Add the new links:
-- (Also would work without the port names, but would not be viewable in FlowEditor without it)
assert(handle:addLink("myAnd:level", "myDelay:signal"))
assert(handle:addLink("myDelay:delayedSignal", "setOutput:newState"))

-- Check the private folder of the app, e.g. move it to resources of the app to show it in the Flow editor of AppStudio
assert(handle:save("private/saved.cflow"))

-- Stop and run the updated flow with the delay:
handle:stop()
assert(handle:start())

-- Parameter can be updated on the fly:
assert(handle:updateParameter("myDelay", "DelayTime", 1000))
