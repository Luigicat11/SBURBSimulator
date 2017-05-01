function FightKing(session){
	this.canRepeat = true;
	this.session = session;
	this.playerList = [];  //what players are already in the medium when i trigger?

	this.trigger = function(playerList){
		this.playerList = playerList;
		//console.log('fight kin trigger?')
		return (this.session.king.getHP() >= 0) &&  (this.session.queen.getHP() <= 0) && (findLivingPlayers(this.session.players).length != 0) ;
	}

	this.killPlayers = function(stabbings){
		for(var i = 0; i<stabbings.length; i++){
			stabbings[i].makeDead("fighting the Black King");
		}
	}

	this.levelPlayers = function(stabbings){
		for(var i = 0; i<stabbings.length; i++){
			stabbings[i].increasePower();
			stabbings[i].increasePower();
			stabbings[i].increasePower();
			stabbings[i].leveledTheHellUp = true;
			stabbings.level_index +=2;
		}
	}



this.getGoodGuys = function(){
		var living = findLivingPlayers(this.session.players);
		var timePlayer = findAspectPlayer(this.session.players, "Time");

		for(var i = 0; i<timePlayer.doomedTimeClones.length; i++){
			var timeClone = timePlayer.doomedTimeClones[i];
			living.push(timeClone);
		}
		return living;
	}

	//render each living player, each time clone, and some dersites/prospitan rabble (maybe)
	this.renderGoodguys = function(div,living){
		var repeatTime = 1000;
		var divID = (div.attr("id")) + "_final_boss";
		var ch = canvasHeight;
		var fightingPlayers = this.getGoodGuys();
		if(fightingPlayers.length > 6){
			ch = canvasHeight*1.5; //a little bigger than two rows, cause time clones
		}
		var canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth + "' height="+ch + "'>  </canvas>";
		div.append(canvasHTML);
		//different format for canvas code
		var canvasDiv = document.getElementById("canvas"+ divID);
		poseAsATeam(canvasDiv, fightingPlayers, 2000);
	}

	this.renderContent = function(div){
		console.log("rendering fight king);")
		div.append("<br>");
		div.append(this.content());

		this.renderGoodguys(div); //pose as a team BEFORE getting your ass handed to you.
		if(this.session.democraticArmy.hp > 0 ) living.push(this.session.democraticArmy);
		var fighting = this.getGoodGuys()
		if(this.session.democraticArmy.getHp() > 0) fighting.push(this.session.democraticArmy)
		this.king.strife(div, fighting)

	}

	this.minorLevelPlayers = function(stabbings){
		for(var i = 0; i<stabbings.length; i++){
			stabbings[i].increasePower();
		}
	}



	this.setPlayersUnavailable = function(stabbings){
		for(var i = 0; i<stabbings.length; i++){
			removeFromArray(stabbings[i], this.session.availablePlayers);
		}
	}

	this.getDeadList = function(living){
		var numStabbings = getRandomInt(0,living.length);
		var timePlayer = findAspectPlayer(this.session.players, "Time");
		var ret = [];
		//doomed time clones absorb some of the hits.
		for(var i = 0; i<timePlayer.doomedTimeClones.length; i++){
				ret.push(timePlayer.doomedTimeClones[i]);
				removeFromArray(timePlayer.doomedTimeClones[i], timePlayer.doomedTimeClones)
		}

		if(living.length == 0){
			return ret;
		}
		for(var i = ret.length; i<=numStabbings; i++){
			ret.push(getRandomElementFromArray(living));
		}
		return Array.from(new Set(ret));
	}



	this.content = function(){
		var nativePlayersInSession = findPlayersFromSessionWithId(this.playerList);
		var badPrototyping = findBadPrototyping(nativePlayersInSession);

		var ret = " It is time for the final opponent, the Black King. ";
		if(badPrototyping){
			ret += " He is made especially terrifying with the addition of the " + badPrototyping + ". ";
		}

		
		return ret;

	}
}
