---@meta

---@class Taneth
---@field IsExternal fun(): boolean
---@field RegisterTestSuite fun(self: Taneth, id: string, callback: fun()): nil
---@field RunTestSuite fun(self: Taneth, id: string, callback?: fun()): boolean?
---@field RunTestSuites fun(self: Taneth, ids: string[], callback?: fun()): boolean?
---@field RunAll fun(self: Taneth, callback?: fun()): boolean?

---@class TanethAssert
---@field equals fun(a: any, b: any): nil
---@field same fun(a: any, b: any): nil
---@field is_true fun(a: any): nil
---@field is_false fun(a: any): nil
---@field is_nil fun(a: any): nil
---@field is_not_nil fun(a: any): nil
---@field are_not { equals: fun(a: any, b: any): nil }
---@field has_error fun(expectedError: string, callback: fun()): nil
---@field has_no_error fun(callback: fun()): ...
---@field fail fun(message: string): nil

---@class TanethDescribe
---@field skip fun(label: string, callback: fun()): nil

---@class TanethIt
---@field skip fun(label: string, callback?: fun()): nil
---@field async TanethItAsync

---@class TanethItAsync
---@field skip fun(label: string, callback?: fun()): nil

---Global Taneth testing framework instance.
---@type Taneth
Taneth = {}

---Check if running in external (non-ESO) environment.
---@return boolean
function Taneth.IsExternal() end

---Register a test suite with the given ID.
---@param id string The unique identifier for the test suite
---@param callback fun() Function that defines the test suite using describe/it blocks
function Taneth:RegisterTestSuite(id, callback) end

---Run a single test suite by ID.
---@param id string The ID of the test suite to run
---@param callback? fun() Optional callback to execute after tests complete
---@return boolean? Returns true if async tests were started, nil otherwise
function Taneth:RunTestSuite(id, callback) end

---Run multiple test suites by their IDs.
---@param ids string[] Array of test suite IDs to run
---@param callback? fun() Optional callback to execute after all tests complete
---@return boolean? Returns true if async tests were started, nil otherwise
function Taneth:RunTestSuites(ids, callback) end

---Run all registered test suites.
---@param callback? fun() Optional callback to execute after all tests complete
---@return boolean? Returns true if async tests were started, nil otherwise
function Taneth:RunAll(callback) end

---Register a test suite. This is a callable table, so you can use `Taneth(id, callback)`.
---@param id string The unique identifier for the test suite
---@param callback fun() Function that defines the test suite using describe/it blocks
function Taneth(id, callback) end

---Define a test suite or nested test group.
---Can be nested to create hierarchical test organization.
---
---## Example
---```
---describe("My Test Suite", function()
---    it("runs a test", function()
---        assert.equals(1, 1)
---    end)
---    describe("Nested Suite", function()
---        it("runs a nested test", function()
---            assert.is_true(true)
---        end)
---    end)
---end)
---```
---@param label string The name/label for this test suite
---@param callback fun() Function containing test definitions
---@class TanethDescribe
describe = {}

---Callable function to define a test suite.
---@param label string The name/label for this test suite
---@param callback fun() Function containing test definitions
function describe(label, callback) end

---Skip a test suite. All tests within will be marked as pending.
---@param label string The name/label for this test suite
---@param callback fun() Function containing test definitions
function describe.skip(label, callback) end

---Define a test case.
---Tests will pass if they complete without errors or failed assertions.
---
---## Example
---```
---it("should pass", function()
---    assert.equals(1, 1)
---end)
---
---it("can be pending", function()
---    -- No callback means pending
---end)
---```
---@param label string The name/label for this test
---@param callback? fun() Optional function containing test code. If omitted, test is marked as pending.
---@class TanethIt
it = {}

---Callable function to define a test case.
---@param label string The name/label for this test
---@param callback? fun() Optional function containing test code. If omitted, test is marked as pending.
function it(label, callback) end

---Skip a test case. The test will be marked as pending.
---@param label string The name/label for this test
---@param callback? fun() Optional function (ignored)
function it.skip(label, callback) end

---Define an asynchronous test case.
---The test callback receives a `done` function that must be called to complete the test.
---
---## Example
---```
---it.async("async test", function(done)
---    SomeAsyncOperation(function()
---        assert.equals(1, 1)
---        done()
---    end)
---end)
---```
---@param label string The name/label for this test
---@param callback fun(done: fun(err?: string)) Function that receives a done callback
---@param timeout? number Optional timeout in milliseconds (default: 5000)
function it.async(label, callback, timeout) end

---Skip an asynchronous test case.
---@param label string The name/label for this test
---@param callback? fun() Optional function (ignored)
function it.async.skip(label, callback) end

---Mark the current test as pending.
---Calling this function will mark the test as skipped/pending.
function skip() end

---Assertion object providing various assertion methods.
---@class TanethAssert
assert = {}

---Assert that two values are equal using `==`.
---@param a any Expected value
---@param b any Actual value
function assert.equals(a, b) end

---Assert that two values are deeply equal (recursive table comparison).
---@param a any Expected value
---@param b any Actual value
function assert.same(a, b) end

---Assert that a value is exactly `true`.
---@param a any Value to check
function assert.is_true(a) end

---Assert that a value is exactly `false`.
---@param a any Value to check
function assert.is_false(a) end

---Assert that a value is `nil`.
---@param a any Value to check
function assert.is_nil(a) end

---Assert that a value is not `nil`.
---@param a any Value to check
function assert.is_not_nil(a) end

---Assert that two values are not equal using `~=`.
---@param a any Not expected value
---@param b any Actual value
function assert.are_not.equals(a, b) end

---Assert that a callback throws an error matching the expected error string.
---The error message is normalized (file path and stack trace removed) before comparison.
---@param expectedError string The expected error message (matched at the end)
---@param callback fun() Function that should throw an error
function assert.has_error(expectedError, callback) end

---Assert that a callback executes without errors and returns its return values.
---@param callback fun() Function that should not throw an error
---@return ... Return values from the callback
function assert.has_no_error(callback) end

---Force a test to fail with the given message.
---@param message string Failure message
function assert.fail(message) end

---Basic assertion function. Fails the test if condition is false.
---@param condition any Condition that should be truthy
---@param message? string Optional failure message
function assert(condition, message) end

