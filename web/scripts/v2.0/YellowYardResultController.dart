import "dart:html";

import "../SBURBSim.dart";

 /*
	While the session contains a list of every ImportantEvent that happens inside of it,
	THIS object contains a list of every ImportantEvent the Observer has decided to change.

	it can also compare two important events to see if they are the same.

	TODO: ~~~~~~~~~~~~~~~~~ HAVE AB COMMENT ON SESSIONS THAT HAVE THIS AVAILABLE. " Shit. That went south fast. I better tell JR."

	When I described this to a friend they said "aren't you worried this will turn into a bucket of spiders?".
	(.i.e become intractably complicated and impossible to debug)
	My response: "This has always been a bucket of spidres, I just decided to dump the whole thing on my head and do a little dance with it."

	This is such a stupid idea. So many things can go wrong.  But it's so irresistable. I NEED to make ridiculous ground hog day time shenanigans possible. It is my destiny.

	hrmm...if time playered triggered, maybe can add evil actions, like Damara was doing.
	dirupt ectobiology. kill players, etc. could trigger some godtiers
*/
List<ImportantEvent> yyrEventsGlobalVar = [];

class YellowYardResultController {
 List<ImportantEvent> eventsToUndo = [];


	YellowYardResultController() {}


	ImportantEvent doesEventNeedToBeUndone(ImportantEvent e){
    //  //print("Does: " + e.humanLabel() + " need to be undone?")
        for(num i = 0; i<this.eventsToUndo.length; i++){
            ImportantEvent e2 = this.eventsToUndo[i];
		 // //print("checking if needs to be undone");
          if(doEventsMatch(e,e2,true)){
          //  //print("retunning event that will provide alternate scene, " + e2.humanLabel())
              return e2;
          }
        }
        return null;
    }


}


/*
	This is not perfecct.  A player can, for example, die multiple times with the same mvp power level.
	But i figure if multiple mind-influenced time players warp into save them multiple times (even from one decision), well...time shenanigans.
	it is not unreasonable to imagien 2 timelines that are extremely similar where the Observer made the same choice.
*/
bool doEventsMatch(ImportantEvent newEvent, ImportantEvent storedEvent, [bool spawn = false]){
	////print("comparing: '" + newEvent.humanLabel() + "' to '" + storedEvent.humanLabel() + "'")
	if(newEvent == null || storedEvent == null) return false; //can't match if one of them doesn't exist.;
  if(newEvent.session.session_id != storedEvent.session.session_id){
    //  //print("session id did not match.");
      return false;
  }
  //are they the same kind of event
  if(newEvent.runtimeType != storedEvent.runtimeType){
  //  //print("constructor did not match.");
    return false;
  }
  if(newEvent.mvp_value != storedEvent.mvp_value ){ //mind field means mvp doesn't matter.
      return false;
    //  //print("mvp did not match");
  }
  if(newEvent.player != null && storedEvent.player != null){
	  //should work even if player is supposed to be null
	  if(newEvent.player.class_name != storedEvent.player.class_name){
		 ////print("player class did not match");
		  return false;
	  }

	    if(newEvent.player.aspect != storedEvent.player.aspect){
    //  //print("player aspect did not match");
		return false;
		}
    //print("yes, there is a match.");
    if(spawn){ //don't spawn a time cloen if i'm checking for afterlife stuff.
      spawnDoomedTimeClone(newEvent, storedEvent);
    }
    return true;
  }
  if(spawn){ //don't spawn a time cloen if i'm checking for afterlife stuff.
    spawnDoomedTimeClone(newEvent, storedEvent);
  }
  return true;
}



void spawnDoomedTimeClone(ImportantEvent newEvent, ImportantEvent storedEvent){
    //print("spawning a doomed time clone");
    //since i know the events match, make sure my player is up to date with the current session.
    //had a stupidly tragic bug where I was bringing players back in the DEAD SESSION instead of this new version of it.
    storedEvent.player = newEvent.player;
    storedEvent.session = newEvent.session; //cant get space players otherwise
    //trigger the new sessions timePlayer.  time shenanigans wear on sanaity.
    var alphaTimePlayer = findAspectPlayer(newEvent.session.players, Aspects.TIME);
    if(newEvent.session is DeadSession) alphaTimePlayer = newEvent.session.players[0];
    alphaTimePlayer.addStat(Stats.SANITY, -10); //how many re-dos does this give me before they snap?
    alphaTimePlayer.doomedTimeClones.add(storedEvent.doomedTimeClone);
    alphaTimePlayer.flipOut("their own doomed time clones that seem to be mind controlled or something");
    if(storedEvent.secondTimeClone != null){
        //print("think there is a second time clone");
        alphaTimePlayer.doomedTimeClones.add(storedEvent.secondTimeClone);
    }
}

void redemptionArc() {
        //make the current session a REGULAR session with the same session number (unless 4037).
    SimController.instance.clearElement(SimController.instance.storyElement);
    Element explanation = new DivElement();
    explanation.text = "Once upon a time there lived a not-quite-yet-player with a chat handle of ${curSessionGlobalVar.players[0].chatHandle}. It's hard to see what happened to them. (This is SBURBSim after all, and our story is not yet set in SBURB).  Did they kill their 'friends'? Abandon them? Were they bullied and rejected by them? (Did they escape on the back of a magic dog?). It doesn't matter why. What DOES matter. Is that they were alone. And were on the verge of playing SBURB alone, which as we now know, is a bad fucking idea. We can imagine that there is a flash of light. A time player.  A Choice changed.  They have friends now. Perhaps bridges were repaired and they are with their old ones. Perhaps they have found new. Who can say? All we can know for sure is... It's not a single player game, anymore. ";
    SimController.instance.storyElement.append(explanation);
    //convert session
    int id = curSessionGlobalVar.session_id;
    if(id == 4037) id = 13; //redemption and new friends.
    Session s = new Session(id);
    s.reinit();
    s.makePlayers();
    s.randomizeEntryOrder();
    s.makeGuardians();
    Scene.createScenesForSession(s);
    curSessionGlobalVar = s;
    //maybe ther ARE no corpses...but they are sure as shit bringing the dead dream selves.
    List<Player> living = findLivingPlayers(curSessionGlobalVar.aliensClonedOnArrival);
    window.scrollTo(0, 0);
    load(curSessionGlobalVar.players, <Player>[], ""); //in loading.js
    //restart session
    ///???
    ///profit
}


void decision(){
    String a;
    try {
         a = (querySelector("input[name='decision']:checked") as InputElement).value;
    }catch(e) {
        if(curSessionGlobalVar is DeadSession) redemptionArc();
        return;
    }
  int index = int.parse(a, onError:(String s) => 0);
  if(index < yyrEventsGlobalVar.length){
    var eventDecided = yyrEventsGlobalVar[int.parse(a, onError:(String s) => 0)];
    //alert(eventDecided.humanLabel());
    curSessionGlobalVar.addEventToUndoAndReset(eventDecided);
  }else{
    //undoing undoing an event.
    index = index - yyrEventsGlobalVar.length;
    var eventToUndo2x = curSessionGlobalVar.yellowYardController.eventsToUndo[index];
    var timePlayer = findAspectPlayer(curSessionGlobalVar.players, Aspects.TIME);
    if(curSessionGlobalVar is DeadSession) timePlayer = curSessionGlobalVar.players[0];

    var doom = Player.makeRenderingSnapshot(timePlayer);
		doom.dead = false;
		doom.doomed = true;
		doom.setStat(Stats.CURRENT_HEALTH, doom.getStat(Stats.HEALTH));
    doom.influenceSymbol = "mind_forehead.png";
    eventToUndo2x.secondTimeClone = doom;
    curSessionGlobalVar.addEventToUndoAndReset(null);
  }

}
