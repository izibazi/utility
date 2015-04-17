# irb

IRB.conf[:IRB_NAME] = 'home_irb'
IRB.conf[:SAVE_HISTORY] = 100
IRB.conf[:ECHO] = true
IRB.conf[:LOAD_MODULES] = ['pp']
IRB.conf[:PROMPT][:ishibashi] = {
	:PROMPT_I=>"%N(%m):%03n:%i> ", 
	:PROMPT_N=>"%N(%m):%03n:%i> ",
	:PROMPT_S=>"%N(%m):%03n:%i%l ",
	:PROMPT_C=>"%N(%m):%03n:%i* ",
	:RETURN=>"return => %s\n"
}
IRB.conf[:PROMPT_MODE] = :ishibashi
