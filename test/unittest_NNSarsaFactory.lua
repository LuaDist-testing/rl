require 'rl'
local tester = torch.Tester()

local mdp = rl.TestMdp()
local discount_factor = 0.631
local TestNNSarsaFactory = {}
function TestNNSarsaFactory.test_get_control()
    local mdp_config = rl.MdpConfig(mdp, discount_factor)
    local lambda = 0.65
    local eps = 0.2437
    local explorer = rl.ConstExplorer(eps)
    local feature_extractor = rl.TestSAFE()
    local step_size = 0.92

    local nn_sarsa = rl.NNSarsa(
        mdp_config,
        lambda,
        explorer,
        feature_extractor,
        step_size)
    local factory = rl.NNSarsaFactory(
        mdp_config,
        lambda,
        explorer,
        feature_extractor,
        step_size)
    local nn_sarsa2 = factory:get_control()
    -- Not a clean way to prevent the q's from being initialized to different
    -- (random) parameters since they're neural network weights
    nn_sarsa2.q = nn_sarsa.q
    tester:assert(nn_sarsa2 == nn_sarsa)
end

tester:add(TestNNSarsaFactory)

tester:run()

