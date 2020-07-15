<GLOBAL CHARACTERS-ENABLED T>

<CONSTANT BAD-ENDING "The adventure is over. You quest for glory ends here.">
<CONSTANT GOOD-ENDING "You are successful in your quest for glory! Congratulations!">

<OBJECT CURRENCY (DESC "doubloons")>
<OBJECT VEHICLE (DESC "ships")>

<CONSTANT INTERRUPT-KEY-CAPS !\D>
<CONSTANT INTERRUPT-KEY !\d>

<ROUTINE SPECIAL-INTERRUPT-ROUTINE (KEY)
	<COND (<EQUAL? .KEY INTERRUPT-KEY-CAPS INTERRUPT-KEY>
		<COND (<IN? ,HEALING-POTION ,PLAYER>
			<CRLF><CRLF>
			<TELL "Drink healing potion?">
			<COND (<YES?>
				<SETG ,LIFE-POINTS ,MAX-LIFE-POINTS>
				<REMOVE ,HEALING-POTION>
			)>
			<RTRUE>
		)>
	)>
	<RFALSE>>

<ROUTINE RESET-OBJECTS ()
	<PUTP ,LADY-OF-SHALOTT ,P?STARS 1>
	<PUTP ,SHIVERED-TIMBER ,P?STARS 2>
	<PUTP ,QUEENS-RANSOM ,P?STARS 3>
	<PUTP ,FAERIE-QUEEN ,P?STARS 3>
	<PUTP ,METEOR ,P?STARS 4>
	<PUTP ,OCTAVIUS ,P?STARS 4>
	<PUTP ,PROVIDENCE ,P?STARS 5>
	<PUTP ,CALYPSO ,P?STARS 5>
	<RETURN>>

<ROUTINE RESET-STORY ()
	<RESET-TEMP-LIST>
	<SETG USED-CHARMS-TO-FLOAT F>
	<PUTP ,STORY007 ,P?CODEWORD ,CODEWORD-DETRUDE>
	<PUT <GETP ,STORY012 ,P?DESTINATIONS> 3 ,STORY409>
	<PUT <GETP ,STORY136 ,P?DESTINATIONS> 2 ,STORY405>
	<PUT <GETP ,STORY164 ,P?DESTINATIONS> 5 ,STORY409>
	<PUT <GETP ,STORY177 ,P?DESTINATIONS> 2 ,STORY404>
	<PUT <GETP ,STORY202 ,P?DESTINATIONS> 5 ,STORY409>
	<PUTP ,STORY005 ,P?DEATH T>
	<PUTP ,STORY006 ,P?DEATH T>
	<PUTP ,STORY013 ,P?DEATH T>
	<PUTP ,STORY032 ,P?DEATH T>
	<PUTP ,STORY040 ,P?DEATH T>
	<PUTP ,STORY041 ,P?DEATH T>
	<PUTP ,STORY047 ,P?DEATH T>
	<PUTP ,STORY066 ,P?DEATH T>
	<PUTP ,STORY073 ,P?DEATH T>
	<PUTP ,STORY081 ,P?DEATH T>
	<PUTP ,STORY097 ,P?DEATH T>
	<PUTP ,STORY099 ,P?DEATH T>
	<PUTP ,STORY110 ,P?DEATH T>
	<PUTP ,STORY120 ,P?DEATH T>
	<PUTP ,STORY125 ,P?DEATH T>
	<PUTP ,STORY133 ,P?DEATH T>
	<PUTP ,STORY135 ,P?DEATH T>
	<PUTP ,STORY142 ,P?DEATH T>
	<PUTP ,STORY152 ,P?DEATH T>
	<PUTP ,STORY155 ,P?DEATH T>
	<PUTP ,STORY167 ,P?DEATH T>
	<PUTP ,STORY171 ,P?DEATH T>
	<PUTP ,STORY175 ,P?DEATH T>
	<PUTP ,STORY182 ,P?DEATH T>
	<PUTP ,STORY191 ,P?DEATH T>
	<PUTP ,STORY197 ,P?DEATH T>
	<PUTP ,STORY200 ,P?DEATH T>
	<PUTP ,STORY203 ,P?DEATH T>
	<PUTP ,STORY206 ,P?DEATH T>
	<PUTP ,STORY215 ,P?DEATH T>
	<PUTP ,STORY216 ,P?DEATH T>
	<PUTP ,STORY219 ,P?DEATH T>
	<PUTP ,STORY225 ,P?DEATH T>
	<PUTP ,STORY231 ,P?DEATH T>
	<PUTP ,STORY237 ,P?DEATH T>
	<PUTP ,STORY254 ,P?DEATH T>
	<RETURN>>

<CONSTANT DIED-IN-COMBAT "You died in combat">
<CONSTANT DIED-OF-HUNGER "You died of hunger and thirst">
<CONSTANT DIED-GREW-WEAKER "You grow weaker and eventually died">
<CONSTANT DIED-OF-THIRST "You go mad from thirst">
<CONSTANT DIED-EJADA-SORCERY "You have died from the Ejada's sorcery">

<ROUTINE DAMAGE-SHIP (DMG SURVIVED DESTROYED "AUX" STARS)
	<COND (,CURRENT-VEHICLE
		<CRLF>
		<HLIGHT ,H-BOLD>
		<TELL CT ,CURRENT-VEHICLE " suffers " N .DMG " damage" ,PERIOD-CR>
		<HLIGHT 0>
		<SET STARS <GETP ,CURRENT-VEHICLE ,P?STARS>>
		<SET STARS <- .STARS .DMG>>
		<COND (<L? .STARS 0> <SET .STARS 0>)>
		<PUTP ,CURRENT-VEHICLE ,P?STARS .STARS>
		<COND (<G? .STARS 0> <STORY-JUMP .SURVIVED>)>
		<STORY-JUMP .DESTROYED>
	)>
	<RETURN>>

<ROUTINE ADD-PROVISIONS ("OPT" AMOUNT "AUX" QUANTITY)
	<COND (<NOT .AMOUNT> <SET AMOUNT 1>)>
	<COND (<IN? ,PROVISIONS ,PLAYER>
		<SET QUANTITY <+ <GETP ,PROVISIONS ,P?QUANTITY> .AMOUNT>>
		<PUTP ,PROVISIONS ,P?QUANTITY .QUANTITY>
	)(ELSE
		<SET QUANTITY .AMOUNT>
		<PUTP ,PROVISIONS ,P?QUANTITY .QUANTITY>
		<TAKE-ITEM ,PROVISIONS>
	)>>

<ROUTINE CONSUME-PROVISIONS ("OPT" AMOUNT JUMP "AUX" QUANTITY RETURN-VALUE)
	<SET RETURN-VALUE F>
	<COND (<NOT .AMOUNT> <SET AMOUNT 1>)>
	<COND (<IN? ,PROVISIONS ,PLAYER>
		<SET QUANTITY <GETP ,PROVISIONS ,P?QUANTITY>>
		<COND (<G? .QUANTITY 0>
			<SET QUANTITY <- .QUANTITY .AMOUNT>>
			<PUTP ,PROVISIONS ,P?QUANTITY .QUANTITY>
			<COND (<G=? .QUANTITY 1>
				<HLIGHT ,H-BOLD>
				<TELL "[Your supply of provisions decreased by " N .AMOUNT "]" CR>
				<HLIGHT 0>
			)(ELSE
				<EMPHASIZE "[You've exhausted your supply of provisions]">
			)>
			<COND (.JUMP <STORY-JUMP .JUMP>)>
			<SET RETURN-VALUE T>
		)>
		<COND (<L? .QUANTITY 1> <REMOVE ,PROVISIONS>)>
	)>
	<RETURN .RETURN-VALUE>>

<ROUTINE TAKE-VESSEL (VESSEL)
	<COND (.VESSEL
		<COND (,CURRENT-VEHICLE <REMOVE ,CURRENT-VEHICLE>)>
		<MOVE .VESSEL ,VEHICLES>
		<SETG CURRENT-VEHICLE .VESSEL>
	)>>

<CONSTANT PROLOGUE-TEXT "\"Pirates!\" The roar of cannonfire thunders across the waves as word leaves the captain's lips. Hurtling out of the billowing plumes of smoke come a barrage of iron shells. Each is larger than a man's fist, and strikes with a force that splinters the oak beams of your ship and shatters men's skulls like eggs. The mainmast takes a direct hit and topples, crushing the sailors standing under it.||A grappling hook latches onto the rail. The pirates are getting ready to board you. Rushing to the side, you see their sinister vessel drawing alongside, black sails flapping in the breeze like a carrion-bird's wings. Her prow has the face of a medieval gargoyle. You read the name painted on her bows: the Belle Dame. But there is no look of beauty about her, nor hint of mercy on the faces of the eager brigands lining her rail.||A crewman standing beside you utters a groan of fear. \"It's Skarvench's ship.\"||\"Who's he?\" you ask, having to shout over the din of cannon shots and the pirates' battle-cries.||He stares at you as though you are a simpleton, and then remembers that this is your first voyage to the New World. \"The worst man that ever lived,\" is his blunt reply. And then the ships come together and the pirates are upon you.||Rushing headlong into the terrified crew, the pirates cleave a swathe of gory death across the ship's deck, their cutlasses rising and falling like scythes. You see the ship's officers fighting valiantly to defend the helm, but they are hopelessly outnumbered and soon butchered at their post. The fierce grins on the pirate's faces tell you that they expect easy pickings. You narrow your eyes as anger wells up inside you. You know that you will die today, but you feel no fear -- only a cold determination to sell your life dearly. Two pirates lunge at you. You duck the swing of the first, catch his arm and throw him against his crony. The sword intended for you ends up in a pirate's belly, and his knife comes up by reflex to slash at the man who has inadvertently impaled him.||\"Two down...\" You turn, and then for the first time you clap eyes on Skarvench himself. He stands astride the rail, grasping a grappling-line in one hand and a pistol in the other, whipping his sea-dogs into a killing frenzy with his evil laughter. His broad back and gangling limbs make him look like a massive crow. His beard is as long and lank as seaweed, and a single eye blazes beneath his bald brow -- the other is covered by a leather patch.||He is raising his pistol. You are rooted to the spot under his baleful stare. It can't be fear you're feeling surely...||\"Ah, matey,\" he says with a brown-toothed grin. \"Got to kill you again, 'ave I?\"||Again..? You have no time to ponder this enigma. In the next instant, he fires his pistol and your whole world goes black.||--||You sit up with a gasp, sweat soaking your clothes.||\"You've 'ad that dream again, eh?\"||You look around, memory trickling back as the dream recedes. The slow creaking of a ship's timbers, the unhurried heave of the waves... you are in the stuffy confines of the Belle Dame's bowels. Sailors snore fitfully around you, catching some sleep between chores. In the glimmer of an oil lamp sits Old Marshy, the ship's carpenter, whittling at a stick of wood. He glances across at you, shaking his head sadly. \"It was two years ago. Don't know why you can't stop 'aving the dreams.\"||\"Dreams? Nightmares!\" you say, mopping the sweat away. As you do, you feel the scar across your forehead where Skarvench's bullet struck you. A finger's breadth to the right -- one less tot of rum for Skarvench's breakfast that fateful morning! -- and your brains would have been blown out. As it is the bullet only grazed you, leaving the visible mark on your head and the scar of hatred deep in your heart.||Now that the nightmare has washed away, you recall the two years that have passed since that day. When you were first brought aboard the Belle Dame, Skarvench deemed you too insignificant to ransom and too close to death to be worth pressing into service. He would have cast you into the deep and never had a qualm -- that was the fate of most who survived the battle -- but Old Marshy undertook to nurse you back to health. You can well remember the weeks it took to get your strength back -- weeks experienced like glimpses in broken glass, because of fever. You remember Old Marshy holding the wooden spoons of gruel to your lips until his thin arms trembled with tiredness, urging you to eat. You remember the shouts of the pirates as they toiled in the rigging, and their drunken laughter under the stars at night. And most of all you remember Skarvench, looming through your thoughts like the embodiment of cruelty, striding the deck and waiting for you to die.||You did not die; thanks to Old Marshy you regained your strength. But death might have been better than the living hell you have had to endure these two years as an ordinary seaman aboard the cruellest ship to sail the Carab Sea. Skarvench metes out discipline as the whim takes him, revelling in the suffering of others; pain is his wine, and death his meat. Often you have had to stand by and watch a man whipped for the slightest mistake. Sometimes you have felt that whip yourself -- all to raucous laughter of Skarvench and his vicious pirate band.||\"All hands on deck!\" Hearing the command, you shake the other sailors awake and hurry up out of the dingy confines of the orlop deck into the blaze of daylight.||Skarvench stands on the poopdeck. The ox-like first mate, Porbuck gives you a shove and growls, \"You , get up in the rigging.\" As you climb, you glance out to sea. A small ship lies off the port bow and the Belle Dame is rapidly closing on her. You see a tall wooden crucifix standing amidships; she has no cannon. That is foolhardy. \"Go to sea on a prayer,\" as the adage goes, \"but take a keg of powder too.\"||You understand the reason for the other ship's lack of weaponry when you get a better view of the men lining her rail. They're all monks!||Skarvench's voice goes snarling across the water. \"Heave to or be blown out o' the water!\" he calls. \"We'll be takin' your treasure, holy or not!\"||\"We have no treasure,\" calls back one of the monks. \"We are poor brothers of the Saviour, travelling to the New World to spread His message to the heathen.\"||Skarvench smiles -- always a sign of his bad temper -- and says, \"Is that so? Well, I know of no place more heathen than the ocean bed.\" He leans on the poopdeck rail and calls to the master gunner: \"Mister Borograve, prepare to give 'em a broadside. I want their shaved heads sent forty fathoms deep, where heaven can't hear their mealy-mouthed prayers!\"||The monks know they cannot outrun the Belle Dame. As Borograve orders the cannons primed, they begin to sing a hymn. It is a glorious and peaceful sound that reminds you of the meadows and villages of your homeland. Most of the sailors pause in their duties, overcome by the melancholy beauty of the song. Even one or two of the pirates look uneasy at what they are about to do.||\"Prepare to fire,\" says Skarvench, keen as a hound at the scent of a kill.||\"No!\" A carpenter's hammer goes flying through the air and strikes Skarvench's head with a crack loud enough to carry up to where you sit in the rigging. Skarvench remains as steady as a rock, his hand flashing out with the startling speed to snatch the hammer out of the air as it falls. then he turns. His face is a mask of white fury. The fact that there is a stream of blood flowing from his temple only makes him look all the more terrible. His gaze bores along the deck and finds:||\"Mister Marsh! This your hammer, is it?\"||Old Marshy quails, his one jot of boldness used up. \"B-but, Cap'n... they're holy men! I don't think...||Skarvench tastes his own blood on his lip and savours it with his tongue. He gestures to a couple of pirates, and Old Marshy is seized and dragged up to the poopdeck. \"Lay his head on the rail there, lads,\" says Skarvench in a voice like honeyed venom. He raises the hammer. \"You're right, Mister Marsh; you don't think. That's the trouble with having nothin' in your brain-pan, see?\"||Far too late, you realise what Skarvench is going to do. You give a gasp and start down through the rigging. But even as you act, you know there is nothing you can do...||The hammer smashes down. It sounds like a wineflask breaking. The ordinary seamen look away in horror. The pirates grin gleefully like their captain, excited by the grisly sight. The corpse slumps to the deck.||\"God curse you, Skarvench,\" you mutter under your breath as you reach the foot of the mast. \"I'll see you dead for that.\"||\"You're not alone in wishing that,\" whispers a voice, \"but I'd stow such talk unless you want your own skull under the hammer next.\"||You look around to see three of the crew -- Grimes, Oakley and Blutz -- men who, like you, were taken off plundered ships and force to work for the pirates. \"We've a plan,\" continues Grimes in a low voice. \"If we stay aboard this devil ship our days are surely numbered, so tonight we plan to jump ship. We're scheduled to take the evening watch. We'll lower the jollyboat with a few supplies, then strike out towards Port Leshand.\"||\"Five hundred leagues of open ocean in a tiny boat like that!\" you gasp. \"It's near certain death.\"||\"Better than certain death, which is what we can expect here,\" mutters Oakley. \"Look, you've got a reputation of being a handy customer to have along in a tight spot. To be honest, we haven't got much of a chance without you. Now, are you with us?\"||You glare back up at the tall stooped figure on the poopdeck. He stamps to and fro, the brain-smeared hammer still in his hand, annoyed that the monks made their getaway while he was distracted by Old Marshy. You'll make him pay for his crimes one day, but you know the moment is not yet right.||You turn to Grimes and the others and give a swift nod. \"I'm with you.\"">

<CONSTANT TEXT-BLANK "This story point has not been written yet.">

<ROOM PROLOGUE
	(IN ROOMS)
	(DESC "PROLOGUE")
	(STORY PROLOGUE-TEXT)
	(CONTINUE STORY001)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT001 "You know that you will need supplies to have any chance of survival on the open sea. It means taking a big risk, since you will have to go right past the officers' cabins, but there is no help for it. While your comrades keep a nervous vigil, fearing discovery at any moment, you creep aft and descend below decks. The only light in the passage is the glow of an oil-lamp shining from the half-open door of Skarvench's cabin. As you skulk forward through the shadows, you hear the voice of the pirate captain raised in typically drunken bluster:||\"What, my merry lads, is the easiest route to fortune, would you say?\"||\"Why, piracy, Cap'n,\" you hear one of the men answer hurriedly.||\"Aye, piracy, right enough,\"roars Skarvench. \"but what's the most profitable form of piracy, I'm askin' you? Why, 'tis kidnap and ransom, that's what. There's no cargo takes up so little space nor fetches so high a price as live human baggage -- so long as you choose the right person. Even you daft lubbers must've heard how Toliver Crimp earned himself a thousand doubloons last summer when he ransomed the Viceroy's nephew -- \"||\"A thousand doubloons!\" cry the pirates in unison.||\"A spit in the ocean compared to what I've got planned! I'll be earning us a king's ransom -- or a queen's ransom, rather, if you wants to split hairs on it -- when I capture the best prize of all. I'm talking about that pretty young Queen Titania of Glorianne, my hearties, who'll soon be sailing here on a tour of the colonies!\"||You were just tiptoeing past the door, glad of Skarvench's ranting as it kept you from being overheard, but this news roots you to the spot. Can Skarvench really mean to set his sights so high? The kidnapping of a monarch is surely beyond the limits of even his voracious ambition. Everyone knows that the Queen Titania is well guarded by her loyal admiral, Lord Calidor, whose naval tactics have sent many a foe to the sea's bottom. And no trickery or poison can prevail against her while she is protected by her wizardly counsellor, Dr. Wild. Skarvench's plan seems impossible, and yet you have suffered enough harsh experience of the man aboard his ship to know that , although unmatched for cruelty and greed, he is nobody's fool. He must really think he has a chance of carrying off the Queen!||You glance across the passage to the sailmaster's cabin. No light shows under the door. The sailmaster must still be in the gallery with  most of the other pirates. Now is your chance to sneak into the empty cabin and gather a few items for your voyage -- and God knows, your comrades must be getting anxious for you to return. At any moment one of the pirates might go up on deck and your bid for freedom would be discovered. But Skarvench is still boasting of his madcap scheme, and despite your best instincts you feel compelled to eavesdrop further.">
<CONSTANT CHOICES001 <LTABLE "stay where you are and listen to what Skarvench says" "look in the sailmaster's cabin for supplies" "decide to hurry straight up on the deck">>

<ROOM STORY001
	(IN ROOMS)
	(DESC "001")
	(STORY TEXT001)
	(CHOICES CHOICES001)
	(DESTINATIONS <LTABLE STORY020 STORY039 STORY172>)
	(TYPES THREE-NONES)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT002 "Your chosen course takes you through raging storm-tossed seas where high waves constantly threaten to swamp the little jollyboat. There is no respite from bailing out the puddle of sea water that fills the bottom of the hull. From dawn to dusk the sky is darker than granite and your rare glimpses of the sun are greeted by groans of bleak dismay, for it only reminds you how cold you are. Frequent thunderstorms rattle behind the clouds, casting the corpselight glare of lightning across your terrified faces. And through it all an icy rain lashes down, hard as needles, numbing your weary limbs.">

<ROOM STORY002
	(IN ROOMS)
	(DESC "002")
	(STORY TEXT002)
	(PRECHOICE STORY002-PRECHOICE)
	(CONTINUE STORY222)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY002-PRECHOICE ()
	<COND (<CHECK-SKILL ,SKILL-WILDERNESS-LORE> <STORY-JUMP ,STORY421>)>>

<CONSTANT TEXT003 "You make a valiant attempt to break through the encircling throng of natives, but to no avail. As two of them seize your arms, a third brings his wooden club crashing down on your skull. A blaze of painful white light is followed by darkness and oblivion. If you awaken at all, it will be to find yourself simmering in the cookpot of these fearsome cannibals.||Your adventure is at an end.">

<ROOM STORY003
	(IN ROOMS)
	(DESC "003")
	(STORY TEXT003)
	(DEATH T)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT004 "Hidden among the lush ferns of the jungle, you watch as Skarvench locates a mark carved on the trunk of a tall tree and then paces off towards a clearing. Pointing to the ground, he directs the two sailors to start digging while he and his officers rest in the shade with a bottle of grog.||\"Looks like he's come here to collect his buried loot,\" muses Blutz.||\"I wonder why,\" whispers Oakley. \"I mean, it's not like he needs extra cash, is it? I'd give anything to be a fly on his face right now and hear what they're talking about.\"||\"A fly?\" snorts Grimes. \"I'd sooner be a hornet and sting the cur!\"">
<CONSTANT CHOICES004 <LTABLE "risk sneaking closer to listen in on what they're saying" "stay hidden until they have collected the treasure and sailed away">>

<ROOM STORY004
	(IN ROOMS)
	(DESC "004")
	(STORY TEXT004)
	(CHOICES CHOICES004)
	(DESTINATIONS <LTABLE STORY042 STORY288>)
	(TYPES TWO-NONES)
	(PRECHOICE STORY004-PRECHOICE)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY004-PRECHOICE ()
	<COND (<CHECK-SKILL ,SKILL-SPELLS> <STORY-JUMP ,STORY061>)>>

<CONSTANT TEXT005 "Ejada responds with a cry of rage and sorcerous gesture. Immediately a hail of red-hot stones pour down out of the sky to pelt you as you flee. \"Craven mortals, \" she thunders. \"I gave you the chance to leave with honour, but you spurned my kindness. Now suffer the consequences.\"||\"Kindness, she calls it?\" gasps Blutz as he struggles to keep up through the battering rain of stones. \"She's killing us with her kindness!">

<ROOM STORY005
	(IN ROOMS)
	(DESC "005")
	(STORY TEXT005)
	(PRECHOICE STORY005-PRECHOICE)
	(CONTINUE STORY195)
	(DEATH T)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY005-PRECHOICE ("AUX" (DMG 6))
	<COND (<CHECK-SKILL ,SKILL-CHARMS> <SET DMG <- .DMG 2>>)>
	<COND (<IN? ,FEATHER-SHIELD ,PLAYER> <SET DMG <- .DMG 2>>)>
	<LOSE-LIFE .DMG DIED-EJADA-SORCERY ,STORY005>>

<CONSTANT TEXT006 "All the pent-up emotion of your crew explodes in an excited roar as they go leaping onto the deck of the enemy ship with you at their head. The pirates stand ready to meet your boarding party, but the pounding they took from your guns has sapped their morale and the battle seems a forgone conclusion. Gunshots crack deafeningly all around you, and you are half blinded by the thick clouds of smoke and sprays of blood, but you charge right into the thick of the fray with a cry of, \"Have at them, lads!\"">
<CONSTANT TEXT006-CONTINUED "You ignore the wound you have taken. The battle rages back and forth across the deck. Pirates come running at you but you dash them aside. Your only thought now is to find your foe and slay him yourself; you do not want him to have the mercy of a stray bullet.||The instant you catch sight of him, you realise your anxiety was misplaced. The bullets go whistling around his ears, but he stands there oblivious of danger, arms spread out and laughing like a fiend from the pit. You begin to wonder if he can be killed -- or are his hate and madness stronger than death itself?||His single eye fixes on you through the haze of gunsmoke. \"Ah, matey,\" he says. \"Come to see your old cap'n one last time, eh?\"">

<ROOM STORY006
	(IN ROOMS)
	(DESC "006")
	(STORY TEXT006)
	(EVENTS STORY006-EVENTS)
	(PRECHOICE STORY006-PRECHOICE)
	(CONTINUE STORY089)
	(DEATH T)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY006-EVENTS ()
	<PUTP ,STORY006 ,P?DEATH T>>

<ROUTINE STORY006-PRECHOICE ()
	<TELL "A bullet tears into your leg. ">
	<COND (<IS-ALIVE 1>
		<SETG ,LIFE-POINTS <- ,LIFE-POINTS 1>>
		<PUTP ,STORY006 ,P?DEATH F>
		<TELL TEXT006-CONTINUED>
		<CRLF>
	)(ELSE
		<CRLF>
		<LOSE-LIFE 1 "You died from the bullet wound" ,STORY006>
	)>>

<GLOBAL USED-CHARMS-TO-FLOAT F>

<CONSTANT TEXT007 "It is impossible to prevent it from leaking. Already dangerously low in the water, it now requires two people to bail constantly.">

<ROOM STORY007
	(IN ROOMS)
	(DESC "007")
	(STORY TEXT007)
	(EVENTS STORY007-EVENTS)
	(CODEWORD CODEWORD-DETRUDE)
	(CONTINUE STORY026)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY007-EVENTS ()
	<COND (,USED-CHARMS-TO-FLOAT
		<RETURN ,STORY026>
	)>
	<COND (<CHECK-SKILL ,SKILL-CHARMS>
		<PUTP ,STORY007 ,P?CODEWORD NONE>
	)(ELSE
		<PUTP ,STORY007 ,P?CODEWORD CODEWORD-DETRUDE>
	)>
	<RETURN ,STORY007>>

<CONSTANT TEXT008 "\"Never heard of the place!\" cries Mandrigard, spilling ruby wine across his gold and gems as he brings the goblet banging down hard on the tabletop.||\"Never heard of it?\" you repeat incredulously. \"Why, man, it's the richest and biggest port of all the Gloriannic colonies.\"||He snorts indifferently. \"It means nothing. I have sailed the world's waters longer than such places have had a name. And though it grieves me to say it, I'm resigned to sailing on long after those ports have sunk into the sea.\"">
<CONSTANT CHOICES008 <LTABLE "ask him to tell you more" "explore the rest of the ship">>

<ROOM STORY008
	(IN ROOMS)
	(DESC "008")
	(STORY TEXT008)
	(CHOICES CHOICES008)
	(DESTINATIONS <LTABLE STORY046 STORY065>)
	(TYPES TWO-NONES)
	(FLAGS LIGHTBIT)>

<ROOM STORY009
	(IN ROOMS)
	(DESC "009")
	(EVENTS STORY009-EVENTS)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY009-EVENTS ()
	<COND (<CHECK-CODEWORD ,CODEWORD-CHANCERY>
		<RETURN ,STORY406>
	)>
	<RETURN ,STORY423>>

<CONSTANT TEXT010 "Half fainting from exhaustion, you stand on teetering legs and raise your wand to the sky, then softly speak the words of the spell. Over and over, like a child's nursery rhyme, your lilting chant carries across the flat calm of the sea.||At first hopeful, the others wait tensely for several minutes, finally giving sighs of despondency. They slump to the bottom of the boat, their postures showing they have lost all hope now. You abandon the spell and crouch down beside them. You left it too late. Your resolve was too weakened by hardship, your willpower too drained, for you to muster your magic.||Splot! -- a loud wet slap as a damp spot appears on the dry grey timbers of the boat. Then another, and another. One strikes your face and you cry out in sheer joy. It is pure fresh rainwater! As it falls in a steady shower, the four of you lie sprawled in the bottom of the boat with your mouths wide open, giggling like lunatics.||You are still lying there an hour later, by now soaked in drizzle, when a shadow looms against the sky and a voice calls down to you: \"Ahoy there! We're throwing down a rope.\"||All four of you sit bolt upright. A ship has come right up alongside -- The Jewel of Heaven -- and you never even noticed the crew hailing you over the noise of your own merry laughter. \"Why, this is a glad day!\" says Oakley as you climb up the rope. \"First a good drink of water, and now a ride home into the bargain!\"">

<ROOM STORY010
	(IN ROOMS)
	(DESC "010")
	(STORY TEXT010)
	(CONTINUE STORY370)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT011 "\"I see,\" he says soberly when you have told him all you know. He sets his cup aside and goes to make sure no-one is listening at the cabin door. Returning, he drops his voice and says, \"Keep this to yourselves. It may well be that we shall yet foil Skarvench's scheme, but we'll have no hope of catching him if word gets out that we're forewarned. Listen now: once you are settle in Leshand, come to my house on Halyard Street. Ask for Master Capstick -- that's me. There we'll make our plans to catch that sea rat.\"">

<ROOM STORY011
	(IN ROOMS)
	(DESC "011")
	(STORY TEXT011)
	(CONTINUE STORY108)
	(CODEWORD CODEWORD-MARATHON)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT012 "You make your way along the dockside, threading between the cars and bales and bustling sailors, until you come to a doorway under a painted sign showing a coil of rope and a ship's barrel. This is the shop of Gallowglass, a chandler and general trader from you have often bought supplies in the past. Catching sight of you through the open doorway, he beckons you inside. \"Ashore again, eh?\" he says jovially. \"But not for long, I'll be bound. What can I do for you?\" He shows you his wares.">
<CONSTANT TEXT012-CONTINUED "As he turns to serve another customer, Gallowglass adds, \"You won't be staying in port for the Queen's visit, then?\"||\"When is she due to arrive?\" asks Grimes.||Gallowglass smiles and shrugs. \"A month or so. She's touring the colonies, I hear. Everyone's been told to stay on best behaviour or they must answer to the governor. Perhaps that's why I haven't sold half my usual turnover of gunpowder this week.\"||Leaving the chandler's you consider your next move.">

<CONSTANT CHOICES012 <LTABLE "find someone to identify any unusual items you've come across" "listen for rumours" "apply for a letter of marque" "pay a visit to Master Capstick" "you have now completed all your business in Leshand">>

<ROOM STORY012
	(IN ROOMS)
	(DESC "012")
	(STORY TEXT012)
	(CHOICES CHOICES012)
	(DESTINATIONS <LTABLE STORY031 STORY088 STORY409 STORY069 STORY107>)
	(REQUIREMENTS <LTABLE NONE NONE NONE <LTABLE CODEWORD-MARATHON> NONE>)
	(TYPES <LTABLE R-NONE R-NONE R-NONE R-CODEWORD R-NONE>)
	(PRECHOICE STORY012-PRECHOICE)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY012-PRECHOICE ()
	<COND (,RUN-ONCE
		<MERCHANT <LTABLE CRUCIFIX PISTOL SWORD COMPASS PARROT> <LTABLE 8 10 10 10 2>>
	)>
	<CRLF>
	<TELL TEXT012-CONTINUED>
	<TELL ,PERIOD-CR>
	<COND (<CHECK-SKILL ,SKILL-ROGUERY>
		<PUT <GETP ,STORY012 ,P?DESTINATIONS> 3 ,STORY050>
	)(ELSE
		<PUT <GETP ,STORY012 ,P?DESTINATIONS> 3 ,STORY409>
	)>>

<CONSTANT TEXT013 "These men have cut-throat skills honed in a hundred desperate backstreet fights. They wield their knives with the precision of trained surgeons -- except that each finely judged cut is intended to cause death, not avert it.">

<ROOM STORY013
	(IN ROOMS)
	(DESC "013")
	(STORY TEXT013)
	(PRECHOICE STORY013-PRECHOICE)
	(CONTINUE STORY070)
	(DEATH T)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY013-PRECHOICE ("AUX" (DMG 6))
	<COND (<OR <CHECK-SKILL ,SKILL-MARKSMANSHIP> <CHECK-SKILL ,SKILL-SWORDPLAY>>
		<SET DMG 2>
	)(<CHECK-SKILL ,SKILL-BRAWLING>
		<SET DMG 3>
	)>
	<LOSE-LIFE .DMG DIED-IN-COMBAT ,STORY013>>

<CONSTANT TEXT014 "A look of thunder flickers behind Skarvench's eye. \"Still alive, eh? Come and drink with your old cap'n!\" He waves the rum bottle as if inviting you to take it, but you'd sooner put your hand in a wolf's mouth.||Blutz's blood is up at the sight of your hated foe. \"God rot your one eye, villain!\" he screams. \"I'd like to take that bottle and --\"||There is a crash of breaking wood and Blutz falls with a groan. Glancing to one side, you see he has been hit over the head with a stool. Curshaw stands there grinning, then puts his boot into the unconscious Blutz's ribs. He drops the broken leg of the stool beside him.||Oakley and Grimes stand face to face with the closing circle of Skarvench's men. You whirl to face the pirate captain himself. \"Enough, Skarvench; your quarrel's with me, not them.\"||He crows with laughter. \"Ah, that's a right noble sentiment and no mistake! See here, though: my quarrel's with all who'd try'n scupper my plans. I'm aimin' to bag me a queen, no less, an' then sell her to the highest bidder. So I'm goin' to have to do away with you, mate -- which I should've done long ago, but I guess my old heart's just too soft.\"||His hand goes to his belt. You realise he's reaching for a weapon, and your own fingers close instinctively on something on the table beside you. You raise it, and Skarvench gives a screech of laughter. You're holding only a corkscrew. He has a musket. \"I'll be the wealthiest man on the seven seas,\" he boasts. \"And he who would that wealth deny, down among the dead men let him lie!\"||There is a flash as he fires. Smoke fills the air and the musket-ball thuds into your chest. You feel an instant of searing pain, then everything goes black.">

<ROOM STORY014
	(IN ROOMS)
	(DESC "014")
	(STORY TEXT014)
	(CONTINUE STORY362)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT015 "Raising your arms to the heavens, you commence the incantation. At first the apparent gibberish coming from your lips gives your three companions cause to smile. But the smiles soon fade, to be replaced by wide-eyed awe, when they see black storm clouds piling up against the eastern sky at your command. The faint glow of sunrise is drowned in fresh darkness. Thunder cracks from far off like distant cannon-fire, sending a dull and ominous rumble across the world.||A breeze ruffles your clothes. Finishing the spell, you glance down to see your friends crouching in the bottom of the jollyboat, faces drained of colour. \"Do not be afraid,\" you tell them. \"The full force of the storm will not reach us here. I have placed it athwart the Belle Dame's bows, and she'll have to run with the wind till it blows itself out. Skarvench will have a hard time following us now.\"||A blossom of lightning flares beyond the sooty haze of the storm clouds. If only you felt as confident as you are trying to sound. But you know that such titanic elemental forces cannot be conjured lightly and indeed, even as you lower your wand, it explodes in a shower of crackling blue sparks!">

<ROOM STORY015
	(IN ROOMS)
	(DESC "015")
	(STORY TEXT015)
	(PRECHOICE STORY015-PRECHOICE)
	(CONTINUE STORY289)
	(CODEWORD CODEWORD-PROSPERO)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY015-PRECHOICE ()
	<LOSE-ITEM ,MAGIC-WAND>>

<CONSTANT TEXT016 "You sail back into Selenice harbour with a hold full of treasure and hearts full of confidence. News of your fortune spreads rapidly, bringing the master shipwright himself hurrying down to the quay to greet you.||\"Come aboard, Master Kemp,\" you say, heartily pumping his hand as he steps off the gangplank. \"We've found rich pickings on our travels. Perhaps now you can sell us a ship more suited to our needs?\" With that, you throw open the hold covers with a theatrical flourish.||The sunlight reflects off your haul in patterns of gold, silver and ruby-red across Kemp's face. He looks up with as broad a smile as a mouth could manage and says, \"Why, captain. I have the very ship for you moored just along the quay.\"||You turn to look where he is pointing, a gasp of admiration escaping your lips as you do. The ship is a proud tall-masted galleon with sixty cannon bristling along her gunwales. Her figurehead is a painted oak mermaid of almost supernatural beauty. \"The Faerie Queen,\" says Blutz, reading the name emblazoned on the prow. \"I think I'm in love.\"||\"That's the one for us,\" you concur. \"Master Kemp, you keep the sloop and the loot here in the hold. We'll have the Faerie Queen.\"||Kemp nods, stunned at having made the quickest sale of his life, while you stride down the gangplank and along the quay to take command of your new vessel.">

<ROOM STORY016
	(IN ROOMS)
	(DESC "016")
	(STORY TEXT016)
	(PRECHOICE STORY016-PRECHOICE)
	(CONTINUE STORY184)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY016-PRECHOICE ()
	<TAKE-VESSEL ,FAERIE-QUEEN>>

<CONSTANT TEXT017 "You agree it is senseless to try steering out of the bay in thick fog. The anchor is dropped, but as you turn to go below you are met by a deputation of crewmen. Their spokesman is the bo'sun - a great thickset man with a head like a cannonball, he stands before you twisting his cap in his hand with the nervousness of a small child. \"The thing is, Cap'n\" he says with many a glance to left and right, \"this looks a dire place to lie becalmed, an' now with this fog comin' in... Well, it's given some o' the men the jibbers, an' we was wonderin' -- with your reputation for magic an' that -- if you couldn't lay a charm to keep the ship safe from hobgoblins an' such?\"||\"A simple enough request, bo'sun, and one I'm glad to grant if it will help the men's morale.\"Taking your amulet in hand, you recite a benediction that renders the ship inviolate against any assault by evil spirits or creatures of the night. Acknowledging the crew's thankful looks with a bland smile, you go down to your cabin and turn in. The night passes uneventfully.">

<ROOM STORY017
	(IN ROOMS)
	(DESC "017")
	(STORY TEXT017)
	(CONTINUE STORY396)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT018 "Sudden rain thunders down onto the deck, and a moment later you are hit by a wind that strains the sails to the verge of snapping. The sky above looks like molten tar, and lightning drops in dazzling splinters through the darkness. Drawing the fan from your sleeve, you rush forward and sweep it hard. There are mutterings of superstitious awe from the sailors as the storm abates. You can still see the titanic waves crashing down off your bows, but it seems that the fan forms a funnel through the storm -- a funnel through which you can steer your ship.||\"Helmsman!\" you shout. \"Dead ahead: take us into the eye of the storm.\" The thundercloud fan vanishes from your hand now that its power is used up -- but it has served its purpose.">

<ROOM STORY018
	(IN ROOMS)
	(DESC "018")
	(STORY TEXT018)
	(PRECHOICE NONE)
	(CONTINUE STORY094)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY018-PRECHOICE ()
	<LOSE-ITEM ,THUNDERCLOUD-FAN>>

<CONSTANT TEXT019 "Smoke-hazed flashes blister among the gunwales of the Moon Dog, followed by a sound like thunder that rolls across the water. Cannonballs crack against the timbers of your vessel. There is a cry of alarm as the mizzenmast splits, and you have to dodge to one side as the rigging comes crashing down. At least one of your crew is not so fortunate: you see him swept overboard by the broken boom as it falls.">

<ROOM STORY019
	(IN ROOMS)
	(DESC "019")
	(STORY TEXT019)
	(PRECHOICE STORY019-PRECHOICE)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY019-PRECHOICE ()
	<DAMAGE-SHIP 2 ,STORY006 ,STORY227>>

<CONSTANT TEXT020 "There is a murmur of amazement from the pirates in Skarvench's cabin. Then you hear a voice which you recognize as Curshaw, the weaselly quartermaster: \"But how, Cap'n? Them Gloriannes know the sea like as to porpoises. They'd blow us out of the water before we got within a league of the Queen's flagship.\"||Crouching outside in the darkened passage, you nod to yourself. That's the question you'd have liked to ask.||There is a pause. You picture Skarvench giving one of his secretive smiles as he takes a pinch of snuff. Sure enough, there comes a satisfied sneeze and then his crowing voice is heard again: \"Never you mind the details, Mister. Thats for your old captain to sort out, ain't it? Suffice to say that there's a shipwright in Port Selenice who's being well paid for his work.\"||\"But, Cap'n\" you hear the ox-like first mate, Porbuck protesting, \"we've always stuck by all your plans, but this surely can't be feasible. Won't Queen Titania be heavily guarded? It'd be our one ship against a dozen!\"||Precisely what you were thinking.">
<CONSTANT CHOICES020 <LTABLE "wait and hear Skarvench's reply" "rejoin your friends" "risk taking the time to snatch some supplies from the sailmaster's cabin">>

<ROOM STORY020
	(IN ROOMS)
	(DESC "020")
	(STORY TEXT020)
	(CHOICES CHOICES020)
	(DESTINATIONS <LTABLE STORY077 STORY172 STORY039>)
	(TYPES THREE-NONES)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT021 "Having sailed these waters often as an honest merchant before he was press-ganged into service on the Belle Dame, Oakley relates what he knows of the islands:||\"Pandanus Island, the westernmost in the chain, has often been visited by ships,\" he says. \"The natives there are friendly enough. The next, known as Grimoire Island, is a mystery except I've heard the natives shun it out of fear for a hellish demon that lives there. Foolishness, of course. Next in the chain is Firepeak Island, which gets its name from the immense cone of a smouldering volcano that dominates its hinterland. I never met a man who went ashore there --\"||But what about the easternmost island?\" asks Blutz. \"That's the first one we'll come to.\"||Oakley shrugs. \"Red Skull Island. I've heard that too is inhabited, but it lies clear of the main shipping route and so the natives can have little contact with the outside world.\"">

<ROOM STORY021
	(IN ROOMS)
	(DESC "021")
	(STORY TEXT021)
	(PRECHOICE STORY021-PRECHOICE)
	(CONTINUE STORY097)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY021-PRECHOICE ()
	<COND (<CHECK-SKILL ,SKILL-FOLKLORE> <STORY-JUMP ,STORY058>)>>

<CONSTANT TEXT022 "Overawed by what they have witnessed of your power, the cannibals are afraid to attack. Instead they come forward and drop to their knees, bowing to you as though in heathen prayer.||\"Blow me!\" says Oakley. \"They think you're some kind o' demigod, mate.\"||\"It seems they do.\"||Milking the situation for all it's worth, you raise your voice to an angry shout and rail at the cannibals, cursing them for daring to try and harm you. Although they cannot understand your words, the meaning is clear enough. Quailing, they scurry off and return with gifts, strewing these before you on the sand in the hopes of assuaging your wrath.||You are offered a feather shield, an obsidian necklace, and a shark's tooth sword, which is a blade of hard wood studded with shark's teeth that serves as well as any steel sword. Take whatever you want.">

<ROOM STORY022
	(IN ROOMS)
	(DESC "022")
	(STORY TEXT022)
	(PRECHOICE STORY022-PRECHOICE)
	(CONTINUE STORY098)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY022-PRECHOICE ()
	<SELECT-FROM-LIST <LTABLE FEATHER-SHIELD OBSIDIAN-NECKLACE SHARKS-TOOTH-SWORD> 3 1>>

<CONSTANT TEXT023 "Who can say how long the carnage lasts? Amid explosive gunshots, hoarse yells and the clang of steel blades, your ragged but valiant band struggle to the death against Skarvench and his murderous henchmen.||Eventually the battle shrinks to just you and Skarvench. Crouching behind his cutlass, he weaves and lunges and parries -- cocksure and vicious at first, his sneering smile only gradually fading as he realises you are the better fighter. Then his taunts turn to weary gasps as he struggles desperately to defend himself.||You are exhausted too. You gulp at the air like a drowning man, each swing plumbing the last dregs of your strength. But at last the red rage fades. You r enemy lies dying at your feet. Looking up at you the evil light fades from his eyes, he musters a mad grin and shrieks with laughter. \"So that's your victory, is it mate?\" A bitter triumph, I'd say!\"||You look around, and now you see what he means. The forest floor is like a scene from a slaughterhouse, your friends lying dead along with the pirates. You stagger, sick at heart. You wanted revenge, but not at this high price.||Skarvench gives a last laugh. \"See you in hell,\" he croaks.||He is dead.">

<ROOM STORY023
	(IN ROOMS)
	(DESC "023")
	(STORY TEXT023)
	(DEATH T)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT024 "The warship's captain comes aboard with a party of heavily armed marines. He casts a pebble-eyed glance at the assorted rogues of your ship's company, then turns to address you. \"I take it you are the captain of this rabble. I put it to you that your business on the high seas is nothing but common piracy and, this being so, I hereby take charge of your vessel in the name of Her Majesty the Queen.\"">

<ROOM STORY024
	(IN ROOMS)
	(DESC "024")
	(STORY TEXT024)
	(PRECHOICE STORY024-PRECHOICE)
	(CONTINUE STORY111)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY024-PRECHOICE ()
	<COND (<IN? ,LETTER-OF-MARQUE ,PLAYER> <STORY-JUMP ,STORY092>)>>

<CONSTANT TEXT025 "With a groan of protesting timbers, your ship lurches to a dead halt as her prow smashes into the Moon Dog's side. Your sailors cast grappling-hooks, catching the other ship's rail and pulling them together for the final battle.">

<ROOM STORY025
	(IN ROOMS)
	(DESC "025")
	(STORY TEXT025)
	(PRECHOICE STORY025-PRECHOICE)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY025-PRECHOICE ()
	<DAMAGE-SHIP 1 ,STORY006 ,STORY227>>

<CONSTANT TEXT026 "Despite all hardships, you can at least console yourselves with that fact that you are making good headway. The same gales that threaten to swamp your boat are also driving you swiftly westwards.||\"It's a race against time,\" says Oakley with a sour grin, his hair plastered down against his white face by the unceasing rain. \"Will we get out of this before our food or our strength runs out?\"||\"Our our luck,\" mutters Grimes.||\"Stop it!\" screeches Blutz. \"I can't stand it much longer, stuck out here on this tiny boat and the endless ocean around and beneath us waiting to swallow us up.\"||\"Aye!\" says Oakley. He slaps the timbers of the boat. \"That's all we have keeping us from a watery grave, mates. Barely more wood in her than a coffin lid... \" His eyes blaze feverishly and he gives a sudden wild laugh. \"So let's christen her, then: to the good ship Coffin Lid and all who sail in her, whether it be to Leshand harbour -- or straight down to hell!\"||Blutz turns away, and suddenly his eyes start with fright. He is staring at something over your shoulder, in the water off to starboard. You turn slowly, following his gaze, and see something that makes your heart miss a beat. For there swims a sea maiden, with pearl-white skin and hair the colour of coral, whose beauty and silent haunted look seem as terrible as the ocean depths.">

<ROOM STORY026
	(IN ROOMS)
	(DESC "026")
	(STORY TEXT026)
	(PRECHOICE STORY026-PRECHOICE)
	(CONTINUE STORY064)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY026-PRECHOICE ()
	<COND (<CHECK-SKILL ,SKILL-FOLKLORE> <STORY-JUMP ,STORY045>)>>

<CONSTANT TEXT027 "He sheds a single tear, which falls like a liquid pearl from the long beak of his nose to splatter on the gold coins strewn about his feat. \"My crew! My loyal lambs! Where are they now?\" He takes a long draught of wine from the seemingly inexhaustible supply in his goblet. \"Thirty-six of them came away with me from Hecuba Island, and all shared my curse. Yet one by one they slipped away. How, I'll never know -- for the curse was that we'd never make landfall, nor could we leave the ship. They broke the curse somehow, but they left their old captain behind along with the loot. God curse them for that, say I, and I'll drink to their ill health!\"||He gulps more wine, reeling now and plunging his head close to the table.">
<CONSTANT CHOICES027 <LTABLE "take advantage of his drunkenness to go poking around the ship" "rouse him with further questions">>

<ROOM STORY027
	(IN ROOMS)
	(DESC "027")
	(STORY TEXT027)
	(CHOICES CHOICES027)
	(DESTINATIONS <LTABLE STORY065 STORY046>)
	(TYPES TWO-NONES)
	(EVENTS NONE)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT028 "There is a sweet smell in the air which you notice as you tie up the boat. Could it be honey? Unlikely, you think, as how could bees live here with no flowers from which to gather pollen? Your worries about food are soon allayed, though, when you see shoals of fish swimming in towards the island.||\"Where are they going to? says Blutz, peering into the water. \"I can see dozens of fishes swimming this way, but none of them seems to be reaching the shore.\"||Oakley points at a dark indistinct shape moving sluggishly to and fro deep below the surface. \"Might that be a shark? Let's do no swimming, anyway, just to be on the safe side.\"||Striding towards the centre of the little island, you discover a rock pool and fall to your knees beside it with a cry of joy. However, no sooner have you tasted the water than you give a grimace and spit it out. It tastes of salt. This strikes you as odd, since the pool is surely above the level of high tide.">
<CONSTANT CHOICES028 <LTABLE "gather food on the island" "decide to put to sea now and go north" "continue west">>

<ROOM STORY028
	(IN ROOMS)
	(DESC "028")
	(STORY TEXT028)
	(CHOICES CHOICES028)
	(DESTINATIONS <LTABLE STORY085 STORY066 STORY047>)
	(TYPES THREE-NONES)
	(PRECHOICE STORY028-PRECHOICE)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY028-PRECHOICE ()
	<COND (<CHECK-SKILL ,SKILL-FOLKLORE> <STORY-JUMP ,STORY104>)>>

<CONSTANT TEXT029 "Mortice gives you food and water from his store, while you relate the story of your time aboard Skarvench's ship and how you finally manage to escape, only to face further perils on the open sea.||By now the moon has risen, shedding a spectral glow across the phosphorescent foam on the water. \"A wondrous tale,\" says Mortice, still with the same fixed leer on his face.||\"And what about you, oldster?\" asks Blutz as he chews the last scrap of meat off a chicken leg. \"How do you come to be adrift on a bare raft, with only a bucket of fresh water and a hamper of food for company?\"||\"Ah!\" cries the old man. \"That's a wondrous tale, too. But it can wait till morning, methinks, for the hour is late and I perceive that the full meal has made you tired.\"">

<ROOM STORY029
	(IN ROOMS)
	(DESC "029")
	(STORY TEXT029)
	(PRECHOICE STORY029-PRECHOICE)
	(CONTINUE STORY105)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY029-PRECHOICE ()
	<COND (<CHECK-SKILL ,SKILL-SEAFARING> <STORY-JUMP ,STORY067>)>>

<CONSTANT TEXT030 "You've been on the island just a week, living in a lean-to on the beach. One morning Blutz comes chasing up the beach, waving his arms and shouting for all he's worth.||Grimes, sprawled on the sand in the shade of a palm, puffs his pipe and remarks, \"It's a rare occurrence that stirs our Blutz to move faster than a trot. What's up, d'ye think, lads\"||You smile. \"Perhaps the sun has gone in front of a cloud? Or a fish caught a seagull?\"||\"Or he found a pearl inside a coconut?\" chuckles Oakley.||But your smiles vanish when Blutz reaches you and blurts out his news: \"The Belle Dame's just coming around the headland. She'll be dropping anchor in the bay, and here's us like four turkeys at Yuletide.\"">
<CONSTANT CHOICES030 <LTABLE "run off to hide in the interior of the island until Skarvench departs" "first bribe the natives to say that you're not here" "go boldly down to confront Skarvench when he comes ashore">>

<ROOM STORY030
	(IN ROOMS)
	(DESC "030")
	(STORY TEXT030)
	(CHOICES CHOICES030)
	(DESTINATIONS <LTABLE STORY049 STORY068 STORY087>)
	(PRECHOICE STORY030-PRECHOICE)
	(TYPES THREE-NONES)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY030-PRECHOICE ()
	<COND (,RUN-ONCE <GAIN-LIFE 1>)>>

<CONSTANT TEXT031 "In a small courtyard off the fish market lives Doctor Scriptor, a collector of magical curios. You have brought him items in the past, both for identification and to see if he would buy them from you. He looks up from his dusty manuscripts and takes what you have brought to show him, holding up a jeweller's glass and passing each item in turn under the sharp scrutiny of his beady old eyes.||\"Well?\" you ask.||\"One moment.\" Scriptor gives a dry cough, perching his glasses on his thin nose and consulting a dusty leatherbound book. \"Hmm. Ah yes, ah yes. Eureka!\"">
<CONSTANT CHOICES031 <LTABLE "ask him about a" "a" "a" "a" "if you don't have any of these you may as well leave">>

<ROOM STORY031
	(IN ROOMS)
	(DESC "031")
	(STORY TEXT031)
	(CHOICES CHOICES031)
	(DESTINATIONS <LTABLE STORY316 STORY335 STORY354 STORY373 STORY392>)
	(REQUIREMENTS <LTABLE CONCH-SHELL-HORN BAT-SHAPED-TALISMAN BRONZE-HELMET DRAGON-RING NONE>)
	(TYPES <LTABLE R-ITEM R-ITEM R-ITEM R-ITEM R-NONE>)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT032 "You explode into a sudden flurry of dazzling action. Pushing your friends back out of danger, you dive nimbly to one side as the chief ruffian's knife whistles through the air just a hand's breath above your scalp. Then, springing up onto the bar, you launch yourself forward, tumbling in midair so as to go careening against the ruffian's legs with the force of a rolling barrel. They are bowled over like so many skittles.||Jumping to your feet, you pause just long enough to check that Blutz and the others have safely made their getaway. It is your one mistake. A clumsily thrown knife catches you in the thing, laying open a nasty gash.">
<CONSTANT TEXT032-CONTINUED "You limp hastily outside where your friends help you to get to safety. Only when you are sure there is no sound of pursuit do you slow to a walk.||\"Well, that wasn't very successful,\" says Blutz, gasping for breath.\"||\"What are you griping about, Mister Blutz?\" you say with a relieved grin. \"You've still got your health, and that's what counts.\"">

<ROOM STORY032
	(IN ROOMS)
	(DESC "032")
	(STORY TEXT032)
	(PRECHOICE STORY032-PRECHOICE)
	(CONTINUE STORY392)
	(DEATH T)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY032-PRECHOICE ()
	<LOSE-LIFE 1 "You died from the knife wound" ,STORY032>
	<IF-ALIVE TEXT032-CONTINUED>>

<CONSTANT TEXT033 "The sunlight, filtering weakly through tobacco-stained windows, makes his eyes shine like pearls as he turns to you. \"Pull up a pew, mates,\" he says, stifling a sodden belch. \"Ol' Greymalkin is always ready to swap stories with a fellow buccaneer.\"||\"Here is a fearless warrior of the waves, indeed,\" says Grimes behind his hand. \"He's in full sail on a sea of wine, and that smell isn't salt spray billowing on the wind!\"||\"I heard that!\" snaps Greymalkin drunkenly. \"Poke fun at ol' Greymalkin if you like, ye scurvy nobbler -- I'll wager I saw more action afore my lights were put out than ye'll see in your whole poxy life. Aye, an' I heard a few tales in my time, too.\"||\"Heard anything recently?\" you ask.||\"Heard a fair bit. Talkin' about it dries the tongue out, though.\"">
<CONSTANT CHOICES033 <LTABLE "buy a drink" "go over to the three bullies and the scholar" "pay a visit to the shipyard">>

<ROOM STORY033
	(IN ROOMS)
	(DESC "033")
	(STORY TEXT033)
	(CHOICES CHOICES033)
	(DESTINATIONS <LTABLE STORY090 STORY052 STORY374>)
	(REQUIREMENTS <LTABLE 1 NONE NONE>)
	(TYPES <LTABLE R-MONEY R-NONE R-NONE>)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT034 "His eyes roll in their sockets, each an orb as big as a boulder. \"A ship, is it? Well, there are many moored in this harbour. More ships than you could dream of: all the ships of myth and legend! But do you not see this harbour chain?\" His hand dips into the dark water, jangling the massive links as a man might play with a watch-chain.||\"Won't you lift it,\" you boldly ask him; \"allow us to enter and choose a vessel?\"||He booms his mirth to the sky. \"Hah! You're audacious enough to be a hero, at least. No, I won't help you -- but see this lock? You could open the chain yourself easily enough, except for the fact that no man can see or touch the key that fits it.\"">
<CONSTANT CHOICES034 <LTABLE "try something" "try unlocking the chain by magic" "try an item that you think might do the trick" "failing any of these, you must admit defeat.">>

<ROOM STORY034
	(IN ROOMS)
	(DESC "034")
	(STORY TEXT034)
	(CHOICES CHOICES034)
	(DESTINATIONS <LTABLE STORY091 STORY110 STORY129 STORY072>)
	(REQUIREMENTS <LTABLE SKILL-CUNNING SKILL-SPELLS NONE NONE>)
	(TYPES <LTABLE R-SKILL R-SKILL R-NONE R-NONE>)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT035 "\"Sidonian men-o'-war hard astern! Three of of 'em!\" cries your lookout. The Gloriannic warship sees them too and alters course to engage the enemy. Forgotten for the time being, your own ship is able to slip away.||Oakley joins you on the poopdeck. \"They're almost over the horizon,\" he says, glancing back. \"A nice bit of luck, those Sidonian ships turning up just when they did. But I'm a bit surprised at you making a run for it, skipper. I'd have thought you'd order us to muck in and help the Gloriannic captain.\"||You smile and pat the wand tucked into your belt. \"Help him, Mister Oakley? Against what -- those magical mirages I conjured? They'll be fading like a morning haze as soon as we're out of sight.\"||He laughs heartily to hear this.">

<ROOM STORY035
	(IN ROOMS)
	(DESC "035")
	(STORY TEXT035)
	(CONTINUE STORY016)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT036 "Sailors are a superstitious lot, easily spooked by any overt display of sorcery. Because of this you are reluctant to unleash the full force of your magic in front of the crew. Luckily Blutz realises your dilemma and provides you with an excuse to slip away. \"When I was a lad, we always used to say you could get a wind by whistling for it,\" he declares loudly. \"Its worth a try now, ain't it, shipmates?\" Turning to you, he adds: \"Begging your pardon, skipper, but it's an ill wind you get if you whistle while the captain's on deck.\"||\"Eh? Oh yes, of course; I've heard that legend. Well, anything's worth trying. Carry on, Mister Blutz.\"||While the crew start whistling, you go below to your cabin and conjure a wind. Returning on deck a little while later, you see the sails billowing and the sailors dancing for joy. \"Quick thinking, Mister Blutz,\" you mutter as the Lady of Shalott clears the mouth of the bay.||\"Just whistle anytime you need me, Cap'n\" he replies with a wink.">

<ROOM STORY036
	(IN ROOMS)
	(DESC "036")
	(STORY TEXT036)
	(CONTINUE STORY396)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT037 "The storm turns the sky to boiling pitch, and in your fancy it seems that you would be swamped by celestial fires if it were not that the sea now boils up to the edge of heaven, hissing those fires into smoky darkness. Your crew cling to whatever comes to hand as mighty waves come heaving over the side. You see one man lose his balance and go hurtling across the deck -- only saved at the last moment by catching hold of the mainsail shrouds.||\"Cap'n!\" cries the helmsman, peering into the thundering curtains of rain. \"I cannot see to steer her!\"||You hold your amulet before his eyes. Its burnished gold surface sparkles in the flicker of lightning. \"Focus your gaze on this,\" you tell him. \"Have faith.\"||He stands fast as though entranced, turning the whipstaff to follow each swing of the amulet. The sails strain, drawing shrieks of protest from the masts, and high waves crash around your bows, but you plunge on directly for the heart of the storm.">

<ROOM STORY037
	(IN ROOMS)
	(DESC "037")
	(STORY TEXT037)
	(CONTINUE STORY094)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT038-NODAMAGE "You pull your ship deftly aft of the enemy ship without taking damage">

<CONSTANT TEXT038-DAMAGED "You are clipped by cannon-fire as you go in">

<ROOM STORY038
	(IN ROOMS)
	(DESC "038")
	(PRECHOICE STORY038-PRECHOICE)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY038-PRECHOICE ()
	<COND (<CHECK-SKILL ,SKILL-SEAFARING>
		<CRLF>
		<TELL TEXT038-NODAMAGE>
		<TELL ,PERIOD-CR>
		<STORY-JUMP ,STORY415>
	)(ELSE
		<CRLF>
		<TELL TEXT038-DAMAGED>
		<TELL ,PERIOD-CR>
		<DAMAGE-SHIP 1 ,STORY415 ,STORY227>
	)>>

<CONSTANT TEXT039 "The sailmaster is the officer in charge of day-to-day navigation of the ship. His tiny cabin is strewn about with papers, compasses, books and other maritime paraphernalia.||A sound from the bunk directly by your shoulder makes you give a start of alarm. You thought the blasted cabin was empty! But just as you are lunging forward, the blanket is tossed aside and you have a clear view of the bunk's occupant -- not a sailor, but only the little monkey that serves as the ship's mascot. Mister Chatter is what the crew call him. He squats on the bunk and watches as you search around the rest of the cabin.||You have time to grab two items from the following: a toolkit, a book of charts, a crucifix, a lodestone and the monkey.">

<ROOM STORY039
	(IN ROOMS)
	(DESC "039")
	(STORY TEXT039)
	(PRECHOICE STORY039-PRECHOICE)
	(CONTINUE STORY172)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY039-PRECHOICE ()
	<SELECT-FROM-LIST <LTABLE TOOLKIT BOOK-OF-CHARTS CRUCIFIX LODESTONE MONKEY> 5 2>>

<CONSTANT TEXT040 "BY steering a southerly route you take advantage of the prevailing east current which should bear you to Port Leshand with the need for hard effort at the oars. Additionally, there is always the chance that you will be picked up by one of the many ships that ply these waters||After a whole day at sea you do not have such hopes. In all that tie you have seen nothing but the boundless expanse of ocean all around you. The sky is cloudless, giving you no respite from the sun that beats mercilessly down from dawn to dusk. By night a cool wind leaves you huddled, shivering, inside your ragged clothes.">
<CONSTANT TEXT040-CONTINUED "Shortly after sunrise on the second day, you catch sight of a small uncharted island off to port. In form it is a rough hump of rock with no more than a hundred paces from side to side, girt with weed and sandbanks covered with clumps of greenish algae.||\"A coral reef,\" decides Grimes, noting the vague orange-pink shadow of rocks beneath the waves. \"There could at least be fresh rainwater here -- and insects, if not birds.\"||\"What do we want with insects?\" asks Blutz in disgust.||\"Food,\" you tell him. \"Necessity must overrule nicety if we're to survive.\"">
<CONSTANT CHOICES040 <LTABLE "put in at at the island" "continue on your present course" "detour northwards towards the Smoking Islands">>
<CONSTANT RAGGED-CLOTHES "Your ragged clothes were not enough to keep you warm. You died some time in the night">

<ROOM STORY040
	(IN ROOMS)
	(DESC "040")
	(STORY TEXT040)
	(CHOICES CHOICES040)
	(DESTINATIONS <LTABLE STORY028 STORY047 STORY066>)
	(PRECHOICE STORY040-PRECHOICE)
	(TYPES THREE-NONES)
	(DEATH T)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY040-PRECHOICE ()
	<COND (<CHECK-SKILL ,SKILL-WILDERNESS-LORE>
		<COND (,RUN-ONCE <LOSE-LIFE 1 RAGGED-CLOTHES ,STORY040>)>
		<IF-ALIVE "[With your knowledge of WILDERNESS LORE, you soak your ragged clothes in the sea to keep yourself warm at night and cool during the day]">
	)(ELSE
		<COND (,RUN-ONCE <LOSE-LIFE 2 RAGGED-CLOTHES ,STORY040>)>
		<COND (<IS-ALIVE>
			<CRLF>
			<TELL "[" RAGGED-CLOTHES "]">
			<CRLF>
		)>
	)>
	<IF-ALIVE TEXT040-CONTINUED>>

<CONSTANT TEXT041 "Heavy stones fly about you like shots from a cannon as you beat your retreat. Several of them thud harmlessly into the soft sand but then you feel a hot slash of pain as one strikes the inside of your head, leaving a ragged gash. You stumble, but Blutz catches your arm and helps you into the boat.||You lose consciousness for a moment. The next thing you know, the boat is already out amid the waves with Oakley and Grimes plying the oars for all they're worth.||The battering hail of rocks continues as the natives watch you row away.">
<CONSTANT TEXT041-CONTINUED "You slump down into the bottom of the boat with an exhausted sigh of relief as you finally get out to open sea beyond reach of the islander's bombardment.||\"I think they wanted us to stay for dinner,\" jokes Oakley with grim humour. \"I hope the natives on the next island are more friendly.\"||So do you.">

<CONSTANT DIED-BOMBARDMENT "You died from injuries sustained during the bombardment.">

<ROOM STORY041
	(IN ROOMS)
	(DESC "041")
	(STORY TEXT041)
	(PRECHOICE STORY041-PRECHOICE)
	(CONTINUE STORY116)
	(DEATH T)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY041-PRECHOICE ()
	<COND (<CHECK-SKILL ,SKILL-CHARMS>
		<LOSE-LIFE 1 DIED-BOMBARDMENT ,STORY041>
		<IF-ALIVE "[Your lucky magic amulet saved you from sustaining more serious injuries]">
	)(ELSE
		<LOSE-LIFE 4 DIED-BOMBARDMENT ,STORY041>
	)>
	<IF-ALIVE TEXT041-CONTINUED>>

<CONSTANT TEXT042 "You tread on a twig and Skarvench and his cronies leap up with angry roars to do battle. Discovered, you have no recourse but to rush in on them.">

<ROOM STORY042
	(IN ROOMS)
	(DESC "042")
	(STORY TEXT042)
	(EVENTS STORY042-EVENTS)
	(CONTINUE STORY267)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY042-EVENTS ()
	<COND (<OR <CHECK-SKILL ,SKILL-ROGUERY> <CHECK-SKILL ,SKILL-WILDERNESS-LORE>> <RETURN ,STORY080>)>
	<RETURN ,STORY042>>

<CONSTANT TEXT043 "\"These are glad tidings!\" he declares with enthusiasm. \"I am always happy to launch gentlemen of fortune on their careers.\"||For the next hour you are shown around the shipyard while discussing the exact specifications of your new ship. You explain to Kemp everything you want, from the timber to be used and the kind of armaments right down to details such as cargo capacity, the figurehead, and even the cabin fittings.||\"You know your vessels,\" he says approvingly. \"Naturally, in view of the fact that on every point you have stipulated that you want materials and labour of only the soundest and best quality, you must appreciate that the price will not be cheap.\"||You add up the costs and discover that you will need at least one diamond to purchase even a small second-hand ship. Failing that, you will have to obtain one some other way. Promising to return as soon as you have come to a firm decision, you take your leave of Master Kemp and walk back into town.||\"Where to now?\" says Oakley.||You think for a moment. \"We'll take rooms at the Sweat of the Brow inn. If Skarvench shows his face anywhere in Selenice, it'll be there.\"||Never a truer word was spoken. You arrive at the inn and stand frozen in shock in the doorway. There the devil stands, large as life in front of you. A rum bottle is clutched in his hand and his crew throng the tap-room around him, cowering as he subjects them to one of his thunderous drunken rants.||Then his eye alights on you. His snarling voice is cut off in mid-sentence. A thin line of spittle runs down into his beard as his teeth show shark-like in a vicious grin. It is the moment you have waited for. Face to face with your arch foe.">

<ROOM STORY043
	(IN ROOMS)
	(DESC "043")
	(STORY TEXT043)
	(CONTINUE STORY014)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT044 "Blutz directs the crew to fetch up the cargo from the hold. At first you have no idea what he's talking about, then you remember the barrels of rock salt that the last owner of the Lady of Shalott left aboard when he sold her. The light begins to dawn when Blutz orders the cannons loaded with this salt. The first broadside scours the surface of the iceberg, and it is not long before water is trickling down in the hot noon sun.||\"I remembered that salt can be used to melt ice and snow,\" explains Blutz, beaming with elation at the success of his plan. After two more broadsides the salt has etched its way deep into the ice and there comes a continuous crackling sound as the iceberg slowly breaks apart under the onslaught.||An attack with pickaxes completes the task. Soon the ice has been chipped away to leave a deep gouge, and the Octavius comes drifting forth gleaming into the full daylight. You board her, abandoning the sloop, and set a northward course.||The days pass and your new ship is a delight, handling better than any vessel you've ever sailed. You feel a glow of pride as you at last steer her through the harbour gate and up to the Selenice docks.">

<ROOM STORY044
	(IN ROOMS)
	(DESC "044")
	(STORY TEXT044)
	(PRECHOICE STORY044-PRECHOICE)
	(CONTINUE STORY184)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY044-PRECHOICE ()
	<TAKE-VESSEL ,OCTAVIUS>>

<CONSTANT TEXT045 "Mermaids are like all faerie creatures in being motivated by caprice. They  can be cruel or kind, as the whim takes them. It is well known that they sometimes seek the company of mortal men, whom they entice with their beauty and promise of secret wealth, because they constantly yearn to draw a little of the surface world's warmth and vitality into their own submerged realm of twilit silence. Few who have succumbed to a mermaid's lures survive to tell the tale. There are cases of men who have tarried a while under the sea, then returned with the gift of second sight -- for the mermaids are able to grant knowledge of future events. Such cases are rare. A more likely fate is to be washed up ton the beach, leeched of breath by the mermaid's kiss, dead face forever frozen in fearful rapture of having heard the mermaid's secrets and witnessed her unearthly beauty.||You know one more thing. Any question put to a mermaid must be answered truthfully if the questioner has a firm grip on her. In that respect, too, she is like any other faerie creature.">

<ROOM STORY045
	(IN ROOMS)
	(DESC "045")
	(STORY TEXT045)
	(CONTINUE STORY064)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT046 "Slurring his words, Mandrigard peers soddenly at you across the table. \"It's more talk you want, is it? Well, I'm talked out. Not all the blabber in a thousand harems will wipe out the curse I carry with me -- and you poor dolts are part of that curse now -- now, and forevermore!\"||Wine-soaked spittle sprays out from his lips as he screams all this. The look in his eyes is like the fires of hell. Then suddenly his eyelids droop, and he slumps forward across the treasure, mumbling, \"See this scar on my left hand? There's the proof, y'see? 'Tis where I broke the lock of that heathen shrine. See the stain of my curse, do you?\"">

<ROOM STORY046
	(IN ROOMS)
	(DESC "046")
	(STORY TEXT046)
	(CONTINUE STORY065)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT047 "A little rainfall helps to slake your thirst, but hunger still chews at your bellies and the constant blaze of the sun makes you dizzy.">
<CONSTANT TEXT047-CONTINUED "Squinting into the sunset, Oakley gives a sudden cry of anguish. \"Another night of this, God rot me, and I'll be as mad as a gannet! If we only had something to eat.\" He gnaws the leather of his belt just to have a taste of something solid in his mouth.">
<CONSTANT CHOICES047 <LTABLE "improvise something with" "or" "eat a" "otherwise">>

<ROOM STORY047
	(IN ROOMS)
	(DESC "047")
	(STORY TEXT047)
	(CHOICES CHOICES047)
	(DESTINATIONS <LTABLE STORY218 STORY218 STORY237 STORY275>)
	(REQUIREMENTS <LTABLE SKILL-SEAFARING SKILL-WILDERNESS-LORE MONKEY NONE>)
	(TYPES <LTABLE R-SKILL R-SKILL R-ITEM R-NONE>)
	(PRECHOICE STORY047-PRECHOICE)
	(DEATH T)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY047-PRECHOICE ()
	<COND(,RUN-ONCE <LOSE-LIFE 1 DIED-OF-HUNGER ,STORY047>)>
	<IF-ALIVE TEXT047-CONTINUED>>

<CONSTANT TEXT048 "You eat and drink while listening to Mortice tell his tale. It is a gruesome story, beginning with a storm at sea. Mortice was washed ashore on a deserted island along with a dozen corpses of his former shipmates. After many months he was picked up by a ship called Cold Grue, but there his hope soon turned to despair. \"By day I was locked up in the fo'c'sle, and only let out at night to toil on deck. I never knew a harsher taskmaster than El Draque, the captain of that fell ship! There were other poor sailors aboard with me, and if ever you set a foot wrong -- or even if you didn't, sometimes -- you'd be taken down to the hold an' never seen again. Once I watched El Draque and his corsairs bury treasure by moonlight on a stretch o' shore off Tortoise Island, under a rock marked with crossed bones. Aye, I marked that well; I'd be goin' back there, if I had myself a ship that could outrun the Cold Grue!\"||\"And how did you escape?\" asks Blutz, chomping on a chicken leg.||\"Why, I made myself this raft and starved until I was so thin I could squeeze out the fo'c'sle hatch like any bag of old scraps. There wasn't a soul stirring on deck during the hours o' daylight, you see. So I loaded up food and water and pushed off. Been adrift for weeks, I have, till I caught sight o' you jolly lads!\" He refills your cups from the full barrel beside him.">

<ROOM STORY048
	(IN ROOMS)
	(DESC "048")
	(STORY TEXT048)
	(PRECHOICE STORY048-PRECHOICE)
	(CONTINUE STORY105)
	(CODEWORD CODEWORD-RAVEN)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY048-PRECHOICE ()
	<COND (<CHECK-SKILL ,SKILL-SEAFARING> <STORY-JUMP ,STORY067>)>>

<CONSTANT TEXT049 "You race off into the jungle not a moment too soon. Turning to peer back from the crest of a wooded hill, you see the Belle Dame already riding at anchor offshore. A rowboat is bringing Skarvench and his cut-throats to the beach even now.||\"He'll never leave until he's found us,\" mutters Oakley as you trudge on through the dense green thickets.||\"It's a big island,\" you call back over your shoulder. \"If we stay hidden long enough, he'll have to give up the search and leave. For all he knows we might be dead already.\"">

<ROOM STORY049
	(IN ROOMS)
	(DESC "049")
	(STORY TEXT049)
	(PRECHOICE STORY049-PRECHOICE)
	(CONTINUE STORY163)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY049-PRECHOICE ()
	<COND (<CHECK-SKILL ,SKILL-WILDERNESS-LORE> <STORY-JUMP ,STORY144>)>>

<CONSTANT TEXT050 "A letter of marque would allow you to indulge in a spot of honest piracy -- or rather privateering, as it is called. Such a letter licenses you to act as a private soldier of Her Majesty's navy, with full entitlement to plunder Sidonian treasure-ships.||\"But we'll never be able to get one,\" says Blutz despondently after you have all spent some time discussing the idea.||\"That's right,\" growls Oakley. \"It costs almost as much in bribes to get hold of a letter of marque as you're likely to bring in as profit.\"||\"Aha,\" you say, pulling a furled-up document from your sleeve and tossing it onto the table. \"What's this?\"||Grimes inspects it with mounting astonishment. \"Why, it's a letter of marque, establishing your right to act as privateers on the Carab Sea! How did you get --\" He pauses and a slow grin suffuses his face. \"The ink's still wet.\"||You retrieve the letter of marque, beaming with pride. It is a good a forgery as any you've ever done. When the ink dries up it will be indistinguishable from the real thing.">
<CONSTANT CHOICES050 <LTABLE "call on Master Capstick" "otherwise">>

<ROOM STORY050
	(IN ROOMS)
	(DESC "050")
	(STORY TEXT050)
	(CHOICES CHOICES050)
	(DESTINATIONS <LTABLE STORY069 STORY107>)
	(REQUIREMENTS <LTABLE <LTABLE CODEWORD-MARATHON> NONE>)
	(TYPES <LTABLE R-CODEWORD R-NONE>)
	(ITEM LETTER-OF-MARQUE)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT051 "\"Fine,\" you say smartly. \"Go ahead and carve us up. Then see what Skarvench does to you when he hears about it.\"||The leader of the cut-throats replies with a scowl, but you see him hesitate. He's not sure. \"You're bluffing,\" he says. \"Skarvench said to deal with anyone who came around snooping after him.\"||\"We're supposed to be with him,\" you say, adopting the tone you would use to a stupid child. You're push your luck, but that's how you like it.||\"How do I know you're telling the truth..?\" he says, tiny eyes clouding with uncertainty. The knife point wavers.||You give a derisive snort. \"Would we be daft enough to just waltz in here asking questions if not?\"||\"Get 'em to prove it, Cuss,\" prompts one of the other thugs.||You glare at them. \"Don't think we're going to start blabbing the details of the plan in a dump like this. Anyone might overhear. But, Cuss -- suffice it to say, there'll be a right royal fuss if we don't link up with the cap'n\"||\"He's in Selenice by now, I should think,\" says Cuss, sheepishly putting away his knife. ||\"Uh, huh,\" you say nodding. \"We'll find him aboard --\"||\"Aboard the Moon Dog,\" he supplies helpfully.||\"That's the one. Be seeing you.\" You leave, waiting until you're around the corner to give a sigh of relief.||\"What's this about the Moon Dog?\" Blutz wonders. \"Skarvench's ship was always the Belle Dame. Why change now?\"||\"Perhaps we'll find out,\" you say. \"in Selenice.\"">

<ROOM STORY051
	(IN ROOMS)
	(DESC "051")
	(STORY TEXT051)
	(CONTINUE STORY392)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT052 "The elderly scholar makes another short-sighted lunge for his spectacles, only to trip over the outstretched leg of one of the ruffians and go sprawling. Their laughter is harsh and braying. The scholar gets to his feet and brushes the dust of his velvet robe. \"Please...\" he says, almost in tears. \"Give those back; I can't see without them.\"">
<CONSTANT CHOICES052 <LTABLE "use" "try" "or fight with a sword" "a pistol" "your bare hands">>

<ROOM STORY052
	(IN ROOMS)
	(DESC "052")
	(STORY TEXT052)
	(CHOICES CHOICES052)
	(DESTINATIONS <LTABLE STORY128 STORY147 STORY166 STORY185 STORY204>)
	(REQUIREMENTS <LTABLE SKILL-CUNNING SKILL-STREETWISE SKILL-SWORDPLAY SKILL-MARKSMANSHIP NONE>)
	(TYPES <LTABLE R-SKILL R-SKILL R-SKILL R-SKILL R-NONE>)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT053 "He places his hand to his jaw and squints his eyes in thought, smiling as he considers your request.||\"Will you ponder the matter until the stars go out and the moon cracks in two?\" you cry boldly. \"Our foe is mortal like ourselves, and does not unfold his plans at the testudineous pace you seem to favour.\"||\"Have a care!\" pleads Blutz. \"You'll anger him. He might be the very god Neptune himself.\"||You round on him with a blaze of anger. \"God or not, I'm your skipper, Mister Blutz! Now keep your counsel while I parley with yon giant.\"||The giant rumbles with laughter, amused by this exchange. There is a sparkle in his green marble eyes as he says, \"Well spoken, mortal. At sea a man should respect neither god nor titan, but only his captain. I'll help you right enough, since I now see you deserve it, but what help is it you want? Will it be wealth to buy a ship -- or the wisdom to sail her well?\"">
<CONSTANT CHOICES053 <LTABLE "choose wealth" "wisdom">>

<ROOM STORY053
	(IN ROOMS)
	(DESC "053")
	(STORY TEXT053)
	(CHOICES CHOICES053)
	(DESTINATIONS <LTABLE STORY148 STORY167>)
	(TYPES TWO-NONES)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT054 "The warship pulls alongside to windward, stealing the breath from your sails. Clambering into the rigging, you run along the mainyard to where the sails of the two ships are already touching. One of the enemy sailors sees you and comes swinging down from the crow's nest, knife in hand. You duck nimbly under his knife-thrust and a cheer goes up from the deck of the Lady of Shalott as your men see you stun your opponent with a sharp jab to the chin. He sags back, caught in the ratlines, and you grab the knife from his limp fingers. Climbing higher into the rigging of the enemy ship, with musket-shots whistling around your ears, you glance down to see the marines casting grappling hooks. Your own crew stand ready to repel boarders as two ships are pulled together.||Digging your knife into the mainsail, you slide right down the billowing canvas, using deft twists of the blade to steer your descent. You land on the deck in front of the helmsman, the split canvas drooping above you. You raise the knife, but the helmsman has no stomach for a fight and runs off, allowing you to throw the whipstaff hard over. The two vessels begin to pull apart as the warship veers in response. Realising your plan too late, the marines make a dash back from the rail, but you have already jammed the whipstaff in position with the knife and swung up to the poopdeck rail out of reach. Running for the side, you launch yourself into space and catch hold of one of the grapple-lines, swiftly pulling yourself hand over hand back to the Lady of Shalott amid the delighted shouts of your crew.||Oakley and the rest lose no time in cutting the remaining lines, and the ships drift rapidly apart. On the deck of the warship you can see the marines struggling to free the jammed whipstaff. By the time they can do that and repair the mainsail you tore in half, you'll have made your getaway.">

<ROOM STORY054
	(IN ROOMS)
	(DESC "054")
	(STORY TEXT054)
	(CONTINUE STORY016)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT055 "The next half-hour gives you as gruelling a test of your ship-handling skills as you've ever faced. Taking constant depth reckoning with a lead line, you steer the Lady of Shalott slowly between reefs and sandbars until at last you are out of the bay in open waters.||Here a light breeze ruffles the sails, but it is not enough to give you the headway you want. You order the rowboats lowered and commence kedging -- carrying the anchor as far ahead of the bows as possible and then dropping it so that you can winch the ship onwards. It is slow going, but at last you are well clear of Tortoise Island and the eldritch fog that surrounds it. Soon you pick up a decent wind and from then on it is plain sailing back to Selenice. But you make the voyage with bitter heart because you are returning empty-handed.">

<ROOM STORY055
	(IN ROOMS)
	(DESC "055")
	(STORY TEXT055)
	(CONTINUE STORY396)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT056 "Driven on by remorseless determination, you hardly notice the stirrings of mutiny. At all hours of the day and night you are to be seen pacing the deck, marking the wind and sea currents in you log-book or using a cross-staff to plot the position of the stars. The crew dare not question your judgement now -- they  fear they would never get home without you.||At last your steadfastness is rewarded with a cry of \"Ice ho!\" from the deck. You race up the companion-way and give a great shout of triumph as you catch sight of the blow blue hump of an iceberg dead ahead.">

<ROOM STORY056
	(IN ROOMS)
	(DESC "056")
	(STORY TEXT056)
	(CONTINUE STORY414)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT057 "Despite having her sails in tatters from the storm earlier, the Rose is not quite out of the fight. Her crew realise the threat and man their cannons, bringing several telling shots. to bear on the Moon Dog. Once you are standing abaft your enemy, you add your own fire to that of the Rose. Raked by two foes, the Moon Dog shudders as her mainmast topples.||\"She's dead in the water!\" you cry. \"Close for boarding!\"">

<ROOM STORY057
	(IN ROOMS)
	(DESC "057")
	(STORY TEXT057)
	(CONTINUE STORY006)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT058 "According to the stories you have heard, Grimoire Island is inhabited not by a demon, but by a powerful witch called Ejada the Green. She is thought to be more than a thousand years old, and one legend is that she sealed a pact with an ancient earth god which guarantees her invulnerability so long as her feet remain on solid ground.||But, whether true or false, these folk-tales are not your first concern. Now you must sail on towards the first of the islands -- the one Oakley believes to be inhabited by savages.">

<ROOM STORY058
	(IN ROOMS)
	(DESC "058")
	(STORY TEXT058)
	(CONTINUE STORY097)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT059 "\"What is it you want of me? \"growls the god, fixing you in the sharp glare of his eyes.||\"My Olympian lord,\" you begin, \"we are trapped on this ship...\"||\"It's captain dared to pillage my shrine!\" Dionysus thunders. \"But we don't deserve this fate, lord,\" you protest.||Dionysus ponders your case. \"Perhaps not. If you were more my creature, I might be moved to mercy.||\"Your creature, lord?\"||\"The type of mortal I favour,\" continues Dionysus impatiently, \"is a roistering rowdy varlet, full of craziness and lusty with the more uproarious joys that life has to offer. Not for me these sober scholars with their books and scrolls.\"||\"Not I, lord!\" you say hastily.||He nods thoughtfully. \"I wonder. Well, I'll whisk you off to your destination, but mind you're on your worst behaviour from now on. I can't abide a dainty do-gooder!\"At Dionysus's gesture, the wine soaking the decks rises in a cloud of giddying vapour. Reeling from the fumes, you grope out until you feel the hands of your friends. They cling to you as their only protection -- though, truth to tell, if the god had unleashed his full wrath then there would have been little enough that you could do.||The wine-mist clears. There is no sign of Dionysus or his panthers -- nor of the cursed ship. Now the four of you are huddle together in the corner of a dingy tavern. A burly barman stomps over and swabs at a puddle of spilled wine on the table in front of you. \"Ain't you got no homes to go to?\" he grumbles.||\"Where are we?\" Oakley innocently asks him.||The barman gives him a contemptuous look. \"You drunken lubbers! This is a Slaughtered Goat tavern, in Port Leshand.\"||You have been spirited magically to where you wanted to go, but the god's services has its price. He has left your mind permanently tinged with exuberant madness that is his hallmark.">

<ROOM STORY059
	(IN ROOMS)
	(DESC "059")
	(STORY TEXT059)
	(PRECHOICE STORY059-PRECHOICE)
	(CONTINUE STORY009)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY059-PRECHOICE ()
	<COND (<NOT <AND <CHECK-SKILL ,SKILL-ROGUERY> <CHECK-SKILL ,SKILL-BRAWLING>>>
		<CRLF>
		<HLIGHT ,H-BOLD>
		<TELL "You must acquire now " D ,SKILL-ROGUERY " and " D ,SKILL-BRAWLING>
		<HLIGHT 0>
		<CRLF>
		<SKILL-SWAP <LTABLE SKILL-ROGUERY SKILL-BRAWLING>>
	)>>

<CONSTANT TEXT060 "Raising your wand you commence a chant of your own, calling upon the occult forces which empower your magic. Seeing this, the natives fall back with a frightened moan. Then one withered old man in a feather cloak steps forward: their shaman. Wielding an obscene wand carved from a human thigh bone, he screeches a hasty incantation and advances to match his sorcery against yours.||Spells flash and sparkle in the air, but the uncanny duel is short-lived. Seeing that you are far more powerful a wizard than he, the shaman hurls his wand down into the sand in a gesture of surrender.">

<ROOM STORY060
	(IN ROOMS)
	(DESC "060")
	(STORY TEXT060)
	(CONTINUE STORY022)
	(ITEM NONE)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT061 "Magic bends the very elements of nature to your will. The breeze obediently brings you the words of Skarvench and his cronies as they sit chatting over their bottle of grog. They are still more than fifty paces away, but you can now hear them as clearly as if they were right by your side!||\"So what's this treasure for, Cap'n?\" hiccups the quartermaster.||\"To pay a certain shipwright in Port Selenice, for one thing,\" says Skarvench. \"He's to be paid in gold for the new ship he's building us.\"||\"New ship?\" says Porbuck the mate, roused from his dull witted torpor. \"I liked the old one...\"||\"This one's better though. The Moon Dog, she's to be named, and her special sails were ensorcelled by the Queen's own wizard. Does things the Belle Dame never could.\"||\"The Queen's wizard?\" repeat Curshaw.||\"Aye, Will Wild himself. My dear half-brother! But he wants silver coins for his pains, see, so there's another reason for needing this here loot. Ahoy there, ye lazy lubbers, ain't you struck the box yet?\"||The two sailors look up from their work. \"Aye, Cap'n. Here it is.\"||You've heard enough.">
<CONSTANT CHOICES061 <LTABLE "wait until they have taken the treasure aboard their ship and sailed off" "risk attacking them in your weakened state">>

<ROOM STORY061
	(IN ROOMS)
	(DESC "061")
	(STORY TEXT061)
	(CHOICES CHOICES061)
	(DESTINATIONS <LTABLE STORY288 STORY267>)
	(TYPES TWO-NONES)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT062 "A funnel of wind whiplashes down out of the sky. As she feels it engulf her, Ejada gives vent to a cry of alarm and tries to catch a handhold on the palace wall. Her hair and robes billow in the wind and she is sucked inexorably into the air. To your amazement, you can now see something like green shoots or rootlets dangling from the soles of her feet. As soon as these are tugged out of the ground, she begins visibly to weaken and soon she is begging for mercy.">

<ROOM STORY062
	(IN ROOMS)
	(DESC "062")
	(STORY TEXT062)
	(CONTINUE STORY157)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT063 "Kemp nods. \"Just recently finished. Skarvench took delivery of her two days ago, a fine galleon of forty guns which he means to name Moon Dog. Got some queer features to her, though.\"||You press him on the point. \"Such as?\"||\"Well, first off he had me install gunports along the keel. \"The ship'll sink,\" says I, but Skarvench would have none of it -- just chortled like an old crow and showed me the designs he'd brought. \"Along the keel,\" he insists, \"and mind you fit the masts thus and so; they've a fair load to lift.\"||\"Eh?\" You're puzzled. \"What did he mean by that?\"||Kemp sighs, \"My own guess is worthless, so doubtless your own is better. It's not how I've built any ship before, and I've built hundreds. The timber was too light also -- pine is easily split by cannon -- but Skarvench only laughed fit to burst and said, \"It depends where the cannons be pointing!\" So in the end, since his gold was good, I did it the way he wanted. Now I have other customers to attend to, so I'll be bidding you good day.\"||\"Where to now?\" says Oakley as you walk back to town.||You think for a moment. \"We'll take rooms at the Sweat o' the Brow inn. If Skarvench shows his face anywhere in Selenice, it'll be there.\"||You have never spoken a truer word, for no sooner have you stepped through the doorway of the inn than you are rooted to the spot in shock. There the fiend stands, large as life in front of you. A rum bottle is clutched in his hand and his crew throng the tap-room around him, cowering as he subjects them to one of his thunderous drunken rants.||Then his eyes alights on you. His snarling voice is cut off in mid-sentence. A thin line of spittle runs down into his beard as his teeth show shark-like in a vicious grin. It is the moment you have waited for. Face to face with your dearest foe.">

<ROOM STORY063
	(IN ROOMS)
	(DESC "063")
	(STORY TEXT063)
	(CONTINUE STORY014)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT064 "A long moment passes while you sit thunderstruck gawping in amazement at the mermaid like four fishes in a net. She waits, serene as a statue. Then a slow smile appears on her lips and, raising her pale arms, she turns to swim away...||It is Blutz who reacts first, shocking himself with his own impetuosity. His arm shoots out and he seizes a hunk of the mermaid's long mauve-pink hair. For her part, she gives a cry of shock -- abrupt and musical, like the plucked string of a harp -- and twists in his grasp like an eel.||\"I got her!\" cries Blutz. His eyes shine as he looks around at the rest of you, partly seeking applause and partly reassurance.||Then the mermaid herself speaks. Clutching at Blutz's hand, she slowly relaxes her struggles and says, \"Release me, man of the dry land, and I will aid you.\" Managing to twist around until she faces you, her eyes flash with wild light as she adds: \"But if you should harm me, I'll lay a curse on you to harrow the hearts of all who hear of it!\"">
<CONSTANT CHOICES064 <LTABLE "counter any such curse" "enthral her with magic" "recommend Blutz to turn her loose" "ask her what lies ahead on your journey" "about the best course you can take to Port Leshand">>

<ROOM STORY064
	(IN ROOMS)
	(DESC "064")
	(STORY TEXT064)
	(CHOICES CHOICES064)
	(DESTINATIONS <LTABLE STORY083 STORY102 STORY121 STORY140 STORY159>)
	(REQUIREMENTS <LTABLE SKILL-CHARMS SKILL-SPELLS NONE NONE NONE>)
	(TYPES <LTABLE R-SKILL R-SKILL R-NONE R-NONE R-NONE>)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT065 "Taking your leave of the drunken captain, you investigate the ship. It is built in a style rarely seen these days, with high structures to fore and aft and small brass cannons designed to fire grape-shot at any enemy attempting to board. \"An old vessel,\" decides Grimes, \"and somewhat in the Moorish style.\" He points to abstract fretwork carvings in the woodwork. \"Such geometrical decoration is typical of the Moors.\"||\"What's this?\" asks Blutz. He has found a wooden casket on the main deck, beside the gangplank rail.||Grimes rubs his jaw thoughtfully. \"Perhaps a water tank?\"||\"Er... I don't think so,\" replies Blutz, eyes widening as he takes a peek inside the casket. \"You'd better take a look at this, mates.\"||You peer over his shoulder, almost yelping with shock at what you see inside the casket. For although it is half full of rainwater as Grimes surmised, it also contains several dozen skeletal hands.">

<ROOM STORY065
	(IN ROOMS)
	(DESC "065")
	(STORY TEXT065)
	(CONTINUE STORY084)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT066 "Rigging a small sail made from your torn shirts, you take the boat northwards. There you hope to find an island with food and fresh water to sustain you on the long journey back to civilization.||Hunger makes a knot of your belly, and thirst drives you to distraction.">
<CONSTANT TEXT066-CONTINUED "You arrive at last at an island. Above the bright emerald line marking its jungle-fringed shore rises the steep cone of a volcano. Clouds of smoke wreath its summit, and you can see a dull red glimmer that can only be lava. \"Let's not put in here,\" say Blutz despite his thirst. \"It might erupt and kill us all.\"">
<CONSTANT CHOICES066 <LTABLE "land here" "head towards the next island in the chain">>

<ROOM STORY066
	(IN ROOMS)
	(DESC "066")
	(STORY TEXT066)
	(CHOICES CHOICES066)
	(DESTINATIONS <LTABLE STORY174 STORY135>)
	(TYPES TWO-NONES)
	(PRECHOICE STORY066-PRECHOICE)
	(DEATH T)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY066-PRECHOICE ()
	<COND (,RUN-ONCE <LOSE-LIFE 1 DIED-OF-HUNGER ,STORY066>)>
	<IF-ALIVE TEXT066-CONTINUED>
	<COND (<CHECK-SKILL ,SKILL-WILDERNESS-LORE> <STORY-JUMP ,STORY193>)>>

<CONSTANT TEXT067 "Few details of any sea-going craft escape your trained eye. You note that although Mortice's raft is made of oak planks, which is a heavy wood, it floats surprisingly light in the water. This is especially odd given that the raft also carries the burden of a man, a full rain barrel, and a large chest of provisions. You can only conclude there must be something buoyant lashed to the underside of the raft.">
<CONSTANT CHOICES067 <LTABLE "query Mortice about this" "let it lie">>

<ROOM STORY067
	(IN ROOMS)
	(DESC "067")
	(STORY TEXT067)
	(CHOICES CHOICES067)
	(DESTINATIONS <LTABLE STORY124 STORY105>)
	(TYPES TWO-NONES)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT068 "Scared witless by the gargoyle-prow and black sails of Skarvench's ship, the natives will not be easy to convince. Their chief believes the pirates will kill them if they suspect them of lying. In all honesty, you have to admit he is right. You must part with two items to bribe the natives. The will accept two of the following: a sword, a pistol, a wand, an amulet, a ship in a bottle, a conch-shell horn, a bat-shaped talisman, a black kite, a diamond, a toolkit, a healing potion, a bronze helmet, a crucifix, or a dragon ring.">

<CONSTANT STORY068-UNWILLING "You were unwilling to part with two such items.">
<CONSTANT STORY068-UNABLE "You are unable to part with two such items.">

<CONSTANT CHOICES068 <LTABLE "stay here to confront Skarvench" "run off into the jungle">>

<ROOM STORY068
	(IN ROOMS)
	(DESC "068")
	(STORY TEXT068)
	(CHOICES CHOICES068)
	(DESTINATIONS <LTABLE STORY087 STORY049>)
	(TYPES TWO-NONES)
	(PRECHOICE STORY068-PRECHOICE)
	(FLAGS LIGHTBIT)>

<CONSTANT STORY068-GIVELIST <LTABLE SWORD SHARKS-TOOTH-SWORD PISTOL MAGIC-WAND MAGIC-AMULET SHIP-IN-BOTTLE CONCH-SHELL-HORN BAT-SHAPED-TALISMAN BLACK-KITE DIAMOND TOOLKIT HEALING-POTION BRONZE-HELMET CRUCIFIX DRAGON-RING>>

<ROUTINE STORY068-PRECHOICE ()
	<GIVE-FROM-LIST STORY068-GIVELIST STORY068-UNABLE STORY068-UNWILLING 2 ,STORY144>>

<CONSTANT TEXT069 "Capstick has a fine house on Halyard Street, in one of the richest parts of town. Smartening yourselves up to look as respectable as possible, you ignore the sidelong glances and haughty sniffs of the wealthy passers-by, marching straight up to present yourselves at the front door. The servant who answers the door at first mistakes you for beggars, but once you've corrected that small misunderstanding he shows you through his master's study.||Capstick is sitting by the fire with a book. Seeing you, he gives his great belly-shaking laugh and leaps up to greet you, commanding the servant to bring a bottle of sherry.||\"Freshly taken off a Sidonian merchantman,\" he says shortly, lifting his glass to savour the smoky gold liquid before drinking. \"And..\" he smacks his lips, refills your glasses \"all the better for being plundered off one of those rascals, eh?\"||Soon the conversation turns to the matters you discussed aboard the Jewel of Heaven. At this, Capstick's face falls. \"I have sour news,\" he tells you. \"I must sail for Glorianne in two days' time, and so I'll be unable to partner you in your attack on that devil Skarvench. Moreover I've told the tale to several high officials, but no one believes it's true.\"||You give a glum nod. \"Who can blame them, given the source of your information? We are vagabond ex-pirates, which is not the best pedigree for reliable testimony.\"||\"But I believe you, by God!\" He produces an envelope and hands it to you. \"This is a deed of ownership for a sloop that I own in Port Selenice. She's just a small craft, but better than no ship at all. Go to Selenice, get together a crew, and see if you can't beat this Skarvench at his own game.\"||Thanking Capstick for his help, you take your leave. \"I'm only sorry not to be sailing with you,\" are his parting words.">

<ROOM STORY069
	(IN ROOMS)
	(DESC "069")
	(STORY TEXT069)
	(CONTINUE STORY107)
	(ITEM DEED-OF-OWNERSHIP)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT070 "Most of the tavern's customers have scurried off into the night. Nursing your injuries, you stagger through the wreckage and take a stiff swig of rum from an overturned bottle on the bar.||A weak bloody-mouthed spluttering comes from under broken trestle. Stepping over, you haul the chief cut-throat to his feet. With his teeth broken and his little close-set eyes swollen half closed, he doesn't look nearly so tough now -- like a lot of bullies you've known after the fight's been knocked out of them.||\"Skarvench's new ship,\" you say, shaking him. \"What's it called?\"||His eyes flicker open. \"Can't tell you,\" he groans. \"He'd rip my lungs out.\"||You break the rum bottle against the wall and shove it towards his chest. \"He won't be able to find your lungs.\"||The threat breaks what's left of his nerve. In a panic stricken torrent, he blabbers about a ship called the Moon Dog which Skarvench is having built in Port Selenice.||You cast the lout back into the debris. As you go to leave you find the innkeeper, Drood, standing by the doorway, hopping from one foot to the other in agitation. \"Who's going to pay for this damage?\" he wails.||Blutz pushes him aside. \"Don't think of it as damage. Think of it as a free redecoration.\"||With a laugh, the four of you set off along the street.">

<ROOM STORY070
	(IN ROOMS)
	(DESC "070")
	(STORY TEXT070)
	(CONTINUE STORY392)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT071 "The blind man is Greymalkin Smith. Once a pirate himself, he was blinded in powder keg explosion and now ekes out a living running errands around town and swapping gossip for drinks.||You have also seen the three ruffians before. In fact, just a few weeks ago you learned that the governor of Leshand has put a price on their heads.">
<CONSTANT CHOICES071 <LTABLE "talk to Greymalkin" "intervene to stop the ruffians bullying the scholar" "go off to the shipyard">>

<ROOM STORY071
	(IN ROOMS)
	(DESC "071")
	(STORY TEXT071)
	(CHOICES CHOICES071)
	(DESTINATIONS <LTABLE STORY033 STORY052 STORY374>)
	(TYPES THREE-NONES)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT072 "His laughter is the peal of summer thunder. \"Scurry off then, little mice. I mistook you for a sea rats at least!\"||The dolphin and the shark convey you back to the beach where you blew the horn. In awed silence, still stunned by the uncanny adventure, you disembark uncertainly and stagger on weak knees up the shore.">

<ROOM STORY072
	(IN ROOMS)
	(DESC "072")
	(STORY TEXT072)
	(CONTINUE STORY203)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT073 "Grappling hooks hug your vessel to the warship's flank, and marines come swarming over the rail with loud battle-cries. The fighting rages from stem to stern -- the clash of cutlasses, the bangs and acrid smoke of pistol shots, the screams of wounded men. Blood and gunpowder are the smells mingling on the briny breeze this afternoon.||The marines have numbers on their side, but they are pitched against some of the toughest buccaneers on the Carab Sea. Your men know they are fighting for their very lives, since almost every one of them has a price on his head.">

<ROOM STORY073
	(IN ROOMS)
	(DESC "073")
	(STORY TEXT073)
	(PRECHOICE STORY073-PRECHOICE)
	(CONTINUE STORY225)
	(DEATH T)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY073-PRECHOICE ("AUX" (DMG 6))
	<COND (<OR <CHECK-SKILL ,SKILL-SWORDPLAY> <CHECK-SKILL ,SKILL-MARKSMANSHIP>>
		<SET DMG 2>
	)(<CHECK-SKILL ,SKILL-BRAWLING>
		<SET DMG 3>
	)>
	<LOSE-LIFE .DMG DIED-IN-COMBAT ,STORY073>>

<CONSTANT TEXT074 "It is only a matter of minutes before you hear the sound you were dreading: an ominous scraping as the ship lurches to a halt. \"That tears it!\" says Grimes. \"We've run aground.\"||A hasty inspection reveals that you have run the keel onto a sandbank. There is no damage to the hull, but you will have to wait until high tide to get off again. By now the fog is closing tightly around the bay, blotting out any sight of the island.||\"We may as well sit it out until dawn,\" you decide.">

<ROOM STORY074
	(IN ROOMS)
	(DESC "074")
	(STORY TEXT074)
	(CONTINUE STORY366)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT075 "The storm fills the sky and your ship is just a speck in its grip. The rain lashes down out of a darkness blacker than night, drumming the deck. Waves as high as cliffs sweep past, flooding over the side and forcing each man to cling on for dear life. Your orders are drowned out by the palpable roar of the wind, which strains the sails to bursting point. You take the whipstaff yourself and push the prow into the onrushing tumult, seeking the hurricane's heart.||Grimes rushes back, his face contorted with fear. \"Skipper!\" he cries. \"The hurricane must have scattered the Queen's fleet! There's a Gloriannic warship dead across our bows, and the wind's sweeping her straight towards us!\"||You can see the ship between billowing sheets of rain. Her mast is broken and she is careening out of control towards you. You have only seconds in which to avoid a collision.">
<CONSTANT CHOICES075 <LTABLE "tilt the whipstaff to port" "starboard">>

<ROOM STORY075
	(IN ROOMS)
	(DESC "075")
	(STORY TEXT075)
	(CHOICES CHOICES075)
	(DESTINATIONS <LTABLE STORY113 STORY132>)
	(TYPES TWO-NONES)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT076 "To your own amazement as much as your foe's, the weasel suddenly jumps out of your haversack and leaps across the deck to give him a painful bite on the hand. Skarvench drops the taper with a startled oath: \"Agh! Devil take the animal!\"||He seizes the weasel by its neck and casts it off over the side, but its attack has bought you the time you need to close in. Now you are face to face with Skarvench in a battle to the finish.">

<ROOM STORY076
	(IN ROOMS)
	(DESC "076")
	(STORY TEXT076)
	(CONTINUE STORY171)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT077 "Skarvench gives a sharp cough as he swigs a shot of rum. \"Guarded?\" he snarls. \"Aye, she'll be guarded. But what if a storm scattered her escort fleet? What then, eh my lads?||\"There'd still be her flagship to contend with, Cap'n\" objects the quartermaster. \"The Rose, I'm told it's called -- a ship of eighty cannon!\"||\"It's possible to pluck a rose, me hearties!\" rejoins Skarvench with a peal of harsh laughter. \"Specially when she lies becalmed, shrouded in mist with no target for her guns.\"||\"But what's this talk of mist and dead calm?\" queries Borograve the master gunner. \"I thought the plan rested on a storm?\"||\"It all relies too much on chance, if you ask me,\" says the first mate.||You tend to agree -- although you never knew Skarvench to trust anything to luck before, not even when playing dice. You are itching to hear how he is going to justify his scheme, but every second you linger here increases the risk of discovery.">
<CONSTANT CHOICES077 <LTABLE "continue to eavesdrop regardless of the danger" "snatch a few supplies from the empty cabin opposite" "go straight back on deck empty-handed">>

<ROOM STORY077
	(IN ROOMS)
	(DESC "077")
	(STORY TEXT077)
	(CHOICES CHOICES077)
	(DESTINATIONS <LTABLE STORY115 STORY096 STORY172>)
	(TYPES THREE-NONES)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT078 "Two more boxes are swiftly opened, their lids splintering under hard shovel-blows. These also contain dead bodies lying on bars of silver. The third gives you particular cause to shudder -- a thin rill of blood has caked on its lips, just as a careless or gluttonous man might leave a dribble of gravy.||\"Vampires!\" gasps Blutz. All together you turn to look at the sun, now almost drowned in the western sea. In mere moments the last of the daylight will have drained away.||Blutz pulls a stick from his belt and thrusts it into your hand. It is the broken stool-leg he got clouted with back in the tavern in Selenice. The end has splintered to leave a sharp point. Sharp enough to pierce a heart, if driven down with courage and strength.||There is just time to impale one of the three corpses you've unearthed. You glance from one to other. Which will it be:">
<CONSTANT CHOICES078 <LTABLE "choose the body with blood on its lips" "the one with a skull tattoo" "the one with ice-blue eyes">>

<ROOM STORY078
	(IN ROOMS)
	(DESC "078")
	(STORY TEXT078)
	(CHOICES CHOICES078)
	(DESTINATIONS <LTABLE STORY169 STORY188 STORY150>)
	(TYPES THREE-NONES)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT079 "As the cannibals close in, things look bleak indeed. Can you possibly outrun them and get the jollyboat out to sea before you are overwhelmed? Then you remember seeing fragments of coloured chalk further up the beach. \"Come on,\" you say urgently, pulling your companions after you, \I've got an idea.\"||The cannibals follow in sullen silence as you retreat along the beach. Pretending to stumble, you gather pieces of pink chalk as you go and use these to daub spots on your skin. At first the others think you've lost your wits, but then Blutz sees what you have in mind. \"They'll think we're plague ridden!\" he cries. \"They certainly won't want to eat us then!\"||The four of you crouch shivering beside your boat as he cannibals come striding up. At first the look on their faces is one of ravenous glee, but this soon changes to horror when they get close enough to see the ugly blotches on your skin. The shivering helps to make it look as though you have a fever, but in fact there is no need for pretence -- you really are quaking in fear by now.||You give a ghastly moan and start to foam convincingly at the mouth. This is more than enough for the cannibals. Flinging down their weapons, they run off. Once they are out of sight along the beach, you get up and examine what they have left behind. Along with a profusion of spears and clubs, you find a feather shield and a shark's tooth sword. The latter is a blade of hardwood edged with shark's teeth -- unconventional but it serves as well as a normal sword.">
<CONSTANT TEXT079-CONTINUED "The others have lost no time getting the boat into the water. Hurrying in case the cannibals should realise they've been tricked and return, you put to sea.">

<ROOM STORY079
	(IN ROOMS)
	(DESC "079")
	(STORY TEXT079)
	(PRECHOICE STORY079-PRECHOICE)
	(CONTINUE STORY116)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY079-PRECHOICE ()
	<SELECT-FROM-LIST <LTABLE FEATHER-SHIELD SHARKS-TOOTH-SWORD> 2 2>
	<CRLF>
	<TELL TEXT079-CONTINUED>
	<TELL ,PERIOD-CR>>

<CONSTANT TEXT080 "Moving with no more noise than a snake, you edge through the undergrowth until you are close enough to hear what Skarvench and the others. While the two seamen sweat over their spades, heaving up great clods of earth, Skarvench passes the grog bottle around and recounts his scurvy plans.||\"So what's this treasure for, Cap'n?\" hiccups the quartermaster.||\"To reward a certain shipwright in Port Selenice, for one thing,\" says Skarvench.\"He's to be paid in gold for the new ship he's building us.\"||\"New ship?\" says Porbuck the mate, roused from his dull-witted torpor. \"I liked the old one.\"||Skarvench ignores him. \"And the silver's for the Queen's wizard, William wild. He'll be supplying special sails for our new vessel -- aye, and a bit o' trickery into the bargain to ensure we take the Rose unhindered, me hearties!\" And he gives a low chuckle of perfect wickedness at the thought.||The scheming dog! His monstrous arrogance makes your blood boil.">
<CONSTANT CHOICES080 <LTABLE "wait until they have taken the treasure aboard their ship and sailed off" "risk attacking them in your weakened state">>

<ROOM STORY080
	(IN ROOMS)
	(DESC "080")
	(STORY TEXT080)
	(CHOICES CHOICES080)
	(DESTINATIONS <LTABLE STORY288 STORY267>)
	(TYPES TWO-NONES)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT081 "A torrent of red fire crackles around Ejada but she stands steadfast, weathering the onslaught. Your spell fades leaving her charred and withered like a burnt wooden effigy. But then, in front of your astonished gaze, she rapidly regenerates and in seconds is completely unscathed!||\"My mother's gift to her daughter: unending vitality,\" she explains with a triumphant smile. Then with a gesture she causes fists of rock to rip up out of the ground and pummel.">
<CONSTANT CHOICES081 <LTABLE "run away now" "continue the duel with either a whirlwind spell" "a darkness spell">>

<ROOM STORY081
	(IN ROOMS)
	(DESC "081")
	(STORY TEXT081)
	(CHOICES CHOICES081)
	(DESTINATIONS <LTABLE STORY005 STORY062 STORY100>)
	(TYPES THREE-NONES)
	(PRECHOICE STORY081-PRECHOICE)
	(DEATH T)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY081-PRECHOICE ("AUX" (DMG 6))
	<COND (<IN? ,FEATHER-SHIELD ,PLAYER> <SET DMG <- .DMG 3>>)>
	<COND (<CHECK-SKILL ,SKILL-CHARMS> <SET DMG <- .DMG 1>>)>
	<COND (,RUN-ONCE <LOSE-LIFE .DMG DIED-EJADA-SORCERY ,STORY081>)>>

<CONSTANT TEXT082 "\"She was El Draque's ship,\" says Kemp. \"A fine stout vessel. I did some work on her once. Curious to choose a bat as your figurehead, but that was El Draque for you. Those scarlet sails can't have been cheap, either. I hear he was captured by the Gloriannic Navy and hanged at sea for his crimes -- though what became of the Grue, I can't say.\"||Kemp has other customers to attend to, so you bid him good day and walk back to town.||\"Where to now?\" says Oakley.||You think for a moment. \"We'll take rooms at the Sweat o' the Brow inn. If Skarvench shows his face anywhere in Selenice, it'll be there.\"||You have never spoken a truer word, for no sooner have you stepped through the doorway of the inn than you are rooted to the spot in shock. There the fiend stands, large as life in front of you. A rum bottle is clutched in his hand and his crew throng the tap-room around him, cowering as he subjects them to one of this thunderous drunken rants.||Then his eye alights on you. His snarling voice is cut off in mid-sentence. A thin line of spittle runs down into his beard as his teeth show shark-like in a vicious grin. It is the moment you have waited for. Face to face with your dearest foe.">

<ROOM STORY082
	(IN ROOMS)
	(DESC "082")
	(STORY TEXT082)
	(CONTINUE STORY014)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT083 "Touching your magical amulet, you utter the words of a brief incantation that will deflect any curse the mermaid might attempt.||At this she pouts. \"Such crude magic.\"||\"Crude, perhaps, my  lady,\" you return with a gallant flourish, \"but I have always found it no less effective for that\"">
<CONSTANT CHOICES083 <LTABLE "bring her under hypnotic control" "tell Blutz to let her go at once" "ask her what lies ahead on your journey" "ask her about the best course you can take to Port Leshand">>

<ROOM STORY083
	(IN ROOMS)
	(DESC "083")
	(STORY TEXT083)
	(CHOICES CHOICES083)
	(DESTINATIONS <LTABLE STORY102 STORY121 STORY140 STORY159>)
	(REQUIREMENTS <LTABLE SKILL-SPELLS NONE NONE NONE>)
	(TYPES <LTABLE R-SKILL R-NONE R-NONE R-NONE>)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT084 "Most of the hands are just bare bone, but a couple still show traces of skin and sinew. One even wears a gold ring, though none of you cares o fish it out of the tank. \"I'm glad we haven't drunk from this,\" says Oakley quietly, closing the lid. \"No wonder the captain prefers wine. It could fair kill a bloke's thirst for fresh water, it could.\"||\"Here's what did the job,\" announces Grimes, picking something up off the deck. He hands it to you: a long-bladed butcher's cleaver.||\"I'm for leaving right now,\" declares Blutz, quaking with fear. But as he tries to climb back down the jolly boat moored alongside, he makes an ominous discovery. \"I can't get over the rail. It's as if some supernatural force is tugging me back!\"||The same applies to the rest of you. \"The ship is cursed,\" says Grimes. \"And now shipmates, we're cursed too.">
<CONSTANT CHOICES084 <LTABLE "make repairs to the boat using" "or a" "use" "otherwise">>

<ROOM STORY084
	(IN ROOMS)
	(DESC "084")
	(STORY TEXT084)
	(CHOICES CHOICES084)
	(DESTINATIONS <LTABLE STORY103 STORY103 STORY122 STORY141>)
	(REQUIREMENTS <LTABLE SKILL-SEAFARING TOOLKIT SKILL-CHARMS NONE>)
	(TYPES <LTABLE R-SKILL R-ITEM R-SKILL R-NONE>)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT085 "Before long the others call to you, saying they have collected a goodly share of barnacles and other succulent shellfish from the shore of the island. You have meanwhile been strolling around in search of fresh water, but every single pool that has formed in depressions in the rock has turned out to be full of brine.||Suddenly there is a shuddering underfoot. The whole island begins to shake. Your companions utter cries of alarm and you see them run towards the boat, abandoning their pile of shellfish. \"It's sinking into the sea!\" screeches Blutz. \"Hurry or we'll be drowned!\"||Out of the corner of your eye you see something break the surface of the sea. You turn watching aghast as it rises high up into the air. It is sharp and huge, its serrated edge casting an orange-red shadow across the sky. As it flexes open and closed, you stare at it dumbfounded. And then you realise what it is: a giant pincer.||The shock almost makes you pass out. This is no island. You're on the back of a gigantic crab.">

<ROOM STORY085
	(IN ROOMS)
	(DESC "085")
	(STORY TEXT085)
	(PRECHOICE STORY085-PRECHOICE)
	(CONTINUE STORY142)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY085-PRECHOICE ()
	<COND (<CHECK-SKILL ,SKILL-AGILITY> <STORY-JUMP ,STORY123>)>>

<CONSTANT TEXT086 "Maybe it is ungracious to harbour suspicions about Mortice when he has been kind enough to feed you. All the same, you cannot help but notice certain disquieting facts. For one thing, the supply of food and water he has left is amazing given that he shows every sign of having been adrift for weeks. Also, he declined to eat or drink anything himself while you were eating, not even joining your toast at the end of the meal. His bald statement on the subject was, \"I never drink grog.\" That is a very odd thing for any seaman to say. Finally, his insistence at getting a formal invitation to board your boat, along with the fact that he apparently finds the moonlight rather bright for his eyes, is little short of sinister.||On the other hand, maybe you've just been at this game too long. Its your choice --">
<CONSTANT CHOICES086 <LTABLE "invite him aboard" "let him spend the night where he is">>

<ROOM STORY086
	(IN ROOMS)
	(DESC "086")
	(STORY TEXT086)
	(CHOICES CHOICES086)
	(DESTINATIONS <LTABLE STORY143 STORY162>)
	(TYPES TWO-NONES)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT087 "Skarvench's face twists into a broad smile as he sees you striding along the foreshore towards him. But it is a smile to make your blood run with ice: the smile on a wolf's face before it seizes its prey.||\"Ah, so you blokes have fared well!\" he thunders. \"Still hale and hearty, I see. And glad I am to see it, for I wanted to savour your deaths meself. Just knowing you'd been drowned would have left me inconsolable, like.\"">
<CONSTANT CHOICES087 <LTABLE "fight him here and now" "use" "use" "bide your time">>

<ROOM STORY087
	(IN ROOMS)
	(DESC "087")
	(STORY TEXT087)
	(CHOICES CHOICES087)
	(DESTINATIONS <LTABLE STORY182 STORY315 STORY334>)
	(REQUIREMENTS <LTABLE NONE THUNDERCLOUD-FAN BAT-SHAPED-TALISMAN NONE>)
	(TYPES <LTABLE R-NONE R-ITEM R-ITEM R-NONE>)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT088 "Rumours abound in a port like Leshand. Some are mere gossip, some are tall tales, some are outright lies -- and a very few are the gospel truth. The trick lies in telling the difference.||You keep your ear to the ground for a day or two, trawling the taverns on the lookout for information. What are are you interested in finding out about?">
<CONSTANT CHOICES088 <LTABLE "look for rumours concerning the pirate El Draque" "information on Queen Titania's state visit" "hear news of Skarvench">>

<ROOM STORY088
	(IN ROOMS)
	(DESC "088")
	(STORY TEXT088)
	(CHOICES CHOICES088)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(PRECHOICE STORY088-PRECHOICE)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY088-PRECHOICE ()
	<COND (<CHECK-SKILL ,SKILL-STREETWISE>
		<PUTP ,STORY088 ,P?DESTINATIONS <LTABLE STORY164 STORY202 STORY278>>
		<PUTP ,STORY088 ,P?REQUIREMENTS <LTABLE SKILL-STREETWISE SKILL-STREETWISE SKILL-STREETWISE>>
		<PUTP ,STORY088 ,P?TYPES <LTABLE R-SKILL R-SKILL R-SKILL>>
	)(ELSE
		<PUTP ,STORY088 ,P?DESTINATIONS <LTABLE STORY183 STORY221 STORY297>>
		<PUTP ,STORY088 ,P?REQUIREMENTS NONE>
		<PUTP ,STORY088 ,P?TYPES THREE-NONES>
	)>>

<CONSTANT TEXT089 "\"You've given me a cannon-load o' trouble,\" says Skarvench. \"Here's where I pay you back -- with my trusty basilisk here.\"||You glance down to see that he is standing beside a cannon which is pointing straight at you. Skarvench shows you the lighted taper in his hand.||\"You despicable cur!\" you snarl. \"You've no stomach for facing me at close quarters, I see.\"||\"Stow your bluster, mate,\" he sneers. \"Here's where you retire to a safe distance. Thirty fathoms down!\"">
<CONSTANT CHOICES089 <LTABLE "use a pistol" "amulet" "just plain" "otherwise">>

<ROOM STORY089
	(IN ROOMS)
	(DESC "089")
	(STORY TEXT089)
	(CHOICES CHOICES089)
	(DESTINATIONS <LTABLE STORY095 STORY114 STORY133 STORY152>)
	(REQUIREMENTS <LTABLE SKILL-MARKSMANSHIP SKILL-CHARMS SKILL-AGILITY NONE>)
	(TYPES <LTABLE R-SKILL R-SKILL R-SKILL R-NONE>)
	(PRECHOICE STORY089-PRECHOICE)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY089-PRECHOICE ()
	<COND (<IN? ,WEASEL ,PLAYER> <STORY-JUMP ,STORY076>)>>

<CONSTANT TEXT090 "You fetch a foaming stoop of ale. After fastidiously transferring the contents to his odd saucer-shaped goblet, he turns his blind gaze on you. \"You were with that Skarvench, weren't ye?\"||\"How did you --?\" begins Blutz.||He holds up his hand. \"I hears a thing or two. Like about Skarvench doin' in old Marshy. I sailed with Marshy, lads, once upon a time, and Skarvench weren't fit to spit upon his shoes. Talkin' of Skarvench, you know the new ship he's had built, the Moon Dog? Fitted with silver sails that came in a crate all the way from Glorianne. An' why did Skarvench keep askin' around about full moons an' cloud cover an' such -- ain't tide tables good enough for him no more? Makes you wonder, mates. Is it lunacy, or is there method in his madness?\"||He's a fine one to talk about lunacy,\" whispers Grimes as you get up to leave.||\"I heard that too!\" screeches Greymalkin after you. \"Ye'd do well to pay heed to what I told you, if ye want to live. Watch out for that basilisk he had shipped aboard an an' all.\"">
<CONSTANT CHOICES090 <LTABLE "step in to save the scholar from being bullied" "go to the shipyard">>

<ROOM STORY090
	(IN ROOMS)
	(DESC "090")
	(STORY TEXT090)
	(CHOICES CHOICES090)
	(DESTINATIONS <LTABLE STORY052 STORY374>)
	(TYPES TWO-NONES)
	(EVENTS STORY090-EVENTS)
	(PRECHOICE STORY090-PRECHOICE)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY090-EVENTS ()
	<CHARGE-MONEY 1>
	<PRESS-A-KEY>
	<RETURN ,STORY090>>

<ROUTINE STORY090-PRECHOICE ()
	<COND (<CHECK-SKILL ,SKILL-FOLKLORE>
		<STORY-JUMP ,STORY385>
	)(<CHECK-SKILL ,SKILL-SEAFARING>
		<STORY-JUMP ,STORY109>
	)>>

<CONSTANT TEXT091 "A key that no-one can see or touch? A riddle set by an ocean god is a mere trifle for an artful trickster like yourself. Pursing your lips, you whistle a few bars of a jaunty tune. To the amazement of others, this causes the chain to unlock itself and fall aside, giving you admittance to the harbour.||You spread your hands and take a bow. \"It was the key of C,\" you explain with a smile.">

<ROOM STORY091
	(IN ROOMS)
	(DESC "091")
	(STORY TEXT091)
	(CONTINUE STORY205)
	(FLAGS LIGHTBIT)>

<ROOM STORY092
	(IN ROOMS)
	(DESC "092")
	(EVENTS STORY092-EVENTS)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY092-EVENTS ()
	<COND (<CHECK-CODEWORD ,CODEWORD-ICARUS> <RETURN ,STORY130>)>
	<RETURN ,STORY149>>

<CONSTANT TEXT093 "With your every thought focussed on the goal of finding the iceberg, you are blinded to the stirrings of mutiny. Oakley, Grimes and Blutz come to your cabin. Although you are all old comrades, they seem nervous in the face of your driving obsession. \"Skipper,\" begins Oakley, \"the crew are discontent. They fear you'll sail us off the edge of the world.\"||\"Edge of the world? Pah!\" you fling your charts down and take a swig of rum. \"It's a thousand leagues from here, at least.\"||\"I don't care for the look on their faces, Cap'n,\" presses Grimes. \"They look like mourners at a funeral -- our funeral, if you won't turn back.\"||You give a sour scowl. \"And you, Mister Blutz? Are you party to this insubordination too?\"||\"I'd sail with you to hell, skipper, if you asked me,\" replies Blutz. \"It's just... well, I never till now though you'd ask!\"||Suddenly the door crashes in. The crew stand there with drawn swords, the bo'sun at their head. \"Out on deck,\" he growls. \"'Tis time we settled this.\"||You and your comrades are hauled up and tied. A plank is fixed out over the side of the ship. Even now, it is livid rage rather than fear that consumes you. You curse them for their perfidy, but to no avail. With a sword at your back, you are forced to climb over the rail and walk until you run out of plank...">

<ROOM STORY093
	(IN ROOMS)
	(DESC "093")
	(STORY TEXT093)
	(DEATH T)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT094 "It seems like hours. At last the storm blows over. The full moon appears -- a blazing white beacon. The clouds go draining away like pools of quicksilver in the vast dark blue dish of the sky.||\"Ship ahoy!\@ cries the lookout. \"She's the Rose!\"||It is indeed the Queen's proud flagship, her spars snapped and rigging torn from the storm she's just weathered. Even so, she is a daunting oaken fortress on the slow swell of the ocean. There is no sign of the escort fleet -- presumably scattered or sent to the deeps by the recent hurricane. You order a cautious approach, wary in case the Rose's gunners open fire on you out of panic.||But this uncanny night still has surprises in store, it seems. As you draw closer to the drifting Rose, thick white fog boils out from nowhere and spreads rapidly across the sea. Within a minute it has entirely obscured your view of the ship. You gaze out at the blanket of fog, luminous in the moonlight, sitting on the waters like a malevolent entity. Tendrils drift across your own deck, and the crew look up at you with expressions of confusion and fear.||You sniff the air. \"There's a smell of sorcery here, my lads,\" you say to the others.||\"Look up there!\" cries one of the sailors, and suddenly there is a moan of awestruck amazement from everyone on deck. You lift your eyes towards the sky and feel a sudden chill of supernatural dead. Sailing down out of the scattered clouds, her silver sails filled with lunar light, comes Skarvench's enchanted galleon: the Moon Dog.">
<CONSTANT CHOICES094 <LTABLE "use" "use" "otherwise">>

<ROOM STORY094
	(IN ROOMS)
	(DESC "094")
	(STORY TEXT094)
	(CHOICES CHOICES094)
	(DESTINATIONS <LTABLE STORY151 STORY170 STORY208>)
	(REQUIREMENTS <LTABLE BAT-SHAPED-TALISMAN BLACK-KITE NONE>)
	(TYPES <LTABLE R-ITEM R-ITEM R-NONE>)
	(PRECHOICE STORY094-PRECHOICE)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY094-PRECHOICE ()
	<COND (<AND <CHECK-CODEWORD ,CODEWORD-HORAL> <IN? ,POCKET-WATCH ,PLAYER>> <STORY-JUMP ,STORY189>)>>

<CONSTANT TEXT095 "Calmly levelling your pistol, you shoot the end off the taper. \"By all that's unholy!\" sears Skarvench. \"I never seen such a shot!\"||Neither have you, but you do not let surprise cost you your momentary advantage. You race in before Skarvench can relight the fuse, and in seconds the two of you are locked in a fight to death.">

<GLOBAL STORY095-MARKSMANSHIP-FLAG F>

<ROOM STORY095
	(IN ROOMS)
	(DESC "095")
	(STORY TEXT095)
	(PRECHOICE STORY095-PRECHOICE)
	(CONTINUE STORY171)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY095-PRECHOICE ()
	<SETG STORY095-MARKSMANSHIP-FLAG T>>

<CONSTANT TEXT096 "You hurry into the cabin, startling the pet monkey which is perched on the bunk. Immediately it starts jumping up and down, chittering wildly, and the only thing you can do is grab it and stuff it into your haversack. Praying that no-one heard the noise, you head up on deck.">

<ROOM STORY096
	(IN ROOMS)
	(DESC "096")
	(STORY TEXT096)
	(CONTINUE STORY172)
	(ITEM MONKEY)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT097 "Taking turns at the oars, you row westwards  under the glare of a fierce sun. Soon your lips are parched, your necks blistered red in the heat. Everyone's spirits were at first buoyed up by the relief you felt at escaping from Skarvench's grasp, but soon you begin to wilt with the awful gnawing of discouragement and doubt. Will you survive long enough to reach land, or will the little jollyboat become your floating coffin?">
<CONSTANT TEXT097-CONTINUED "Around noon of the second day you catch sight of Red Skull Island. \"Well?\" mutters Grimes through thirst-blackened lips. \"Do we risk going ashore? There might be fresh water... and food.\"||\"Aye says Oakley.\" \"And it's us that might be the food, if there are cannibals in these parts.\"||They look to you to make the final decision.">
<CONSTANT CHOICES097 <LTABLE "go ashore" "sail on towards the next island">>

<ROOM STORY097
	(IN ROOMS)
	(DESC "097")
	(STORY TEXT097)
	(CHOICES CHOICES097)
	(DESTINATIONS <LTABLE STORY173 STORY116>)
	(PRECHOICE STORY097-PRECHOICE)
	(TYPES TWO-NONES)
	(DEATH T)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY097-PRECHOICE ()
	<COND (<CHECK-SKILL ,SKILL-WILDERNESS-LORE>
		<EMPHASIZE "You soaked your clothes in the water to protect yourself from the heat.">
	)(ELSE
		<COND(,RUN-ONCE <LOSE-LIFE 1 RAGGED-CLOTHES ,STORY097>)>
	)>
	<IF-ALIVE TEXT097-CONTINUED>>

<CONSTANT TEXT098 "The chief of the islander arrives. He is a very big man adorned in feathers and glass trinkets, with a weathered grey face like a carving in driftwood. Dipping his finger in a coconut-shell dish carried by an attendant, he proceeds to draw a design on your face in red dye.||\"It's just like the warpaint of these natives,\" says Grimes, looking at you. \"I wonder what that means?\"||\"Maybe he's inviting me to join the tribe,\" you say with a wry smile.||Next the tribal shaman comes forward and draws a picture in the sand with his long bony fingers. It shows a woman with a scorpion crown. He spits on the picture, then lifts his ceremonial sceptre and points westwards. The chief says something which sounds like, \"Matya Ejada niyu,\" and each of the islanders in turn nods and repeats the words before stamping on the picture. Before long the image is completely lost in the scuffed sand.||\"A curious little ritual,\" remarks Oakley. \"Now, why don't we shove off, mates before we outstay our welcome?\"||You have to agree. Clambering into the boat, you row off watched by the horde of silent islanders. \"You're not going to leave that warpaint on your face, are you?\" Oakley asks when you are well clear of the shore. \"It makes you look like a ruddy heathen.\"">

<ROOM STORY098
	(IN ROOMS)
	(DESC "098")
	(STORY TEXT098)
	(CONTINUE STORY116)
	(PRECHOICE STORY098-PRECHOICE)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY098-PRECHOICE ()
	<CRLF>
	<TELL "Wash off the dye before it dries?">
	<COND (<NOT <YES?>>
		<GAIN-CODEWORD ,CODEWORD-SCRIP>
	)>>

<CONSTANT TEXT099 "Recognizing its former master, the little animal suddenly slips out of your grasp, bursts from the undergrowth and goes scampering towards him. Skarvench and his men leap up and seize their weapons, instantly alert. Standing rigid with a snarl stamped on this cruel face, Skarvench scans the jungle and then his eyes lock on yours despite the cover of foliage. You realise the game is up -- he's spotted you. You rise to your feet with a defiant battle-cry as he levels his pistol. Thirty paces separate you -- a distance you might cover in six seconds, from a standing start. A bullet can cross it in an instant...||Just as Skarvench squeezes the trigger, the monkey leaps up and gives his wrist a painful nip. He bellows in range and the shot goes wide, whistling past your ear to embed itself in the bole of a tree. But you have no time to give thanks; within moments the pirates have closed in. The battle is joined, and you and your comrades are fighting for your lives.">

<ROOM STORY099
	(IN ROOMS)
	(DESC "099")
	(STORY TEXT099)
	(PRECHOICE STORY099-PRECHOICE)
	(CONTINUE STORY023)
	(DEATH T)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY099-PRECHOICE ()
	<COND (<AND <CHECK-SKILL ,SKILL-SWORDPLAY> <CHECK-SKILL ,SKILL-MARKSMANSHIP>>
		<LOSE-LIFE 7 DIED-IN-COMBAT ,STORY099>
	)(<AND <CHECK-SKILL ,SKILL-BRAWLING> <CHECK-SKILL ,SKILL-MARKSMANSHIP>>
		<LOSE-LIFE 8 DIED-IN-COMBAT ,STORY099>
	)(ELSE
		<EMPHASIZE "You are quickly slain.">
	)>>

<CONSTANT TEXT100 "Utter blackness falls like an iron door. You can hear your foe raging blindly, casting deadly bolts of occult force at random into the dark in her frenzied efforts to slay you.">
<CONSTANT CHOICES100 <LTABLE "follow up your advantage with a whirlwind spell" "else take advantage of the cover of darkness to sneak back to the boat">>

<ROOM STORY100
	(IN ROOMS)
	(DESC "100")
	(STORY TEXT100)
	(CHOICES CHOICES100)
	(DESTINATIONS <LTABLE STORY062 STORY195>)
	(TYPES TWO-NONES)
	(PRECHOICE STORY100-PRECHOICE)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY100-PRECHOICE ()
	<COND (<CHECK-SKILL ,SKILL-ROGUERY> <STORY-JUMP ,STORY176>)>>

<CONSTANT TEXT101 "Only one thing can save you and your comrades now. You must summon a rainstorm to provide you with the drinking water you so desperately need. But despite the dire straits you are now in, you cannot help hesitating. Conjuring with the weather is a risky business at best of times. The slightest slip can turn a breeze into a typhoon, or a scatter of snowflakes into a raging blizzard. You remember a time years ago, when you were just an apprentice wizard. You tried to conjure a sunny afternoon so you could go picnicking, only to start a three-week heat wave that burnt the fields brown and reduced rivers to muddy trickles.||You gaze a the wand in your hand. Mistakes like that are a long way in your past; you are an accomplished sorcerer now. On the other hand, the hurricane season is looming just a month away, and that makes the risk in summoning a storm particularly high.||\"What are you waiting for?\" says Blutz. \"We'll die without fresh water.\"||\"And what if rain swamps our boat and it sinks?\" you ask him. \"We'll be just as dead.\"||Decide.">
<CONSTANT CHOICES101 <LTABLE "try conjuring rain" "not">>

<ROOM STORY101
	(IN ROOMS)
	(DESC "101")
	(STORY TEXT101)
	(CHOICES CHOICES101)
	(DESTINATIONS <LTABLE STORY010 STORY120>)
	(TYPES TWO-NONES)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT102 "\"Give me a hand!\" says Blutz. \"She's as slippery as a salmon.\"||The mermaid thrashes in his grasp, churning up sea-foam with her powerful tail, but Oakley and Grimes hurry to help, holding her fast until you can complete your spell. You chant the words. Her eyes glaze like frost; her struggling ceases. For a brief time, the magic makes her your slave.||\"What is our best route home?\" you demand of her.||\"Home?\" she says dully, speaking as though in deep sleep. \"Where is home?\"||\"The far west. Port Leshand.\"||\"Sail on your present course if you fear neither weird dooms nor fierce weather. Steer south if a witch's hospitality does not daunt you. West to face rain and wind and the nightmare ship; south to see the earth god's daughter.\"||There is along pause while you all weigh up these words. \"Er, perhaps not as lucid as we might've hoped...\" says Grimes.||\"The best we'll get from a faerie creature, enthralled or not,\" you tell him. You dismiss the mermaid, breaking the spell with a snap of your fingers.">

<ROOM STORY102
	(IN ROOMS)
	(DESC "102")
	(STORY TEXT102)
	(CONTINUE STORY178)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT103 "You get the others' help in hooking the jollyboat's mooring rope and winching it up onto the desk by means of pulleys attached to the ship's yardarm. \"At least we can make sure our little craft is seaworthy,\" you tell the others as you bend to examine whatever damage the boat has taken during the days you have spent on the open ocean.||\"Are you stark mad?\" says Oakley. \"We're trapped aboard a cursed ship, and all you find to do is fiddle with the damned jollyboat!\"||You hum a few bars of a sea shanty, then look up from your work with a relaxed grin. \"Let's think of a plan while we fix our boat up, mates. That way we'll be ready to jump ship when the chance comes our way.\"">

<ROOM STORY103
	(IN ROOMS)
	(DESC "103")
	(STORY TEXT103)
	(PRECHOICE STORY103-PRECHOICE)
	(CONTINUE STORY122)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY103-PRECHOICE ()
	<COND (<CHECK-CODEWORD ,CODEWORD-DETRUDE> <REMOVE ,CODEWORD-DETRUDE>)>
	<COND (<CHECK-CODEWORD ,CODEWORD-PECCANT> <REMOVE ,CODEWORD-PECCANT>)>>

<CONSTANT TEXT104 "Certain features of this island are ominously reminiscent of an old sea-myth concerning the giant crab Pusat Tassek. This crab is said to be as big as a house. It basks in mid-ocean with the top of its shell exposed, sometimes staying in one place so long that sands gathers on its back and plants start to grow there, all the while feeding on fish that it attracts to its maw with a sweet-smelling chemical secretion.">
<CONSTANT CHOICES104 <LTABLE "stay here to look for food" "put to sea, either heading on your previous course westward" "turning north towards the Smoking Islands">>

<ROOM STORY104
	(IN ROOMS)
	(DESC "104")
	(STORY TEXT104)
	(CHOICES CHOICES104)
	(DESTINATIONS <LTABLE STORY085 STORY047 STORY066>)
	(TYPES THREE-NONES)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT105 "\"So,\" says Mortice as you settle down to sleep, \"are you going to invite me aboard your boat, or leave me here on my blessed raft all night?\"||Oakley smiles at him. \"Are you standing on ceremony, mate? Waiting for a bloody invite?\"||Mortice takes ill against this joking retort. \"Aye,\" he growls, spitting into his beard. \"An invite's just what I'm after. Well, haven't ye dined like lords at my expense until you're as full as farmyard geese? Call me over, damn your veins!\"||Blutz is understandably not keen to sleep beside a lunatic, no matter how charitable. He turns to you and mutters under his breath, \"Well, our boat's pretty cramped already -- and no more comfortable than his raft, I'd say.\"||\"What's that whispering?\" snarls Mortice, stamping his foot. \"Secrecy and distrust!\" Is this how you repay a bit o' kindness, eh? Come on, will you ask me aboard or not?||\"||\"Ask the skipper,\" says Grimes, nodding towards you.">
<CONSTANT CHOICES105 <LTABLE "either ask Mortice to come aboard" "let him stay on his raft">>

<ROOM STORY105
	(IN ROOMS)
	(DESC "105")
	(STORY TEXT105)
	(CHOICES CHOICES105)
	(DESTINATIONS <LTABLE STORY143 STORY162>)
	(TYPES TWO-NONES)
	(PRECHOICE STORY105-PRECHOICE)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY105-PRECHOICE ()
	<COND (<CHECK-SKILL ,SKILL-FOLKLORE> <STORY-JUMP ,STORY086>)>>

<CONSTANT TEXT106 "The clouds are black banners across the scarlet of sunset when, gazing into the face of approaching night, you spy a billowing sail gleaming wanly in the dusk. A ship bound for Leshand! Jumping to your feet, shouting and waving, you wait anxiously until an answering hail tells you they've seen you. The ship comes nearer, her prow sliding though the twilit waters, her sails pinned like sheets of gold against the darkening sky. Faces look down from the rail, and a rope ladder is lowered. You climb rapidly despite your fatigue, gladdened by the friendly speech of the sailors.||A hand grasps yours and helps you up. \"Welcome aboard the Jewel of Heaven,\" says a Gloriannic voice. You do not reply at once, but fall on your knees alongside Oakley and the others, thanking almighty God for deliverance from the brink of doom.">

<ROOM STORY106
	(IN ROOMS)
	(DESC "106")
	(STORY TEXT106)
	(CONTINUE STORY370)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT107 "Finding a secluded snug in a tavern away from the docks, you consult with your friends as to what your next move should be.||Blutz is all for telling the authorities what you know, \"They're in a better position than we are to protect Queen Titania,\" he argues.||\"I disagree,\" says Grimes, \"An opportunity like this won't quickly come our way again. It's like the tide: take it at the flood and fortune follows; wait till it's out and you've missed your boat.\"||\"We should go to Port Selenice,\" says Oakley. \"That's where Skarvench will go next. \"Let's see if we can't steal a march on the fiend and scupper his plans. The Gloriannic authorities will reward us richly, but even more important than that --||\"More important than that, we get our revenge on Skarvench,\" you finish.">
<CONSTANT CHOICES107 <LTABLE "head straight for Selenice" "go to the governor first">>

<ROOM STORY107
	(IN ROOMS)
	(DESC "107")
	(STORY TEXT107)
	(CHOICES CHOICES107)
	(DESTINATIONS <LTABLE STORY145 STORY126>)
	(TYPES TWO-NONES)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT108 "The days pass, balmy and full of ease after your long deprivation. With rest and food you recover quickly from your ordeal.||At last you catch sight of land, and after tacking along the coast for a few hours you arrive at Leshand harbour. A forest of masts sways along the wharf, and the sharp smells of tar and fish waft on the air. As the Jewel of Heaven ties up at the quayside, you are anxious to gather your few belongings and go ashore.||\"Dry land,\" says Oakley, in the tone of a man greeting his long-lost sweetheart. \"I never thought to see it again!\"||The captain and crew are busy with unloading their cargo. You thank them, shaking each man's hand as you press across the deck and make your way down the gangplank.||The dock is a confused bustle, with longshoremen and sailors teeming around and wagons trundling to and fro. Pushing through the milling crowds, you head along a narrow alley in search of an inn.">

<ROOM STORY108
	(IN ROOMS)
	(DESC "108")
	(STORY TEXT108)
	(CONTINUE STORY009)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT109 "The basilisk is the name of a new type of powerful long-range cannon that has recently come into use on Gloriannic warships. They are not easy to obtain, being manufactured exclusively by the Queen's armourers at the Royal Arsenal. If Skarvench really has managed to lay his hands on one, he must have friends in high places at the Gloriannic court.||The commotion at the bar continues.">
<CONSTANT CHOICES109 <LTABLE "intervene" "leave and go off to shipyard">>

<ROOM STORY109
	(IN ROOMS)
	(DESC "109")
	(STORY TEXT109)
	(CHOICES CHOICES109)
	(DESTINATIONS <LTABLE STORY052 STORY374>)
	(TYPES TWO-NONES)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT110 "You lift your wand, occult syllables leaping to the front of your mind like war hounds eager to be unleashed. \"What can be locked can be unlocked,\" you assert. \"I shall open the chain by most potent art.\"||The colossus regards you with his cool majestic eyes. \"But, mortal: the chain is held closed by magic.\"||You laugh. \"Then I'll cast a spell to undo magic!\" No sooner do you, however, than the coracle is swept off away from the harbour at dizzying speed. If not for Blutz catching hold of your coat, you would have been thrown overboard. \"What's happened, skipper?\" he says as the four of you crouch terrified in the bottom of the coracle with the waves crashing against the sides.||\"I forgot,\" you say with a groan. \"It was magic that brought us here in the first place. My spell undid that.\"||It is dawn by the time you reach Selenice. You are flung up onto the shore, and by the time you turn and look out to the sea, the coracle has vanished.">

<CONSTANT CHOICES110 <LTABLE "use both" "a deed given to you by Master Capstick" "diamonds">>

<ROOM STORY110
	(IN ROOMS)
	(DESC "110")
	(STORY TEXT110)
	(CHOICES CHOICES110)
	(DESTINATIONS <LTABLE STORY261 STORY318 STORY299>)
	(REQUIREMENTS <LTABLE <LTABLE CORKSCREW SHIP-IN-BOTTLE> DEED-OF-OWNERSHIP DIAMOND>)
	(TYPES <LTABLE R-ALL R-ITEM R-ITEM>)
	(PRECHOICE STORY110-PRECHOICE)
	(DEATH T)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY110-PRECHOICE ()
	<COND (<OR <AND <IN? ,CORKSCREW ,PLAYER> <IN? ,SHIP-IN-BOTTLE ,PLAYER>>
		<IN? ,DEED-OF-OWNERSHIP ,PLAYER>
		<IN? ,DIAMOND ,PLAYER>>
		<PUTP ,STORY110 ,P?DEATH F>
		<CRLF>
		<TELL "Now you must look for another way to obtain a vessel:">
		<CRLF>
	)(ELSE
		<TELL CR "You have no hope of catching up with Skarvench." CR>
	)>>

<CONSTANT TEXT111 "A rope is slung over the yardarm. The warship captain personally ties the end into a noose. As he puts it over your head, you cannot resist a few futile words of defiance. \"You enjoy your job, don't you?\" you snarl at him.||He gazes back at you coolly. \"I serve my Queen and country. That is all; there's nothing personal about this.\" He turns to the marines holding the end of the rope and gives a curt nod. You are hauled aloft to kick out your life under the shadow of you own ship's yardarm. It is a fate that awaits many pirates, and a far cry from the glorious destiny you dreamed of.">

<ROOM STORY111
	(IN ROOMS)
	(DESC "111")
	(STORY TEXT111)
	(DEATH T)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT112 "You have not long gone off watch, and are sitting in your cabin with a warming cup of grog, when there comes a stifled cry from up on deck. Bone weary, you throw on your cloak and grumpily stomp back up the companion-way. You are on the point of berating Blutz for calling out, certain that he has simply allowed the mist and the desolation of the spot to unnerve him, but the moment you emerge on deck those words choke off in your throat.||Everything is swathed in the eerie greenish mist. Blutz stands amidships, backing away from the rail with little fluttering motions of his hands. You turn and behold the cause of his terror. Coming up over the side is a figure out of a nightmare -- a seaweed-draped corpse clad in robes sodden with sea water. As it climbs over the rail, its angular hunched stance and galvanic spasms of motion put you in mind of a spider's stalking gait. Patches of exposed bone show through the rotted flesh and it has only deep black sockets for eyes. In one hand it holds a rust-blotched sword; the other is rigid like a claw poised to strike.||\"All hands on deck!\" Your voice is a thin reedy screech, strained by stark fear. Even as you hear the bustle of men rushing up from below, more of these ghastly apparitions appear at the rail, and you know that you are in for the toughest battle of your life.">

<ROOM STORY112
	(IN ROOMS)
	(DESC "112")
	(STORY TEXT112)
	(CONTINUE STORY321)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT113 "Your bows smash into the helpless warship with an anguished splintering of timbers. The ship lurches and you see at least one of your crew swept overboard by a titanic wave. He is immediately swallowed up by the storm's fury. There is nothing you can do to save him -- you may not even be able to save yourself.">

<ROOM STORY113
	(IN ROOMS)
	(DESC "113")
	(STORY TEXT113)
	(PRECHOICE STORY113-PRECHOICE)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY113-PRECHOICE ()
	<DAMAGE-SHIP 2 ,STORY094 ,STORY227>>

<CONSTANT TEXT114 "An all-purpose good luck charm is your best chance. Touching your amulet, you mutter the words of the cantrip at the same moment that Skarvench lights the basilisk cannon's fuse. There is a damp spluttering and then -- nothing.||\"Misfire, curse it!\" snarls Skarvench. He pulls his sword from his belt. \"Very well, then, we'll have to settle our business up close an' personal, like.\"">

<ROOM STORY114
	(IN ROOMS)
	(DESC "114")
	(STORY TEXT114)
	(CONTINUE STORY171)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT115 "\"You ask me how I can be sure of Queen Titania's itinerary, my lads?\" growls Skarvench. \"You ask how I can whistle up a storm to scatter her escort fleet, then as quickly becalm her flagship in a bank of fog? And maybe you'll ask how I'll descend from the skies on a rope to whisk the pretty little package away before her soldiers even know what's what? Oh, what a bunch of scurvy doubting dogs you are, to be sure! There's one simple answer to all such cynical questions, and that's this: her wizard, William Wild, is my half-brother. He's  in on the scheme, y'see.\"||You have heard enough. The whole world knows of the court wizard Dr Wild and the boundless trust placed in him by Queen Titania. If he plots betrayal, she is in real danger and not all her soldiers can save her.||A floorboard creaks from further along the passage. You look around sharply. Someone is coming.">
<CONSTANT CHOICES115 <LTABLE "hide in the sailmaster's cabin" "else stand your ground">>

<ROOM STORY115
	(IN ROOMS)
	(DESC "115")
	(STORY TEXT115)
	(CHOICES CHOICES115)
	(DESTINATIONS <LTABLE STORY134 STORY191>)
	(TYPES TWO-NONES)
	(PRECHOICE STORY115-PRECHOICE)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY115-PRECHOICE ()
	<COND (<CHECK-SKILL ,SKILL-AGILITY> <STORY-JUMP ,STORY153>)>>

<CONSTANT TEXT116 "Another day passes, and your voyage becomes an increasing ordeal as heat and fatigue take their toll. The sea sits all about you like a gleaming leaden plate; the sun turns the sky into a furnace of white haze. By night you shiver under the uncaring gaze of a million stars.">

<ROOM STORY116
	(IN ROOMS)
	(DESC "116")
	(STORY TEXT116)
	(PRECHOICE STORY116-PRECHOICE)
	(CONTINUE STORY155)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY116-PRECHOICE ()
	<CONSUME-PROVISIONS 1 ,STORY426>>

<CONSTANT STORY117-GIVELIST <LTABLE SWORD PISTOL MAGIC-AMULET MAGIC-WAND CRUCIFIX TOOLKIT ALL-MONEY>>

<CONSTANT TEXT117 "They bring forward a shield woven of brightly coloured feathers and a wooden sword studded with shark's teeth which they offer in exchange.||Oakley gives a snort of disgust when he sees these. \"They're not worth a tenth of what we gave them!\"||\"Maybe you shouldn't accept these gifts,\" cautions Blutz, catching your sleeve. \"The natives might get angry. Maybe it's just a token gesture and they don't really want to part with them.\"">
<CONSTANT TEXT117-TURNNASTY "They start to turn nasty and you realise you had better run for it.">

<ROOM STORY117
	(IN ROOMS)
	(DESC "117")
	(PRECHOICE STORY117-PRECHOICE)
	(CONTINUE STORY098)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY117-PRECHOICE ("AUX" GIVE-RESULT)
	<SET GIVE-RESULT <GIVE-FROM-LIST STORY117-GIVELIST UNABLE-TO-PART UNWILLING-TO-PART>>
	<COND (<OR <EQUAL? .GIVE-RESULT GIVE-UNWILLING> <EQUAL? .GIVE-RESULT GIVE-UNABLE>>
		<EMPHASIZE TEXT117-TURNNASTY>
		<STORY-JUMP ,STORY041>
	)(ELSE
		<COND (<IN? ,ALL-MONEY ,GIVEBAG>
			<COND (<L? ,MONEY 1>
				<EMPHASIZE TEXT117-TURNNASTY>
				<MOVE ,ALL-MONEY ,PLAYER>
				<STORY-JUMP ,STORY041>
				<RETURN>
			)>
			<SETG ,MONEY 0>
			<UPDATE-STATUS-LINE>
		)>
		<CRLF>
		<TELL TEXT117>
		<CRLF>
		<TELL CR "Take feather shield and shark's tooth sword?">
		<COND (<YES?>
			<TAKE-ITEM ,FEATHER-SHIELD>
			<TAKE-ITEM ,SHARKS-TOOTH-SWORD>
		)>
		<MOVE ,ALL-MONEY ,PLAYER>
	)>>

<CONSTANT TEXT118 "You drag your boat up the beach under the blandly incurious gaze of the paradise-birds. Blutz gives an excited cry and points, saying, \"Look, above the treetops! It's a tower. A ruddy marble tower, mates.\"||He's right. In the declining golden light of the afternoon, you see a gleaming tower of polished stone. Since there are no creepers growing over it, the place is surely inhabited. But do you want to meet the inhabitant?">
<CONSTANT CHOICES118 <LTABLE "head for the tower" "gather food and water" "put to sea immediately">>

<ROOM STORY118
	(IN ROOMS)
	(DESC "118")
	(STORY TEXT118)
	(CHOICES CHOICES118)
	(DESTINATIONS <LTABLE STORY194 STORY232 STORY137>)
	(TYPES THREE-NONES)
	(PRECHOICE STORY118-PRECHOICE)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY118-PRECHOICE ()
	<COND (<CHECK-SKILL ,SKILL-WILDERNESS-LORE> <STORY-JUMP ,STORY213>)>>

<CONSTANT TEXT119 "You suggest that, instead of draining one person's entire soul so that he dies, she contents herself with a quarter of the life force taken from each of you. She considers this, then gives a short regal nod. \"I accept. Step forward , mortals.\"||She lays her knife against the chest of each of you in turn. A cold chill spreads through you as her magic leeches a part of your very soul.">

<ROOM STORY119
	(IN ROOMS)
	(DESC "119")
	(STORY TEXT119)
	(PRECHOICE STORY119-PRECHOICE)
	(CONTINUE STORY137)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY119-PRECHOICE ("AUX" GIVE-RESULT)
	<REPEAT ()
		<TELL CR "You must sacrifice one skill permanently">
		<SET GIVE-RESULT <GIVE-FROM-LIST SKILL-GLOSSARY UNABLE-TO-PART UNWILLING-TO-PART 1 NONE ,SKILLS>>
		<COND (<EQUAL? .GIVE-RESULT ,GIVE-GIVEN>
			<COND (<EQUAL? ,MAX-LIFE-POINTS ,LIFE-POINTS>
				<SETG LIFE-POINTS <- ,LIFE-POINTS 1>>
			)>
			<SETG MAX-LIFE-POINTS <- ,MAX-LIFE-POINTS 1>>
			<EMPHASIZE "You also permanently lose one life point.">
			<UPDATE-STATUS-LINE>
			<RETURN>
		)>
		<EMPHASIZE "But you must!">
		<PRESS-A-KEY>
	>>

<CONSTANT TEXT120 "The days and nights become a flickering blur as you sink deeper into exhausted delirium. Arising from a fever, your eyes aching in your sockets, you behold a beautiful woman gliding across the dead calm of the sea. Her hair is the colour of honey and her skin is so white that it makes her lips blaze like rubies. Reaching you, she bends down and lifts you out of the boat as though you're weightless. Indeed, after your long ordeal your body has now become little more than skin stretched taught over bone. Borne higher and higher into the air, you realise with a curious detachment that you are not in a woman's arms at all, but in a kind of rope sling...||Now you come properly awake, opening your eyes to find yourself on the deck of a ship. You are surrounded by sailors. One of them bends down and cradles your head, putting a cup of water to your lips.||\"Where...? you croak feebly.||\"On board the Jewel of Heaven,\" he replies. \"Now drink.\"||The water stings your shrivelled lips, runs like acid in your throat. After a few sips a wave of weakness enfolds you and you pass out.">

<ROOM STORY120
	(IN ROOMS)
	(DESC "120")
	(STORY TEXT120)
	(PRECHOICE STORY120-PRECHOICE)
	(DEATH T)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY120-PRECHOICE ()
	<COND (<IS-ALIVE 2>
		<PUTP ,STORY120 ,P?DEATH F>
		<STORY-JUMP ,STORY370>
	)(ELSE
		<EMPHASIZE "You never recover consciousness: you're beyond any help they can give">
	)>>

<CONSTANT TEXT121 "She swims well out of reach and remains silent while recovering her dignity. Then she rears up dolphin-like amidst the high waves and says: \"You were wise to set me free. If you had not, who can say what curse would have fallen on your heads? But now I will give you a proper reward for your courtesy.\"||Swimming closer she catches the mooring rope and passing it over her shoulder, proceeds to tug your boat behind her as she swims rapidly southwards.||\"A fine figurehead for our good ship Coffin Lid!\" declares Oakley, standing in the prow where the spray soaks his face. \"You'll agree to be our pallbearer to, I hope, madam, If the events turn against us?\"||\"Sit down and be quiet, for God's sake,\" whines Blutz. \"Do you want her to drag us down into the depths?\"">
<CONSTANT CHOICES121 <LTABLE "let the mermaid take you south" "tell her to depart">>

<ROOM STORY121
	(IN ROOMS)
	(DESC "121")
	(STORY TEXT121)
	(CHOICES CHOICES121)
	(DESTINATIONS <LTABLE STORY197 STORY178>)
	(TYPES TWO-NONES)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT122 "The curse is immaterial. You are confident that your magical knowledge is enough to negate it -- at least so that you and your friends can escape from the ship. But Captain Mandrigard is another matter. Having suffered under the curse's power for so long, he is probably doomed forever now.||As you start to recite the charm, Grimes catches your sleeve and points up at the sails. \"We're running before an east wind,\" he says. \"No hurry in leaving the ship so long as can do it whenever we like. Let's leave it a day or so, when we'll be closer to home.\"||Blutz rolls his eyes at this. \"Madness! Let's get away while we have the chance.\"" >
<CONSTANT CHOICES122 <LTABLE "neutralize the curse and escape right now" "remain on board for the nonce, in line with Grimes's suggestion.">>

<ROOM STORY122
	(IN ROOMS)
	(DESC "122")
	(STORY TEXT122)
	(CHOICES CHOICES122)
	(DESTINATIONS <LTABLE STORY160 STORY141>)
	(REQUIREMENTS <LTABLE SKILL-CHARMS NONE>)
	(TYPES <LTABLE R-SKILL R-NONE>)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT123 "The crab's huge claw descends from the sky to snap at you, but you dive nimbly over it in a forward roll and continue running towards the jollyboat without so much as breaking stride. The others are already aboard. You can hear their frantic shouts urging you on. As the crab rears and plunges you are almost flung off your feet, but the same surefootedness that has carried you across many a storm-tossed deck lets you keep your balance now. A last bound carries you clear of the \"shore\" and into the boat.||\"Go!\" you yell. \"Work those oars as you've never worked 'em before, my hearties!\"">

<ROOM STORY123
	(IN ROOMS)
	(DESC "123")
	(STORY TEXT123)
	(CONTINUE STORY161)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT124 "\An' what if I do have something under my raft?\" he counters darkly. \"Even a poor shipwrecked mariner's entitled to a bit o' shelter, ain't he, out here where the pickings are lean and there's precious little cover to keep a wight from shrivellin' up and blowing away in the wind?\"||Seeing how you all stare at this outburst, he suddenly falls quiet and cracks his mad smile again, saying, \"But blow it, shipmates, why quarrel? Tomorrow there'll be no secrets between us, that I promise ye or my name's not Timmy Mortice.">

<ROOM STORY124
	(IN ROOMS)
	(DESC "124")
	(STORY TEXT124)
	(CONTINUE STORY105)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT125 "No rain falls. Soon your tongue is so parched that it clings to the roof of your mouth like flypaper. The slightest effort wearies you, and you spend most of your time lolling half in a faint, idly tilting the rudder or gazing out over the pitiless expanse of the ocean.">

<ROOM STORY125
	(IN ROOMS)
	(DESC "125")
	(STORY TEXT125)
	(PRECHOICE STORY125-PRECHOICE)
	(CONTINUE STORY106)
	(DEATH T)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY125-PRECHOICE ()
	<LOSE-LIFE 2 DIED-OF-HUNGER ,STORY125>>

<CONSTANT TEXT126 "You are taken into the marble-floored audience hall of the fort, where the governor receives visitors. He proves to be a short dumpy man with a harried look about him, no doubt more suited to banquets and other frippery than to the harsh demands of royal security.||After listening to what you have to say, he exchanges a few whispered words with his officials. Then, turning to you with a stern heavy-lidded expression, he says, \"No doubt you expect some reward for this tall tale of yours? You'll not get one -- not a penny. Do you think we are ready to panic at every wild rumour dredged up from the bottom of a wine-jug? Not a bit of it.\"||Without more ado you are seized by guards and thrown out into the street. \"You fools!\" cries Oakley, jumping to his feet. \"Don't you understand? The Queen's in danger!\"||\"You're in danger of a flogging if you don't shove off, matey boy,\" snarls the captain of the guard as he closes the fortress gates.||The rest of you get up and brush the dirt of the gutter off your clothes. \"Well, so much for that,\" says Grimes. \"Now I say we should sail for Port Selenice without delay.\"">

<ROOM STORY126
	(IN ROOMS)
	(DESC "126")
	(STORY TEXT126)
	(CONTINUE STORY145)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT127 "You soon learn that the governor recently ordered preparations for a state visit by Queen Titania. Sitting in a harbour tavern with an old acquaintance of yours, Black Danny McClintock, you watch amazed as the scar-faced rogue orders a jug of spiced milk instead of his usual shot of strong rum. \"We've been warned off causing any affray, under the threat of Moses's Law on our bare backsides,\" he explains. \"I'm playing it safe by doing no drinking or gambling for the duration.\"||You nod, hiding a smile. Moses's Law is thirty-nine strokes of the birch, but what this pack of dockside villains fear more than the pain is the public humiliation. After strutting like bantam cocks around Leshand's byways for so long, they hate having to knuckle under to the law. Doubtless that's why you can see your old friend Snake-Eyes Johnson in the street just outside helping an old lady with her shopping basket -- and not even filching so much as an orange while he does it.||The others listen with interest when you meet up later to tell them what you've learned. \"This state visit,\" ponders Blutz. \"It must be someone pretty important to cause a clampdown like this.\"||If you are to have any hope of catching up with Skarvench you will have to move on soon. He would never show his face around Leshand, with so many murders to his name. But you also have a feeling it might be worth spending a little while digging out more rumours.">
<CONSTANT CHOICES127 <LTABLE "decide to do so" "visit a chandler's to buy supplies" "look for someone who can identify unusual items" "apply a letter of marque" "pay a visit to Master Capstick" "you have now completed all your business in Leshand">>

<ROOM STORY127
	(IN ROOMS)
	(DESC "127")
	(STORY TEXT127)
	(CHOICES CHOICES127)
	(DESTINATIONS <LTABLE STORY088 STORY012 STORY031 STORY409 STORY069 STORY107>)
	(REQUIREMENTS <LTABLE NONE NONE NONE SKILL-ROGUERY <LTABLE CODEWORD-MARATHON> NONE>)
	(TYPES <LTABLE R-NONE R-NONE R-NONE R-SKILL R-CODEWORD R-NONE>)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT128 "Pretending not to have noticed the three ruffians, you go up to the scholar and greet him like an old friend: \"Ah, here you are! I've been searching high and low. Captain Skarvench has been most concerned for your safety.\"||\"Eh..?\" says the scholar, peering at you with large watery eyes. \"I don't know -- \" You hastily silence him with a poke between his ribs.||The ruffians are looking on nervously. \"Um, did you say Skarvench?\" says one of them at last, a sickly half-smile curdling on his rough features.||\"Why, yes,\" you reply, turning as if noticing them for the first time. \"This gentleman is his new ship's surgeon. The captain's been waiting for him to arrive in Selenice. Have you fellows been looking after him? That's very gracious. Tell me your names -- the captain may wish to reward you when he hears about this.\"||There is the sound of three very audible gulps. \"Er... think nothin' of it,\" says one of the men, handing back the scholar's spectacles. \"We got to be goin', ain't we, lads?\" And they are out of the door in less time than it takes to drain a tot of rum.">

<ROOM STORY128
	(IN ROOMS)
	(DESC "128")
	(STORY TEXT128)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT129 "Which of these possessions will you use?">
<CONSTANT CHOICES129 <LTABLE "try the" "a" "a" "you give up and throw yourself on the giant's charity">>

<ROOM STORY129
	(IN ROOMS)
	(DESC "129")
	(STORY TEXT129)
	(CHOICES CHOICES129)
	(DESTINATIONS <LTABLE STORY243 STORY224 STORY262 STORY072>)
	(REQUIREMENTS <LTABLE HORNPIPE MONKEY DRAGON-RING NONE>)
	(TYPES <LTABLE R-ITEM R-ITEM R-ITEM R-NONE>)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT130 "The captain takes your letter of marque, scans it briefly, then regards you with his coldly disapproving gaze. \"This document is invalid. We have reports that you have been plundering Gloriannic ships, which disqualifies you from acting as a privateer on Her Majesty's behalf.">

<ROOM STORY130
	(IN ROOMS)
	(DESC "130")
	(STORY TEXT130)
	(CONTINUE STORY111)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT131 "You come on deck shortly before eight bells. The fog shrouds everything in a spectral pall. You look up at the rigging, which hangs like the shadow of a giant web. There is a rotting miasmal smell in the air, wafting from the swamps along the back of the bay. Blutz gives a rattling cough, mumbles something about yellow fever and wanting to be shot of this anchorage, and stumps below to get a cup of grog before turning in. You are left alone on the deck.||Gazing back towards the glow from the swamps, you hear the muffled sound of oars splashing far off in the darkness. A small boat appears, gradually taking solid form out of the fog, and in the light of the ship's lanterns you see a tall figure standing in the prow with two rowers hunched over the oars behind him. As the boat pulls alongside you have a clear view of the man -- tall and pale, with eyes of startling cobalt blue. His teeth flash in a smile as he hails you: \"Permission to come aboard?\"">
<CONSTANT CHOICES131 <LTABLE "give him permission to come onto your ship" "not">>

<ROOM STORY131
	(IN ROOMS)
	(DESC "131")
	(STORY TEXT131)
	(CHOICES CHOICES131)
	(DESTINATIONS <LTABLE STORY283 STORY302>)
	(TYPES TWO-NONES)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT132 "The Gloriannic ship goes rushing past, helpless in the grip of the storm. You catch a brief glimpse of tiny figures scurrying across her deck. Then a wave crashes down, obscuring all sight of her, and when you look again she is gone.||\"God help the Rose if she's out in that,\" gasps Oakley, staring into the teeth of the hurricane.||You do not answer. It takes every ounce of your strength to hold the whipstaff and keep your own ship on an even keel. As the thunderclouds spit molten light into the darkness all around you, fracturing the heavens with their fury, you strike on implacably towards your goal.">

<ROOM STORY132
	(IN ROOMS)
	(DESC "132")
	(STORY TEXT132)
	(CONTINUE STORY094)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT133 "You duck into a forward roll just as the cannon belches forth its charge. The ball goes whizzing over your head, snapping a spar just where you were standing. You have the bad luck to be caught by a flying splinter of wood, but it only grazes your forehead.">

<ROOM STORY133
	(IN ROOMS)
	(DESC "133")
	(STORY TEXT133)
	(PRECHOICE STORY133-PRECHOICE)
	(CONTINUE STORY171)
	(DEATH T)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY133-PRECHOICE ()
	<LOSE-LIFE 1 "The wound proved to be fatal" ,STORY133>>

<CONSTANT TEXT134 "You dart inside the cabin, pushing the door behind you and listening with bated breath as the heavy tread of boots advances along the passage and pauses just outside. Then the door starts to swing open...">
<CONSTANT CHOICES134 <LTABLE "use" "use" "failing those options, you cannot avoid detection">>

<ROOM STORY134
	(IN ROOMS)
	(DESC "134")
	(STORY TEXT134)
	(CHOICES CHOICES134)
	(DESTINATIONS <LTABLE STORY210 STORY229 STORY191>)
	(REQUIREMENTS <LTABLE SKILL-CHARMS SKILL-ROGUERY NONE>)
	(TYPES <LTABLE R-SKILL R-SKILL R-NONE>)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT135 "Your tiny boat heads heads onward. By day you are seared by the sun; by night you are racked with chill. Salt spray chafes the sores on your skin, and the need to bail water constantly gives you no rest. Another two days crawl by, and you gradually give way to fever and exhaustion.">

<ROOM STORY135
	(IN ROOMS)
	(DESC "135")
	(STORY TEXT135)
	(PRECHOICE STORY135-PRECHOICE)
	(CONTINUE STORY212)
	(DEATH T)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY135-PRECHOICE ()
	<LOSE-LIFE 1 DIED-OF-HUNGER ,STORY212>
	<COND (<IS-ALIVE>
		<COND (<CONSUME-PROVISIONS 1 ,STORY212> <RETURN>)>
		<COND (<IN? ,MONKEY ,PLAYER>
			<CRLF>
			<TELL "Eat the monkey (if you are heartless or desperate enough)?">
			<COND (<YES?>
				<REMOVE ,MONKEY>
				<STORY-JUMP ,STORY212>
				<RETURN>
			)>
		)>
	)>>

<CONSTANT TEXT136 "\"Here's the question as I sees it,\" says Grimes. \"Do we try to make it all the way to Leshand, or do we strike southward first? I reckon we'd have a shorter hop to Pandanus Isle, and we could pick up provisions there.\"||\"Or the natives could pick up provisions,\" says Oakley. \"Us.\"||It looked as if Blutz was about to go along with Grimes's suggestion, but at the mention of cannibals he looks nervously to the south. \"We were on that cursed ship a fair while, mates,\" he says. \"Surely Leshand can't be far off, if we stay bold.\"||\"Bold!\" Oakley gives a croak of mocking laughter.||They can't decide amongst themselves. The decision is left to you --">
<CONSTANT CHOICES136 <LTABLE "head south to the Smoking Islands" "steer straight ahead and hope to make it to Port Leshand without further mishap">>

<ROOM STORY136
	(IN ROOMS)
	(DESC "136")
	(STORY TEXT136)
	(CHOICES CHOICES136)
	(DESTINATIONS <LTABLE STORY156 STORY405>)
	(PRECHOICE STORY136-PRECHOICE)
	(TYPES TWO-NONES)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY136-PRECHOICE ()
	<COND (<CHECK-CODEWORD ,CODEWORD-PECCANT>
		<PUT <GETP ,STORY136 ,P?DESTINATIONS> 2 STORY386>		
	)(ELSE
		<PUT <GETP ,STORY136 ,P?DESTINATIONS> 2 STORY405>
	)>>

<CONSTANT TEXT137 "Swept onwards, your little craft starts to spring leaks.">

<ROOM STORY137
	(IN ROOMS)
	(DESC "137")
	(STORY TEXT137)
	(PRECHOICE STORY137-PRECHOICE)
	(CONTINUE STORY175)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY137-PRECHOICE ()
	<COND (,USED-CHARMS-TO-FLOAT
		<EMPHASIZE "However, there is no cause for alarm.">
	)>
	<CONSUME-PROVISIONS 1 ,STORY156>>

<CONSTANT TEXT138 "A strong breeze stretches your sails wide against the sky, driving you on towards your destiny. But you have no time to brood on what the future may hold; you have a ship to command. Seeing the way her prow cleaves the water, and the jaunty courage of your crew as they go about their chores, your heart brims with optimism. Soon Skarvench will see his last sunset in his life -- of that you feel sure.">
<CONSTANT TEXT138-CONTINUED "More than a week goes by. On the ninth day, you stand on the deck watching the sun slide out of the sky. Long blazing beams of orange light turn the green waves to liquid gold. And then -- in the blink of an eye -- this idyllic scene is transformed. A purple murk rises from the western horizon, blotting out the afternoon sun behind thick thunderclouds. A cold gust blows in your face, setting the sails to a pensive fluttering like frightened birds. You know well the taste of that chill wind; it is the harbinger of the hurricane.||\"This is but the twitch of the lion's tail compared to what will come,\" mutters Grimes. \"We'll have to put about.\" He calls to the crew: \"Strike the main topsail.\"||You turn. \"Belay that striking order. Lash it!\"||Oakley stares at you. \"Skipper, the hurricane'll tear us apart.\"||The first rain spits into your face, icily intense. \"'We're going in, hurricane or not. God is the master of the heavens and all the world -- but, by all that's holy, I'm the master of this ship!">
<CONSTANT CHOICES138 <LTABLE "use a" "an amulet" "use" "otherwise">>

<ROOM STORY138
	(IN ROOMS)
	(DESC "138")
	(STORY TEXT138)
	(CHOICES CHOICES138)
	(DESTINATIONS <LTABLE STORY018 STORY037 STORY397 STORY075>)
	(REQUIREMENTS <LTABLE THUNDERCLOUD-FAN SKILL-CHARMS SKILL-SEAFARING NONE>)
	(PRECHOICE STORY138-PRECHOICE)
	(TYPES <LTABLE R-ITEM R-SKILL R-SKILL R-NONE>)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY138-PRECHOICE ()
	<COND (,RUN-ONCE <GAIN-LIFE 2>)>
	<CRLF>
	<TELL TEXT138-CONTINUED>
	<TELL ,EXCLAMATION-CR>>

<CONSTANT TEXT139 "Mulling over your extensive knowledge of myth and legend, you consider what the items might be. Obviously they are classical in style. Very old, then -- which suggests the possibility of powerful magic, since everyone knows that the sorcerers of ancient times knew many magical secrets that are now lost. On the basis of hopeful surmise, you finally identify the items as follows:||The diamond would suffice to buy you a ship of your own but it has no magical properties, unless the effect of staggering wealth on men's greed can be accounted magical.||The conch-shell horn reminds you of such an item which was said to be taken by the Trojans after the sack of Atlantis. It can be used to convey its owner to the secret harbour of Poseidon, god of the sea. This harbour is filled with treasures, but it is guarded by a locked gate which can only be opened by the note of a flute or pipe.||The thundercloud fan is surely sacred to the storm deity of far-off Cathay. If wielded carefully, it unleashes a hurricane which can be directed as one wishes.||You soon place the bronze helmet as having belonged to a Spartan king. No doubt it confers skill at arms upon the wearer, since the Spartans were renowned for their martial prowess.||As for the dragon ring... you're not sure. It strikes a distant chord of memory, but nothing you can quite dredge to the surface. Handling it makes you feel distinctly uneasy, however.">
<CONSTANT STORY139-LIST <LTABLE DIAMOND CONCH-SHELL-HORN THUNDERCLOUD-FAN BRONZE-HELMET DRAGON-RING>>

<ROOM STORY139
	(IN ROOMS)
	(DESC "139")
	(STORY TEXT139)
	(PRECHOICE STORY139-PRECHOICE)
	(CONTINUE STORY217)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY139-PRECHOICE ("AUX" ITEMS)
	<TELL CR "Do you wish to change the two items you're taking on the basis of this information?.">
	<COND (<YES?>
		<SET ITEMS <GET STORY139-LIST 0>>
		<DO (I 1 .ITEMS)
			<COND (<IN? <GET .ITEMS .I> ,PLAYER>
				<REMOVE <GET .ITEMS .I>>
			)>
		>
		<SELECT-FROM-LIST STORY139-LIST 5 2>
	)>>

<CONSTANT TEXT140 "\"Much maintenance,\" she replies in answer to your query. \"Furious storms could yet swamp your boat; icy rain will chill you; hunger will gnaw at your insides and thirst will wither your tongues --\"||\"Is that all?\" says Oakley.||She looks hard at him. \"A cursed ship plies these waters. If you have nerves of iron and fear no fright under all of heaven, you might travel aboard her and safely be brought in sight of land.\"||\"A cuh-cursed ship...\" stammers Blutz. \"What's the cuh-catch?\"||\"You'd pay a high price for your passage,\" replies the mermaid. \"A sinister sacrifice is called for when you wish to disembark. But nothing,\" she stares at the hand grasping her long tresses, \"nothing you can't afford to part with.\"||Nervousness makes Blutz relax his grip. With a haughty twist, the mermaid pulls away from him.">

<ROOM STORY140
	(IN ROOMS)
	(DESC "140")
	(STORY TEXT140)
	(CONTINUE STORY178)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT141 "You return to the captain's cabin, where you find Mandrigard snoring, sprawled across a table full of gold coins. Oakley stands looking down at him with hands on hips, his expression an odd mixture of pity and loathing. \"One way to lift the curse,\" he says at last, \"might be to put an end to the wretch.\"||\"Murder him?\" gasps Blutz. \"I don't hold with killing a man who's not standing on his hind legs. Anyway, you're only saying that so you can take his treasure.\"||\"He's dead drunk,\" points out Grimes. \"We could take the treasure from under his nose without provoking so much as a murmur. He'd never miss a few choice bits, and what good is treasure to him if he can never spend it?\"||As usual the others look to you for authority.">
<CONSTANT CHOICES141 <LTABLE "give the go-ahead to murder Mandrigard while he sleeps" "help yourself to just a few items of treasure" "go back up on deck">>

<ROOM STORY141
	(IN ROOMS)
	(DESC "141")
	(STORY TEXT141)
	(CHOICES CHOICES141)
	(DESTINATIONS <LTABLE STORY179 STORY198 STORY217>)
	(TYPES THREE-NONES)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT142 "Huge eye-stalks rise from the water, swivelling to bring you under the scrutiny of the crab's ghastly black gaze. It's claw swings down at you like a yacht's boom, and it rears and twists in a furious effort to snatch you off its back. Realising that you will be torn in half instantly if you fall prey to the claws, you throw yourself flat and cling to the crab's shell for dear life. There is a great lurch, then sea water washes in to engulf you. The crab is diving into the depths -- and taking you along with it.">
<CONSTANT CHOICES142 <LTABLE "try swimming to safety" "rely on a charm against drowning">>

<ROOM STORY142
	(IN ROOMS)
	(DESC "142")
	(STORY TEXT142)
	(CHOICES CHOICES142)
	(DESTINATIONS <LTABLE STORY180 STORY199>)
	(REQUIREMENTS <LTABLE SKILL-SEAFARING SKILL-CHARMS>)
	(TYPES <LTABLE R-SKILL R-SKILL>)
	(PRECHOICE STORY142-PRECHOICE)
	(DEATH T)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY142-PRECHOICE ()
	<COND (<OR <CHECK-SKILL ,SKILL-SEAFARING> <CHECK-SKILL ,SKILL-CHARMS>>
		<PUTP ,STORY142 ,P?DEATH F>
	)(ELSE
		<EMPHASIZE "There is nothing you can do to save yourself.">
	)>>

<CONSTANT TEXT143 "Rising to your feet, you perform as elegant an imitation of a courtly bow as your uncouth background and the cramped conditions will allow. \"Of course, we had nearly forgotten our manners. Long privation can do that to the best of us --\"||\"Yes, yes!\" says Mortice eagerly, gripping the side of your boat.||Oakley's brow furrows into a frown and he looks on the point of saying something, but not before you have completed your mock ritual with the words: \"Mister Mortice, you have my permission to come aboard our little vessel.\"||Instantly there is a flutter of tattered rags and a soft thud as he lands beside you in a jollyboat. You are taken aback. He moved so fast! With a toothy smile, he says, \"You lot get some rest. I'll keep watch a while">

<ROOM STORY143
	(IN ROOMS)
	(DESC "143")
	(STORY TEXT143)
	(PRECHOICE STORY143-PRECHOICE)
	(CONTINUE STORY200)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY143-PRECHOICE ()
	<COND (<OR <IN? ,CRUCIFIX ,PLAYER> <CHECK-SKILL ,SKILL-CHARMS>> <STORY-JUMP ,STORY181>)>>

<CONSTANT TEXT144 "You hide out deep in the hinterland of the island, surviving off berries and fruit. Eventually you deem it safe to make your way back to the native village. Peering out from the sheltering foliage, you find that the Belle Dame has sailed off. The coast is clear.||\"That fiend!\" rages Oakley. \"No doubt he's off to wreak more wickedness in the world. Are we really going to sit here sucking coconuts while he goes unpunished?\"||You all agree it is high time you pressed on with your journey. The natives are now too scared to repeat the offer of an escort; you're on your own.">

<ROOM STORY144
	(IN ROOMS)
	(DESC "144")
	(STORY TEXT144)
	(CONTINUE STORY177)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT145 "Experienced sailors like the four of you have no trouble working your passage to Port Selenice. You sign on aboard a caravel and for the next week or so your days are filled with the familiar routine of life at sea.||\"Look at the sunset!\" calls Blutz across the deck one evening. He points to where long clouds like like mauve paint smears across a palette of gloriously mingled gold, scarlet, violet and grey. \"This is the life, eh, shipmates?||Grimes looks up from trimming the topsails. \"I'll take no pleasure from any such sight,\" he says grimly, \"until I know that Skarvench no longer lives under the same sky as we.\"||Eventually you reach port, and the captain of the caravel pays you off with 5 doubloons. Taking up your packs, you stride down the gangplank and along the bustling quay.">

<ROOM STORY145
	(IN ROOMS)
	(DESC "145")
	(STORY TEXT145)
	(PRECHOICE STORY145-PRECHOICE)
	(CONTINUE STORY165)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY145-PRECHOICE ()
	<GAIN-LIFE 3>
	<GAIN-MONEY 5>>

<CONSTANT TEXT146 "The innkeeper of The Hanged Man is a sour-faced man named Drood. You can see him at the bar polishing tankards with a filthy piece of rag. As you step up, he sets aside the tankard he's holding and gives you a long loury glare. \"Heard you were dead,\" he says. \"Seems the news hasn't reach you yet, though.\"||You ignore this. \"Skarvench been in?\" you ask.||\"Not lately. Things are too hot for him in Leshand.\" Drood spits on the bar and starts wiping it.||A beefy hand clamps on your shoulder and turns you around. Facing you are six burly ruffians. You vaguely recognise them as Skarvench's \"business associates\" -- men who act as his spies and assassins on shore.||There leader regards you with eyes like tiny beads of dull glass. \"Cap'n Skarvench is in Port Selenice takin' delivery of a new ship,\" he says, \"Why're you askin'?\"||\"We're planning to meet him.\"||You start to move past the ruffians, then freeze as they draw knives. \"Tell you what,\" says the leader, \"you go straight to hell, and no doubt the cap'n will join you there when he's good and ready...\"||It's life or death.">
<CONSTANT CHOICES146 <LTABLE "fight" "use" "use">>

<ROOM STORY146
	(IN ROOMS)
	(DESC "146")
	(STORY TEXT146)
	(CHOICES CHOICES146)
	(DESTINATIONS <LTABLE STORY013 STORY051 STORY032>)
	(REQUIREMENTS <LTABLE NONE SKILL-CUNNING SKILL-AGILITY>)
	(TYPES <LTABLE R-NONE R-SKILL R-SKILL>)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT147 "Stepping up to the bar, you act as if you'd only just spotted the three ruffians. \"Toby Whipstaff!\" you say to the largest of them. \"Why, I haven't clapped eyes on you in a month o' Sundays! How blows the wind, Toby?\"||He greets you with a broad smile, forgetting his sport with the scholar. \"All's well. Last week we took a Sidonian galleon loaded with gold plate; pickings have rarely been richer.\"||You nod. \"And not just Sidonian pickings, I suppose, otherwise the governor wouldn't have set a price of a hundred doubloons on your head.\"||He fingers his neck nervously. \"Ah that must be the little business involving the Gloriannic merchantman a while back. I didn't expect them to make so much of it.\"||\"You're too modest! Five sailors were killed, including the governor's godson.\"||Whipstaff visibly pales. \"A hundred doubloons, eh? That much.\"||\"Your brother's been posted for twice that. No doubt it was his expertise with the flensing-knife that attracted undue attention.\"||\"My brother? But he's sailing for Leshand this very day. I must get to the docks!\" Tossing the spectacles on the bar, he races out with his two cronies close behind.">

<ROOM STORY147
	(IN ROOMS)
	(DESC "147")
	(STORY TEXT147)
	(CONTINUE STORY223)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT148 "He gives you a single large emerald -- one of his tears of mirth at your great gall. The dolphin and the shark convey you back, chatting to one another on the way. You cannot hear everything they are saying because of the splashing of the waves, but you gather they had their own ideas as to how you'd fare at Neptune's gate. \"One of them's the spitting image of that Ulysses,' you overhear the dolphin say. The shark snorts and replies, \"I'm more interested in the fat one. I like the look of him. I might hang around the shore tomorrow and see if he goes swimming.||At last you arrive at the beach near Selenice. Your adventure has taken the whole night. As the sun rises, the coracle sinks under the waves. Blutz gives a shudder and seeing this, you remark, \"Don't worry, Mister Blutz, you'll be all right so long as you don't go for a swim.\"||\"Er, it's not that,\" he protests. \"I was just, er, a bit chilly. Come on, mates, let's go to the shipyard and spend our emerald!">

<ROOM STORY148
	(IN ROOMS)
	(DESC "148")
	(STORY TEXT148)
	(CONTINUE STORY337)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT149 "He examines the letter, then hands it back. \"All's in order,\" he says. His manner is far from friendly, but at least the expression of icy menace is gone from  his eyes. He orders the marines to lower their weapons. You cannot help noticing that the marine sergeant keeps his pistol cocked, however. \"I will take delivery of Her Majesty's share of your plunder,\" says the captain curtly. \"This will save you the trouble of sailing to Leshand to hand it over.\"||You show him to the hold, where he makes an inventory of your treasure and then divides a sizeable pile from it -- nearly a quarter of all your spoils. \"You're levying a harsh tax,\" you say, pointing at the pile.||For the first time his face shows a smile. It is like a crack appearing on thin ice. \"You're mistaken. That pile is what you get to keep. We're taking all the rest.\"||You barely choke back a gasp. He means to take three-quarters of your treasure! You will barely have enough left to buy a decent ship.">
<CONSTANT CHOICES149 <LTABLE "use" "if not then either you allow him to take the Queen's share" "else to fight to keep what you have">>

<ROOM STORY149
	(IN ROOMS)
	(DESC "149")
	(STORY TEXT149)
	(CHOICES CHOICES149)
	(DESTINATIONS <LTABLE STORY168 STORY187 STORY206>)
	(REQUIREMENTS <LTABLE SKILL-CUNNING NONE NONE>)
	(TYPES <LTABLE R-SKILL R-NONE R-NONE>)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT150 "You do not relish such grisly work, but there is no time for hesitation. Kneeling in the bottom of the pit, you raise the sharp stake and drive it deep into the corpse's chest. Instantly the mouth gapes open and there issues forth such a howl of cold hatred that it will haunt your dreams forevermore. The eyes blaze for an instant in their sockets, then darken in true death as a fountain of dry brown blood wells up around the wound.||You lurch to your feet, glad to feel your friends' hands at your shoulders. Gradually, under your horrified eyes, the corpses collapse and shrivel away to dust.||\"Collect the treasure, shipmates,\" you say in a hoarse voice. \"And look sharp -- I'm keen to quit this place.\"||The moon has risen by the time all the loot is safely stowed aboard the Lady of Shalott. Only then, with shaking hand do you broach a bottle of rum. Each man gulps his tot eagerly, anxious to rid himself of his memories of this ghastly evening.">

<ROOM STORY150
	(IN ROOMS)
	(DESC "150")
	(STORY TEXT150)
	(CONTINUE STORY016)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT151 "Clutching the talisman, you appeal to whatever ancient god or demon it depicts to use its power now. For a long instant nothing happens, and you fear that the talisman's magic has worn off with age, but then you see a black shadow spreading across the face of the moon. It has the outline of a bat's wing.||\"The bat was the symbol of night in ancient times,\" says Grimes, his voice hushed in awe as the last moonlight vanishes like a shuttered lantern-beam and the world is plunged into starlit darkness.">

<ROOM STORY151
	(IN ROOMS)
	(DESC "151")
	(STORY TEXT151)
	(CONTINUE STORY246)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT152 "The basilisk cannon roars, hurling fire and hot iron towards you. You throw yourself to one side, but the blast still catches you.">
<CONSTANT TEXT152-CONTINUED "You cry out in terrible agony but manage to stagger towards your foe. \"You take a lot o' killing, I'll say that for ye,\" hisses Skarvench as he draws his sword. \"But now your luck's run out.\"">

<ROOM STORY152
	(IN ROOMS)
	(DESC "152")
	(STORY TEXT152)
	(PRECHOICE STORY152-PRECHOICE)
	(CONTINUE STORY171)
	(DEATH T)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY152-PRECHOICE ()
	<LOSE-LIFE 5 "You died from your injuries" ,STORY152>
	<IF-ALIVE TEXT152-CONTINUED>>

<CONSTANT TEXT153 "Reaching up, you take a firm grip on the bulkhead beam running across the ceiling of the passage. Then you swing yourself up until you are braced across the beam. A moment later you see the sailmaster's distinctive bald head appear below where you're hiding, but he does not look up. As he vanishes into his cabin, you drop silently to the floor and hurry up the companion-way to join your comrades.">

<ROOM STORY153
	(IN ROOMS)
	(DESC "153")
	(STORY TEXT153)
	(CONTINUE STORY172)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT154 "You row in towards the island, beaching your vessel on the deserted shore. Oakley gives a cry of delight as he spots a pineapple that has fallen from a tree at the top of the beach. Its juice stings his sun-cracked lips, but he chews ravenously at it all the same.||\"Head's up,\" Grimes says tersely. \"We got company, shipmates.\"||You turn your head. A large group of Carab natives have emerged from the woods and are coming across the sand towards you. \"Welcoming party...\" you mutter under your breath, noticing the spears.">
<CONSTANT CHOICES154 <LTABLE "attack either with a pistol" "or in hand-to-hand fighting" "or you might prefer to parley" "put to sea before they reach you">>

<ROOM STORY154
	(IN ROOMS)
	(DESC "154")
	(STORY TEXT154)
	(CHOICES CHOICES154)
	(DESTINATIONS <LTABLE STORY196 STORY215 STORY272 STORY177>)
	(REQUIREMENTS <LTABLE SKILL-MARKSMANSHIP NONE NONE NONE>)
	(TYPES <LTABLE R-SKILL R-NONE R-NONE R-NONE>)
	(PRECHOICE STORY154-PRECHOICE)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY154-PRECHOICE ()
	<COND (<CHECK-CODEWORD ,CODEWORD-SCRIP> <STORY-JUMP ,STORY253>)>>

<CONSTANT TEXT155 "Your limbs ache with the strain of rowing, like men who have been stretched on the rack. Slumping over the oars, you gaze feebly out across the merciless distance that still separates you from civilization. The water laps temptingly against the sides of your boat, but you know that it holds out a false promise: brine cannot slake a poor mariner's thirst, it can only drive him mad.">

<ROOM STORY155
	(IN ROOMS)
	(DESC "155")
	(STORY TEXT155)
	(PRECHOICE STORY155-PRECHOICE)
	(CONTINUE STORY426)
	(DEATH T)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY155-PRECHOICE ("AUX" (DMG 2))
	<COND(<CHECK-SKILL ,SKILL-SEAFARING>
		<SET DMG 1>
	)>
	<LOSE-LIFE .DMG DIED-OF-THIRST ,STORY155>>

<CONSTANT TEXT156 "The most westerly of the islands comes in sight. It is a large golden-shored jungle island with many welcoming coves. \"Others have put in here, when blown north off the main shipping route,\" Grimes recalls. \"The natives are said to be hospitable.\"||You stare into the west. Leshand is still two hundred leagues off, and it might be wise to re-provision before you undertake that long haul. And yet worry gnaws at your mind: \"Hospitable when faced with gifts and muskets and a sea-going vessel of ten cannon, perhaps. But how will they greet a handful of starving wretches in a ramshackle craft?\"||It's up to you.">
<CONSTANT CHOICES156 <LTABLE "put in here" "sail on towards Port Leshand">>

<ROOM STORY156
	(IN ROOMS)
	(DESC "156")
	(STORY TEXT156)
	(CHOICES CHOICES156)
	(DESTINATIONS <LTABLE STORY154 STORY177>)
	(TYPES TWO-NONES)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT157 "Now you guess the truth. As daughter of the earth goddess, Ejada received unending strength and vitality as long as she remained in contact with the ground. Now she is like an uprooted flower wilting in the hot sunlight. \"Restore me to the earth,\" she begs, \"and all my treasures are yours.\"||\"They are anyway.\" You learned never to trust a sorceress. Wedging her on a high cornice of the building, well clear of the soil that would regenerate her power, you go inside to explore. You soon find a hoard of magical treasures comprising a magic wand, a healing potion, a ship in a bottle, and a black kite. The potion can be drunk once at any time to restore your Life points to normal (Press 'D' during action selection). The other items may or may not come in handy later.">
<CONSTANT TEXT157-CONTINUED "Returning to the beach, you quit Grimoire Island without further delay">

<ROOM STORY157
	(IN ROOMS)
	(DESC "157")
	(STORY TEXT157)
	(PRECHOICE STORY157-PRECHOICE)
	(CONTINUE STORY137)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY157-PRECHOICE ()
	<SELECT-FROM-LIST <LTABLE MAGIC-WAND HEALING-POTION SHIP-IN-BOTTLE BLACK-KITE> 4 4>
	<CRLF>
	<TELL TEXT157-CONTINUED>
	<TELL ,PERIOD-CR>>

<CONSTANT TEXT158 "Coconuts are often found drifting at sea. This is how coconut trees establish themselves on new islands, after all. They can float at sea for months and remain perfectly fresh, so there is no reason why this one should not be edible. You finally manage to convince Blutz that it has not bobbed up from the kingdom of the dead or any such nonsense, and he happily joins the rest of you in your meal.">

<ROOM STORY158
	(IN ROOMS)
	(DESC "158")
	(STORY TEXT158)
	(CONTINUE STORY389)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT159 "The mermaid splashes grey spume with her tail, writhing angrily in Blutz's grip and spitting like a snake. But she answers you none the less: \"Set your prow south if food and  comfort are your aim, for the islands there more hospitable to land-dwellers than these storm-churned seas. Your present course westward will take you to a baleful rendezvous, and one you are unlikely to get away from in once piece.\"||\"I don't like the sound of that,\" says Blutz. \"But tell us more about the isles to the south. Aren't there any dangers there?\"||\"There is the witch Ejada,\" replies the mermaid. \"She seeks souls for her god, and such is her power that none can strike her down while her feet remain planted on solid earth --\"||Suddenly flinging a handful of brine into Blutz's face, she pulls free of his grip, leaving only two or three coral-coloured hairs twined between his stubby fingers.">

<ROOM STORY159
	(IN ROOMS)
	(DESC "159")
	(STORY TEXT159)
	(CONTINUE STORY178)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT160 "Settling into your jollyboat, you are not sorry to see the gloomy hulk of the Larnassos fade off into the darkness and drizzle. As for Captain Mandrigard -- will he ever find rest or an end to his curse? You wonder.||\"Should have more sense than to offend a high priest, shouldn't he,\" says Oakley. \"Save your pity for ourselves mate; we're not through this yet.\"">
<CONSTANT CHOICES160 <LTABLE "steer south from here, towards the Smoking Islands" "stay on your present course" "otherwise">>

<ROOM STORY160
	(IN ROOMS)
	(DESC "160")
	(STORY TEXT160)
	(CHOICES CHOICES160)
	(DESTINATIONS <LTABLE STORY135 STORY386 STORY349>)
	(REQUIREMENTS <LTABLE NONE <LTABLE CODEWORD-PECCANT NONE>>)
	(PRECHOICE STORY160-PRECHOICE)
	(TYPES <LTABLE R-NONE R-CODEWORD R-NONE>)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY160-PRECHOICE ()
	<REMOVE ,CURRENT-VEHICLE>
	<SETG CURRENT-VEHICLE NONE>>

<CONSTANT TEXT161 "Gazing back, you see the hump of the great crab's shell as it rears up, threshing at the water with its claws in a frenzied search for the human prey that so narrowly escaped its clutches.||\"I expect it's rather short-sighted,\" Blutz says. \"Obviously it wouldn't need sharp vision, seeing as how fish are so plentiful in these waters.\"||\"Yes, but keep your voice down,\" hisses Oakley. \"No reason to suppose that it's deaf as well.\"||Leaving the crab far in your wake, you decide which way to go next.">
<CONSTANT CHOICES161 <LTABLE "steer westwards" "north towards the Smoking Islands">>

<ROOM STORY161
	(IN ROOMS)
	(DESC "161")
	(STORY TEXT161)
	(CHOICES CHOICES161)
	(DESTINATIONS <LTABLE STORY047 STORY066>)
	(TYPES TWO-NONES)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT162 "Mortice becomes livid with rage, hissing out a torrent of curses to freeze the blood. At last, when his anger runs out of words, he lapses into silence and merely glares at you with incandescent yellow eyes.||\"Perhaps we should board his vessel, if it comes to that,\" suggests Grimes.||Oakley agrees. \"There could well be treasure in that long box there,\" he says. His eyes are locked on Mortice.||All of you stand tense, alert. Mortice couches on his raft like a wild beast at bay. As he sees Oakley place his foot on the side of the jollyboat, ready to spring over to the raft, he gives a guttural snarl and says, \"Try it. I'll rip yer gizzard out through yer backside and feed it to the fishes.\"||\"Emphatically unwelcoming,\" you remark. \"If we persist in trying to board the raft I think we'll have a fight on our hands.\"||\"A fight?\" says Oakley, looking back at you. \"He's just one old lubber.\" But all the same he stays poised there, waiting for you to say the word.">
<CONSTANT CHOICES162 <LTABLE "attack Mortice with bare hands" "a sword" "a pistol" "you can just cut the raft adrift">>

<ROOM STORY162
	(IN ROOMS)
	(DESC "162")
	(STORY TEXT162)
	(CHOICES CHOICES162)
	(DESTINATIONS <LTABLE STORY219 STORY238 STORY257 STORY276>)
	(REQUIREMENTS <LTABLE NONE SKILL-SWORDPLAY SKILL-MARKSMANSHIP NONE>)
	(TYPES <LTABLE R-NONE R-SKILL R-SKILL R-NONE>)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT163 "\"Let's face it,\" says Oakley a few days later, \"we don't know the first thing about foraging. We'll starve if we stay here.\"||You have to admit he is right. Unable to trap birds or animals, you are forced back on a meager diet of nuts. You cannot even be sure which are safe to eat, and stomach pains and retching gradually sap your resolve.">
<CONSTANT TEXT163-CONTINUED "\"It's hopeless,\" says Grimes. \"We'd be better off going out to face Skarvench. At least we might get a quick clean death.\"||Knowing Skarvench, you doubt that. But it is better to boldly confront your foe than starve to death like miserable dogs. You lead others back to the shore.">

<ROOM STORY163
	(IN ROOMS)
	(DESC "163")
	(STORY TEXT163)
	(PRECHOICE STORY163-PRECHOICE)
	(CONTINUE STORY087)
	(DEATH T)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY163-PRECHOICE ()
	<LOSE-LIFE 1 DIED-OF-HUNGER ,STORY163>
	<IF-ALIVE TEXT163-CONTINUED>>

<CONSTANT TEXT164 "Haunting moonlit street corners and smoky low-raftered taverns, you gradually piece together a tale of real terror. It seems El Draque was a Carpathian mercenary who arrived in the New World ten years ago and at once embarked on a spree of unrestrained piracy. Instantly recognizable by his filed teeth and acid blue eyes, he inspired such fear that most ships surrendered as soon as he raised his flag. The general consensus among everyone you speak to is that he slept by day in a box in the cargo hold of his ship, that he drank the blood of those he murdered, and that he was impervious to mortal injury.||There is one more thing. A month ago, taken unawares by a Gloriannic frigate, El Draque was caught and hanged at sea. His body was then flung overboard. The authorities were satisfied -- at least enough to pay out the bounty on his head to the frigate captain who caught him. But then, a week or so later, that same frigate captain was found dead in a harbour-front inn. His throat has been sliced from ear to ear, but the weird thing was there was that there was hardly a drop of blood.||You've heard enough to guess that the career of the notorious El Draque has not yet ended.">
<CONSTANT CHOICES164 <LTABLE "try to find out more about Skarvench's activities" "ask around concerning the impending royal visit" "visit a chandler's to buy supplies now that you've heard all the rumours that interest you" "look for someone who can identify unusual items" "apply for a letter of marque" "pay a visit to Master Capstick" "you have completed all your business in Leshand">>

<ROOM STORY164
	(IN ROOMS)
	(DESC "164")
	(STORY TEXT164)
	(CHOICES CHOICES164)
	(DESTINATIONS <LTABLE STORY278 STORY202 STORY012 STORY031 STORY409 STORY069 STORY107>)
	(REQUIREMENTS <LTABLE NONE NONE NONE NONE NONE <LTABLE CODEWORD-MARATHON> NONE>)
	(TYPES <LTABLE R-NONE R-NONE R-NONE R-NONE R-NONE R-CODEWORD R-NONE>)
	(PRECHOICE STORY164-PRECHOICE)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY164-PRECHOICE ()
	<COND (<CHECK-SKILL ,SKILL-ROGUERY>
		<PUT <GETP ,STORY164 ,P?DESTINATIONS> 5 ,STORY050>
	)(ELSE
		<PUT <GETP ,STORY164 ,P?DESTINATIONS> 5 ,STORY409>
	)>>

<CONSTANT TEXT165 "Of all the ports in the Carab Sea, only Selenice -- 'the Pirates' Haven' -- would it be safe for a bloodthirsty cut-throat like Skarvench to show his face and openly spend his ill-gotten gold. Selenice has no allegiance to any nation. It is ruled by the common consent of buccaneers who live here -- the Brethren of the Coast, as they term themselves -- and it is buccaneers and their families who are the town's only citizens.||Curiously, life here is not the lawless mayhem that outsiders imagine. The buccaneers of Selenice arrive here glutted with more than their share of violence and hardship. They want nothing more than to peacefully squander their loot on ale, women and dice. One rule that is stringently enforce above all others is an absolute ban on the use of weapons. Normal brawls can and do occur, for buccaneers are hard men filled with pride, and tempers can flare up easily when the rum flows freely. But any brawl is settled barehanded, since to draw a weapon in Selenice is to invite summary justice from the Brethren of the Coast. However you may have fared elsewhere under the laws of civilized kingdoms, you'd do well not to fall afoul of the Brethren.||Passing a pedlar in the street outside the Thorny Knot tavern, Oakley glances across at you. \"Maybe we should do a spot of shopping, skipper?\"||\"I'd rather do a spot of drinking,\" says Blutz, casting a longing eye at the tavern.">
<CONSTANT CHOICES165 <LTABLE "buy something form the pedlar" "go into the tavern" "go off to see the local shipbuilder">>

<ROOM STORY165
	(IN ROOMS)
	(DESC "165")
	(STORY TEXT165)
	(CHOICES CHOICES165)
	(DESTINATIONS <LTABLE STORY336 STORY355 STORY374>)
	(TYPES THREE-NONES)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT166 "Drawing your sword, you lunge towards the three bullies with a fierce yell. The terrified scholar throws himself flat and crawls under a table. The fight ranges back and forth across the room until suddenly you are seized from behind. Craning your neck, you see a throng of disapproving faces. A tall dour-faced man steps forward, saying, \"To draw a weapon in Selenice contravenes the code of the Brethren of the Coast. Fortunately we were able to stop you before anyone got seriously hurt.||Your weapons are confiscated and any doubloons you were carrying are taken as fine. Then you are bustled out of the inn and sent packing.">

<ROOM STORY166
	(IN ROOMS)
	(DESC "166")
	(STORY TEXT166)
	(PRECHOICE STORY166-PRECHOICE)
	(CONTINUE STORY374)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY166-PRECHOICE ()
	<COND (<IN? ,SWORD ,PLAYER>
		<REMOVE ,SWORD>
	)(<IN? ,SHARKS-TOOTH-SWORD ,PLAYER>
		<REMOVE ,SHARKS-TOOTH-SWORD>
	)(<IN? ,CLEAVER ,PLAYER>
		<REMOVE ,CLEAVER>
	)>
	<COND (<IN? ,PISTOL ,PLAYER> <REMOVE ,PISTOL>)>
	<SETG MONEY 0>
	<UPDATE-STATUS-LINE>>

<CONSTANT TEXT167 "He takes a mighty breath and blows it out at you, sending your coracle surging away on a huge billowing wave. You careen through the sea-soaked darkness, shivering for hours in the teeth of an unseasonal gale until finally you are cast up onto the beach outside Selenice.||Dawn tinges the sky with rose and gold. You sit up. There is no sign of the coracle. Waves lap the shoreline, seeming to whisper the secrets of the sea. You know those secrets well now;">
<CONSTANT TEXT167-CONTINUED "Returning to town, you run through your remaining options">

<ROOM STORY167
	(IN ROOMS)
	(DESC "167")
	(STORY TEXT167)
	(PRECHOICE STORY167-PRECHOICE)
	(DEATH T)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY167-PRECHOICE ()
	<COND (<NOT <CHECK-SKILL ,SKILL-SEAFARING>>
		<CRLF>
		<HLIGHT ,H-BOLD>
		<TELL "You must acquire now " D ,SKILL-SEAFARING>
		<HLIGHT 0>
		<CRLF>
		<SKILL-SWAP <LTABLE SKILL-BRAWLING>>
	)>
	<COND (<AND <IN? ,CORKSCREW ,PLAYER> <IN? ,SHIP-IN-BOTTLE ,PLAYER>>
		<STORY-JUMP ,STORY261>
	)(<IN? ,DEED-OF-OWNERSHIP ,PLAYER>
		<STORY-JUMP ,STORY318>
	)(<IN? ,DIAMOND ,PLAYER>
		<STORY-JUMP ,STORY299>
	)(ELSE
		<EMPHASIZE "Returning to town, you have exhausted all your options. You have no hope of catching up with Skarvench.">
		<RETURN>
	)>
	<PUTP ,STORY167 ,P?DEATH F>
	<CRLF>
	<TELL TEXT167-CONTINUED>
	<TELL ,PERIOD-CR>>

<CONSTANT TEXT168 "After agreeing to the captain's demands, you direct your crew to carry the bulk of the treasure aboard the warship. At least, that's the way it seems. The truth is that only the top of each chest contains gold coins - the rest is filled with the salt that was left aboard the Lady Shalott by her last owner. A few groans, pleas, tears and offers of bribery help to make this charade convincing. The warship sails off towards Leshand and you turn your prow towards Selenice, hoping to be long gone before they discover you've tricked them.">

<ROOM STORY168
	(IN ROOMS)
	(DESC "168")
	(STORY TEXT168)
	(CONTINUE STORY016)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT169 "This is grim work, but you cannot afford the luxury of hesitation. The sunlight is all but gone. Kneeling quickly beside the open coffin, you raise the stake in both hands and plunge it down with all your strength into the corpse's breast. There is a terrible gasping sigh from the dead lips. It reminds you of autumn leaves scattering in a breeze. Then the body crumples like withered parchment.||Blutz cries out. At the same moment, the sun is blotted out beyond the horizon and blue darkness rushes across the shore.">

<ROOM STORY169
	(IN ROOMS)
	(DESC "169")
	(STORY TEXT169)
	(CONTINUE STORY347)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT170 "Handing the kite to a sailor, you tell him to go up into the rigging and cast it towards the sky. \"What good will that do, skipper?\" asks Oakley as you watch the man climb.||\"Call it a hunch, Mister Oakley. That witch Ejada wouldn't treasure anything so mundane as a kite unless it possessed some kind of magical power. Now we'll find out exactly what.\"||\"It's a long shot,\" says Blutz, watching the Moon Dog dip lower in the night sky with silver sails gleaming.||You watch the sailor reach the top of the mast and throw the kite up into the heavens. Caught by some wind that the sails do not feel, it soars aloft higher and higher, seeming to grow larger as it goes so that it spreads like an inkblot against the moon.||\"The dragon wing of night o'erspreads the world...\" breathes Grimes, his voice barely a whisper. And the last of the moonlight is blotted out, leaving only the gleam of ships' lanterns on the low bank of fog and the spangling of a million stars in the clear blackness above.">

<ROOM STORY170
	(IN ROOMS)
	(DESC "170")
	(STORY TEXT170)
	(CONTINUE STORY246)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT171 "\"I don't know how you escaped death before,\" snarls Skarvench, \"but this time I'm going to make sure of the matter. I'll cut off your head and stick it on the bowsprit of my ship!||His sword comes slicing down in a lethal arc, barely missing your shoulder as you dodge desperately aside. It splinters a great chunk of wood out of the mast behind you. Skarvench only gives a bellow of insensate fury and draws it back for another swing. His is in a killing rage, and this fight will be every bit as dangerous as you had anticipated.">

<ROOM STORY171
	(IN ROOMS)
	(DESC "171")
	(STORY TEXT171)
	(PRECHOICE STORY171-PRECHOICE)
	(CONTINUE STORY361)
	(DEATH T)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY171-PRECHOICE ("AUX" (DMG 5))
	<COND (<AND <CHECK-SKILL ,SKILL-SWORDPLAY> <CHECK-SKILL ,SKILL-MARKSMANSHIP>>
		<SET DMG 2>
	)(<CHECK-SKILL ,SKILL-BRAWLING>
		<SET DMG 3>
	)>
	<LOSE-LIFE .DMG DIED-IN-COMBAT ,STORY171>>

<CONSTANT TEXT172 "The others are waiting for you on deck. In the slanting rays of the setting moon you make out the furtive silhouettes of Grimes, tall and gaunt; Oakley, strong as a tar barrel; and fat little Blutz.||They have the jollyboat swung out over the side. Stealthily you lower it into the water, working in deep silence like four burglars intent on a night's business. From the below wafts the sound of a hornpipe and snatches of revelry as the crew sing sea shanties in the galley. Climbing down to the jollyboat, you shove off from the side and row with muffled oars away from the brooding bulk of Belle Dame. The moon slips below the western horizon, leaving the night studded with stars. There is no wind and the sea is as flat as a pane of glass. As the sounds of jollity fade into the distance, only the soft splash of your oars remains to disturb the eerie quiet.">

<ROOM STORY172
	(IN ROOMS)
	(DESC "172")
	(STORY TEXT172)
	(PRECHOICE STORY172-PRECHOICE)
	(CONTINUE STORY289)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY172-PRECHOICE ()
	<COND (<OR <CHECK-SKILL ,SKILL-SEAFARING> <IN? ,BOOK-OF-CHARTS ,PLAYER>>
		<STORY-JUMP ,STORY381>
	)(<CHECK-SKILL ,SKILL-CHARMS>
		<STORY-JUMP ,STORY399>
	)(<CHECK-SKILL ,SKILL-SPELLS>
		<STORY-JUMP ,STORY416>
	)>>

<CONSTANT TEXT173 "You beach the jollyboat on a narrow strand of fine white sand backed by high cliffs. At the top of the cliffs you can clearly see the tall green boles of coconut trees. \"We're saved!\" cries Blutz, dancing an absurd little jig. \"We can eat those coconuts and even drink the milk if we can't find fresh water.\"||\"But there's a problem,\" says Grimes, surveying the steep cliffs with a dour gaze. \"Who's going to climb up there and get them? You, Mister Blutz?\"">
<CONSTANT CHOICES173 <LTABLE "climb the cliffs alone" "make your way along the beach in search of a way up" "try looking for food here on the beach" "put to sea and continue west towards the next island">>

<ROOM STORY173
	(IN ROOMS)
	(DESC "173")
	(STORY TEXT173)
	(CHOICES CHOICES173)
	(DESTINATIONS <LTABLE STORY192 STORY211 STORY230 STORY116>)
	(REQUIREMENTS <LTABLE SKILL-AGILITY NONE NONE NONE>)
	(TYPES <LTABLE R-SKILL R-NONE R-NONE R-NONE>)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT174 "Putting into a small cove, you moor the boat beside a large rock and then scramble ashore up a rocky moss-coated slope. Immediately you are confronted by lush jungle teeming with colour and life. Bright bulbous fruits dangle enticingly from the tree branches, yours for the taking. High up amid the emerald foliage, parrots in stained-glass hues peer down at you curiously, heads cocked to one side giving them a comical expression.||You and your friends have no difficulty in gathering food and fresh water.">

<ROOM STORY174
	(IN ROOMS)
	(DESC "174")
	(STORY TEXT174)
	(PRECHOICE STORY174-PRECHOICE)
	(CONTINUE STORY269)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY174-PRECHOICE ()
	<ADD-PROVISIONS 2>
	<COND (<CHECK-CODEWORD ,CODEWORD-PROSPERO> <STORY-JUMP ,STORY250>)>>

<CONSTANT TEXT175 "Your head swims; your limbs tremble with weakness. Looking into Oakley's face, you give a croak of bleak amusement. \"Saints alive, man, you look as though you'd been keelhauled!\"||He manages a wry half-smile- \"You think you do don't?\" Staggering over to slump beside you, he adds, \"We're not for long for this world now now, are we, mate?\"||You gaze into the west, almost all hope gone.">

<ROOM STORY175
	(IN ROOMS)
	(DESC "175")
	(STORY TEXT175)
	(PRECHOICE STORY175-PRECHOICE)
	(CONTINUE STORY156)
	(DEATH T)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY175-PRECHOICE ("AUX" (DMG 2))
	<COND (<CHECK-SKILL ,SKILL-SEAFARING>
		<SET DMG 1>
	)>
	<LOSE-LIFE .DMG DIED-OF-HUNGER ,STORY175>>

<CONSTANT TEXT176 "Resorting to an old trick of your trade, you toss a few pebbles to distract Ejada. She thinks she has heard you creeping away, and gives a wild laugh as she hurls her deathly bolts in the direction of the sound. Meanwhile you sneak into her tower and hastily feel your way along the wall until you come to a treasure chest. From this you pull a large diamond and a black kite.">
<CONSTANT TEXT176-CONTINUED "Ejada is still striding about the outside casting her spells into the undergrowth. \"Show yourself, coward!\" she screeches. \"This darkness won't last forever.\" Indeed it won't. Before the spell can wear off, you take your friends' arms and lead them back to the beach">

<ROOM STORY176
	(IN ROOMS)
	(DESC "176")
	(STORY TEXT176)
	(PRECHOICE STORY176-PRECHOICE)
	(CONTINUE STORY195)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY176-PRECHOICE ()
	<SELECT-FROM-LIST <LTABLE DIAMOND BLACK-KITE> 2 2>
	<CRLF>
	<TELL TEXT176-CONTINUED>
	<TELL ,PERIOD-CR>>

<CONSTANT TEXT177 "Taking stock of your situation leaves you in a grim mood. \"We're still more than two hundred leagues out from Port Leshand, ad there are no islands along the route for us to restock our supplies. What we've got left for now is going to have to keep us going for at least ten days.\"||Oakley has another thought, equally sobering. Pointing at the timbers of your vessel - now warped by the constant sun and the battering of high waves -- he mutters: \"Ten days? We might not stay afloat that long.\"||\"Maybe we shouldn't try to make it all the way to Leshand,\" suggests Blutz. \"We could head south from here towards the main shipping lanes. There's a good chance we'd be rescued by a friendly vessel.\"">

<CONSTANT CHOICES177 <LTABLE "go south" "keep on heading west">>

<ROOM STORY177
	(IN ROOMS)
	(DESC "177")
	(STORY TEXT177)
	(CHOICES CHOICES177)
	(DESTINATIONS <LTABLE STORY367 STORY404>)
	(TYPES TWO-NONES)
	(PRECHOICE STORY177-PRECHOICE)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY177-PRECHOICE ()
	<COND (<CHECK-CODEWORD ,CODEWORD-PECCANT>
		<PUT <GETP ,STORY177 ,P?DESTINATIONS> 2 ,STORY386>
	)(ELSE
		<PUT <GETP ,STORY177 ,P?DESTINATIONS> 2 ,STORY404>
	)>>

<CONSTANT TEXT178 "The flash of coral-pink tail against the white-foamed grey of the sea, and then she is gone.||Thunder rattles the buttresses of heaven, and the sky gleams with distant lightning. Grimes squints into the west. \"Another storm rolling in ahead,\" he says. \"We're in for a battering.\"||\"Let's head south!\" cries Blutz in sudden desperation. \"There are fewer storms, and we could pick up supplies among the islands, some of which are inhabited.\"||\"Yes,\" grunts Oakley. \"By cannibals.\"">
<CONSTANT CHOICES178 <LTABLE "give the order to steer south" "stay on your present westward course">>

<ROOM STORY178
	(IN ROOMS)
	(DESC "178")
	(STORY TEXT178)
	(CHOICES CHOICES178)
	(DESTINATIONS <LTABLE STORY135 STORY235>)
	(TYPES TWO-NONES)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT179 "It takes no special skill to murder a man while he sleeps, just a callous disregard for life. As Mandrigard's bright red blood drips down onto the floorboards and scattered jewels, you and your three companions stare at one another in the flickering lamplight. You all know the significance of your dreadful deed. Before you were merry rogues -- swashbucklers with one eye for plunder and one eye for thrills. Now you are rank villains.||Cramming your pockets with gold and gems worth a king's ransom you hurry away from the scene of the murder, up onto the deck where you at last feel a shudder of remorse.||Oakley recognizes the look on your face; he wears the same expression himself. Nodding, he cries, \"If this fresh breeze could only clean up my lungs of the stench of butchery - and this rain wash my hands of Mandrigard's blood!\"||\"Forget it,\" grunts Grimes. \"The deed's done. \"We can never go back to being as we were before.\"">
<CONSTANT CHOICES179 <LTABLE "escape from the ship" "or you think you have an item in your possession that might help" "otherwise">>

<ROOM STORY179
	(IN ROOMS)
	(DESC "179")
	(STORY TEXT179)
	(CHOICES CHOICES179)
	(DESTINATIONS <LTABLE STORY236 STORY255 STORY388>)
	(REQUIREMENTS <LTABLE SKILL-CHARMS NONE NONE>)
	(TYPES <LTABLE R-SKILL R-NONE R-NONE>)
	(PRECHOICE STORY179-PRECHOICE)
	(CODEWORD CODEWORD-CHANCERY)
	(FLAGS LIGHTBIT)>

<ROUTINE  STORY179-PRECHOICE ()
	<COND (,RUN-ONCE
		<GAIN-MONEY 10000>
	)>>

<CONSTANT TEXT180 "The giant crab drops down into the murk of the ocean, sinking as rapidly as a rock, and you are being carried along with it in the strong undertow. Luckily you were able to get a good lungful of air before you went under, and now you make full use of your remaining strength to strike powerfully up towards the glimmering pane of light that marks the surface.||The water drags at you like liquid lead. Your pulse thunders in your ears and your chest is burning with the need for air, but you struggle on with desperate strokes, clawing your way upwards until at last you break the surface.||Gasping for air, you are barely aware of your friends hauling you into the jollyboat. \"Come on, lads!\" you hear Oakley's voice yelling. \"Let's get clear before it resurfaces.\"">

<ROOM STORY180
	(IN ROOMS)
	(DESC "180")
	(STORY TEXT180)
	(CONTINUE STORY161)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT181 "You sleep soundly, waking at dawn to discover that Mortice and his raft have vanished. \"Good riddance to him, too,\" growls Oakley when you shake him awake with the news.||\"He was a rather creepy character,\" Grimes concedes.||\"Yes, but what about the food and water he had?\" Blutz reminds them. \"Now we're just as badly off as we were before.\"">

<ROOM STORY181
	(IN ROOMS)
	(DESC "181")
	(STORY TEXT181)
	(CONTINUE STORY332)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT182 "Skarvench and his men are not the sort to be taken unawares. With savagery shining from their eager faces, they close to surround you. The clash of steel and the sharp crack of musket shots ring out, startling the constant jungle murmur into silence. Gunpowder smoke and the abattoir stink of blood clog your nostrils. You are heavily outnumbered, and the struggle grows ever more desperate.">
<CONSTANT TEXT182-DEATH "You sell your lives dearly, but in an ultimately futile massacre.">
<CONSTANT CHOICES182 <LTABLE "fight on" "surrender">>

<ROOM STORY182
	(IN ROOMS)
	(DESC "182")
	(STORY TEXT182)
	(CHOICES CHOICES182)
	(DESTINATIONS <LTABLE STORY220 STORY201>)
	(PRECHOICE STORY182-PRECHOICE)
	(TYPES TWO-NONES)
	(DEATH T)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY182-PRECHOICE ()
	<COND (<AND <CHECK-SKILL ,SKILL-SWORDPLAY> <CHECK-SKILL ,SKILL-MARKSMANSHIP>>
		<COND (,RUN-ONCE
			<LOSE-LIFE 5 DIED-IN-COMBAT ,STORY182>
		)>
	)(ELSE
		<CRLF>
		<TELL TEXT182-DEATH>
		<TELL ,PERIOD-CR>
	)>>

<CONSTANT TEXT183 "\"El Draque?\" whispers an old sea salt whom you get talking to. \"Have ye not heard? He was captured and hanged at sea barely a month ago. By one account, his body was thrown overboard, but then swam three times around the ship before it sank.\"||Grimes peers into the sailor's tankard. \"What are you drinking mate?\"||\"Why, are you buying a round?\" says the fellow briskly.||\"No,\" Grimes replies. \"I was just going to advise you to drink a bit less of it.\" As you leave the tavern, he says, \"Enough of these taproom tales. It's time we shipped out after Skarvench.\"">

<ROOM STORY183
	(IN ROOMS)
	(DESC "183")
	(STORY TEXT183)
	(CONTINUE STORY392)
	(FLAGS LIGHTBIT)>

<ROOM STORY184
	(IN ROOMS)
	(DESC "184")
	(PRECHOICE STORY184-PRECHOICE)
	(CONTINUE STORY320)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY184-PRECHOICE ()
	<COND (<EQUAL? ,CURRENT-VEHICLE ,LADY-OF-SHALOTT>
		<PUTP ,LADY-OF-SHALOTT ,P?STARS 1>
	)(<EQUAL? ,CURRENT-VEHICLE ,SHIVERED-TIMBER>
		<PUTP ,SHIVERED-TIMBER ,P?STARS 2>
	)(<EQUAL? ,CURRENT-VEHICLE ,QUEENS-RANSOM>
		<PUTP ,QUEENS-RANSOM ,P?STARS 3>
	)(<EQUAL? ,CURRENT-VEHICLE ,FAERIE-QUEEN>
		<PUTP ,FAERIE-QUEEN ,P?STARS 3>
	)(<EQUAL? ,CURRENT-VEHICLE ,METEOR>
		<PUTP ,METEOR ,P?STARS 4>
	)(<EQUAL? ,CURRENT-VEHICLE ,OCTAVIUS>
		<PUTP ,OCTAVIUS ,P?STARS 4>
	)(<EQUAL? ,CURRENT-VEHICLE ,PROVIDENCE>
		<PUTP ,PROVIDENCE ,P?STARS 5>
	)(<EQUAL? ,CURRENT-VEHICLE ,CALYPSO>
		<PUTP ,CALYPSO ,P?STARS 5>
	)>>

<CONSTANT TEXT185 "One of the bullies gives a brutish sneer. \"You won't use that,\" he says with a scornful glance at the pistol. \"You'd be strung up for using a weapon in a brawl.\"||You shrug. \"True, I might get a rope around my neck -- if I'm caught. But it's a sure thing you won't attend the hanging. You'll be dead meat by then.\" He stares at you, licking his thick lips uncertainly. \"You wouldn't dare. Even if you kill me, my buddies here'll rip you apart.\"||You raise your pistol purposefully. It is aimed right between his eyes. \"Again, maybe that's so, but it won't do you any good with your brains splattered all over that wall.\"||His nerve breaks. With a snarl, he draws his cronies away and they slope off into the street. You tuck the pistol back inside your shirt before anyone sees you with it.">

<ROOM STORY185
	(IN ROOMS)
	(DESC "185")
	(STORY TEXT185)
	(CONTINUE STORY223)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT186 "Signing on a small crew, you set sail. A strong following wind allows you to make good headway, and you reach the island within a fortnight. As you coast in search of safe anchorage, Blutz points out a smaller isle that would be joined to the main island at low tide. Beyond it lies a bay where you drop anchor. Going ashore on the smaller island armed with shovels, you soon discover a boulder marked with crossed bones. \"Here's where we shall dig,\" you tell the others.||You labour on throughout the afternoon -- and hot work it is, with barely a breath of wind under a sun steaming through coastal marsh-haze. The western sky is already turning the colour of blood when there is the scrape of iron on wood. \"I've found a box!\" yells Blutz.||\"And I another!\" Grimes calls out a moment later.||Scooping away the sand with your hands, you uncover a dozen large wooden crates. \"This is a goodly hoard!\" you say, breathless with sudden excitement. \"Break one open, lads, and let's see El Draque's treasure.\"||Grimes smashes a hasp with his shovel. There is a creak as you wrench the lid up. A strong smell of tobacco and tar rises from the interior -- and something else: formaldehyde. A corpse lies there, resting on silver ingots, eyes staring sightlessly from a face which is colourless but untouched by decay. On the waxy flesh of its bare chest you see a tattoo with the legend \"Dethly is fear\".||\"In God's holy name,\" breathes Oakley, \"what's this?\"||Blutz grabs your arm. \"The sun's close to setting, skipper. For heaven's sake, let's forget the treasure and put to sea while we still can!\"">
<CONSTANT CHOICES186 <LTABLE "open the other boxes" "wait until nightfall" "return to the ship and set sail at once">>

<ROOM STORY186
	(IN ROOMS)
	(DESC "186")
	(STORY TEXT186)
	(CHOICES CHOICES186)
	(DESTINATIONS <LTABLE STORY078 STORY347 STORY413>)
	(TYPES THREE-NONES)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT187 "The captain and his marines wait like hawks for your decision. You can sense Oakley and the others readying themselves for a fight, but you know that both honour and common-sense demand that you give in to these conditions.||\"All right, tell your men to load the Queen's gold aboard your ship.\" After he has issued the order, your resentment is still smouldering. \"I expect you'd have preferred us to fight,\" you say. \"You enjoy killing pirates, I'll bet.\"||He shrugs as if your opinion means nothing. \"Killing pirates is my duty. But you're not a pirate are you? You're a privateer, and it's not my job to quarrel with privateers. Not so long as they pay the Queen her due.\"||He returns to his warship and turns in the direction of Leshand. \"Any orders? asks Grimes as you watch the warship sail away.||\"Yes, Mister Grimes. Lay in a course for Selenice while we still have a few doubloons in our hold.\"">

<ROOM STORY187
	(IN ROOMS)
	(DESC "187")
	(STORY TEXT187)
	(CONTINUE STORY301)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT188 "This is grim work, but you cannot afford the luxury of hesitation. In moments the sunlight will be gone. Quickly dropping to your knees beside the open box, you raise the stake in both hands and plunge it down hard into the corpse's heart. A terrible gasping sigh escapes the dead lips, reminding you of the sound of autumn leaves scattering in a breeze. Then the body crumbles like ancient parchment.||Blutz cries out. At the same moment, the sun is blotted out beyond the horizon and night rushes triumphantly across the world.">

<ROOM STORY188
	(IN ROOMS)
	(DESC "188")
	(STORY TEXT188)
	(CONTINUE STORY347)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT189 "You take out your pocket-watch and glance at it. The glass was cracked when it stopped Skarvench's bullet, but it is still working. \"Midnight,\" you say, and close the case with a click.||There is a gasp from the sailors. One man almost falls out of the rigging in shock. Staring at the sky, they watch as an encroaching arc of darkness closes in front of the moon. \"'Tis doomsday!\" cries the bo'sun. \"First an unseasonal hurricane, then becalmed in fog, then flying ships - an' now a dragon devours the moon!\" A low moan of dread escapes the crew's lips.||Stand fast, you timid swabs!\" you thunder down at them from the poopdeck. \"Have you never seen an eclipse of the moon before?\"">

<ROOM STORY189
	(IN ROOMS)
	(DESC "189")
	(STORY TEXT189)
	(CONTINUE STORY246)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT190 "The helmet fills your mind with the battle-lore of the Spartans. You sense the effect is only temporary - but it should last long enough to help you defeat Skarvench, or die trying.">

<ROOM STORY190
	(IN ROOMS)
	(DESC "190")
	(STORY TEXT190)
	(PRECHOICE STORY190-PRECHOICE)
	(CONTINUE STORY209)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY190-PRECHOICE ("AUX" COUNT)
	<RESET-TEMP-SKILLS>
	<SET COUNT 1>
	<COND (<NOT <CHECK-SKILL ,SKILL-BRAWLING>>
		<PUT TEMP-SKILLS .COUNT ,SKILL-BRAWLING>
		<SET COUNT <+ .COUNT 1>>
		<EMPHASIZE "You have temporarily gained BRAWLING">
	)>
	<COND (<NOT <CHECK-SKILL ,SKILL-SWORDPLAY>>
		<PUT TEMP-SKILLS .COUNT ,SKILL-SWORDPLAY>
		<SET COUNT <+ .COUNT 1>>
		<EMPHASIZE "You have temporarily gained SWORDPLAY">
	)>
	<RETURN>>

<CONSTANT TEXT191 "You come face to face with the sailmaster. For a moment he stands there in simple perplexity. As an ordinary seaman you are not supposed to be in this part of the ship. \"What are you doing..?\" he starts to say.">
<CONSTANT TEXT191-END "You are helpless to prevent him from altering the other pirates, who rush out of Skarvench's cabin to seize you. Your adventure ends before it even began">
<CONSTANT CHOICES191 <LTABLE "attack him before he can sound the alarm using" "or" "fall back">>

<ROOM STORY191
	(IN ROOMS)
	(DESC "191")
	(STORY TEXT191)
	(CHOICES CHOICES191)
	(DESTINATIONS <LTABLE STORY286 STORY248 STORY305>)
	(REQUIREMENTS <LTABLE SKILL-SWORDPLAY SKILL-BRAWLING SKILL-CUNNING>)
	(PRECHOICE STORY191-PRECHOICE)
	(TYPES <LTABLE R-SKILL R-SKILL R-SKILL>)
	(DEATH T)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY191-PRECHOICE ()
	<COND (<OR <CHECK-SKILL ,SKILL-SWORDPLAY> <CHECK-SKILL ,SKILL-BRAWLING> <CHECK-SKILL ,SKILL-CUNNING>>
		<PUTP ,STORY191 ,P?DEATH F>
	)(ELSE
		<TELL TEXT191-END>
		<TELL ,PERIOD-CR>
	)>>

<CONSTANT TEXT192 "With a dexterity that amazes your companions, you scale the cliffs like a monkey and have soon hurdle down enough coconuts to keep you all supplied for days. You scramble back down to the beach amid cheers of delight.||\"Well done,\" says Oakley. He is smiling, but you notice he turns to cast a wary look along the shore. \"Now I suggest we lose no time loading these aboard and casting off. I've no wish to run into the natives hereabouts.\"">
<CONSTANT CHOICES192 <LTABLE "leave this island and head west as Oakley suggests" "explore further">>

<ROOM STORY192
	(IN ROOMS)
	(DESC "192")
	(STORY TEXT192)
	(CHOICES CHOICES192)
	(DESTINATIONS <LTABLE STORY116 STORY211>)
	(TYPES TWO-NONES)
	(PRECHOICE STORY192-PRECHOICE)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY192-PRECHOICE ()
	<ADD-PROVISIONS 2>>

<CONSTANT TEXT193 "\"No, you're wrong,\" you tell Blutz. \"Look at most of the island. It's well covered in vegetation, right?\" That volcano has most likely been hissing and spitting for years, but if there had been any major eruption then the jungle wouldn't have grown up to that extent.\"||\"All the same,\" says Grimes, \"let's not dally longer than we have to. The sight of those lava-covered slopes puts me in mind of Stan's brimstone fires!\"">
<CONSTANT CHOICES193 <LTABLE "go ashore" "row on westwards">>

<ROOM STORY193
	(IN ROOMS)
	(DESC "193")
	(STORY TEXT193)
	(CHOICES CHOICES193)
	(DESTINATIONS <LTABLE STORY174 STORY135>)
	(TYPES TWO-NONES)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT194 "Despite the thick jungle, you reach the tower quickly by following a stone pathway that leads through the undergrowth. You emerge into a wide grass-covered plaza and facing you is a white marble palace with a high tower. You move cautiously closer and Oakley runs his hand over the monumental carvings beside the entrance. They show a queen or priestess dispatching her enemies into luridly depicted hells.||\"How was this stone brought here?\" Grimes wonders aloud. \"It's not local to the island, if I'm any judge.\"||\"You're right,\" says a woman's voice. \"I brought it here by magic.\"">

<ROOM STORY194
	(IN ROOMS)
	(DESC "194")
	(STORY TEXT194)
	(CONTINUE STORY251)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT195 "It seems that the witch's exertions have weakened the spell she cast to bury your jollyboat. Or perhaps desperation lends you unprecedented strength. Whatever the reason, you manage to dig the boat out of the sand and drag it down to the water's edge. Piling in, you put out to sea at once.">

<ROOM STORY195
	(IN ROOMS)
	(DESC "195")
	(STORY TEXT195)
	(CONTINUE STORY137)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT196 "A shot rings out. A man falls dead. It is a sad, grim, brutally sudden scene which has been played out many times on the stage of life. As always, the onlookers stand for a moment, stunned, waiting for Death to withdraw into the wings so the action can resume.||The moment passes. The natives are not awed by your ability to kill at a distance -- they have seen firearms before, and know it is no miracle. There is an angry shout, and a thrown rock grazes your hand. The pistol is knocked to the ground. The natives stand watching you, ominously tense, torn between shock, grief and rage.">
<CONSTANT CHOICES196 <LTABLE "get out while you can, abandoning your pistol" "you stand and fight">>
<GLOBAL DROPPED-WEAPON NONE>

<ROOM STORY196
	(IN ROOMS)
	(DESC "196")
	(STORY TEXT196)
	(CHOICES CHOICES196)
	(DESTINATIONS <LTABLE STORY177 STORY215>)
	(TYPES TWO-NONES)
	(PRECHOICE STORY196-PRECHOICE)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY196-PRECHOICE ()
	<COND (,RUN-ONCE
		<LOSE-ITEM ,PISTOL>
		<SETG DROPPED-WEAPON ,PISTOL>
	)>>

<CONSTANT TEXT197 "Gradually you leave behind the icy rain that has been your constant accompaniment throughout the journey. The southern waters into which the mermaid is now taking you are calmer, the weather warmer. Even so, the comfort only allows you time to regret your other deprivations - not the least of which is hunger.">
<CONSTANT TEXT197-CONTINUED "You see a fleece of white cloud, then a green-tinged hump of land comes in sight. \"Yonder is Red Skull Island,\" announces the mermaid. \"Here, food and water are yours for the taking -- subject only to those laws of ownership which pertain throughout the surface world.\" With a sly wink which raises belated misgivings in your mind, she releases the tow-rope and slides beneath the waves.">

<ROOM STORY197
	(IN ROOMS)
	(DESC "197")
	(STORY TEXT197)
	(PRECHOICE STORY197-PRECHOICE)
	(CONTINUE STORY173)
	(DEATH T)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY197-PRECHOICE()
	<COND (<IN? ,MONKEY ,PLAYER>
		<CRLF>
		<TELL "Eat the monkey (if you are heartless or desperate enough)?">
		<COND (<YES?>
			<REMOVE ,MONKEY>
		)(ELSE
			<LOSE-LIFE 2 DIED-OF-HUNGER ,STORY197>
		)>
	)(ELSE
		<LOSE-LIFE 2 DIED-OF-HUNGER ,STORY197>
	)>
	<IF-ALIVE TEXT197-CONTINUED>>

<CONSTANT TEXT198 "You hesitate, hands hovering over the wealth of spilled treasure. You are spoiled for choice. Simple riches would buy you a ship of your own, in which you could track down and challenge the foul Skarvench. On the the other hand, you cannot help noticing some special items among the treasure -- artefacts whose real value lies not in their monetary worth, but in the magical power they might posses.||Mandrigard snores, stirring in his sleep. He might awaken at any moment. You must decide.">
<CONSTANT CHOICES198 <LTABLE "take items of simple monetary value" "favour items which look to be magical in nature">>

<ROOM STORY198
	(IN ROOMS)
	(DESC "198")
	(STORY TEXT198)
	(CHOICES CHOICES198)
	(DESTINATIONS <LTABLE STORY274 STORY293>)
	(TYPES TWO-NONES)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT199 "\"Can you hear me, shipmate?||Blutz's face swims out of a murky void. Your first thought is: what's he doing under the sea? The next moment you sit bold upright, convulsing as you cough sea-water out of your lungs.||\"We thought you were lost,\" says Oakley in a voice filled with wonder. \"Since you went down with that giant crab, we hadn't seen a sign of you. That was almost an hour ago. Then you came bobbing up near the boat and we hauled you in.\"||\"It's a miracle you aren't drowned,\" says Grimes.||You look down to see your fingers clutched tightly around your magic amulet. It is the one thing you managed to hold on to; all your possessions are gone. You cannot remember how, but you guess that your last act before losing consciousness must have been to work a charm against drowning. That explains why you are not dead. But Grimes is still partly right, because it's a miracle that the current carried you back to your friends.||The crab is long gone, but it is still not safe to stay in the vicinity.">
<CONSTANT CHOICES199 <LTABLE "carry on westwards on your present course" "steer north in the hope of striking the island chain">>

<ROOM STORY199
	(IN ROOMS)
	(DESC "199")
	(STORY TEXT199)
	(CHOICES CHOICES199)
	(DESTINATIONS <LTABLE STORY047 STORY066>)
	(PRECHOICE STORY199-PRECHOICE)
	(TYPES TWO-NONES)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY199-PRECHOICE ()
	<RESET-POSSESSIONS>
	<MOVE ,MAGIC-AMULET ,PLAYER>>

<CONSTANT TEXT200 "Sleep gradually gives way to awareness. Daylight bathes you, slowly warming the chill from your bones. Suddenly your eyes snap open. You have slept long past dawn and the sun is now high in the sky.. You rise and stretch, feeling curiously giddy and drained of strength. The others are the same. You remark on how haggard they look, bloodshot eyes staring from bloodless faces. You all look and feel as though you had been drugged.||\"Something's bitten me on the neck...\" growls Oakley, gingerly touching the wound and examining the sticky smear of blood on his fingers.||\"Me too,\" says Blutz.||All four of you have been bitten -- a double puncture mare, deep and raw. No mosquito could have made those bites. And now you notice something else: the raft and its sinister occupant have vanished during the night.">

<ROOM STORY200
	(IN ROOMS)
	(DESC "200")
	(PRECHOICE STORY200-PRECHOICE)
	(CONTINUE STORY332)
	(DEATH T)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY200-PRECHOICE ()
	<LOSE-LIFE 4 "You died some time during the night" ,STORY200>
	<IF-ALIVE TEXT200>>

<CONSTANT TEXT201 "Your arms are tied. \"Take 'em to the ship,\" growls Skarvench to a couple of his men. \"I'm going to stock up on fresh victuals while we're here.\" You are bundled into the boat. The men assigned to guard you are the rat-faced quartermaster, Curshaw, and Porbuck, the burly first mate. Skarvench himself stays behind with the rest of the shore party to collect supplies while you are rowed back, bound, towards the Belle Dame. You must do something.">
<CONSTANT CHOICES201 <LTABLE "use" "use" "use" "otherwise if you have none of those">>

<ROOM STORY201
	(IN ROOMS)
	(DESC "201")
	(STORY TEXT201)
	(CHOICES CHOICES201)
	(DESTINATIONS <LTABLE STORY372 STORY391 STORY408 STORY240>)
	(REQUIREMENTS <LTABLE SKILL-CUNNING SKILL-ROGUERY SKILL-BRAWLING>)
	(TYPES <LTABLE R-SKILL R-SKILL R-SKILL R-NONE>)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT202 "Queen Titania will be visiting a number of Gloriannic colonies in the New World and is scheduled to finish her tour at Port Tudor, where she will reside until after the hurricane season. Since the Sidonians would dearly love to capture her, security for the trip has been made watertight. She will be accompanied by Dr Wild, the court sorcerer, aboard her flagship the Rose, and escorted by Admiral Lord Calidor with a fleet of twelve galleons.||\"The flotilla's security is as unassailable as the Queen's own virtue,\" opines one of your informants. From what you have learned you'd be inclined to agree. And yet... Skarvench clearly has some trick up his sleeve.">
<CONSTANT CHOICES202 <LTABLE "try to find out exactly what Skarvench has been up to recently" "more interested in the notorious pirate El Draque" "visit a chandler's to buy supplies" "get your magical treasures identified" "apply for a letter of marque" "pay a visit to Master Capstick" "you have now completed all your business in Leshand">>

<ROOM STORY202
	(IN ROOMS)
	(DESC "202")
	(STORY TEXT202)
	(CHOICES CHOICES202)
	(DESTINATIONS <LTABLE STORY278 STORY164 STORY012 STORY031 STORY409 STORY069 STORY107>)
	(REQUIREMENTS <LTABLE NONE NONE NONE NONE NONE <LTABLE CODEWORD-MARATHON> NONE>)
	(TYPES <LTABLE R-NONE R-NONE R-NONE R-NONE R-NONE R-CODEWORD R-NONE>)
	(PRECHOICE STORY202-PRECHOICE)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY202-PRECHOICE ()
	<COND (<CHECK-SKILL ,SKILL-ROGUERY>
		<PUT <GETP ,STORY202 ,P?DESTINATIONS> 5 ,STORY050>
	)(ELSE
		<PUT <GETP ,STORY202 ,P?DESTINATIONS> 5 ,STORY409>
	)>>

<CONSTANT TEXT203 "The shark and the dolphin slowly sink, taking the strange boat with them. The waters close over them like thin black oil, and in a last pearly glimmer they are gone. Moonrise flickers just below the horizon. The wind soughs, ruffling white flecks on the waves.||\"We'd have fared ill if we'd ventured into Neptune's realm,\" says Oakley with conviction. \"Better that we obtain a ship by more normal means.\"||You return to spend the night in Selenice. The next day you take stock of your remaining options.">

<ROOM STORY203
	(IN ROOMS)
	(DESC "203")
	(STORY TEXT203)
	(PRECHOICE STORY203-PRECHOICE)
	(DEATH T)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY203-PRECHOICE ()
	<COND (<AND <IN? ,CORKSCREW ,PLAYER> <IN? ,SHIP-IN-BOTTLE ,PLAYER>>
		<STORY-JUMP ,STORY261>
	)(<IN? ,DEED-OF-OWNERSHIP ,PLAYER>
		<STORY-JUMP ,STORY318>
	)(<IN? ,DIAMOND ,PLAYER>
		<STORY-JUMP ,STORY299>
	)(ELSE
		<EMPHASIZE "But you have already exhausted all your options. Your cause is hopeless.">
		<RETURN>
	)>
	<PUTP ,STORY203 ,P?DEATH F>>

<CONSTANT TEXT204 "With the help of your comrades you make short work of the three ruffians.">
<CONSTANT TEXT204-CONTINUED "You retrieve the spectacles from the hands of one of those unconscious ruffians and hand them back to their owner">

<ROOM STORY204
	(IN ROOMS)
	(DESC "204")
	(STORY TEXT204)
	(PRECHOICE STORY204-PRECHOICE)
	(CONTINUE STORY223)
	(DEATH T)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY204-PRECHOICE ()
	<LOSE-LIFE 1 DIED-IN-COMBAT ,STORY204>
	<IF-ALIVE TEXT204-CONTINUED>>

<CONSTANT TEXT205 "The harbour is vast. You cannot see the wharfs, blurred by the distance and darkness. As your coracle proceeds, you pass a multitude of ships lying at anchor all around you. A huge hulk looms up, shaped rather like a massive cradle. \"What about that one?\" says Blutz, awestruck. \"You could fit an entire menagerie insider her!\"||\"Too ponderous,\" you decide.||Next you pass a sleek high-powered galley with notches for fifty deck-cannon. \"There's a ship built for heroes,\" avers Grimes. \"Notice the fine beam of the prow, carved to resemble a mouth. What wisdom might she utter, if that mouth could talk!\"||\"A well-designed vessel, to be sure,\" you admit, \"but look at the timbers of the bowsprit. They are so weathered with age that they might give way, to the mortal detriment of any poor soul standing below when they fell.\"||\"What about that one?\" suggests Oakley, pointing further across the bay.||\"Bah, she is entirely clad in sheets of iron! She would be slow to turn -- and, see, despite those long spars of metal she has no masts on her deck! No, we must look further.\"||\"There's our ship!\" yells Blutz in sudden excitement.||You look to see a tall-masted vessel painted all in black except for the blue lacquer adoring her prow. Her figurehead is a muscular stature in oak wearing a winged helmet on his brow. His arm, upraised with staff held high, seems to point to a destiny brimming with glory. You nod, reading the name blazoned in gold on the ship's escutcheon. \"Yes, she's the one for us. The Calypso.||Climbing aboard, you raise the sails and take her out of the harbour under the watchful gaze of the colossus. Still standing astride the harbour mouth, he calls after you as you sail off: \"Mind you don't earn my ire like that other rogue that sailed her before you!\"||There's no telling what he means by that, but your only thought is for your new vessel. She cuts through the waves with matchless grace and speed, steady as a surgeon's saw. You stand proudly behind the mast, revelling in every wave and gust of salty spray. As dawn breaks, you see the familiar outline of Selenice harbour ahead.">

<ROOM STORY205
	(IN ROOMS)
	(DESC "205")
	(STORY TEXT205)
	(PRECHOICE STORY205-PRECHOICE)
	(CONTINUE STORY184)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY205-PRECHOICE ()
	<TAKE-VESSEL ,CALYPSO>>

<CONSTANT TEXT206 "Your call to arms is cut short by the marine sergeant, who coshes you with the butt of his pistol before discharging it at Grimes. In seconds a frenzied battle breaks out all along the ship. The marines fight with iron discipline, hearts brimming with patriotic fervour, but your scurvy mob of pirates have a still stronger motivation: the glitter of gold awaits them if they win, a hangman's noose if they lose.">

<ROOM STORY206
	(IN ROOMS)
	(DESC "206")
	(STORY TEXT206)
	(PRECHOICE STORY206-PRECHOICE)
	(CONTINUE STORY225)
	(DEATH T)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY206-PRECHOICE ("AUX" (DMG 8))
	<COND (<OR <CHECK-SKILL ,SKILL-MARKSMANSHIP> <CHECK-SKILL ,SKILL-SWORDPLAY>>
		<SET DMG 2>
	)(<CHECK-SKILL ,SKILL-BRAWLING>
		<SET DMG 4>
	)>
	<LOSE-LIFE .DMG DIED-IN-COMBAT ,STORY206>
	<IF-ALIVE "You survive to see victory.">>

<CONSTANT TEXT207 "Your obsessive search for the iceberg drives you to plot a course far off the familiar shipping lanes. At first, awed by your reputation as a mariner, the crew toil on without complaint. But the days draw by with no sight of land or other ships, and then grumbling begins. Initially it takes the form of simple discontent -- a spluttered curse when a man bites into an apple from the deck-barrel and finds it sour, or a surly rejoinder when orders are given. Oakley, Grimes and Blutz do their best to keep discipline, but the sun beats down day after day until the pitch bubbles in the seams and the deck is too hot to walk on in bare feet. Water begins to run low, and it is then that the grumbling begins to veer towards outright mutiny.">
<CONSTANT CHOICES207 <LTABLE "decide to continue searching for the iceberg in spite of the crew's reluctance" "abandon the search and return to Selenice">>

<ROOM STORY207
	(IN ROOMS)
	(DESC "207")
	(STORY TEXT207)
	(CHOICES CHOICES207)
	(DESTINATIONS <LTABLE STORY093 STORY396>)
	(TYPES TWO-NONES)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT208 "There is not enough wind to bring you up to the fog bank before the Moon Dog. You watch her descend until she is hovering above the fog, sails shimmering with occult energy. Ropes are dropped down from her rail, and hazily you make out the shapes of men descending on these ropes like a dozen web-spinning spiders.||\"Not enough breeze for the sails,\" you groan. \"I'd give half my life for a single gust of that hurricane now!\"||The fog envelops your bows. \"We'll have to heave to, skipper,\" cautions Grimes. \"We might run smack into the Rose in this pea-souper.\"||You are forced to agree. Tense minutes pass. Straining your ears, you think you can hear muffled shouts from far off: \"The Queen! They've got the Queen!\" and \"Where's their ship?\"||As suddenly as it arose, the fog disperses. The Rose looms close ahead of you, and now you can see figures milling across her deck in panic. You look up to see Skarvench's flying ship appear as a gaunt shadow across the moon for a moment; then it disappears into a rack of cloud.||Soldiers come rowing out from the Rose and clamber aboard waiting for permission. You find yourselves staring down the barrels of thirty muskets. \"What is this?\" you demand angrily. \"We're not your enemies. We came to save the Queen!\"||Admiral Calidor stares at you like a hawk. He is obviously in a state of anguish but he struggles to control it as he says flatly, \"The Queen has been kidnapped by your accomplices. You're going to tell me where they've taken her.\"||\"I don't know!\" you yell back at him. \"They weren't our accomplices. I told you, we're on your side!\"||Your arms are seized by soldiers and you are bundled into a rowboat. \"These pirates are all the same,\" mutters Calidor to his sergeant of marines. \"Distasteful though it is, we'll have to put them to torture.\"||You are a long time dying on the rack in the bowels of Calidor's ship. But what makes your death all the more bitter is that you are being punished for the crimes of your arch enemy, the evil Captain Skarvench.">

<ROOM STORY208
	(IN ROOMS)
	(DESC "208")
	(STORY TEXT208)
	(DEATH T)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT209 "The deck is deserted. Barrels and splintered booms lie scattered all around. Fog drifts through the torn rigging, reminding you of the slow unfolding of undersea plants. \"What happened to the crew? The soldiers guarding the Queen?\" whispers Blutz as he climbs over the rail behind you.||\"Perhaps stunned by the storm,\" you reply, also in a whisper. \"They must have taken a fearful battering. Also they must be expecting trouble...\"||The end of a rope lashes down onto the deck. You glance up. A vast grey shadow is hovering overhead, buoyed up by nothing but mist and moonlight: the Moon Dog.">
<CONSTANT CHOICES209 <LTABLE "climb up the rope to the Moon Dog" "try out a plan" "wait at the bottom of the rope until your enemies come to you">>

<ROOM STORY209
	(IN ROOMS)
	(DESC "209")
	(STORY TEXT209)
	(CHOICES CHOICES209)
	(DESTINATIONS <LTABLE STORY228 STORY247 STORY266>)
	(REQUIREMENTS <LTABLE SKILL-AGILITY SKILL-CUNNING NONE>)
	(TYPES <LTABLE R-SKILL R-SKILL R-NONE>)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT210 "Hurriedly clutching your amulet and uttering an all-purpose good luck charm, you wait to see what effect it will have. Just as the cabin door is swinging open, the person outside gives a gasp of annoyance. \"Damn it...\" he mutters to himself, and you hear the rustle of oilskins as he pats his pockets, \"left my pipe in the galley.\"||Only when he has retraced his steps, vanishing off along the passage in the direction of the galley, do you expel your breath in a relieved sigh. A hurried inspection of the cabin uncovers a few items that might prove useful: a toolkit, a book of charts, and a crucifix. The last of these brings a wry smile to your lips. A thousand crucifixes would not be enough to save the souls of the black-hearted villains in Skarvench's crew.">
<CONSTANT TEXT210-CONTINUED "Just as you are about to leave the cabin, there is a little shriek from the bunk and something small and grey launches itself onto your back. The shock sends your heart thudding like a hammer, but it is only the monkey that serves as the ship's mascot. Mister Chatter, the crew call him. He seems keen to go with you -- and small wonder, given the cruelty with which he is treated by most of the pirates. You could let him perch on your shoulder. Maybe he would bring you luck, at that. On the other hand, he'd be an extra mouth to feed aboard the rowing-boat, and if he does not keep quiet then he could bring the whole crew down on you">
<CONSTANT TEXT210-ENDING "Then, having spent long enough about fetching supplies, you hasten to rejoin your friends">

<ROOM STORY210
	(IN ROOMS)
	(DESC "210")
	(STORY TEXT210)
	(PRECHOICE STORY210-PRECHOICE)
	(CONTINUE STORY172)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY210-PRECHOICE ()
	<SELECT-FROM-LIST <LTABLE TOOLKIT BOOK-OF-CHARTS CRUCIFIX> 3 1>
	<CRLF>
	<TELL TEXT210-CONTINUED>
	<TELL ,PERIOD-CR>
	<CRLF>
	<TELL "Take the monkey?">
	<COND (<YES?> <TAKE-ITEM ,MONKEY>)>
	<CRLF>
	<TELL TEXT210-ENDING>
	<TELL ,PERIOD-CR>>

<CONSTANT TEXT211 "Some distance along the shore you find a ladder of knotted vines dangling down from the clifftop. \"Looks like there are natives,\" observes Oakley unnecessarily. \"Perhaps we'd be wiser to go back to the boat and shove off.\"||Your experience has been that not all islanders are hostile. It usually depends on the way they have been treated by the outsiders they've met. On the other hand, there are some who are unabashed cannibals and will attack with provocation if they see the chance of an easy meal.">
<CONSTANT CHOICES211 <LTABLE "climb the vines" "return to the jollyboat and continue on your voyage">>

<ROOM STORY211
	(IN ROOMS)
	(DESC "211")
	(STORY TEXT211)
	(CHOICES CHOICES211)
	(DESTINATIONS <LTABLE STORY249 STORY116>)
	(TYPES TWO-NONES)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT212 "Grimoire Island is a strangely idyllic-looking place, with wide white beaches fringed by gently swaying palm trees. A balmy breeze blows refreshingly from the east. Birds the colour of precious gems watch your approach without fear.||\"It's eerie,\" decides Grimes. \"Almost too perfect.\"||\"Like it's been tended,\" says Blutz. \"You know, like somebody's garden back home.\"||\"A demon's garden, if the native stories are to be believed,\" chips in Oakley. All three, like you, are in a strange mood: both allured and uneasy.">
<CONSTANT CHOICES212 <LTABLE "go ashore" "row on towards the next island">>

<ROOM STORY212
	(IN ROOMS)
	(DESC "212")
	(STORY TEXT212)
	(CHOICES CHOICES212)
	(DESTINATIONS <LTABLE STORY118 STORY137>)
	(TYPES TWO-NONES)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT213 "Blutz reaches out towards what looks like a bunch of oranges. You snatch them out of his pudgy hand. \"That's strychnine fruit,\" you warn him. \"It's deadly poisonous.\" Oakley shows you a handful of berries he's picked, but you shake your head. \"Those too. Everything here looks delicious, but most are poison.\"||\"The tower, then,\" says Grimes. \"Whoever lives there might give us food.\"||Blutz looks worried. \"But what kind of person lives on an island surrounded by poisonous plants?\"||It's a good question.">
<CONSTANT CHOICES213 <LTABLE "go to the tower" "put to sea at once">>

<ROOM STORY213
	(IN ROOMS)
	(DESC "213")
	(STORY TEXT213)
	(CHOICES CHOICES213)
	(DESTINATIONS <LTABLE STORY194 STORY137>)
	(TYPES TWO-NONES)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT214 "You easily outmanoeuvre the warship and soon leave her far behind">
<CONSTANT CHOICES214 <LTABLE "fight her" "permit your ship to be boarded">>

<ROOM STORY214
	(IN ROOMS)
	(DESC "214")
	(CHOICES CHOICES214)
	(DESTINATIONS <LTABLE STORY252 STORY024>)
	(PRECHOICE STORY214-PRECHOICE)
	(TYPES TWO-NONES)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY214-PRECHOICE ()
	<COND (<CHECK-SKILL ,SKILL-SEAFARING>
		<CRLF>
		<TELL TEXT214>
		<TELL ,PERIOD-CR>
		<STORY-JUMP ,STORY016>
	)>>

<CONSTANT TEXT215 "You are outnumbered, but you have an advantage they do not hare. Warfare in their society is rarely fatal, intended only as a ritual show of strength. They lack the murderous instincts of you 'civilized' men.">
<CONSTANT TEXT215-CONTINUED "You fight your way down the beach and hastily put to sea under a hail of thrown pebbles.">

<ROOM STORY215
	(IN ROOMS)
	(DESC "215")
	(STORY TEXT215)
	(PRECHOICE STORY215-PRECHOICE)
	(CONTINUE STORY177)
	(DEATH T)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY215-PRECHOICE ("AUX" (DMG 6))
	<COND (<CHECK-SKILL ,SKILL-SWORDPLAY>
		<SET DMG 2>
	)(<CHECK-SKILL ,SKILL-BRAWLING>
		<SET DMG 3>
	)>
	<LOSE-LIFE .DMG DIED-IN-COMBAT ,STORY215>
	<IF-ALIVE TEXT215-CONTINUED>
	<COND (,DROPPED-WEAPON
		<TAKE-ITEM ,DROPPED-WEAPON>
		<SETG DROPPED-WEAPON NONE>
	)>>

<CONSTANT TEXT216 "Oakley's head rocks back as he feels the sting of your knuckles across his cheek, cutting off his song before he can launch into another gloom-ridden verse. \"Quiet!\" you tell him with a hiss of righteous anger in your voice.||He glares back at you, bloodshot eyes wide in a drained and haggard face. He is shaking with fear as much as fury. \"Quiet?\" he sobs. \"Why? We're all going to Davy Jones's mess hall tonight, and it's his pet sharks as will be making their meal of us.\"||\"Nonsense!\" You take hold of his shoulders and stare him straight in the eye. \"Listen to me: none of us is going to die. We can all come through this in one piece if we pull together. The worst threat we have to face isn't the sea, or the weather, or hunger, or thirst. It's ourselves. Our fear. If we give in to panic, then we're lost.\"||Oakley nods. \"You're right.\" He helps you bail water taking turns throughout the night and the following day.">
<CONSTANT TEXT216-CONTINUED "You grow weaker, but at least you have inspired a glimmer of hope in your little band.">

<ROOM STORY216
	(IN ROOMS)
	(DESC "216")
	(STORY TEXT216)
	(PRECHOICE STORY216-PRECHOICE)
	(CONTINUE STORY273)
	(DEATH T)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY216-PRECHOICE ()
	<LOSE-LIFE 1 DIED-GREW-WEAKER ,STORY216>
	<IF-ALIVE TEXT216-CONTINUED>
	<COND (<CHECK-CODEWORD ,CODEWORD-CHANCERY> <REMOVE ,CODEWORD-CHANCERY>)>>

<CONSTANT TEXT217 "Salt spray spits across the deck in billows, driven by high winds that stretch the sails hard against the rigging. \"It's a wonder she ain't broke up long since!\" says Blutz.||\"She's a cursed ship,\" declares Oakley matter-of-factly. \"Such vessels have an unnatural resilience.\"||Hours pass, during which you are blown further into the west. You snatch a short sleep in the shelter of a tarpaulin, preferring not to venture below decks again. At last Grimes shakes you from a feverish dream to say, \"It's time we quit this ship matey.\"||You agree.">
<CONSTANT CHOICES217 <LTABLE "use an item" "otherwise">>

<ROOM STORY217
	(IN ROOMS)
	(DESC "217")
	(STORY TEXT217)
	(CHOICES CHOICES217)
	(DESTINATIONS <LTABLE STORY255 STORY388>)
	(PRECHOICE STORY217-PRECHOICE)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY217-PRECHOICE ()
	<COND (<CHECK-SKILL ,SKILL-CHARMS> <STORY-JUMP ,STORY236>)>>

<CONSTANT TEXT218 "With sudden inspiration you snatch off your own belt and twist the metal of the buckle to make a hook. For a line, you get everyone to unlace their boots and tie the strings together. Tied to the end of an oar, this gives you a makeshift fishing rod. You also trick up some nets by fixing socks onto the other oar.||\"What do we use for bait?\" asks Grimes.||\"Ah.\" You give a delicate cough. \"Well, to be blunt... whatever our stomachs couldn't use from the last meal we ate.\"||Their perplexed frowns gradually change to disgust as they catch on to what you mean. \"Ugh, you must be joking says Blutz.||\"Believe me, it's the best bait.You weren't going to use it for anything else, were you, Mister Blutz?\"||Oakley snorts with outrage. \"You expect us to fish using our own excrement? Revolting! Do we want to live like animals, or die like decent men?\"||There is a long pause as the rest of you turn to look at Oakley. He thinks, then gives a grim nod and says, \"Right, let's get on with it, then\"||Hours later you have caught just three small fishes. A meagre enough meal for one person, let alone four. But at least now you won't starve tonight.">

<ROOM STORY218
	(IN ROOMS)
	(DESC "218")
	(STORY TEXT218)
	(CONTINUE STORY256)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT219 "Despite his shrivelled frame and spindly limbs, Mortice fights with the savagery and strength of a madman. Hissing, clawing, snapping at you with his long teeth, he struggles desperately to force you back off his raft.||At last you manage to succeed in pinning him, but not without injury.">
<CONSTANT TEXT219-CONTINUED "You press all your weight down on Mortice's arms while he writhes in your grasp. Even now he continues his stream of invective, calling on the very devils of hell s though they were his blood brothers.||\"He's as strong as an old serpent,\" says Grimes, holding on to Mortice's legs. It takes three of you to keep him down. While you do, Blutz looks around the raft.||He soon discovers something lashed to the bottom of the raft, under the water. It is a large pine box. He drags this up and opens it, and at once a mouldering miasma rises out which causes him to gag. \"It's full of old bones,\" he chokes.||Even as these words leave Blutz's lips, there is a mournful unearthly sigh and suddenly the three of you are wrestling empty air. Mortice has vanished like a ghost.">

<ROOM STORY219
	(IN ROOMS)
	(DESC "219")
	(STORY TEXT219)
	(PRECHOICE STORY219-PRECHOICE)
	(CONTINUE STORY295)
	(DEATH T)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY219-PRECHOICE ("AUX" (DMG 3))
	<COND (<CHECK-SKILL ,SKILL-BRAWLING> <SET DMG 1>)>
	<LOSE-LIFE .DMG DIED-IN-COMBAT ,STORY219>
	<IF-ALIVE TEXT219-CONTINUED>>

<CONSTANT TEXT220 "The natives scatter, filled with fear, as the battle rages up and down the beach inside their village. Men's lifeblood spurts into the sand. Lusty battle-cries are replaced now by ragged gasps and terse grunts of pain as each blow takes its toll.||You are face to face with Skarvench, locked in mortal combat. His breath is a putrid gust in your face. Both of you bear a dozen wounds; your blood runs down to mingle in the gore-soaked sand underfoot. \"I'm sending you to hell -- he snarls through gritted teeth. His cutlass stabs up, and you feel it grate through your ribs as you are impaled.||\"Then we'll go there together!\" you cry, responding with a killing blow which he fails to see until it is too late. The pair of you sag to your knees, locked in a final embrace like old friends. And you are filled with a fierce exultation as, even while your own life ebbs away, you see the face of your foe go stiff and white in death...">

<ROOM STORY220
	(IN ROOMS)
	(DESC "220")
	(STORY TEXT220)
	(DEATH T)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT221 "A few judicious rounds bought in a dockside tavern soon sets tongues wagging. \"Aye, I've heard it's the Queen herself who'll be visiting next month,\" ventures a longshoreman. \"That's why security's been tightened up. It stands to reason, don't it. The governor don't want nothing to go wrong while she's here, or he might end up begging on the streets instead of living in splendour up at the fort.\"||Unfortunately other ears have overheard your enquiries. As you leave the tavern, footsteps ring on the cobbled street behind you. Before you have time to turn, you feel the unpleasantly familiar touch of cold steel against your neck. \"I'm sure the governor will want to know about the keen interest you're taking in Her Majesty's visit,\" says a voice full of honeyed menace. \"Why don't you come and have a chat with him about it?\"||\"Why bother the man?\" you reply. \"He has a lot to deal with at the moment.\"||The knife prices your skin. \"I wouldn't like to have to press the point,\" says the voice in the darkness behind you.||You give a gulp. \"In that case, lead on.\"">

<ROOM STORY221
	(IN ROOMS)
	(DESC "221")
	(STORY TEXT221)
	(CONTINUE STORY126)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT222 "By the onset of the second night, severe gales are driving freezing rain down onto your unprotected heads. You huddle together for warmth, but it is still impossible to snatch more than a few minutes of fitful sleep.">
<CONSTANT TEXT222-CONTINUED "One person had to remain awake at all times to bail water, and in fact this unending task is not as bad as trying to rest -- at least the activity keeps you warm and helps prevent you from getting cramp.||The dawn is grey and cheerless, marked by a greyish pearl-like glimmer beyond the eastern clouds. It might as well be dusk for all the solace it gives you. The rain settles into a persistent, chilling drizzle. \"At least we have fresh drinking water,\" you say, collecting it in your cupped hands. \"As long as the rain keeps up we don't die of thirst.\"||\"I almost wish we would,\" moans Blutz miserable. \"Another night like that and I'll be praying for death.\"||\"Shut your whining mouth,\" snaps Oakley. \"It's going to get a lot worse than this.\"">

<ROOM STORY222
	(IN ROOMS)
	(DESC "222")
	(STORY TEXT222)
	(PRECHOICE STORY222-PRECHOICE)
	(CONTINUE STORY007)
	(DEATH T)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY222-PRECHOICE ()
	<LOSE-LIFE 4 "You died from the bitter cold" ,STORY222>
	<IF-ALIVE TEXT222-CONTINUED>
	<COND (<AND <IS-ALIVE> <CHECK-SKILL ,SKILL-SEAFARING>> <STORY-JUMP ,STORY259>)>>

<CONSTANT TEXT223 "Putting his spectacles back on, the scholar gratefully shakes you by the hand. \"This is a place for gentlemen of fortune, not gentlemen of letters,\" you tell him. \"I recommend you head on to a lawful port as soon as possible.\"||He shakes his head. \"But I've travelled all the way from Glorianne in search of someone: the wizard William Wild.\"||You nod. \"I've heard of him. Why should you expect to find here?\"||\"I'm told he sailed for the colonies with Queen Titania. I left after they did, but my ship must have made better headway because it seems the Queen is still at sea and won't reach the colonies for several weeks.\"||\"It's as you say, but you're mistaken if you think they'll put into port here. Selenice is not under Gloriannic rule.\"||He flutters his hands impatiently. \"I know that. But it occurs to me that Dr Wild's half-brother, a man called Skarvench, might know where he's bound.\"||The others have come over to join you. \"So Skarvench is half-brother to the Queen's wizard!\" says Oakley with a whistle. \"No doubt such news portends mischief.\"||\"Why do you want to find Wild?\" Blutz asks the scholar.||\"He paid me to do some astronomical calculations for him. He wanted to know when a certain eclipse of the moon would occur, as apparently he had certain plans which would be disrupted if the eclipse happened to early. Well, I gave him the results, but after he sailed I double-checked my calculations and it turns out I made an error. I told Dr Wild the eclipse would be at two o'clock on midsummer night, but in fact it will be slightly earlier, at midnight.\"||Assuring the scholar that you will deliver his message personally, you escort him to the harbour and put him aboard a ship bound for Glorianne.">

<ROOM STORY223
	(IN ROOMS)
	(DESC "223")
	(STORY TEXT223)
	(CONTINUE STORY374)
	(CODEWORD CODEWORD-HORAL)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT224 "He said no man can use the key. Pointing to the lock in the middle of the chain, you try to make the monkey understand what you want it to do -- but to no avail. \"Go on, you little fleabag!\" you yell in exasperation, but its only reaction to this is to give itself a cursory scratch and go on squatting there on the edge of the coracle, blinking at you.||\"Begging your pardon, skipper,\" says Blutz, \"but you can't order a monkey about like you would an ordinary seaman. You've got to talk more gentle, like.\"||\"Gentle?\" you say, amazed.||\"Aye,\" Blutz nods. \"It's a thing skippers know nothing about. Let me try.\" He turns to the monkey, \"Now then, Mister Chatter, be a good bloke and unlock the harbour chain so your shipmates can sail through.\"||And blow you down if this doesn't do the trick. The monkey clambers along the chain and you hear the click of a key as its paws turn an invisible object in the lock. The chain falls aside and the monkey comes scurrying back, shrieking gleefully.||\"Imagine if captains had to take such a tone with their crew,\" you mutter. \"A ship's deck would be as blooming genteel as a church!\"||\"Don't worry, skipper,\" says Grimes as the coracle glides into the harbour. \"It might work a treat with monkeys, but sailors will always need a bit of yelling at.\"">

<ROOM STORY224
	(IN ROOMS)
	(DESC "224")
	(STORY TEXT224)
	(CONTINUE STORY205)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT225 "The surviving marines are rounded up and bound. Grimes is all for going aboard the ship and user her as your new vessel. Blutz soon points out the drawback in this idea: \"We'd be hunted down by the entire Gloriannic navy! That's going to make it rather hard to save the Gloriannic Queen, isn't it?\"||\"The Queen be hanged!\" cries one of the crew. \"We've got treasure, and now that we've seized a warship it'll be easy to keep our coffers filled. I'm for a life of solid piracy. Forget revenge, abandon honour -- let rum and gold be our goals!\"">
<CONSTANT TEXT225-CONTINUED "You still envisage yourself as the Queen's saviour and Skarvench's nemesis. You cut the warship adrift and sail the Lady Shalott back to Selenice">

<ROOM STORY225
	(IN ROOMS)
	(DESC "225")
	(STORY TEXT225)
	(PRECHOICE STORY225-PRECHOICE)
	(CONTINUE STORY016)
	(DEATH T)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY225-PRECHOICE ()
	<CRLF>
	<TELL "Do you consent to this?">
	<COND (<NOT <YES?>>
		<PUTP ,STORY225 ,P?DEATH F>
		<CRLF>
		<TELL TEXT225-CONTINUED>
		<TELL ,PERIOD-CR>
	)>>

<CONSTANT TEXT226 "Dropping to your knees, you draw a circle around you in the sand and usher your shipmates to stand within it. Then, holding forth the focus of your protection, you begin to recite: \"They return at evening, and swords are in their lips, but let them growl and wander up and down for their blood; they shall not be satisfied. Though a host should encamp against me, my heart shall not fear; when they come upon me to eat up my flesh they shall stumble and fall. For I will sing of power. Yea, in my refuge I will sing aloud in the morning..!\"||All through the night your ordeal continues. Your voice grows hoarse, and whenever you quaver in your chant one of the vampires lunges forward, trying to snatch you out of the circle. But at long last, just when all hope seems lost, a flicker of grey light trembles on the eastern horizon.||\"The dawn!\" shouts Blutz. \"Thank God!\"||The vampires gnash their fangs and turn like a pack of dogs, skulking back towards their coffins. \"aye, it's sunrise and we must retreat,\" says El Draque in a voice of icy anger. \"But do not rifle my treasure by day, for he that does will suffer my curse. My vengeance will reach out for him beyond the grave.\"||Wit that, he drops back into the hole. When you venture over, emboldened by the spreading daylight, yo see the corpses all back in their boxes. Now you must decide how much you fear his parting threat.">

<ROOM STORY226
	(IN ROOMS)
	(DESC "226")
	(STORY TEXT226)
	(PRECHOICE STORY226-PRECHOICE)
	(CONTINUE STORY396)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY226-PRECHOICE ()
	<CRLF>
	<TELL "Take the silver ingots that the corpses are lying on?">
	<COND (<YES?>
		<GAIN-CODEWORD ,CODEWORD-MALEFIC>
	)>>

<CONSTANT TEXT227 "Your poor ship has taken all the damage she can stand. Listing hard over, her prow begins to sink beneath the waves. \"Man the lifeboats!\" shouts Oakley. \"Abandon ship!\"||Grimes takes your arm. \"Skipper, all's lost now. There's nothing left for us but to save ourselves.\"||You hesitate. Honour demands that a captain go down with his ship, but that is not what roots you to the spot. Instead it is your bitter disappointment at failing to scupper your foe. Who knows what wickedness he will now wreak, and you are powerless to stop him.||Whether or not you flee the sinking ship...">

<ROOM STORY227
	(IN ROOMS)
	(DESC "227")
	(STORY TEXT227)
	(DEATH T)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT228 "Taking hold of the rope, you pull yourself up. Mist surrounds you, dampening your clothes. There is an eerie chill here, suspended in a miasmic white void. The moon shimmers above as though seen in a stagnant pond. The shouts of your men echo leadenly up through the gloom.||The rope stirs. You look up to see a shape descending out of the moonlit vapour towards you. It is Skarvench, hanging like a great black spider on its web. Let him come. You will show him that this is no mere fly he has to face.">

<ROOM STORY228
	(IN ROOMS)
	(DESC "228")
	(STORY TEXT228)
	(CONTINUE STORY323)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT229 "You know well that the art of concealment rests on distracting the attention. Even as the door starts to swing open, you reach across and unlatch the cabin porthole. Then, scattering a few maps and charts onto the floor from the table where they were lying, you take cover in a heap of oilskins behind the door.||Not a moment too soon. The bald stocky figure of the sailmaster stands in the doorway, lantern in his hand. Seeing the open porthole he gives a growl of annoyance and rushes to close it, worried that salt spray could damage his precious navigation charts. Then he gathers up some papers, puts them under his arm, and crosses to Skarvench's cabin.||You emerge from your hiding place and peek across the passage. The door of Skarvench's cabin stands ajar, and you can hear him going over the charts with the sailmaster. Now is your chance. Seeing a toolkit beside the door, you take it: your rowing-boat may very well need repairs. There is no time to look for other items. You sneak back along the passage and up on deck.">

<ROOM STORY229
	(IN ROOMS)
	(DESC "229")
	(STORY TEXT229)
	(CONTINUE STORY172)
	(ITEM TOOLKIT)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT230 "You find only a couple of small crabs which between them amount to barely more than a mouthful. Blutz gazes at them hungrily, flabby jowls sagging in dismay. \"Not worth dividing them up,\" he groans. \"Who's going to be the lucky one, then?\"||As usual, the others instinctively look to you for leadership. Your own stomach is growling as much as anyone's.">
<CONSTANT CHOICES230 <LTABLE "award yourself the crabs" "you can let one of the others have them.">>

<ROOM STORY230
	(IN ROOMS)
	(DESC "230")
	(STORY TEXT230)
	(CHOICES CHOICES230)
	(DESTINATIONS <LTABLE STORY268 STORY287>)
	(TYPES TWO-NONES)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT231 "Your skin is loose on your bones and your tongue feels like a wad of burnt cotton. The urge to drink seawater is almost unbearable now. Your only respite from consciousness is not sleep, but dream-haunted delirium.">

<ROOM STORY231
	(IN ROOMS)
	(DESC "231")
	(STORY TEXT231)
	(PRECHOICE STORY231-PRECHOICE)
	(CONTINUE STORY212)
	(DEATH T)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY231-PRECHOICE ("AUX" (DMG 2))
	<COND (<CHECK-SKILL ,SKILL-SEAFARING> <SET DMG 1>)>
	<LOSE-LIFE .DMG DIED-OF-THIRST ,STORY231>>

<CONSTANT TEXT232 "You gorge yourselves on ripe fruits and tasty nuts -- only to suffer severe stomach cramps just minutes later. Oakley rushes down the beach and gulps sea water until he vomits. The rest of you follow suit, but you are left dizzy and weak.||\"Something must have been poisonous,\" groans Blutz. \"Maybe we ought to go to the tower. There might be someone there who'll give us food.\"">
<CONSTANT CHOICES232 <LTABLE "agree and go to the tower" "you think it is better to leave the island now">>

<ROOM STORY232
	(IN ROOMS)
	(DESC "232")
	(STORY TEXT232)
	(CHOICES CHOICES232)
	(DESTINATIONS <LTABLE STORY194 STORY137>)
	(TYPES TWO-NONES)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT233 "The four of you crouch down in the weird boat. No sooner have you settled yourselves than the two great fish slap the waters with their tails, drawing you out to sea. Darkness and frothy waves churn past. With spray in your eyes, the moon looks like a whirlpool in the firmament and their is no way to tell how far you've travelled when, at last, the boat drifts to a halt. You see that you are close to the entrance of a massive harbour. A long golden chain is stretched across the harbour mouth to block the vessels from entering or leaving.||The moon emerges from behind a cloud, flooding the scene in its timeless white glow. You give a gasp, for now you see that you had taken to be the pillars of the harbour gate are actually colossal legs stretching up far into the night sky. Craning your neck, you see the massive outline of a giant's shoulders against the moon-grazed clouds.||The giant stoops, showing a smile as wide as a galleon's beam in his face of smooth dark marble. \"Four wayfarers,\" he says in the tone of one who has noticed four curious insects under his nose. \"Mortals. What brings you to Neptune's gate?\"">
<CONSTANT CHOICES233 <LTABLE "say you seek a ship" "ask for his help in your quest" "tell him you want to return home">>

<ROOM STORY233
	(IN ROOMS)
	(DESC "233")
	(STORY TEXT233)
	(CHOICES CHOICES233)
	(DESTINATIONS <LTABLE STORY034 STORY053 STORY072>)
	(TYPES THREE-NONES)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT234 "\"Quick,\" you say to Oakley over your shoulder, \"push me over and make like you're giving me a kick. And make it look convincing.\" He is taken aback at first, but then he catches on to your plan. As you feel him shove you from behind, you fling yourself down to sprawl in the sand. \"Ouch\" you grunt as you feel the toe of his boot. \"Not that convincing!\"||\"We've caught this scurvy wretch,\" Oakley tells the natives with the help of sign-language.||The chief must have learned a few words off sailors who stopped here. \"Kill,\" he says. \"Burn alive over fire.\"||Oakley hesitates. \"Er...\"||\"Oh yes. Er, the prisoner will be taken to Queen Titania, the, er, chief of Glorianne. Get it? She'll decide the proper punishment.\"||The natives are still keen to seize you, but Oakley keeps them off with warnings of dire reprisals if Queen Titania's wishes are not carried out.">

<ROOM STORY234
	(IN ROOMS)
	(DESC "234")
	(STORY TEXT234)
	(CONTINUE STORY272)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT235 "The storm rolls over you, tossing your jollyboat halfway to the clouds with each wave. The sea becomes thick with icy froth. The sky is a flickering lantern -- one moment blue-white and bright as daybreak, then blacker than the underworld in the thunderous space between lightning flashes.||Wretchedly sick, weak with exhaustion and hunger, the four of you struggle to keep the little craft from submerging. Oakley sings wildly into the sheets of rain as he bails water with cupped hands:||\"Oh, the Coffin Lid heaves to and fro,|tossed by storms and gales,|What's that thunder now I hear:|four hearts thudding full o' fear?|Or Death's bone fingers  drawing near|and banging in the nails?\"||Grimes and Blutz both look to be near the end of their tether. Oakley's gallows song is not helping their nerves. Nor yours, for that matter.">
<CONSTANT CHOICES235 <LTABLE "try to shut Oakley up and risk provoking a fight" "do nothing and then morale will drain away entirely.">>

<ROOM STORY235
	(IN ROOMS)
	(DESC "235")
	(STORY TEXT235)
	(CHOICES CHOICES235)
	(DESTINATIONS <LTABLE STORY216 STORY254>)
	(PRECHOICE STORY235-PRECHOICE)
	(TYPES TWO-NONES)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY235-PRECHOICE ()
	<COND (<CHECK-CODEWORD ,CODEWORD-DETRUDE> <REMOVE ,CODEWORD-DETRUDE> <GAIN-CODEWORD ,CODEWORD-PECCANT>)>>

<CONSTANT TEXT236 "Holding firm to your mystic amulet, you pronounce the words of a blessing.||\"Hey, it worked!\" exclaims Blutz, clambering cumbrously over the rail.\"Look, we're not trapped by the curse anymore.\"||You nod, allowing yourself a slight smile of self congratulation. \"Don't dawdle, though. The effect of the charm won't last forever.\"||Lowering yourselves down to the water, you get back into the jollyboat tethered there and row hastily away through the chopping waves. Behind you, the Larnassos fades until she is no more than a wavering patch of shadow, and then is swallowed entirely by the darkness. \"Good riddance!\" spits Grimes.">

<ROOM STORY236
	(IN ROOMS)
	(DESC "236")
	(STORY TEXT236)
	(PRECHOICE STORY236-PRECHOICE)
	(CONTINUE STORY136)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY236-PRECHOICE ()
	<REMOVE ,CURRENT-VEHICLE>
	<SETG CURRENT-VEHICLE NONE>>

<CONSTANT TEXT237 "\"Well, Mister Chatter,\" says Oakley, settling the little monkey on his knee and producing a pocket-knife, \"it's been an honour to sail with 'ee, but your shipmates are going to ask a favour of you now, and it's that most noble sacrifice a bloke can make.\"">
<CONSTANT TEXT237-CONTINUED "Rich red sunset glints on the blade, and in a stroke the dead is done. \"Poor little beggar!\" sighs Blutz.||\"Better than poor us, matey,\" says Oakley as he carves you each a hunk of meat. \"Four starving sailors cramped into a jollyboat leaves precious room for sentiment.\"">

<ROOM STORY237
	(IN ROOMS)
	(DESC "237")
	(STORY TEXT237)
	(PRECHOICE STORY237-PRECHOICE)
	(CONTINUE STORY256)
	(DEATH T)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY237-PRECHOICE ()
	<CRLF>
	<TELL "Eat the monkey (if you are heartless or desperate enough)?">
	<COND (<YES?>
		<REMOVE ,MONKEY>
		<PUTP ,STORY237 ,P?DEATH F>
		<IF-ALIVE TEXT237-CONTINUED>
	)(ELSE
		<LOSE-LIFE 1 DIED-OF-HUNGER ,STORY237>
	)>>

<CONSTANT TEXT238 "Raising your sword, you leap aboard the raft. You intended only to warn Mortice, but instead of backing off he gives a murderous snarl and runs straight onto the sword, impaling himself through the heart. You look away quickly with a grimace of dismay. Still gripping the blade, you glance back at the others and start to say, \"There wasn't anything I could do. He just --\"||\"Look out!\" Blutz screeches in warning, pointing past you. \"He's not dead!\"||Your eyes jerk back to Mortice, who you now see to your horror is still moving. Twitching galvanically, he grins a blood-rimmed smile and coughs gore, then starts to pull himself along the sword blade towards you.">
<CONSTANT CHOICES238 <LTABLE "flee back to the boat, letting go of your sword" "fight on">>

<ROOM STORY238
	(IN ROOMS)
	(DESC "238")
	(STORY TEXT238)
	(CHOICES CHOICES238)
	(DESTINATIONS <LTABLE STORY238-LOSE-SWORD STORY314>)
	(TYPES TWO-NONES)
	(FLAGS LIGHTBIT)>

<ROOM STORY238-LOSE-SWORD
	(IN ROOMS)
	(DESC "238")
	(EVENTS STORY238-EVENTS)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY238-EVENTS ()
	<COND (<IN? ,SWORD ,PLAYER>
		<REMOVE ,SWORD>
	)(<IN? ,SHARKS-TOOTH-SWORD ,PLAYER>
		<REMOVE ,SHARKS-TOOTH-SWORD>
	)(<IN? ,CLEAVER ,PLAYER>
		<REMOVE ,CLEAVER>
	)>
	<RETURN ,STORY276>>

<CONSTANT TEXT239 "The captain listens to your tale with equal measures of horror disbelief. \"It's a hard tale to swallow,\" he says at last, \"but I've heard this fellow Skarvench is full of hubris.\"||\"It's no mere pipedream,\" says Grimes. \"Skarvench is cunning and ruthless. If he's set his sights on such a prize, you can be sure he has a good plan.\"||The captain scratches his head. \"It is true that the Queen's flagship is bound for the colonies,\" he admits. \"But I only heard the news myself as I was about to set sail from Glorianne, so Skarvench must have spies in high places. I'd help if I could, but my vessel is only a merchantman and would fare badly against a fully-armed pirate ship.\"||He finally agrees to set you off in Port Selenice, where you have your best chance of enlisting aid against Skarvench. Then, wishing you well, he resumes his journey towards Leshand.">

<ROOM STORY239
	(IN ROOMS)
	(DESC "239")
	(STORY TEXT239)
	(PRECHOICE STORY239-PRECHOICE)
	(CONTINUE STORY165)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY239-PRECHOICE ()
	<COND (<CHECK-CODEWORD ,CODEWORD-CHANCERY> <STORY-JUMP ,STORY406>)>>

<CONSTANT TEXT240 "You are dragged aboard the Belle Dame. Jeering, the pirates gather round and tie you and your friends to the rail. The burly mate, Porbuck, steps forward swinging a whip in his hand. His huge flabby face is creased into a ghoulish grin.||\"While the cat's away, eh, Porbuck?\" says Oakley. He is trying to sound flippant, but his face is the curdled-milk colour of fear. \"Skarvench won't like it if you kill us before he gets back.\"||Porbuck chortles as he raises the whip. \"Don't you go worryin', Oakley. You won't just die yet. Reckon you'll beg for it though...\"||Hours of agony pass before your flayed bodies are finally cast into the sea. By that time you gratefully accept the cool oblivion of death.">

<ROOM STORY240
	(IN ROOMS)
	(DESC "240")
	(STORY TEXT240)
	(DEATH T)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT241 "You raise your fists and step quickly forward, ready to give the demon-witch a sound thrashing if she doesn't lift her spell and allow you to leave the island. For her part, she gives you a disdainful smile and places her hands on her hips, tilting her chin back mockingly. \"Come, mortal,\" she says. \"plant your best punch. Then I'll take my turn, and we'll see who's left standing after that.\"">
<CONSTANT CHOICES241 <LTABLE "take a swing at her as she's inviting you to" "try grappling with her -- either with an armlock" "or to lift her over your head for a body slam" "you can surrender before she gives you a beating you might not survive if you're afraid that you are outclassed">>

<ROOM STORY241
	(IN ROOMS)
	(DESC "241")
	(STORY TEXT241)
	(CHOICES CHOICES241)
	(DESTINATIONS <LTABLE STORY271 STORY290 STORY309 STORY119>)
	(TYPES FOUR-NONES)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT242 "You sit up suddenly with a groan. Your chest feels as though you've been kicked by a horse, but by rights you ought to be dead.||Shaking your head to clear it, you look down and discover that Skarvench's bullet was deflected by the article hanging at your breast. Instead of hitting your heart, it glanced off the metal and only left a long red gash.||Grime's face comes into focus. \"How long have ?I been out cold?\" you ask him, each breath making you wince in pain.||\"At least quarter of an hour, skipper.\"||Quite a crowd has gathered around you, As you stagger groggily to your feat, you find you're still holding the corkscrew. \"A fat lot of good this did me.\"||Oakley cracks a grind, relieved to see you're alright. \"I dunno, you might've had his remaining eye out with it if you'd been a bit closer.\"||And elderly pirate steps out of the crowd. You recognize him as a respected man in the disreputable community of Selenice. \"Skarvench broke the Brethren's law,\" he says. \"He's an outcast now. No port on the Carab will give him shelter.\"||Blutz is nursing a lump on his head. His nostrils flare in rage as he cries, \"If Skarvench succeeds in abducting Queen Titania he'll be rich enough to buy his own port!||\"He won't,\" you say in a voice laced with icy determination.">

<ROOM STORY242
	(IN ROOMS)
	(DESC "242")
	(STORY TEXT242)
	(PRECHOICE STORY242-PRECHOICE)
	(CONTINUE STORY343)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY242-PRECHOICE ()
	<CRLF>
	<TELL "Take corkscrew?">
	<COND (<YES?> <TAKE-ITEM ,CORKSCREW>)>>

<CONSTANT TEXT243 "A key that no one can see or touch? The ocean god's riddle leaves you baffled until you remember the hornpipe in your pocket. Putting it to your lips, you play a snatch of an old sea shanty. As you do, the chain unlocks itself, falling aside to admit your boat into the harbour.||\"Well, son of a gun!\" says Blutz. \"It was a musical key that was needed, then.\"">

<ROOM STORY243
	(IN ROOMS)
	(DESC "243")
	(STORY TEXT243)
	(CONTINUE STORY205)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT244 "Clutching your letter of marque, you emerge into the sunshine with the happy air of scholars who have just been awarded their diploma. Outwardly you retain the weather-beaten faces and grimy clothes of common street ruffians, but the document in your hands proclaims otherwise. Now you are licensed privateers - proud sea warriors in the conflict with the rapacious kingdom of Sidonia!||\"Now all we need is a ship,\" says Blutz.||The rest of you whirl and glare at him, the contended smiles wiped off your faces in an instant. Trust the fat oaf to bring you down to earth with a bump.">

<ROOM STORY244
	(IN ROOMS)
	(DESC "244")
	(STORY TEXT244)
	(PRECHOICE STORY244-PRECHOICE)
	(CONTINUE STORY107)
	(ITEM LETTER-OF-MARQUE)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY244-PRECHOICE ()
	<COND (<CHECK-CODEWORD ,CODEWORD-MARATHON> <STORY-JUMP ,STORY069>)>>

<CONSTANT TEXT245 "El Draque raises his arms and comes forward to embrace you. It could almost be the gesture of one greeting a long-lost friend -- if not for the fangs that gleam like talons beneath his white lips.||A seagull wheels high above in the cloudless indigo sky, its wings catching a last flicker of sunlight. You see one chance. Your sword flashes in the grey dusk too fast for the eye to follow. For an instant El Draque stands rooted to the spot, arms outstretched, not yet aware of what you've done. Then a torrent of mingled hate and anguish and disbelief washes across his pale contorted features as he looks down to see your sword hilt protruding from his chest. He falls and crumbles to a pile of ash, and as he does the other vampires slump to the ground also. A ghastly keening rises from their lips as they slowly dissolve, leaving nothing but a miasmal stench and dark patches in the sand.||You are about to retrieve your sword, but Blutz advises you to leave it where it is. \"I've heard vampires can reform themselves even from lifeless dust.\" he says with a shudder.">
<CONSTANT TEXT245-CONTINUED "Then hurriedly loading the silver ingots aboard the Lady of Shalott, you set sail for Selenice">

<ROOM STORY245
	(IN ROOMS)
	(DESC "245")
	(STORY TEXT245)
	(PRECHOICE STORY245-PRECHOICE)
	(CONTINUE STORY016)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY245-PRECHOICE ()
	<COND (<IN? ,SWORD ,PLAYER>
		<LOSE-ITEM ,SWORD>
	)(<IN? ,SHARKS-TOOTH-SWORD ,PLAYER>
		<LOSE-ITEM ,SHARKS-TOOTH-SWORD>
	)(<IN? ,CLEAVER ,PLAYER>
		<LOSE-ITEM ,CLEAVER>
	)>
	<CRLF>
	<TELL TEXT245-CONTINUED>
	<TELL ,PERIOD-CR>>

<CONSTANT TEXT246 "Without the lunar wind to fill her sails, the Moon Dog drops quickly. You hear her splash down some distance off your starboard bow.||\"Now Skarvench is a seaborne like us,\" says Oakley with a fierce smile. \"If not for this damned fog, we could give him a battle he'd not soon forget.\"">
<CONSTANT CHOICES246 <LTABLE "use a" "disperse the fog" "otherwise">>

<ROOM STORY246
	(IN ROOMS)
	(DESC "246")
	(STORY TEXT246)
	(CHOICES CHOICES246)
	(DESTINATIONS <LTABLE STORY265 STORY284 STORY303>)
	(REQUIREMENTS <LTABLE THUNDERCLOUD-FAN SKILL-SPELLS NONE>)
	(TYPES <LTABLE R-ITEM R-SKILL R-NONE>)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT247 "Darting quickly over into the hold, you break open a travelling chest bearing the royal seal. You scatter the packed clothes and jewels that are inside until you find what you are looking for: one of the Queen's voluminous gowns. Pulling this on, you hurry back on deck, drawing amazed stares from your comrades.||\"Good grief, skipper!\" says Oakley with a wry smile. \"You makes a bloomin' pretty queen, and no mistake!\"||\"Get out of sight, all of you,\" you tell them. Then, lying in to wait behind the overturned water-barrel, you watch until the rope begins to stir. Someone is descending. You see him slide down the rope as loathsome as a great black spider -- Skarvench himself! Choking back the urge to attack him at once, you wait until he reaches the deck before pretending to stumble out of your hiding-place.||\"Oho!\" he cries. \"The precious baggage herself! It's right handy of you to make my job so easy, yer majesty.\" So saying, he reaches out and hefts you over his shoulder. \"Whuf! You're a weighty lass. But a spell on biscuit an' water'll soon take some o' that ample flesh off your bones. That an' the cat, o' course!\"||You wait until he has carried you halfway up the rope. You may as well let the brigand wear himself out before you kill him. Now you are suspended in a weird misty void between sea and sky, with just the faint haze of moonshine to light your final confrontation. You wrest out of his grasp, seize the rope, and throw off your disguise.||\"You!\" gasps Skarvench.">

<ROOM STORY247
	(IN ROOMS)
	(DESC "247")
	(STORY TEXT247)
	(CONTINUE STORY323)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT248 "There is a meaty smack as your fist connects with this solar plexus. He makes a soft sucking sound and falls like a fish out of water. Stooping, you deliver a punch to the jaw that lays him out cold. Freezing, you listen tensely but the conversation in Skarvench's cabin continues as before. Nobody heard anything. Still, you had better not tarry here any longer.">

<ROOM STORY248
	(IN ROOMS)
	(DESC "248")
	(STORY TEXT248)
	(CONTINUE STORY172)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT249 "Reaching the top of the cliffs, you stand atop a spar of rock which gives you a clear view of the interior of the Island. Lush jungle clings to the flanks of a sharply peaked mountain in the centre. The summit of the mountain is hidden by a haze of cloud. Nearer at hand you spy succulent fruits. From beyond the curtain of foliage comes the burgling of a brook.">
<CONSTANT CHOICES249 <LTABLE "collect provisions" "explore the interior of the island" "return to the boat and resume your journey">>

<ROOM STORY249
	(IN ROOMS)
	(DESC "249")
	(STORY TEXT249)
	(CHOICES CHOICES249)
	(DESTINATIONS <LTABLE STORY306 STORY325 STORY116>)
	(TYPES THREE-NONES)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT250 "\"This seems a bountiful enough place -- indeed, a very Eden,\" says Grimes. \"Why don't we tarry here a while, shipmates, and get our strengths back for the long haul to Port Leshand?\"||Blutz casts another nervous glance towards the centre of the island. Rearing above the treetops is the high cone of the volcano, ashen smoke lying above it like a thunderhead. \"I'm not so sure.\" he says.">
<CONSTANT CHOICES250 <LTABLE "vote for spending a few days here" "you should be on your way">>

<ROOM STORY250
	(IN ROOMS)
	(DESC "250")
	(STORY TEXT250)
	(CHOICES CHOICES250)
	(DESTINATIONS <LTABLE STORY288 STORY135>)
	(TYPES TWO-NONES)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT251 "She emerges from the shadows of the entrance: a stately figure with skin the colour of burnished oak and hair like a shower of green stars. Her clothing and accent are not those of a Carab native, but seem to evoke the mysteries of an ancient civilization. \"I am Ejada, witch-queen of this isle,\" she tells you. \"I demand tribute from all who come to my shores, but my demands are not excessive. All I'll take is the soul of one of you, to be sacrificed at dawn to my mother the Earth Goddess.\"||\"Send your own soul to hell!\" yells Oakley, snatching up a rock and dashing forward. Ejada calmly sweeps her arm, knocking Oakley to the ground as though he'd run into a tree branch.||\"Return here in the hour before dawn,\" Ejada goes on. \"By then you must have decided which of you will give up his soul.||Helping Oakley to his feet, you return to find the jollyboat sunk deep into the sand of the beach. You try digging it up, but it only sinks deeper. \"That's that, then,\" sobs Blutz. \"The witch's magic has trapped us here. We'll have to choose who's to die!\"">
<CONSTANT CHOICES251 <LTABLE "make a raft" "got to her at dawn as she told you to" "try hiding from her">>

<ROOM STORY251
	(IN ROOMS)
	(DESC "251")
	(STORY TEXT251)
	(CHOICES CHOICES251)
	(DESTINATIONS <LTABLE STORY308 STORY327 STORY346>)
	(REQUIREMENTS <LTABLE SKILL-SEAFARING NONE NONE>)
	(TYPES <LTABLE R-SKILL R-NONE R-NONE>)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT252 "The warship stands much taller than your own vessel, making your few cannon-shots largely ineffective. Your shells smack into the warship's strong oaken flanks with hardly more effect than grape-shot. If only you could score a hit on the enemy's rigging.||The warship does not return fire. Those mighty guns could easily blast you to kindling, but she is steering instead so as to pull alongside for a boarding action.">
<CONSTANT CHOICES252 <LTABLE "use" "use" "or alternatively you could use a" "or a" "failing any of these options, stand by to repel boarders">>

<ROOM STORY252
	(IN ROOMS)
	(DESC "252")
	(STORY TEXT252)
	(CHOICES CHOICES252)
	(DESTINATIONS <LTABLE STORY035 STORY054 STORY263 STORY282 STORY073>)
	(REQUIREMENTS <LTABLE SKILL-SPELLS SKILL-AGILITY THUNDERCLOUD-FAN BRONZE-HELMET NONE>)
	(TYPES <LTABLE R-SKILL R-SKILL R-ITEM R-ITEM R-NONE>)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT253 "The islanders stare in horror at the red death's head daubed across your face. Several of them step forward with raised spears, angry defiance slowly replacing their initial shock. It is Grimes who realises the cause: \"Those other natives must be their enemies. And they think you're one of 'em.\"">
<CONSTANT CHOICES253 <LTABLE "shout your way out of this" "try fighting your way through them back to the water" "resort to" "try wiping off the red dye and offering gifts to mollify them">>

<ROOM STORY253
	(IN ROOMS)
	(DESC "253")
	(STORY TEXT253)
	(CHOICES CHOICES253)
	(DESTINATIONS <LTABLE STORY196 STORY215 STORY234 STORY291>)
	(REQUIREMENTS <LTABLE SKILL-MARKSMANSHIP NONE SKILL-CUNNING NONE>)
	(TYPES <LTABLE R-SKILL R-NONE R-SKILL R-NONE>)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT254 "Throughout a tempestuous night, Oakley screams verse after verse of his morbid dirge, vying with the thunder's roar until his voice is as hoarse as the croak of a dying man. You can tell from the looks on the others' faces that they have been infected by Oakley's mod. Desperation at your sorry plight has now been worn down to hopelessness and new horror.||\"Dawn,\" says Grimes, nodding towards a dreary grey gleam beyond the soot-coloured clouds. \"I doubt we'll live to see another.\"||The day goes on, and you grow weaker.">

<ROOM STORY254
	(IN ROOMS)
	(DESC "254")
	(STORY TEXT254)
	(PRECHOICE STORY254-PRECHOICE)
	(CONTINUE STORY273)
	(CODEWORD CODEWORD-CHANCERY)
	(DEATH T)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY254-PRECHOICE ()
	<LOSE-LIFE 1 DIED-GREW-WEAKER ,STORY254>>

<CONSTANT TEXT255 "Decide which item you will use:">
<CONSTANT CHOICES255 <LTABLE "use a butcher's" "a" "a toolkit" "otherwise">>

<ROOM STORY255
	(IN ROOMS)
	(DESC "255")
	(STORY TEXT255)
	(CHOICES CHOICES255)
	(DESTINATIONS <LTABLE STORY331 STORY350 STORY369 STORY388>)
	(REQUIREMENTS <LTABLE CLEAVER CRUCIFIX <LTABLE SKILL-CUNNING TOOLKIT> NONE>)
	(TYPES <LTABLE R-ITEM R-ITEM R-SKILL-ITEM R-NONE>)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT256 "Throughout another night and day you are swept westwards by the strong sea current. Sometime after dusk, as night shrouds the vast expanse of water and closes walls of darkness around the tiny confines of your boat, you hear a voice hailing you: \"Ho there! Who is it? I hear your oars -- speak up!\"||Blutz peers out into the darkness. \"I think I see him,\" he whispers to the rest of you. \"A lone figure on a raft. Must've been shipwrecked.\"||\"Shall we row over and pick him up?\" says Grimes.||Predictably, Oakley is against this. \"We have enough bad luck to go around as it is. Why add another hungry mouth to an already overcrowded boat?\"">
<CONSTANT CHOICES256 <LTABLE "row over to the man on the raft" "agree with Oakley that you should ignore him">>

<ROOM STORY256
	(IN ROOMS)
	(DESC "256")
	(STORY TEXT256)
	(CHOICES CHOICES256)
	(DESTINATIONS <LTABLE STORY294 STORY313>)
	(TYPES TWO-NONES)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT257 "The shot rings out in the night and a puff of gunsmoke drifts like silver fog in the moonlight. As the smoke clears you see to your astonishment has not fallen. He is just standing there with a ghastly bloodless grin, eyes blazing like a ship's lanterns. Then you notice something else -- the bullet didn't miss him. There is a gaping hole through his chest. For a long moment no-one moves a muscle. Silence gives the scene an air of unreality.||\"He's not a living man!\" gasps Blutz at last. \"He's one of the undead!\"">
<CONSTANT CHOICES257 <LTABLE "launch a barehanded assault on Mortice" "attack him with a sword" "you'd rather avoid a confrontation, and could just the line mooring his raft to the jollyboat">>

<ROOM STORY257
	(IN ROOMS)
	(DESC "257")
	(STORY TEXT257)
	(CHOICES CHOICES257)
	(DESTINATIONS <LTABLE STORY219 STORY238 STORY276>)
	(REQUIREMENTS <LTABLE NONE SKILL-SWORDPLAY NONE>)
	(TYPES <LTABLE R-NONE R-SKILL R-NONE>)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT258 "You arrive at Leshand harbour to find the town awash with troops. It is not long before you hear the news that has stirred up such panic. \"The nefarious buccaneer Skarvench has captured the Queen of Glorianne,\" a stevedore tells you as he unpacks the ship's cargo. \"He's demanding a million doubloons in ransom, otherwise, he'll make a gift of her to her arch-enemy the King of Sidonia.\"||\"Woeful news!\" groans Oakley. \"The Sidonians will likely break her on the wheel, or tie her to an anchor and send her to sup with Davy Jones! If only we could have done something to prevent it.\"||You could have, but you frolicked too long in an island paradise. Now your part in history is at an end.">

<ROOM STORY258
	(IN ROOMS)
	(DESC "258")
	(STORY TEXT258)
	(DEATH T)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT259 "You are able to jury-rig a weather cloth using strips torn from everyone's clothing. When this is fitted around the boat it has the effect of raising the freeboard, helping to keep the water from sloshing over the sides. You also inspect the planking and make sure that any cracks where the boat is taking in water are plugged with wadding.||\"Will we stay afloat through another storm like last night's though?\" asks Grimes when he sees you taking these measures.||You shrug. \"Pray for better weather.\"">

<ROOM STORY259
	(IN ROOMS)
	(DESC "259")
	(STORY TEXT259)
	(CONTINUE STORY026)
	(FLAGS LIGHTBIT)>

<CONSTANT TEXT260 "You reply with a discreet smile and draw the official aside, adopting the conspiratorial tone of one elegantly mannered knave to another. By promising him a lavish share of any treasure you take from Sidonian galleons, you finally manage to convince him to issue you with a letter of marque.">

<ROOM STORY260
	(IN ROOMS)
	(DESC "260")
	(STORY TEXT260)
	(CONTINUE STORY244)
	(CODEWORD CODEWORD-MAMMON)
	(FLAGS LIGHTBIT)>

<ROOM STORY261
	(IN ROOMS)
	(DESC "261")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY262
	(IN ROOMS)
	(DESC "262")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY263
	(IN ROOMS)
	(DESC "263")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY264
	(IN ROOMS)
	(DESC "264")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY265
	(IN ROOMS)
	(DESC "265")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY266
	(IN ROOMS)
	(DESC "266")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY267
	(IN ROOMS)
	(DESC "267")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY268
	(IN ROOMS)
	(DESC "268")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY269
	(IN ROOMS)
	(DESC "269")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY270
	(IN ROOMS)
	(DESC "270")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY271
	(IN ROOMS)
	(DESC "271")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY272
	(IN ROOMS)
	(DESC "272")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY273
	(IN ROOMS)
	(DESC "273")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY274
	(IN ROOMS)
	(DESC "274")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY275
	(IN ROOMS)
	(DESC "275")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY276
	(IN ROOMS)
	(DESC "276")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY277
	(IN ROOMS)
	(DESC "277")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY278
	(IN ROOMS)
	(DESC "278")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY279
	(IN ROOMS)
	(DESC "279")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY280
	(IN ROOMS)
	(DESC "280")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY281
	(IN ROOMS)
	(DESC "281")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY282
	(IN ROOMS)
	(DESC "282")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY283
	(IN ROOMS)
	(DESC "283")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY284
	(IN ROOMS)
	(DESC "284")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY285
	(IN ROOMS)
	(DESC "285")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY286
	(IN ROOMS)
	(DESC "286")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY287
	(IN ROOMS)
	(DESC "287")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY288
	(IN ROOMS)
	(DESC "288")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY289
	(IN ROOMS)
	(DESC "289")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY290
	(IN ROOMS)
	(DESC "290")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY291
	(IN ROOMS)
	(DESC "291")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY292
	(IN ROOMS)
	(DESC "292")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY293
	(IN ROOMS)
	(DESC "293")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY294
	(IN ROOMS)
	(DESC "294")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY295
	(IN ROOMS)
	(DESC "295")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY296
	(IN ROOMS)
	(DESC "296")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY297
	(IN ROOMS)
	(DESC "297")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY298
	(IN ROOMS)
	(DESC "298")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY299
	(IN ROOMS)
	(DESC "299")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY300
	(IN ROOMS)
	(DESC "300")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY301
	(IN ROOMS)
	(DESC "301")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY302
	(IN ROOMS)
	(DESC "302")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY303
	(IN ROOMS)
	(DESC "303")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY304
	(IN ROOMS)
	(DESC "304")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY305
	(IN ROOMS)
	(DESC "305")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY306
	(IN ROOMS)
	(DESC "306")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY307
	(IN ROOMS)
	(DESC "307")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY308
	(IN ROOMS)
	(DESC "308")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY309
	(IN ROOMS)
	(DESC "309")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY310
	(IN ROOMS)
	(DESC "310")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY311
	(IN ROOMS)
	(DESC "311")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY312
	(IN ROOMS)
	(DESC "312")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY313
	(IN ROOMS)
	(DESC "313")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY314
	(IN ROOMS)
	(DESC "314")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY315
	(IN ROOMS)
	(DESC "315")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY316
	(IN ROOMS)
	(DESC "316")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY317
	(IN ROOMS)
	(DESC "317")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY318
	(IN ROOMS)
	(DESC "318")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY319
	(IN ROOMS)
	(DESC "319")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY320
	(IN ROOMS)
	(DESC "320")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY321
	(IN ROOMS)
	(DESC "321")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY322
	(IN ROOMS)
	(DESC "322")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY323
	(IN ROOMS)
	(DESC "323")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY324
	(IN ROOMS)
	(DESC "324")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY325
	(IN ROOMS)
	(DESC "325")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY326
	(IN ROOMS)
	(DESC "326")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY327
	(IN ROOMS)
	(DESC "327")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY328
	(IN ROOMS)
	(DESC "328")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY329
	(IN ROOMS)
	(DESC "329")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY330
	(IN ROOMS)
	(DESC "330")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY331
	(IN ROOMS)
	(DESC "331")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY332
	(IN ROOMS)
	(DESC "332")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY333
	(IN ROOMS)
	(DESC "333")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY334
	(IN ROOMS)
	(DESC "334")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY335
	(IN ROOMS)
	(DESC "335")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY336
	(IN ROOMS)
	(DESC "336")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY337
	(IN ROOMS)
	(DESC "337")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY338
	(IN ROOMS)
	(DESC "338")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY339
	(IN ROOMS)
	(DESC "339")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY340
	(IN ROOMS)
	(DESC "340")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY341
	(IN ROOMS)
	(DESC "341")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY342
	(IN ROOMS)
	(DESC "342")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY343
	(IN ROOMS)
	(DESC "343")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY344
	(IN ROOMS)
	(DESC "344")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY345
	(IN ROOMS)
	(DESC "345")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY346
	(IN ROOMS)
	(DESC "346")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY347
	(IN ROOMS)
	(DESC "347")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY348
	(IN ROOMS)
	(DESC "348")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY349
	(IN ROOMS)
	(DESC "349")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY350
	(IN ROOMS)
	(DESC "350")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY351
	(IN ROOMS)
	(DESC "351")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY352
	(IN ROOMS)
	(DESC "352")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY353
	(IN ROOMS)
	(DESC "353")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY354
	(IN ROOMS)
	(DESC "354")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY355
	(IN ROOMS)
	(DESC "355")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY356
	(IN ROOMS)
	(DESC "356")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY357
	(IN ROOMS)
	(DESC "357")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY358
	(IN ROOMS)
	(DESC "358")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY359
	(IN ROOMS)
	(DESC "359")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY360
	(IN ROOMS)
	(DESC "360")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY361
	(IN ROOMS)
	(DESC "361")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY362
	(IN ROOMS)
	(DESC "362")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY363
	(IN ROOMS)
	(DESC "363")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY364
	(IN ROOMS)
	(DESC "364")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY365
	(IN ROOMS)
	(DESC "365")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY366
	(IN ROOMS)
	(DESC "366")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY367
	(IN ROOMS)
	(DESC "367")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY368
	(IN ROOMS)
	(DESC "368")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY369
	(IN ROOMS)
	(DESC "369")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY370
	(IN ROOMS)
	(DESC "370")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY371
	(IN ROOMS)
	(DESC "371")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY372
	(IN ROOMS)
	(DESC "372")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY373
	(IN ROOMS)
	(DESC "373")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY374
	(IN ROOMS)
	(DESC "374")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY375
	(IN ROOMS)
	(DESC "375")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY376
	(IN ROOMS)
	(DESC "376")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY377
	(IN ROOMS)
	(DESC "377")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY378
	(IN ROOMS)
	(DESC "378")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY379
	(IN ROOMS)
	(DESC "379")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY380
	(IN ROOMS)
	(DESC "380")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY381
	(IN ROOMS)
	(DESC "381")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY382
	(IN ROOMS)
	(DESC "382")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY383
	(IN ROOMS)
	(DESC "383")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY384
	(IN ROOMS)
	(DESC "384")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY385
	(IN ROOMS)
	(DESC "385")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY386
	(IN ROOMS)
	(DESC "386")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY387
	(IN ROOMS)
	(DESC "387")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY388
	(IN ROOMS)
	(DESC "388")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY389
	(IN ROOMS)
	(DESC "389")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY390
	(IN ROOMS)
	(DESC "390")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY391
	(IN ROOMS)
	(DESC "391")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY392
	(IN ROOMS)
	(DESC "392")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY393
	(IN ROOMS)
	(DESC "393")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY394
	(IN ROOMS)
	(DESC "394")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY395
	(IN ROOMS)
	(DESC "395")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY396
	(IN ROOMS)
	(DESC "396")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY397
	(IN ROOMS)
	(DESC "397")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY398
	(IN ROOMS)
	(DESC "398")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY399
	(IN ROOMS)
	(DESC "399")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY400
	(IN ROOMS)
	(DESC "400")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY401
	(IN ROOMS)
	(DESC "401")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY402
	(IN ROOMS)
	(DESC "402")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY403
	(IN ROOMS)
	(DESC "403")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY404
	(IN ROOMS)
	(DESC "404")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY405
	(IN ROOMS)
	(DESC "405")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY406
	(IN ROOMS)
	(DESC "406")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY407
	(IN ROOMS)
	(DESC "407")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY408
	(IN ROOMS)
	(DESC "408")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY409
	(IN ROOMS)
	(DESC "409")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY410
	(IN ROOMS)
	(DESC "410")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY411
	(IN ROOMS)
	(DESC "411")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY412
	(IN ROOMS)
	(DESC "412")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY413
	(IN ROOMS)
	(DESC "413")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY414
	(IN ROOMS)
	(DESC "414")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY415
	(IN ROOMS)
	(DESC "415")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY416
	(IN ROOMS)
	(DESC "416")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY417
	(IN ROOMS)
	(DESC "417")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY418
	(IN ROOMS)
	(DESC "418")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY419
	(IN ROOMS)
	(DESC "419")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY420
	(IN ROOMS)
	(DESC "420")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY421
	(IN ROOMS)
	(DESC "421")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY422
	(IN ROOMS)
	(DESC "422")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY423
	(IN ROOMS)
	(DESC "423")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY424
	(IN ROOMS)
	(DESC "424")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY425
	(IN ROOMS)
	(DESC "425")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY426
	(IN ROOMS)
	(DESC "426")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROOM STORY427
	(IN ROOMS)
	(DESC "427")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS NONE)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

