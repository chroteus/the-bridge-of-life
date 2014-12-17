-- Shortcuts
local player = game.player
local stats  = player.stats

local function msg(text, onFinish)
    MsgMgr.add(Msg(text, onFinish))
end

local function Dlg(text, choices)
    Dialogue(text, choices):show()
end

local function newNpc(arg)
    return NPC(arg):add()
end

local function imgNpc(part, img)
    local im = love.graphics.newImage("assets/images/"..part.."/"..img..".png")
    im:setFilter("nearest")
    
    return im
end

--------------------------------

local function generateLife()

local bully = newNpc{hair = imgNpc("hair", "brown"),
                     upper_body = imgNpc("upper_body", "jacket"),
                     lower_body = imgNpc("lower_body", "jeans")}

bully.onCollide = function()
    Dlg("School's bully swears at you.",
        {
            {"Hit him.", function()
            local r = math.random(2)
                if r == 1 then
                    player:loseHP(3)
                    msg "He hits you back so hard you bleed."
                    msg "You feel less confident."
                    player:changeStat("confidence", -2)
                    
                else
                    bully:loseHP(3)
                    msg "You hit him so hard, he starts bleeding."
                    msg "His friends are in awe."
                    msg "You feel more confident in yourself."
                    player:changeStat("confidence", 3)
                end
            end},

            {"Ask why he swears", function()
            msg "'Because you suck, man!'"
            msg "Everyone around him just laughs at you."
            msg "You feel less confident."
            game.player:changeStat("confidence", -1)
            end},
            
            {"Do nothing", function()
            msg "You pass by, acting like nothing happened."
            end}
        }
    )
end

------------------------------------------------------------------------

local crush = newNpc{hair = imgNpc("hair", "black"),
                  upper_body = imgNpc("upper_body", "white_shirt"),
                  lower_body = imgNpc("special", "red_skirt")}


local crush_confident_dlg = Dialogue("She seems interested in you.",
    {
        {"How about going to a cinema tomorrow?", function()
            if stats.confidence >= 6 then
                msg "'Sounds great!'"
                msg "........"
                msg "Years pass, you find yourself married to her."
                msg "She gave birth to 2 children."
                msg("You die of lung cancer at the age of 45.", function() game.finish() end)
            else   
                msg "'I don\'t want to.'"
                msg "'Later, maybe.'"
                msg "She didn't want to come with you."
                msg "You feel quite bad."
                player:changeStat("happiness", -3)
            end
        end},
    
        {"I have to go.", function()
            msg "Alright, see ya!"
        end}
    }
)
    
    
    
crush.onCollide = function()
    Dlg("You meet your crush while going back to your home.",
        {
            {"Greet her", function()
                if stats.confidence <= 4 then
                    msg "As you try to greet her, you feel nervous all of a sudden"
                    msg "Words are unable to come out of your mouth."
                    msg "Your crush looks at you weirdly."
                    msg "You slowly go away."
                    msg "You lose confidence."
                    game.player:changeStat("confidence", -1)
                else
                    msg "'Hello!' you say to your crush."
                    msg("'Oh, hello!', she says.", function() crush_confident_dlg:show() end)
                end
            end
            },
            
            {"Avoid her.", function()
                msg "You walk past her, feeling regretful that you didn't speak to her."
                player:changeStat("happiness", -1)
            end}
        }
    )
end
------------------------------------------------------------------------

local boss = newNpc{hair = imgNpc("hair", "brown"),
                    head = imgNpc("special", "moustache"),
                    upper_body = imgNpc("upper_body", "sweater"),
                    lower_body = imgNpc("lower_body", "suit_bottom")}

boss.onCollide = function()
    msg "You finally find a job."
    msg("However, your boss is not the best kind of boss.", function()
        Dlg("'Come on, work, don\'t be such a lazy piece of shit!'",
            {
                {"Fine...", function()
                    msg "You feel extremely angry, but do nothing."
                    player:changeStat("happiness", -2)
                end
                },
                
                {"Disregard him.", function()
                    msg("*cough* *cough*", function()
                        Dlg("",
                            {
                                {"Keep disregarding him.",
                                function()
                                    msg "'You're fired!!!'"
                                    msg "..."
                                    msg "After being fired, you quit the building."
                                    msg("While walking to your home, a bus "
                                        .."crashes into you, killing you.",
                                        function() game.finish() end)
                                end},
                                
                                {"'What?'",
                                function()
                                    msg "'Nothing. Keep working.'"
                                end
                                }
                                
                            }
                        )
                        end
                    )
                end
                }
            }
        )
    end)
end
--------
local poor_bully = newNpc{hair = bully.hair, head = bully.head}

local poor_bully_dlg2 = Dialogue("",
{
    {"Call ambulance.", function()
        msg "With ambulance came the police."
        msg("They arrest you.", function() game.finish() end)
    end},
    
    {"Leave him alone.", function()
        msg "You spit on his face and continue walking."
        player:changeStat("karma", -1)
    end}
})

local poor_bully_dlg = Dialogue("",
{
    {"None of your business.", function()
        msg "'What a rude fuck.'"
        msg "'I would kick your face in if I wasn't so hungry...'"
        msg "......"
        msg "'Fuck you.'"
    end},
    
    {"*beat him*", function()
       msg "'Owww!'"
       poor_bully:loseHP(5)
       msg("'Fuc-'", function() poor_bully_dlg2:show() end)
       player:changeStat("karma", -4)
    end},
    
    {"*give money*", function()
        msg "'Oh, thanks mate.'"
        msg "'Wait, I remember you.'"
        msg "..."
        msg "'Sorry for being such a jerk.'"
        player:changeStat("karma", 3)
    end}
})

poor_bully.onCollide = function()
    msg "You see your school bully, poor, begging for money."
   -- msg "'Heh, remember our fight, back at school? We were so silly.'"
    msg("'Who are you?' asks your old school bully.", function() poor_bully_dlg:show() end)
end

--------------------------------------

local old_crush = newNpc{head = crush.head, hair = crush.hair}
old_crush_insecure_dlg = Dialogue("",
{
    {"How rude!", function()
        msg "'Nah, I\'m just joking, hehe'"
        msg "'You\'re cute!'"
        msg "You feel extremely happy."
        player:changeStat("confidence", 2)
        player:changeStat("happiness", 2)
    end},
    
    {"*Try to hug her*", function()
        local r = math.random(1,2)
        
        if r == 1 then
            msg "You accidentally slip and drop her to the floor."
            msg "Unfortunately, her head hit a nail on the floor."
            old_crush:loseHP(10)
            player:changeStat("karma", -4)
            msg "........"
            msg("Police came and arrested you.", function() game.finish() end)
        else
            if stats.confidence >= 5 then
                msg "'Aww, I\'ve missed you as well.'"
                msg "You feel all nice and fuzzy inside."
                player:changeStat("happiness", 1)
            else
                msg "'Get away from me, you creep!'"
                msg "You feel betrayed."
                player:changeStat("confidence", -2)
                player:changeStat("happiness", -1)
            end
        end
    end}
})


old_crush.onCollide = function()
    msg "You see your school crush walking out of a store."
    
    if stats.confidence <= 4 then
        msg("As you approach her, she says: 'Oh, aren't you that weird guy?'",
            function() old_crush_insecure_dlg:show() end)
    else
        msg "'Oh, hello! I remember you. How are you doing?'"
        msg "'Fine.' you say."
        msg "'Nice to hear.'"
        msg "*hugs*"
        msg "...."
        msg "'You\'ve grown up to be such a handsome man!'"
        msg "(You feel like a macho.)"
        player:changeStat("confidence", 2)
    end
end
------------------------------------------------------------------------


local hacker = newNpc()

local hacker_dlg = Dialogue("",
{
    {"Go on.", function()
        player:changeStat("happiness", 10)
        player:changeStat("karma", -5)
        msg "'Take this pendrive and plug it into any computer in company.'"
        msg "You take the pendrive and later that day plug it in."
        msg "The next day, while going to work hacker approaches you."
        msg "He gives you a suitcase full of money."
        msg "'Good job' he says and leaves."
        msg "You continue working for a month as to not raise suspicions."
        msg("Later, you quit your job and live a great life in Bahamas until you die.",
            function() game.finish() end)
    end},
    
    {"Not interested", function()
        msg "'Your loss.'"
    end}
})
    
hacker.onCollide = function()
    msg "You see a shady-looking man looking at you nervously."
    msg "'Psst. I know you.'"
    msg "'The company you're working at has a major flaw in its system.'"
    msg "'A flaw that will let me transfer most of the money to my account'"
    msg("'Do something for me and I\'ll give you 30% of profits.'",
        function() hacker_dlg:show() end)
end
---------------

local dr = newNpc{upper_body = imgNpc("upper_body", "white_shirt")}

local dr_dlg_cont = function()
    local function death()
        msg("You die.", function() game.finish() end)
    end
    
    msg "........"
    msg "A month passes."
    if stats.karma == 5 then
        msg "A few friends of yours came to your deathbed."
        death()
    elseif stats.karma > 5 then
        msg "Lots of people came, their face full of sorrow."
        death()
    else
        msg "No one came."
        msg "It seems that everyone hates you."
        death()
    end
end

local dr_dlg = Dialogue("Your last wish?",
{
    {"Blackjack and hookers", function()
        msg "As you stroll through Vegas's streets, you become addicted to it."
        msg "You feel great."
        player:changeStat("happiness", 2)
        dr_dlg_cont()
    end},
    
    {"Donate all money to charity", function()
        msg "You donate all your money to charity."
        msg "Charity's spokesperson personally thanks you."
        player:changeStat("karma", 2)
        dr_dlg_cont()
    end}
})
        
dr.onCollide = function()
    msg "On your usual check-up, your doctor notices a tumor growing."
    msg("'You've got a month to live.' he says.", function() dr_dlg:show() end)
end

---- end of life
end

return generateLife   
    
