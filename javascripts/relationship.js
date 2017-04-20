
//can be positive or negative. if high enough, can
//turn into romance in a quadrant.
function Relationship(initial_value, target_player){
	this.value = initial_value;
	this.target = target_player;
	this.saved_type = "";
	this.drama = false; //drama is set to true if type of relationship changes.
	this.old_type = "";
	//wish class variables were a thing.
	this.goodMild = "Friends";
	this.goodBig = "Totally In Love";
	this.badMild = "Rivals";
	this.badBig = "Enemies";
	this.heart = "Matesprits"
	this.diamond = "Moirallegiance"
	this.clubs = "Auspisticism"
	this.spades = "Kismesissitude";

	//eventually, when i adapt this to be SGRUB, have 2d relationships.  feel good or bad, feel concupiscient or not.
	//also trolls are rivals unless value is at least 5 (more likely to be enemies than friends)
	this.changeType = function(){
		if(this.value > 20){ //used to be -10 to 10, but too many crushes.
			return this.goodBig;
		}else if(this.value < -20){
			return this.badBig;
		}else if(this.value > 0){
			return this.goodMild;
		}else{
			return this.badMild;
		}
	}
	//can't do this before function is written. so dumb.
	this.saved_type = this.changeType();
	//for most interactions, the relationship will grow along it's current trajectory.
	this.moreOfSame = function(){
		if(this.value >= 0){
			this.increase();
		}else{
			this.decrease();
		}
	}

	this.increase = function(){
		this.value ++;
	}

	this.decrease = function(){
		this.value += -1;
	}
	
	//the only way to fill your quadrants.
	this.setOfficialRomance = function(type){
		//console.log("official romance of type: " + type )
		//don't generate any extra drama, the event that led to this was ALREADY drama.
		this.saved_type = type;
		this.old_type = type;
	}
	

	this.type = function(){
		//official relationships are different.
		if(this.saved_type == this.heart || this.saved_type == this.spades || this.saved_type == this.diamond || this.saved_type == this.clubs){
			return this.saved_type; //break up in own scene, not here.
		}
		if(this.saved_type == "" ){
			this.drama = false;
			this.saved_type = this.changeType();
			this.old_type = this.saved_type;
			//if it's big drama, you can have your scene
			if(this.saved_type == this.goodBig || this.saved_type == this.badBig){
				this.drama = true;
				this.old_type = this.goodMild;
			}
			return this.saved_type;
		}

		if(Math.seededRandom() > 0.25){
			//enter or leave a relationship, or vaccilate.
			this.old_type = this.saved_type;
			this.saved_type = this.changeType();
		}

		if(this.old_type != this.saved_type){
			this.drama = true;
		}else{
			this.drama = false;
		}
		return this.saved_type;
	}

	this.description = function(){
		return this.type() + " with the " + this.target.htmlTitle();
	}

}

function getRelationshipFlavorGreeting(r1, r2, me, you){
	var ret = "";
	if(r1.type() == r1.goodBig && r2.type() == r2.goodBig){
		ret += " Hey! ";
	}else if(r2.type() == r2.goodBig){
		ret += "Hey.";
	}else if(r1.type() == r1.goodBig){
		ret += " Uh, hey!";
	}else if(r1.type() == r1.badBig && r2.type() == r2.badBig){
		ret += " Hey, asshole.";
	}else if(r2.type() == r2.badBig){
		ret += "Er...hey?"
	}else if(r1.type() == r2.badBig){
		ret += "I'll make this quick. ";
	}else{
		ret += "Hey."
	}
	return ret;

}

function getRelationshipFlavorText(r1, r2, me, you){
	var ret = "";
	if(r1.type() == r1.goodBig && r2.type() == r2.goodBig){
		ret += " The two flirt a bit. ";
	}else if(r2.type() == r2.goodBig){
		ret += " The" + you.htmlTitle() + " is flustered around the " + me.htmlTitle()+ ". ";
	}else if(r1.type() == r1.goodBig){
		ret += " The" + me.htmlTitle() + " is flustered around the " + you.htmlTitle()+ ". ";
	}else if(r1.type() == r1.badBig && r2.type() == r2.badBig){
		ret += " The two are just giant assholes to each other. ";
	}else if(r2.type() == r2.badBig){
		ret += you.htmlTitle() + " is irritable around the " + me.htmlTitle() + ". ";
	}else if(r1.type() == r2.badBig){
		ret += " The" + me.htmlTitle() + " is irritable around the " + you.htmlTitle() + ". ";
	}
	return ret;
}

function cloneRelationship(relationship){
	var clone = new Relationship();
	for(var propertyName in relationship) {
		clone[propertyName] = relationship[propertyName];
	}
	return clone;
}

//when i am cloning players, i need to make sure they don't have a reference to the same relationships the original player does.
//if i fail to do this step, i accidentally give the players the Capgras delusion.
//this HAS to happen before transferFeelingsToClones.
function cloneRelationshipsStopgap(relationships){
		//console.log("clone relationships stopgap")
		var ret = [];
		for(var i = 0; i<relationships.length; i++){
			var r = relationships[i]
			ret.push(cloneRelationship(r));
		}
		return ret;
}

//when i clone alien players on arival, i need their cloned relationships to be about the other clones
//not the original players.
//also, I <3 this method name. i <3 this sim.
function transferFeelingsToClones(player, clones){
	//console.log("transfer feelings to clones")
	for(var i =0; i<player.relationships.length; i++){
			var r = player.relationships[i];
			var clone = findClaspectPlayer(clones, r.target.class_name, r.target.aspect);
			//if i can't find a clone, it's probably a dead player that didn't come to the new session.
			//may as well keep the original relationship
			if(clone){
				r.target = clone;
			}

	}
}

function makeHeart(player1, player2){
	var r1 = player1.getRelationshipWith(player2)
	r1.setOfficialRomance(r1.heart)
	var r2 = player2.getRelationshipWith(player1)
	r2.setOfficialRomance(r2.heart)
}

function makeSpades(player1, player2){
	var r1 = player1.getRelationshipWith(player2)
	r1.setOfficialRomance(r1.spades)
	var r2 = player2.getRelationshipWith(player1)
	r2.setOfficialRomance(r2.spades)
}

function makeDiamonds(player1, player2){
	var r1 = player1.getRelationshipWith(player2)
	if(r1.value < 0){
		r1.value = 1;  //like you at least a little
	}
	r1.setOfficialRomance(r1.diamond)
	var r2 = player2.getRelationshipWith(player1)
	if(r2.value < 0){
		r2.value = 1;
	}
	r2.setOfficialRomance(r2.diamond)
}

//clubs, why you so cray cray?
function makeClubs(middleLeaf, asshole1, asshole2){
	var rmid1 = middleLeaf.getRelationshipWith(asshole1);
	var rmid2 = middleLeaf.getRelationshipWith(asshole2);
	
	var rass1mid = asshole1.getRelationshipWith(middleLeaf);
	var rass12 =   asshole1.getRelationshipWith(asshole2);
	
	var rass2mid = asshole2.getRelationshipWith(middleLeaf);
	var rass21 =   asshole2.getRelationshipWith(asshole1);
	
	if(rmid1.value > 0){
		rmid1.value = -1;  //hate you at least a little
	}
	
	if(rmid2.value > 0){
		rmid2.value = -1;  //hate you at least a little
	}
	
	rmid1.setOfficialRomance(rmid1.clubs)
	rmid2.setOfficialRomance(rmid1.clubs)
	rass1mid.setOfficialRomance(rmid1.clubs)
	rass12.setOfficialRomance(rmid1.clubs)
	rass2mid.setOfficialRomance(rmid1.clubs)
	rass21.setOfficialRomance(rmid1.clubs)
}

function randomBlandRelationship(targetPlayer){
	return new Relationship(1, targetPlayer);
}

function randomRelationship(targetPlayer){
	return new Relationship(getRandomInt(-21,21), targetPlayer);
}

function getRandomInt(min, max) {
    return Math.floor(Math.seededRandom() * (max - min + 1)) + min;
}
