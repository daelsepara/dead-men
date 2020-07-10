<GLOBAL CHARACTERS-ENABLED T>

<CONSTANT BAD-ENDING "The adventure is over. You quest for glory ends here.">
<CONSTANT GOOD-ENDING "You are successful in your quest for glory! Congratulations!">

<OBJECT CURRENCY (DESC "doubloons")>
<OBJECT VEHICLE (DESC "ships")>

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
	<SETG STORY007-FLAG F>
	<PUTP ,STORY005 ,P?DEATH T>
	<PUTP ,STORY006 ,P?DEATH T>
	<PUTP ,STORY007 ,P?CODEWORD CODEWORD-DETRUDE>
	<PUT <GETP ,STORY012 ,P?DESTINATIONS> 3 ,STORY409>
	<PUTP ,STORY013 ,P?DEATH T>
	<PUTP ,STORY032 ,P?DEATH T>
	<PUTP ,STORY040 ,P?DEATH T>
	<PUTP ,STORY041 ,P?DEATH T>
	<PUTP ,STORY047 ,P?DEATH T>
	<PUTP ,STORY066 ,P?DEATH T>
	<RETURN>>

<CONSTANT DIED-IN-COMBAT "You died in combat.">
<CONSTANT DIED-OF-HUNGER "You died of hunger and thirst.">

<ROUTINE DAMAGE-SHIP (DMG SURVIVED DESTROYED "AUX" STARS)
	<COND (,CURRENT-VEHICLE
		<CRLF>
		<HLIGHT ,H-BOLD>
		<TELL CT ,CURRENT-VEHICLE " suffers " N .DMG " damage.">
		<HLIGHT 0>
		<CRLF>
		<SET STARS <GETP ,CURRENT-VEHICLE ,P?STARS>>
		<SET STARS <- .STARS .DMG>>
		<COND (<L? .STARS 0> <SET .STARS 0>)>
		<PUTP ,CURRENT-VEHICLE ,P?STARS .STARS>
		<COND (<G? .STARS 0> <STORY-JUMP .SURVIVED>)>
		<STORY-JUMP .DESTROYED>
	)>
	<RETURN>>

<ROUTINE IF-ALIVE (TEXT)
	<COND (<G? ,LIFE-POINTS 0> <TELL CR .TEXT CR>)>>

<ROUTINE SKILL-SWAP (FIRST-SKILL SECOND-SKILL "AUX" COUNT SKILLS MY-SKILLS)
	<COND (<OR <NOT .FIRST-SKILL> <NOT .SECOND-SKILL>> <RETURN>)>
	<SET COUNT 0>
	<SET MY-SKILLS <LTABLE NONE NONE NONE NONE NONE NONE>>
	<SET SKILLS <FIRST? ,SKILLS>>
	<REPEAT ()
		<COND (<NOT .SKILLS> <RETURN>)>
		<SET COUNT <+ .COUNT 1>>
		<PUT .MY-SKILLS .COUNT .SKILLS>
		<SET .SKILLS <NEXT? .SKILLS>>
	>
	<COND (<NOT <INTBL? .FIRST-SKILL .MY-SKILLS 7>>
		<SET COUNT <+ .COUNT 1>>
		<PUT .MY-SKILLS .COUNT .FIRST-SKILL>
	)>
	<COND (<NOT <INTBL? .SECOND-SKILL .MY-SKILLS 7>>
		<SET COUNT <+ .COUNT 1>>
		<PUT .MY-SKILLS .COUNT .SECOND-SKILL>
	)>
	<COND (<EQUAL? .COUNT 4> <RETURN>)>
	<REPEAT ()
		<RESET-SKILLS>
		<SELECT-FROM-LIST .MY-SKILLS .COUNT 4 "skill" ,SKILLS>
		<COND (<AND <EQUAL? <COUNT-CONTAINER ,SKILLS> 4> <IN? .FIRST-SKILL ,SKILLS> <IN? .SECOND-SKILL ,SKILLS>> <RETURN>)>
		<HLIGHT ,H-BOLD>
		<COND (<NOT <EQUAL? <COUNT-CONTAINER ,SKILLS> 4>>
			<CRLF>
			<TELL "You must select 4 skills!">
			<CRLF>
		)(ELSE <COND (<OR <NOT <IN? .FIRST-SKILL ,SKILLS>> <NOT <IN? .SECOND-SKILL ,SKILLS>>>)> 
			<CRLF>
			<HLIGHT ,H-BOLD>
			<TELL "You must select both " D .FIRST-SKILL " and " D .SECOND-SKILL " skills.">
			<CRLF>
		)>
		<HLIGHT 0>
	>>

<CONSTANT TEMP-LIST <LTABLE NONE NONE NONE NONE NONE NONE NONE NONE NONE NONE NONE NONE NONE NONE NONE>>

<ROUTINE RESET-TEMP-LIST ("AUX" ITEMS)
	<SET ITEMS <GET TEMP-LIST 0>>
	<DO (I 1 .ITEMS)
		<PUT TEMP-LIST .I NONE>
	>>

<ROUTINE GIVE-ITEMS (LIST UNABLE UNWILLING "OPT" MAX JUMP "AUX" ITEMS COUNT)
	<RESET-TEMP-LIST>
	<COND (<NOT .MAX> <SET MAX 1>)>
	<SET ITEMS <GET .LIST 0>>
	<SET COUNT 0>
	<DO (I 1 .ITEMS)
		<COND (<AND <GET .LIST .I> <IN? <GET .LIST .I> ,PLAYER>>
			<SET COUNT <+ .COUNT 1>>
			<PUT TEMP-LIST .COUNT <GET .LIST .I>>
		)>
	>
	<COND (<G? .COUNT 1>
		<RESET-GIVEBAG>
		<REPEAT ()
			<TRANSFER-CONTAINER ,GIVEBAG ,PLAYER>
			<SELECT-FROM-LIST TEMP-LIST .COUNT .MAX "item" ,GIVEBAG>
			<COND (<L? <COUNT-CONTAINER ,GIVEBAG> .MAX>
				<EMPHASIZE .UNWILLING>
				<RETURN>
			)(ELSE
				<CRLF>
				<TELL "Are you sure?">
				<COND (<YES?>
					<CRLF>
					<HLIGHT ,H-BOLD>
					<TELL "You gave: ">
					<HLIGHT 0>
					<PRINT-CONTAINER ,GIVEBAG>
					<COND (.JUMP
						<STORY-JUMP .JUMP>
					)>
					<RETURN>
				)>
			)>
		>
	)(ELSE
		<EMPHASIZE .UNABLE>
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
	<COND (<IN? ,SKILL-WILDERNESS-LORE ,SKILLS>
		<STORY-JUMP ,STORY421>
	)>>

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
	<COND (<IN? ,SKILL-SPELLS ,SKILLS> <STORY-JUMP ,STORY061>)>>

<CONSTANT TEXT005 "Ejada responds with a cry of rage and sorcerous gesture. Immediately a hail of red-hot stones pour down out of the sky to pelt you as you flee. \"Craven mortals, \" she thunders. \"I gave you the chance to leave with honour, but you spurned my kindness. Now suffer the consequences.\"||\"Kindness, she calls it?\" gasps Blutz as he struggles to keep up through the battering rain of stones. \"She's killing us with her kindness!">
<CONSTANT DIED-EJADA-SORCERY "You have died from the Ejada's sorcery.">

<ROOM STORY005
	(IN ROOMS)
	(DESC "005")
	(STORY TEXT005)
	(PRECHOICE STORY005-PRECHOICE)
	(CONTINUE STORY195)
	(DEATH T)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY005-PRECHOICE ()
	<COND (<IN? ,SKILL-CHARMS ,SKILLS>
		<COND (<IN? ,FEATHER-SHIELD ,PLAYER>
			<LOSE-LIFE 2 DIED-EJADA-SORCERY ,STORY005>
		)(ELSE
			<LOSE-LIFE 4 DIED-EJADA-SORCERY ,STORY005>
		)>
	)(ELSE
		<LOSE-LIFE 6 DIED-EJADA-SORCERY ,STORY005>
	)>>

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
	<COND (<G? ,LIFE-POINTS 1>
		<SETG ,LIFE-POINTS <- ,LIFE-POINTS 1>>
		<PUTP ,STORY006 ,P?DEATH F>
		<TELL TEXT006-CONTINUED>
		<CRLF>
	)(ELSE
		<CRLF>
		<LOSE-LIFE 1 "You died from the bullet wound." ,STORY006>
	)>>

<GLOBAL STORY007-FLAG F>

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
	<COND (,STORY007-FLAG
		<RETURN ,STORY026>
	)>
	<COND (<IN? ,SKILL-CHARMS ,SKILLS>
		<PUTP ,STORY007 ,P?CODEWORD NONE>
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
	<COND (<IN? ,CODEWORD-CHANCERY ,CODEWORDS>
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

<CONSTANT CHOICES012 <LTABLE "find someone to identify any unusual items you've come across if you have not already done so" "listen for rumours" "apply for a letter of marque" "pay a visit to Master Capstick" "you have now completed all your business in Leshand">>

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

<ROUTINE STORY012-PRECHOICE()
	<MERCHANT <LTABLE CRUCIFIX PISTOL SWORD COMPASS PARROT> <LTABLE 8 10 10 10 2>>
	<CRLF>
	<TELL TEXT012-CONTINUED>
	<CRLF>
	<COND (<IN? ,SKILL-ROGUERY ,SKILLS>
		<PUT <GETP ,STORY012 ,P?DESTINATIONS> 3 ,STORY050>
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

<ROUTINE STORY013-PRECHOICE ()
	<COND (<OR <AND <IN? ,SKILL-MARKSMANSHIP ,SKILLS> <IN? ,PISTOL ,PLAYER>> <AND <IN? ,SKILL-SWORDPLAY ,SKILLS> <IN? ,SWORD ,PLAYER>>>
		<LOSE-LIFE 2 DIED-IN-COMBAT ,STORY013>
	)(<IN? ,SKILL-BRAWLING ,SKILLS>
		<LOSE-LIFE 3 DIED-IN-COMBAT ,STORY013>
	)(ELSE
		<LOSE-LIFE 6 DIED-IN-COMBAT ,STORY013>
	)>>

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

<CONSTANT TEXT016 "You sail back into Selenice harbour with a hold full of treasure and hearts full of confidence. News of your fortune spreads rapidly, bringing the master shipwright himself hurrying down to the quay to greet you.||\"Come aboard, Master Kemp,\" you say, heartily pumping his hand as he steps off the gangplank. \"We've found rich pickings on our travels. Perhaps now you can sell us a ship more suited to our needs?\" With that, you throw open the hold covers with a theatrical flourish.||The sunlight reflects off your haul in patterns of gold, silver and ruby-red across Kemp's face. He looks up with as broad a smile as a mouth could manage and says, \"Why, captain. I have the very ship for you moored just along the quay.\"||You turn to look where he is pointing, a gasp of admiration escaping your lips as you do. The ship is a proud tall-masted galleon with sixty cannon bristling along her gunwales. Her figurehead is a painted oak mermaid of almost supernatural beauty. \"The Faerie Queen,\# says Blutz, reading the name emblazoned on the prow. \"I think I'm in love.\"||\"That's the one for us,\" you concur. \"Master Kemp, you keep the sloop and the loot here in the hold. We'll have the Faerie Queen.\"||Kemp nods, stunned at having made the quickest sale of his life, while you stride down the gangplank and along the quay to take command of your new vessel.">

<ROOM STORY016
	(IN ROOMS)
	(DESC "016")
	(STORY TEXT016)
	(CONTINUE STORY184)
	(FLAGS LIGHTBIT)>

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
<CONSTANT CHOICES020 <LTABLE "wait and hear Skarvench's reply" "rejoin your friends if you think it's time" "risk taking the time to snatch some supplies from the sailmaster's cabin">>

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
	<COND (<IN? ,SKILL-FOLKLORE ,SKILLS> <STORY-JUMP ,STORY058>)>>

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
	<COND (<IN? ,SKILL-FOLKLORE ,SKILLS> <STORY-JUMP ,STORY045>)>>

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
	<COND (<IN? ,SKILL-FOLKLORE ,SKILLS> <STORY-JUMP ,STORY104>)>>

<CONSTANT TEXT029 "Mortice gives you food and water from his store, while you relate the story of your time aboard Skarvench's ship and how you finally manage to escape, only to face further perils on the open sea.||By now the moon has risen, shedding a spectral glow across the phosphorescent foam on the water. \"A wondrous tale,\" says Mortice, still with the same fixed leer on his face.||\"And what about you, oldster?\" asks Blutz as he chews the last scrap of meat off a chicken leg. \"How do you come to be adrift on a bare raft, with only a bucket of fresh water and a hamper of food for company?\"||\"Ah!\" cries the old man. \"That's a wondrous tale, too. But it can wait till morning, methinks, for the hour is late and I perceive that the full meal has made you tired.\"">

<ROOM STORY029
	(IN ROOMS)
	(DESC "029")
	(STORY TEXT029)
	(PRECHOICE STORY029-PRECHOICE)
	(CONTINUE STORY105)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY029-PRECHOICE ()
	<COND (<IN? ,SKILL-SEAFARING ,SKILLS> <STORY-JUMP ,STORY067>)>>

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
	<GAIN-LIFE 1>>

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
	<LOSE-LIFE 1 "You died from the knife wound." ,STORY032>
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

<CONSTANT TEXT038-NODAMAGE "You pull your ship deftly aft of the enemy ship without taking damage.">

<CONSTANT TEXT038-DAMAGED "You are clipped by cannon-fire as you go in.">

<ROOM STORY038
	(IN ROOMS)
	(DESC "038")
	(PRECHOICE STORY038-PRECHOICE)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY038-PRECHOICE ()
	<COND (<IN? ,SKILL-SEAFARING ,SKILLS>
		<CRLF>
		<TELL TEXT038-NODAMAGE>
		<CRLF>
		<STORY-JUMP ,STORY415>
	)(ELSE
		<CRLF>
		<TELL TEXT038-DAMAGED>
		<CRLF>
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
<CONSTANT RAGGED-CLOTHES "Your ragged clothes were not enough to keep you warm. You died some time in the night.">

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
	<COND (<IN? ,SKILL-WILDERNESS-LORE ,SKILLS>
		<LOSE-LIFE 1 RAGGED-CLOTHES ,STORY040>
		<IF-ALIVE "[With your knowledge of WILDERNESS LORE, you soak your ragged clothes in the sea to keep yourself warm at night and cool during the day]">
	)(ELSE
		<LOSE-LIFE 2 RAGGED-CLOTHES ,STORY040>
		<COND (<G? ,LIFE-POINTS 0>
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
	<COND (<AND <IN? ,SKILL-CHARMS ,SKILLS> <IN? ,MAGIC-AMULET ,PLAYER>>
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
	<COND (<OR <IN? ,SKILL-ROGUERY ,SKILLS> <IN? ,SKILL-WILDERNESS-LORE ,SKILLS>> <RETURN ,STORY080>)>
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
	<REMOVE ,CURRENT-VEHICLE>
	<MOVE ,OCTAVIUS ,VEHICLES>
	<SETG CURRENT-VEHICLE ,OCTAVIUS>>

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
	<LOSE-LIFE 1 DIED-OF-HUNGER ,STORY047>
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
	<COND (<IN? ,SKILL-SEAFARING ,SKILLS> <STORY-JUMP ,STORY067>)>>

<CONSTANT TEXT049 "You race off into the jungle not a moment too soon. Turning to peer back from the crest of a wooded hill, you see the Belle Dame already riding at anchor offshore. A rowboat is bringing Skarvench and his cut-throats to the beach even now.||\"He'll never leave until he's found us,\" mutters Oakley as you trudge on through the dense green thickets.||\"It's a big island,\" you call back over your shoulder. \"If we stay hidden long enough, he'll have to give up the search and leave. For all he knows we might be dead already.\"">

<ROOM STORY049
	(IN ROOMS)
	(DESC "049")
	(STORY TEXT049)
	(PRECHOICE STORY049-PRECHOICE)
	(CONTINUE STORY163)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY049-PRECHOICE ()
	<COND (<IN? ,SKILL-WILDERNESS-LORE ,SKILLS> <STORY-JUMP ,STORY144>)>>

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
<CONSTANT CHOICES052 <LTABLE "use" "try" "if you you don't have either of those skills, you will have to fight them -- either with a sword" "pistol" "your bare hands">>

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

<CONSTANT TEXT059 "\"What is it you want of me? \"growls the god, fixing you in the sharp glare of his eyes.||\"My Olympian lord,\" you begin, \"we are trapped on this ship...\"||\"It's captain dared to pillage my shrine!\" Dionysus thunders. \"But we don't deserve this fate, lord,\" you protest.||Dionysus ponders your case. \"Perhaps not. If you were more my creature, I might be moved to mercy.||\"Your creature, lord?\"||\"The type of mortal I favour,\" continues Dionysus impatiently, \"is a roistering rowdy varlet, full of craziness and lusty with the more uproarious joys that life has to offer. Not for me these sober scholars with their books and scrolls.\"||\"Not I, lord!\" you say hastily.||He nods thoughtfully. \"I wonder. Well, I'll whisk you off to your destination, but mind you're on your worst behaviour from now on. I can't abide a dainty do-gooder!\"At Dionysus's gesture, the wine soaking the decks rises in a cloud of giddying vapour. Reeling from the fumes, you grope out until you feel the hands of your friends. They cling to you as their only protection -- though, truth to tell, if the god had unleashed his full wrath then there would have been little enough that you could do.||The wine-mist clears. There is no sign of Dionysus or his panthers -- nor of the cursed ship. Now the four of you are huddle together in the corner of a dingy tavern. A burly barman stomps over and swabs at a puddle of spilled wine on the table in front of you. \"Ain't you got no homes to go to?\" he grumbles.||\"Where are we?\" Oakley innocently asks him.||The barman gives him a contemptuous look. \"You drunken lubbers! This is a Slaughtered Goat tavern, in Port Leshand.\"||You have been spirited magically to where you wanted to go, but the go's service has its price. He has left your mind permanently tinged with exuberant madness that is his hallmark.">

<ROOM STORY059
	(IN ROOMS)
	(DESC "059")
	(STORY TEXT059)
	(PRECHOICE STORY059-PRECHOICE)
	(CONTINUE STORY009)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY059-PRECHOICE ()
	<CRLF>
	<HLIGHT ,H-BOLD>
	<TELL "You must acquire now " D ,SKILL-ROGUERY " and " D ,SKILL-BRAWLING " if you did not have them before.">
	<HLIGHT 0>
	<CRLF>
	<SKILL-SWAP ,SKILL-ROGUERY ,SKILL-BRAWLING>>

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
	<LOSE-LIFE 1 DIED-OF-HUNGER ,STORY066>
	<IF-ALIVE TEXT066-CONTINUED>
	<COND (<IN? ,SKILL-WILDERNESS-LORE ,SKILLS> <STORY-JUMP ,STORY193>)>>

<CONSTANT TEXT067 "Few details of any sea-going craft escape your trained eye. You note that although Mortice's raft is made of oak planks, which is a heavy wood, it floats surprisingly light in the water. This is especially odd given that the raft also carries the burden of a man, a full rain barrel, and a large chest of provisions. You can only conclude there must be something buoyant lashed to the underside of the raft.">
<CONSTANT CHOICES067 <LTABLE "query Mortice about this" "let it lie, if you prefer">>

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
	<GIVE-ITEMS STORY068-GIVELIST STORY068-UNABLE STORY068-UNWILLING 2 ,STORY144>>

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

<ROOM STORY071
	(IN ROOMS)
	(DESC "071")
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

<ROOM STORY072
	(IN ROOMS)
	(DESC "072")
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

<ROOM STORY073
	(IN ROOMS)
	(DESC "073")
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

<ROOM STORY074
	(IN ROOMS)
	(DESC "074")
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

<ROOM STORY075
	(IN ROOMS)
	(DESC "075")
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

<ROOM STORY076
	(IN ROOMS)
	(DESC "076")
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

<ROOM STORY077
	(IN ROOMS)
	(DESC "077")
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

<ROOM STORY078
	(IN ROOMS)
	(DESC "078")
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

<ROOM STORY079
	(IN ROOMS)
	(DESC "079")
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

<ROOM STORY080
	(IN ROOMS)
	(DESC "080")
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

<ROOM STORY081
	(IN ROOMS)
	(DESC "081")
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

<ROOM STORY082
	(IN ROOMS)
	(DESC "082")
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

<ROOM STORY083
	(IN ROOMS)
	(DESC "083")
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

<ROOM STORY084
	(IN ROOMS)
	(DESC "084")
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

<ROOM STORY085
	(IN ROOMS)
	(DESC "085")
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

<ROOM STORY086
	(IN ROOMS)
	(DESC "086")
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

<ROOM STORY087
	(IN ROOMS)
	(DESC "087")
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

<ROOM STORY088
	(IN ROOMS)
	(DESC "088")
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

<ROOM STORY089
	(IN ROOMS)
	(DESC "089")
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

<ROOM STORY090
	(IN ROOMS)
	(DESC "090")
	(STORY TEXT-BLANK)
	(CHOICES NONE)
	(DESTINATIONS NONE)
	(REQUIREMENTS NONE)
	(TYPES NONE)
	(EVENTS STORY090-EVENTS)
	(PRECHOICE NONE)
	(CONTINUE NONE)
	(ITEM NONE)
	(CODEWORD NONE)
	(COST 0)
	(DEATH F)
	(VICTORY F)
	(FLAGS LIGHTBIT)>

<ROUTINE STORY090-EVENTS ()
	<CHARGE-MONEY 1>
	<PRESS-A-KEY>
	<RETURN ,STORY090>>

<ROOM STORY091
	(IN ROOMS)
	(DESC "091")
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

<ROOM STORY092
	(IN ROOMS)
	(DESC "092")
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

<ROOM STORY093
	(IN ROOMS)
	(DESC "093")
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

<ROOM STORY094
	(IN ROOMS)
	(DESC "094")
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

<ROOM STORY095
	(IN ROOMS)
	(DESC "095")
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

<ROOM STORY096
	(IN ROOMS)
	(DESC "096")
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

<ROOM STORY097
	(IN ROOMS)
	(DESC "097")
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

<ROOM STORY098
	(IN ROOMS)
	(DESC "098")
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

<ROOM STORY099
	(IN ROOMS)
	(DESC "099")
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

<ROOM STORY100
	(IN ROOMS)
	(DESC "100")
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

<ROOM STORY101
	(IN ROOMS)
	(DESC "101")
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

<ROOM STORY102
	(IN ROOMS)
	(DESC "102")
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

<ROOM STORY103
	(IN ROOMS)
	(DESC "103")
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

<ROOM STORY104
	(IN ROOMS)
	(DESC "104")
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

<ROOM STORY105
	(IN ROOMS)
	(DESC "105")
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

<ROOM STORY106
	(IN ROOMS)
	(DESC "106")
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

<ROOM STORY107
	(IN ROOMS)
	(DESC "107")
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

<ROOM STORY108
	(IN ROOMS)
	(DESC "108")
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

<ROOM STORY109
	(IN ROOMS)
	(DESC "109")
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

<ROOM STORY110
	(IN ROOMS)
	(DESC "110")
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

<ROOM STORY111
	(IN ROOMS)
	(DESC "111")
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

<ROOM STORY112
	(IN ROOMS)
	(DESC "112")
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

<ROOM STORY113
	(IN ROOMS)
	(DESC "113")
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

<ROOM STORY114
	(IN ROOMS)
	(DESC "114")
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

<ROOM STORY115
	(IN ROOMS)
	(DESC "115")
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

<ROOM STORY116
	(IN ROOMS)
	(DESC "116")
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

<ROOM STORY117
	(IN ROOMS)
	(DESC "117")
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

<ROOM STORY118
	(IN ROOMS)
	(DESC "118")
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

<ROOM STORY119
	(IN ROOMS)
	(DESC "119")
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

<ROOM STORY120
	(IN ROOMS)
	(DESC "120")
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

<ROOM STORY121
	(IN ROOMS)
	(DESC "121")
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

<ROOM STORY122
	(IN ROOMS)
	(DESC "122")
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

<ROOM STORY123
	(IN ROOMS)
	(DESC "123")
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

<ROOM STORY124
	(IN ROOMS)
	(DESC "124")
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

<ROOM STORY125
	(IN ROOMS)
	(DESC "125")
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

<ROOM STORY126
	(IN ROOMS)
	(DESC "126")
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

<ROOM STORY127
	(IN ROOMS)
	(DESC "127")
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

<ROOM STORY128
	(IN ROOMS)
	(DESC "128")
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

<CONSTANT TEXT129 "Which of these possessions will you use?">
<CONSTANT CHOICES129 <LTABLE "try the" "a" "a" "if you have none of these, you will have to give up and throw yourself on the giant's charity">>

<ROOM STORY129
	(IN ROOMS)
	(DESC "129")
	(STORY TEXT129)
	(CHOICES CHOICES129)
	(DESTINATIONS <LTABLE STORY243 STORY224 STORY262 STORY072>)
	(REQUIREMENTS <LTABLE HORNPIPE MONKEY DRAGON-RING NONE>)
	(TYPES <LTABLE R-ITEM R-ITEM R-ITEM R-NONE>)
	(FLAGS LIGHTBIT)>

<ROOM STORY130
	(IN ROOMS)
	(DESC "130")
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

<ROOM STORY131
	(IN ROOMS)
	(DESC "131")
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

<ROOM STORY132
	(IN ROOMS)
	(DESC "132")
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

<ROOM STORY133
	(IN ROOMS)
	(DESC "133")
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

<ROOM STORY134
	(IN ROOMS)
	(DESC "134")
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

<ROOM STORY135
	(IN ROOMS)
	(DESC "135")
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

<ROOM STORY136
	(IN ROOMS)
	(DESC "136")
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

<ROOM STORY137
	(IN ROOMS)
	(DESC "137")
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

<ROOM STORY138
	(IN ROOMS)
	(DESC "138")
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

<ROOM STORY139
	(IN ROOMS)
	(DESC "139")
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

<ROOM STORY140
	(IN ROOMS)
	(DESC "140")
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

<ROOM STORY141
	(IN ROOMS)
	(DESC "141")
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

<ROOM STORY142
	(IN ROOMS)
	(DESC "142")
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

<ROOM STORY143
	(IN ROOMS)
	(DESC "143")
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

<ROOM STORY144
	(IN ROOMS)
	(DESC "144")
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

<ROOM STORY145
	(IN ROOMS)
	(DESC "145")
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

<ROOM STORY146
	(IN ROOMS)
	(DESC "146")
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

<ROOM STORY147
	(IN ROOMS)
	(DESC "147")
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

<ROOM STORY148
	(IN ROOMS)
	(DESC "148")
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

<ROOM STORY149
	(IN ROOMS)
	(DESC "149")
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

<ROOM STORY150
	(IN ROOMS)
	(DESC "150")
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

<ROOM STORY151
	(IN ROOMS)
	(DESC "151")
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

<ROOM STORY152
	(IN ROOMS)
	(DESC "152")
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

<ROOM STORY153
	(IN ROOMS)
	(DESC "153")
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

<ROOM STORY154
	(IN ROOMS)
	(DESC "154")
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

<ROOM STORY155
	(IN ROOMS)
	(DESC "155")
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

<ROOM STORY156
	(IN ROOMS)
	(DESC "156")
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

<ROOM STORY157
	(IN ROOMS)
	(DESC "157")
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

<ROOM STORY158
	(IN ROOMS)
	(DESC "158")
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

<ROOM STORY159
	(IN ROOMS)
	(DESC "159")
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

<ROOM STORY160
	(IN ROOMS)
	(DESC "160")
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

<ROOM STORY161
	(IN ROOMS)
	(DESC "161")
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

<ROOM STORY162
	(IN ROOMS)
	(DESC "162")
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

<ROOM STORY163
	(IN ROOMS)
	(DESC "163")
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

<ROOM STORY164
	(IN ROOMS)
	(DESC "164")
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

<ROOM STORY165
	(IN ROOMS)
	(DESC "165")
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

<ROOM STORY166
	(IN ROOMS)
	(DESC "166")
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

<ROOM STORY167
	(IN ROOMS)
	(DESC "167")
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

<ROOM STORY168
	(IN ROOMS)
	(DESC "168")
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

<ROOM STORY169
	(IN ROOMS)
	(DESC "169")
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

<ROOM STORY170
	(IN ROOMS)
	(DESC "170")
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

<ROOM STORY171
	(IN ROOMS)
	(DESC "171")
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

<ROOM STORY172
	(IN ROOMS)
	(DESC "172")
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

<ROOM STORY173
	(IN ROOMS)
	(DESC "173")
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

<ROOM STORY174
	(IN ROOMS)
	(DESC "174")
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

<ROOM STORY175
	(IN ROOMS)
	(DESC "175")
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

<ROOM STORY176
	(IN ROOMS)
	(DESC "176")
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

<ROOM STORY177
	(IN ROOMS)
	(DESC "177")
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

<ROOM STORY178
	(IN ROOMS)
	(DESC "178")
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

<ROOM STORY179
	(IN ROOMS)
	(DESC "179")
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

<ROOM STORY180
	(IN ROOMS)
	(DESC "180")
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

<ROOM STORY181
	(IN ROOMS)
	(DESC "181")
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

<ROOM STORY182
	(IN ROOMS)
	(DESC "182")
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

<ROOM STORY183
	(IN ROOMS)
	(DESC "183")
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

<ROOM STORY184
	(IN ROOMS)
	(DESC "184")
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

<ROOM STORY185
	(IN ROOMS)
	(DESC "185")
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

<ROOM STORY186
	(IN ROOMS)
	(DESC "186")
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

<ROOM STORY187
	(IN ROOMS)
	(DESC "187")
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

<ROOM STORY188
	(IN ROOMS)
	(DESC "188")
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

<ROOM STORY189
	(IN ROOMS)
	(DESC "189")
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

<ROOM STORY190
	(IN ROOMS)
	(DESC "190")
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

<ROOM STORY191
	(IN ROOMS)
	(DESC "191")
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

<ROOM STORY192
	(IN ROOMS)
	(DESC "192")
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

<ROOM STORY193
	(IN ROOMS)
	(DESC "193")
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

<ROOM STORY194
	(IN ROOMS)
	(DESC "194")
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

<ROOM STORY195
	(IN ROOMS)
	(DESC "195")
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

<ROOM STORY196
	(IN ROOMS)
	(DESC "196")
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

<ROOM STORY197
	(IN ROOMS)
	(DESC "197")
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

<ROOM STORY198
	(IN ROOMS)
	(DESC "198")
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

<ROOM STORY199
	(IN ROOMS)
	(DESC "199")
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

<ROOM STORY200
	(IN ROOMS)
	(DESC "200")
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

<ROOM STORY201
	(IN ROOMS)
	(DESC "201")
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

<ROOM STORY202
	(IN ROOMS)
	(DESC "202")
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

<ROOM STORY203
	(IN ROOMS)
	(DESC "203")
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

<ROOM STORY204
	(IN ROOMS)
	(DESC "204")
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

<ROOM STORY205
	(IN ROOMS)
	(DESC "205")
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

<ROOM STORY206
	(IN ROOMS)
	(DESC "206")
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

<ROOM STORY207
	(IN ROOMS)
	(DESC "207")
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

<ROOM STORY208
	(IN ROOMS)
	(DESC "208")
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

<ROOM STORY209
	(IN ROOMS)
	(DESC "209")
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

<ROOM STORY210
	(IN ROOMS)
	(DESC "210")
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

<ROOM STORY211
	(IN ROOMS)
	(DESC "211")
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

<ROOM STORY212
	(IN ROOMS)
	(DESC "212")
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

<ROOM STORY213
	(IN ROOMS)
	(DESC "213")
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

<ROOM STORY214
	(IN ROOMS)
	(DESC "214")
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

<ROOM STORY215
	(IN ROOMS)
	(DESC "215")
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

<ROOM STORY216
	(IN ROOMS)
	(DESC "216")
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

<ROOM STORY217
	(IN ROOMS)
	(DESC "217")
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

<ROOM STORY218
	(IN ROOMS)
	(DESC "218")
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

<ROOM STORY219
	(IN ROOMS)
	(DESC "219")
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

<ROOM STORY220
	(IN ROOMS)
	(DESC "220")
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

<ROOM STORY221
	(IN ROOMS)
	(DESC "221")
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

<ROOM STORY222
	(IN ROOMS)
	(DESC "222")
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

<ROOM STORY223
	(IN ROOMS)
	(DESC "223")
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

<ROOM STORY224
	(IN ROOMS)
	(DESC "224")
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

<ROOM STORY225
	(IN ROOMS)
	(DESC "225")
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

<ROOM STORY226
	(IN ROOMS)
	(DESC "226")
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

<ROOM STORY227
	(IN ROOMS)
	(DESC "227")
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

<ROOM STORY228
	(IN ROOMS)
	(DESC "228")
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

<ROOM STORY229
	(IN ROOMS)
	(DESC "229")
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

<ROOM STORY230
	(IN ROOMS)
	(DESC "230")
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

<ROOM STORY231
	(IN ROOMS)
	(DESC "231")
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

<ROOM STORY232
	(IN ROOMS)
	(DESC "232")
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

<ROOM STORY233
	(IN ROOMS)
	(DESC "233")
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

<ROOM STORY234
	(IN ROOMS)
	(DESC "234")
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

<ROOM STORY235
	(IN ROOMS)
	(DESC "235")
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

<ROOM STORY236
	(IN ROOMS)
	(DESC "236")
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

<ROOM STORY237
	(IN ROOMS)
	(DESC "237")
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

<ROOM STORY238
	(IN ROOMS)
	(DESC "238")
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

<ROOM STORY239
	(IN ROOMS)
	(DESC "239")
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

<ROOM STORY240
	(IN ROOMS)
	(DESC "240")
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

<ROOM STORY241
	(IN ROOMS)
	(DESC "241")
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

<ROOM STORY242
	(IN ROOMS)
	(DESC "242")
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

<ROOM STORY243
	(IN ROOMS)
	(DESC "243")
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

<ROOM STORY244
	(IN ROOMS)
	(DESC "244")
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

<ROOM STORY245
	(IN ROOMS)
	(DESC "245")
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

<ROOM STORY246
	(IN ROOMS)
	(DESC "246")
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

<ROOM STORY247
	(IN ROOMS)
	(DESC "247")
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

<ROOM STORY248
	(IN ROOMS)
	(DESC "248")
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

<ROOM STORY249
	(IN ROOMS)
	(DESC "249")
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

<ROOM STORY250
	(IN ROOMS)
	(DESC "250")
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

<ROOM STORY251
	(IN ROOMS)
	(DESC "251")
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

<ROOM STORY252
	(IN ROOMS)
	(DESC "252")
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

<ROOM STORY253
	(IN ROOMS)
	(DESC "253")
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

<ROOM STORY254
	(IN ROOMS)
	(DESC "254")
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

<ROOM STORY255
	(IN ROOMS)
	(DESC "255")
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

<ROOM STORY256
	(IN ROOMS)
	(DESC "256")
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

<ROOM STORY257
	(IN ROOMS)
	(DESC "257")
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

<ROOM STORY258
	(IN ROOMS)
	(DESC "258")
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

<ROOM STORY259
	(IN ROOMS)
	(DESC "259")
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

<ROOM STORY260
	(IN ROOMS)
	(DESC "260")
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

