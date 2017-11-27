/*
http://mspaintadventures.wikia.com/wiki/Alchemiter

Appropriately for AND combining, an && alchemy result will often demonstrate the functionality of both components
 – e.g. Dave's iShades can be a phone and a rad pair of shades – while an || alchemy result will typically have the
  functionality of only one of the components, but the form of the other – e.g. the Hammerhead Pogo Ride, which is
   just a pogo that happens to be hammer-shaped.
 */

abstract class ItemTrait {
  static int FIRST = 0;
  static int OPINION = 1;
  static int SIZE = 2;
  static int SHAPE = 3;
  static int CONDITION = 4;
  static int AGE = 5;
  static int COLOR = 6;
  static int PATTERN = 7;
  static int ORIGIN = 8;
  static int MATERIAL = 9;
  static int PURPOSE = 10;

  //what kind of adj am i, what order should i be displayed?
  int ordering;
  List<String> descriptions = new List<String>();
  double rank = 1.0;
  ItemTrait(List<String> this.descriptions, this.rank, this.ordering) {
    ItemTraitFactory.allTraits.add(this);
  }

  @override
  String toString() {
    if(this.descriptions.isNotEmpty) return this.descriptions.first;
    return "NULL TRAIT";
  }

}

//what can this do?
class ItemFunctionTrait extends ItemTrait {
  ItemFunctionTrait(List<String> descriptions, double rank, int ordering) : super(descriptions, rank, ordering);

  //TODO eventually has something to do with combat? piercing v slashing etc.

}

//what kind of object are you? Not in name.
class ItemObjectTrait extends ItemAppearanceTrait {
  ItemObjectTrait(List<String> descriptions, double rank, int ordering) : super(descriptions, rank, ordering);
}

//What does it look like?
//TODO eventually tie to images?
class ItemAppearanceTrait extends ItemTrait {
  ItemAppearanceTrait(List<String> descriptions, double rank, int ordering) : super(descriptions, rank, ordering);
}

class CombinedTrait extends ItemTrait implements Comparable<CombinedTrait> {

  String name = "JR NAME ME PLZ!!!";
  //the more traits i can get rid of , the better.
  int get priority {
    return subTraits.length;
  }

  //will this work?
  @override
  double get rank {
    double ret = 0.0;
    for(ItemTrait it in subTraits) {
      ret += it.rank;
    }

    return ret;
  }

  //naturally sorted by priority
  @override
  int compareTo(CombinedTrait other) {
    return (other.priority - priority).round(); //TODO or is it the otherway around???
  }

  List<ItemTrait> subTraits;
  CombinedTrait(this.name,List<String> descriptions, double rank, int ordering, this.subTraits) : super(descriptions, rank,ordering);

  bool traitsMatchMe(Set<ItemTrait> traits) {
    //following https://github.com/dart-lang/sdk/issues/2217
    //return traits.every(subTraits.contains); <-- wrong.
    return subTraits.every(traits.contains); //<-- right

  }

  static Set<ItemTrait> lookForCombinedTraits(Set<ItemTrait> traits) {
    Set<ItemTrait> copiedTraits = new Set<ItemTrait>.from(traits);
    Set<ItemTrait> ret = new Set<ItemTrait>();
    List<CombinedTrait> foundCombinedTraits = new List<CombinedTrait>();
    for(CombinedTrait ct in ItemTraitFactory.combinedTraits) {
      if(ct.traitsMatchMe(copiedTraits)) foundCombinedTraits.add(ct);
    }

    foundCombinedTraits.sort(); //now they are sorted by priority.
    for(CombinedTrait ct in foundCombinedTraits) {
      if(ct.traitsMatchMe(copiedTraits)) {
        ret.add(ct);
        for(ItemTrait t in ct.subTraits) {
          copiedTraits.remove(t);
        }
      }
    }
    //anything i couldn't turn into a combo gets passed through.
    if(copiedTraits.isNotEmpty) ret.addAll(copiedTraits);
    return ret;
  }
}

class ItemTraitFactory {
  static Set<ItemTrait> allTraits = new Set<ItemTrait>();

  static Iterable<ItemTrait> get functionalTraits => allTraits.where((ItemTrait a) => (a is ItemFunctionTrait));
  static Iterable<ItemTrait> get appearanceTraits => allTraits.where((ItemTrait a) => (a is ItemAppearanceTrait && !(a is ItemObjectTrait)));
  static Iterable<ItemTrait> get objectTraits => allTraits.where((ItemTrait a) => (a is ItemObjectTrait));
  static Iterable<ItemTrait> get combinedTraits => allTraits.where((ItemTrait a) => (a is CombinedTrait));


  //these are what shape it has? doubles as both specibus kinds and basic objects.
  static ItemObjectTrait GENERIC;
  static ItemObjectTrait SWORD;
  static ItemObjectTrait HAMMER;
  static ItemObjectTrait RIFLE;
  static ItemObjectTrait PISTOL;
  static ItemObjectTrait BLADE;
  static ItemObjectTrait DAGGER;
  static ItemObjectTrait PIGEON;
  static ItemObjectTrait SANTA;
  static ItemObjectTrait FIST;
  static ItemObjectTrait SICKLE;
  static ItemObjectTrait CHAINSAW;
  static ItemObjectTrait FORK;
  static ItemObjectTrait DICE;
  static ItemObjectTrait NEEDLE;
  static ItemObjectTrait STAFF;
  static ItemObjectTrait WHIP;
  static ItemObjectTrait BOW;
  static ItemObjectTrait CLUB;
  static ItemObjectTrait BROOM;
  static ItemObjectTrait BOOK;
  static ItemObjectTrait ROADSIGN;
  static ItemObjectTrait AXE;
  static ItemObjectTrait LANCE;
  static ItemObjectTrait SHIELD;
  static ItemObjectTrait CANE;
  static ItemObjectTrait YOYO;
  static ItemObjectTrait SLING;
  static ItemObjectTrait SHURIKEN;
  static ItemObjectTrait MACHINEGUN;
  static ItemObjectTrait GRENADE;
  static ItemObjectTrait BALL;
  static ItemObjectTrait TRIDENT;
  static ItemObjectTrait CARD;
  static ItemObjectTrait FRYINGPAN;
  static ItemObjectTrait PILLOW;
  static ItemObjectTrait SHOTGUN;
  static ItemObjectTrait STICK;
  static ItemObjectTrait CHAIN;
  static ItemObjectTrait WRENCH;
  static ItemObjectTrait SHOVEL;
  static ItemObjectTrait ROLLINGPIN;
  static ItemObjectTrait PUPPET;
  static ItemObjectTrait RAZOR;
  static ItemObjectTrait PEN;
  static ItemObjectTrait BUST;
  static ItemObjectTrait BOWLING;
  static ItemObjectTrait GOLFCLUB;
  static ItemObjectTrait KNIFE;
  static ItemObjectTrait SCISSOR;
  static ItemObjectTrait SAFE;




  //these would be "color" i guess? material it's made of?
  static ItemAppearanceTrait METAL;
  static ItemAppearanceTrait CLAWS;
  static ItemAppearanceTrait CERAMIC;
  static ItemAppearanceTrait BONE;
  static ItemAppearanceTrait SHITTY;
  static ItemAppearanceTrait WOOD;
  static ItemAppearanceTrait PLASTIC;
  static ItemAppearanceTrait RUBBER;
  static ItemAppearanceTrait PAPER;
  static ItemAppearanceTrait CLOTH;
  static ItemAppearanceTrait STONE;
  static ItemAppearanceTrait GLASS;
  static ItemAppearanceTrait GHOSTLY;
  static ItemAppearanceTrait FLESH;
  static ItemAppearanceTrait CORRUPT;
  static ItemAppearanceTrait FUR;
  static ItemAppearanceTrait PLANT;
  static ItemAppearanceTrait FEATHER;
  static ItemAppearanceTrait UGLY;
  static ItemAppearanceTrait LEGENDARY;

  static ItemFunctionTrait EDGED;
  static ItemFunctionTrait SCARY;
  static ItemFunctionTrait POINTY;
  static ItemFunctionTrait BLUNT;
  static ItemFunctionTrait HEAVY;
  static ItemFunctionTrait SHOOTY;
  static ItemFunctionTrait ONFIRE;
  static ItemFunctionTrait LUCKY;
  static ItemFunctionTrait GLOWING;
  static ItemFunctionTrait OBSCURING;
  static ItemFunctionTrait CALMING;
  static ItemFunctionTrait NUCLEAR;
  static ItemFunctionTrait DOOMED;
  static ItemFunctionTrait EXPLODEY;
  static ItemFunctionTrait COLD;
  static ItemFunctionTrait ZAP;
  static ItemFunctionTrait POISON;
  static ItemFunctionTrait MUSICAL;
  static ItemFunctionTrait VALUABLE;
  static ItemFunctionTrait ENRAGING;
  static ItemFunctionTrait HEALING;
  static ItemFunctionTrait RESTRAINING;
  static ItemFunctionTrait PRETTY;
  static ItemFunctionTrait COMFORTABLE;
  static ItemFunctionTrait UNCOMFORTABLE;
  static ItemFunctionTrait SMART;
  static ItemFunctionTrait SENTIENT;
  static ItemFunctionTrait ROMANTIC;
  static ItemFunctionTrait FUNNY;
  static ItemFunctionTrait EDIBLE;
  static ItemFunctionTrait COOLK1D;
  static ItemFunctionTrait MAGICAL;
  static ItemFunctionTrait ASPECTAL;
  static ItemFunctionTrait CLASSRELATED;
  static ItemFunctionTrait CLASSY;
  static ItemFunctionTrait FAKE;
  static ItemFunctionTrait REAL;
  static ItemFunctionTrait LOUD;

  static CombinedTrait FORGED;
  static CombinedTrait SPOOPY;
  static CombinedTrait WOLVERINE;
  static CombinedTrait DULLEDGED;
  static CombinedTrait DULLPOINTED;
  static CombinedTrait SOFTHARD;
  static CombinedTrait FOSSILIZED;
  static CombinedTrait ADAMANTIUM;
  static CombinedTrait TATAMI;
  static CombinedTrait MESH;
  static CombinedTrait FOIL;
  static CombinedTrait BEANBAG;
  static CombinedTrait PLEATHER;
  static CombinedTrait PLYWOOD;
  static CombinedTrait COLOSSUS;
  static CombinedTrait ROTTING;
  static CombinedTrait  DRAUGR;
  static CombinedTrait LIGHTVOID;
  static CombinedTrait DOOMLUCK;
  static CombinedTrait CANDY;
  static CombinedTrait COTTONCANDY;
  static CombinedTrait GUM;
  static CombinedTrait EDIBLEPOISON;
  static CombinedTrait MARROW;
  static CombinedTrait TOOTHY;
  static CombinedTrait FROST;
  static CombinedTrait CRYSTAL;
  static CombinedTrait MARYSUE;
  static CombinedTrait EDGELORD;
  static CombinedTrait DEADPOOL;
  static CombinedTrait RABBITSFOOT;
  static CombinedTrait ARROWHEAD;
  static CombinedTrait ARROW;
  static CombinedTrait KENDO;
  static CombinedTrait IRONICFAKECOOL;
  static CombinedTrait NET;
  static CombinedTrait MORNINGSTAR;
  static CombinedTrait BARBWIRE;
  static CombinedTrait DECADENT;
  static CombinedTrait SBAHJ;
  static CombinedTrait BAYONET;
  static CombinedTrait SNOOPSNOW;
  static CombinedTrait LIGHTSABER;
  static CombinedTrait FAKEYFAKE;
  static CombinedTrait REALTHING;
  static CombinedTrait SKELETAL;
  static CombinedTrait GREENSUN;
  static CombinedTrait MIDNIGHT;
  static CombinedTrait RADIENT;
  static CombinedTrait EDGEY;
  static CombinedTrait ABOMB;
  static CombinedTrait ULTRAVIOLENCE;
  static CombinedTrait LIVING;
  static CombinedTrait DEAD;
  static CombinedTrait TASER;
  static CombinedTrait NOCTURNE;
  static CombinedTrait DIRGE;
  static CombinedTrait SNOBBBISH;
  static CombinedTrait FLAT;
  static CombinedTrait SHARPCLOTHES;
  static CombinedTrait SHARPNOTE;
  static CombinedTrait BACHS;
  static CombinedTrait MOZARTS;
  static CombinedTrait EINSTEINS;
  static CombinedTrait FEYNMANS;
  static CombinedTrait ZIPTIE;
  static CombinedTrait SMARTPHONE;
  static CombinedTrait SASSACRE;
  static CombinedTrait SLEDGE;
  static CombinedTrait LEGAL;
  static CombinedTrait CLOWN;
  static CombinedTrait PASSIONATE;
  static CombinedTrait PINATA;
  static CombinedTrait ANVIL;
  static CombinedTrait FLASHBANG;
  static CombinedTrait SMOKEBOMB;
  static CombinedTrait NINJA;
  static CombinedTrait TECHNO;
  static CombinedTrait ROCKNROLL;
  static CombinedTrait PISTOLSHRIMP;
  static CombinedTrait JUGGALO;
  static CombinedTrait SHOCKSAUCE;
  static CombinedTrait WEAKSAUCE;
  static CombinedTrait SPICY;
  static CombinedTrait ICECREAM;
  static CombinedTrait POPSICKLE;
  static CombinedTrait ICEPICK;
  static CombinedTrait SCHEZWAN;
  static CombinedTrait VAPORWAVE;
  static CombinedTrait MALLET;
  static CombinedTrait FIDGET;
  static CombinedTrait GOLDFOIL;
  static CombinedTrait CAVIAR;
  static CombinedTrait RADNUCLEAR;
  static CombinedTrait GLAM;
  static CombinedTrait HAIRMETAL;
  static CombinedTrait ELVEN;
  static CombinedTrait SHINY;
  static CombinedTrait BESPOKE;
  static CombinedTrait OPERATIC;
  static CombinedTrait ICE;
  static CombinedTrait ICYHOT;
  static CombinedTrait ICECOLD;
  static CombinedTrait WINTER;
  static CombinedTrait CHRISTMAS;
  static CombinedTrait SANTASAWS;
  static CombinedTrait SANTASAWS2;
  static CombinedTrait SANTACLAWS;
  static CombinedTrait SANDYCLAWS;
  static CombinedTrait SILENTNIGHT;
  static CombinedTrait HALLOWEEN;
  static CombinedTrait MUTANT;
  static CombinedTrait SKATEBOARD;
  static CombinedTrait MICROWAVE;
  static CombinedTrait ORBITAL;
  static CombinedTrait DUMBSMART;
  static CombinedTrait URANIUM;
  static CombinedTrait MOUSEPAD;
  static CombinedTrait FLINT1;
  static CombinedTrait FLINT2;
  static CombinedTrait PICNIC;
  static CombinedTrait XTREME;
  static CombinedTrait LAWN;
  static CombinedTrait UPHOLSTERED;
  static CombinedTrait LEATHER;
  static CombinedTrait SHAG;
  static CombinedTrait LOYAL;
  static CombinedTrait PORCELAIN;
  static CombinedTrait KATANA;
  static CombinedTrait PORKHOLLOW;
  static CombinedTrait CHOCOLATES;
  static CombinedTrait FOILCHOCOLATES;
  static CombinedTrait SCRATCHNSNIFF;
  static CombinedTrait MYTHRIL;
  static CombinedTrait TITANIUM;
  static CombinedTrait LEAD;
  static CombinedTrait ONION;
  static CombinedTrait COMEDYGOLD;
  static CombinedTrait DRY;
  static CombinedTrait POLITE;
  static CombinedTrait STRADIVARIUS;
  static CombinedTrait SCIENTISTIC;
  static CombinedTrait AI;
  static CombinedTrait ROBOTIC2;
  static CombinedTrait SHRAPNEL;
  static CombinedTrait VOCALOID;
  static CombinedTrait HYUNAE;
  static CombinedTrait BUCKSHOT;
  static CombinedTrait CANON;
  static CombinedTrait STATIONARY;
  static CombinedTrait PAPERBOOK;
  static CombinedTrait METALGUN;
  static CombinedTrait PAPERCUT;
  static CombinedTrait SQUEAKY;
  static CombinedTrait KAZOO;
  static CombinedTrait BANDAID;
  static CombinedTrait GUSHERS;
  static CombinedTrait MEDIC;
  static CombinedTrait SICKNASTY;
  static CombinedTrait GILDED;
  static CombinedTrait CHARGING;
  static CombinedTrait SAFETY1;
  static CombinedTrait SAFETY2;
  static CombinedTrait THUNDER;
  static CombinedTrait SCREECHING;
  static CombinedTrait MIRROR;
  static CombinedTrait CRYSTALBALL;
  static CombinedTrait DISABLING;
  static CombinedTrait FASHIONABLE;
  static CombinedTrait IRONICFUNNYCOOL;
  static CombinedTrait IRONICSHITTYFUNNY;
  static CombinedTrait POSTIRONIC;
  static CombinedTrait MONSTOROUS;
  static CombinedTrait ROOTY;
  static CombinedTrait GOLDEN;
  static CombinedTrait PLATINUM;
  static CombinedTrait HORSESHOE;
  static CombinedTrait FELT;
  static CombinedTrait GRANITE;
  static CombinedTrait MARBLE;
  static CombinedTrait GLITCHED;
  static CombinedTrait DEBUGGING;


  static void init() {
    initAppearances();
    initFunctions();
    initObjects();
    initCombined();//IMPORTANT has to be last cuz references others.
  }

  static void initCombined() {
    FORGED = new CombinedTrait("Forged",<String>["forged", "sharpened", "honed", "filed"], 0.0,ItemTrait.CONDITION, <ItemTrait>[METAL, EDGED, POINTY]);
    DULLEDGED = new CombinedTrait("",<String>[], 0.0, ItemTrait.MATERIAL,<ItemTrait>[BLUNT, EDGED]);
    FOSSILIZED = new CombinedTrait("Fossilized",<String>["fossilized"], 0.0, ItemTrait.CONDITION,<ItemTrait>[BONE, STONE]);
    ADAMANTIUM = new CombinedTrait("Adamantium",<String>["adamantium"], 0.0,ItemTrait.CONDITION, <ItemTrait>[BONE, METAL]);
    SOFTHARD = new CombinedTrait("",<String>[], 0.0, ItemTrait.MATERIAL,<ItemTrait>[COMFORTABLE, UNCOMFORTABLE]);
    TATAMI = new CombinedTrait("Tatami",<String>["tatami"], 0.0, ItemTrait.MATERIAL,<ItemTrait>[CLOTH, WOOD]);
    MESH = new CombinedTrait("Mesh",<String>["mesh", "chain link"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[CLOTH, METAL]);
    FOIL = new CombinedTrait("Foil",<String>["foil"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[PAPER, METAL]);
    BEANBAG = new CombinedTrait("Beanbag",<String>["beanbag"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[CLOTH, STONE]);
    PLEATHER = new CombinedTrait("Faux Fur",<String>["pleather", "faux fur"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[FUR, PLASTIC]);
    PLYWOOD = new CombinedTrait("Plywood",<String>["plywood"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[WOOD, PAPER]);
    COLOSSUS = new CombinedTrait("Colossus",<String>["colossus"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[METAL, FLESH]);
    ROTTING = new CombinedTrait("Rotting",<String>["rotting", "zombie"], 0.0,ItemTrait.CONDITION, <ItemTrait>[UGLY, FLESH]);
    DRAUGR = new CombinedTrait("Draugr",<String>["draugr", "white walker"], 0.0,ItemTrait.CONDITION, <ItemTrait>[UGLY, FLESH, COLD]);

    LIGHTVOID = new CombinedTrait("Ultraviolet",<String>["Ultraviolet"], 0.0,ItemTrait.COLOR, <ItemTrait>[GLOWING, OBSCURING]);
    ULTRAVIOLENCE = new CombinedTrait("Ultraviolence",<String>["Ultraviolence"], 0.0, ItemTrait.PURPOSE,<ItemTrait>[GLOWING, OBSCURING, EDGED]);
    DOOMLUCK = new CombinedTrait("",<String>[], 0.0, ItemTrait.PURPOSE,<ItemTrait>[DOOMED, LUCKY]);
    CANDY = new CombinedTrait("Candy",<String>["candy"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[EDIBLE, GLASS]);
    COTTONCANDY = new CombinedTrait("Cotton Candy",<String>["cotton candy"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[EDIBLE, CLOTH]);
    GUM = new CombinedTrait("Gum",<String>["gummy"], 0.0, ItemTrait.MATERIAL,<ItemTrait>[EDIBLE, RUBBER]);
    MARROW = new CombinedTrait("Marrow",<String>["marrow"], 0.0, ItemTrait.MATERIAL,<ItemTrait>[EDIBLE, BONE]);
    TOOTHY = new CombinedTrait("Toothy",<String>["toothy"], 0.0,ItemTrait.SHAPE, <ItemTrait>[BONE, CERAMIC]);
    FROST = new CombinedTrait("Frost",<String>["Frost"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[STONE, GLASS, FLESH]); //refrance
    EDIBLEPOISON = new CombinedTrait("Arsenic",<String>["arsenic", "antifreeze"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[EDIBLE, POISON]);
    CRYSTAL = new CombinedTrait("Crystal",<String>["crystal", "diamond", "quartz"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[STONE, GLASS]);
    MARYSUE = new CombinedTrait("Mary Sue",<String>["mary sue", "sakura katana chan", "shitty oc"], 0.0, ItemTrait.OPINION, <ItemTrait>[PRETTY, ROMANTIC, FUNNY, SMART, CLASSY, LUCKY, MAGICAL]);
    EDGELORD = new CombinedTrait("Edge Lord",<String>["edge lord", "coldsteel the hedgehog"], 0.0,ItemTrait.OPINION, <ItemTrait>[SCARY, OBSCURING, EDGED, LEGENDARY, DOOMED, SMART, CLASSY, COOLK1D]);
    DEADPOOL = new CombinedTrait("Deadpool",<String>["deadpool"], 0.0,ItemTrait.SHAPE, <ItemTrait>[UGLY, HEALING, COOLK1D, FUNNY]);
    SPOOPY = new CombinedTrait("Spoopy",<String>["spoopy", "skellington's", "creppy"], 0.0,ItemTrait.OPINION, <ItemTrait>[SCARY, COOLK1D]);
    WOLVERINE = new CombinedTrait("Wolverine",<String>["wolverine"], 0.0,ItemTrait.SHAPE, <ItemTrait>[BONE, EDGED, POINTY]);
    RABBITSFOOT = new CombinedTrait("Rabbit's Foot",<String>["rabbit's foot"], 0.0,ItemTrait.SHAPE, <ItemTrait>[LUCKY, FUR]);
    ARROWHEAD = new CombinedTrait("Tipped",<String>["tipped", "reinforced", "arrowhead"], 0.0,ItemTrait.CONDITION, <ItemTrait>[POINTY, WOOD]);
    ARROW = new CombinedTrait("Arrow",<String>["arrow", "flechette", "bolt"], 0.0, ItemTrait.SHAPE,<ItemTrait>[POINTY, SHOOTY,WOOD]);
    KENDO = new CombinedTrait("Bokken",<String>["training sword", "bokken"], 0.0,ItemTrait.SHAPE, <ItemTrait>[WOOD, EDGED]);
    IRONICFAKECOOL = new CombinedTrait("Irony Type1",<String>["ironic"], 0.0,ItemTrait.OPINION, <ItemTrait>[FAKE, COOLK1D]);
    NET = new CombinedTrait("Netted",<String>["netted", "webbed"], 0.0,ItemTrait.SHAPE, <ItemTrait>[RESTRAINING, CLOTH]);
    BARBWIRE = new CombinedTrait("Barbed Wire",<String>["barbed wire"], 0.0, ItemTrait.SHAPE,<ItemTrait>[POINTY, RESTRAINING, METAL, CLOTH]);
    MORNINGSTAR = new CombinedTrait("Morning Star",<String>["morning star"], 0.0,ItemTrait.SHAPE, <ItemTrait>[POINTY, BLUNT]);
    DECADENT = new CombinedTrait("Decadent",<String>["decadent"], 0.0, ItemTrait.OPINION,<ItemTrait>[COMFORTABLE, VALUABLE]);
    SBAHJ = new CombinedTrait("SBAHJ",<String>["SBAHJ"], 0.0, ItemTrait.PURPOSE,<ItemTrait>[SHITTY, COOLK1D]);
    BAYONET = new CombinedTrait("Bayonet",<String>["bayonet"], 0.0,ItemTrait.SHAPE, <ItemTrait>[POINTY, SHOOTY]);
    SNOOPSNOW = new CombinedTrait("Snoop",<String>["Snoop Dog's Snow Cone Machete"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[COLD, COOLK1D, EDGED]);
    LIGHTSABER = new CombinedTrait("Light Saber",<String>["light saber"], 0.0, ItemTrait.PURPOSE,<ItemTrait>[GLOWING, ONFIRE, EDGED]);
    FAKEYFAKE = new CombinedTrait("Fakey Fake",<String>["fake as shit", "fakey fake", "bullshit"], 0.0, ItemTrait.OPINION,<ItemTrait>[MAGICAL, FAKE]);
    REALTHING = new CombinedTrait("Real As Shit",<String>["real as shit", "suprisingly real"], 0.0,ItemTrait.OPINION, <ItemTrait>[MAGICAL, REAL]);
    SKELETAL = new CombinedTrait("Skeletal",<String>["skeletal"], 0.0, ItemTrait.SHAPE,<ItemTrait>[SCARY, DOOMED, BONE]);
    GREENSUN = new CombinedTrait("Green Sun",<String>["green sun"], 0.0, ItemTrait.PATTERN,<ItemTrait>[ONFIRE, NUCLEAR, GLOWING]);
    MIDNIGHT = new CombinedTrait("Midnight",<String>["midnight", "3 In The Morning"], 0.0,ItemTrait.COLOR, <ItemTrait>[OBSCURING, CLASSY]);
    RADIENT = new CombinedTrait("Radiant",<String>["radiant", "dazzling"], 0.0,ItemTrait.OPINION, <ItemTrait>[MAGICAL, GLOWING]);
    EDGEY = new CombinedTrait("Edgy",<String>["edgy"], 0.0,ItemTrait.OPINION, <ItemTrait>[EDGED, OBSCURING,COOLK1D]);
    ABOMB = new CombinedTrait("Warhead",<String>["A-Bomb", "Warhead", "Chernobyl"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[NUCLEAR, EXPLODEY]);
    LIVING = new CombinedTrait("Living",<String>["living"], 0.0,ItemTrait.CONDITION, <ItemTrait>[BONE, FLESH, SENTIENT]);
    DEAD = new CombinedTrait("Dead",<String>["dead","corpse","deceased"], 0.0,ItemTrait.CONDITION, <ItemTrait>[BONE, FLESH]);
    TASER = new CombinedTrait("Taser",<String>["taser"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[ZAP, RESTRAINING]);
    NOCTURNE = new CombinedTrait("Nocturn",<String>["nocturn"], 0.0, ItemTrait.PURPOSE,<ItemTrait>[OBSCURING, MUSICAL]);
    DIRGE = new CombinedTrait("Dirge",<String>["dirge"], 0.0, ItemTrait.PURPOSE,<ItemTrait>[DOOMED, MUSICAL]);
    SNOBBBISH = new CombinedTrait("Snobbish",<String>["snobbish"], 0.0,ItemTrait.OPINION, <ItemTrait>[CLASSY, VALUABLE]);
    FLAT = new CombinedTrait("Flat(Music)",<String>["flat"], 0.0,ItemTrait.OPINION, <ItemTrait>[BLUNT, MUSICAL]);
    SHARPNOTE = new CombinedTrait("Sharp(Music)",<String>["sharp"], 0.0, ItemTrait.OPINION,<ItemTrait>[EDGED, MUSICAL]);
    SHARPCLOTHES = new CombinedTrait("Sharp(Clothes)",<String>["sharp"], 0.0,ItemTrait.OPINION, <ItemTrait>[CLASSY, MUSICAL]);
    BACHS = new CombinedTrait("Bach's",<String>["Bach's"], 0.0, ItemTrait.ORIGIN,<ItemTrait>[SMART, MUSICAL]);
    MOZARTS = new CombinedTrait("Mozart's",<String>["Mozart's"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[MAGICAL, MUSICAL]);
    EINSTEINS = new CombinedTrait("Einstein's",<String>["Einstein's","Oppenheimer"], 0.0, ItemTrait.ORIGIN,<ItemTrait>[SMART, NUCLEAR]);
    FEYNMANS = new CombinedTrait("Feynman's",<String>["Feynman's"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[SMART, FUNNY]);
    ZIPTIE = new CombinedTrait("Ziptie",<String>["Ziptie"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[PLASTIC, RESTRAINING]);
    SMARTPHONE = new CombinedTrait("Mobile",<String>["cellular","mobile","handheld","computerized"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[METAL, SMART]);
    SASSACRE = new CombinedTrait("Sassacre",<String>["Sassacre"], 0.0, ItemTrait.ORIGIN,<ItemTrait>[HEAVY, FUNNY]);
    SLEDGE = new CombinedTrait("Sledge",<String>["Sledge"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[BLUNT, HEAVY]);
    LEGAL = new CombinedTrait("Legal",<String>["Legal"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[RESTRAINING, PAPER]);
    CLOWN = new CombinedTrait("Clown",<String>["Clown"], 0.0, ItemTrait.PURPOSE,<ItemTrait>[FUNNY, LOUD]);
    PASSIONATE = new CombinedTrait("Passionate",<String>["passionate"], 0.0,ItemTrait.OPINION, <ItemTrait>[ONFIRE, ROMANTIC]);
    PINATA = new CombinedTrait("Pinata",<String>["pinata"], 0.0, ItemTrait.SHAPE,<ItemTrait>[PAPER, EDIBLE]);
    ANVIL = new CombinedTrait("Anvil",<String>["anvil"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[BLUNT, HEAVY, METAL]);
    FLASHBANG = new CombinedTrait("Flashbang",<String>["flashbang"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[GLOWING, EXPLODEY]);
    SMOKEBOMB = new CombinedTrait("Smokebomb",<String>["smokebomb"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[OBSCURING, EXPLODEY]);
    NINJA = new CombinedTrait("Ninja",<String>["ninja"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[OBSCURING, EDGED]);
    TECHNO = new CombinedTrait("Techno",<String>["techno"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[ZAP, MUSICAL]);
    ROCKNROLL = new CombinedTrait("Rock And/Or Roll",<String>["rock and roll"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[STONE, MUSICAL]);
    PISTOLSHRIMP = new CombinedTrait("Pistol Shrimp",<String>["pistol shrimp", "horrifying"], 0.0,ItemTrait.SHAPE, <ItemTrait>[SENTIENT, FLESH, SHOOTY]);
    JUGGALO = new CombinedTrait("Juggalo",<String>["juggalo"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[FUNNY, MUSICAL, LOUD, SCARY]);
    SHOCKSAUCE = new CombinedTrait("Shock Sauce",<String>["shocksauce"], 0.0,ItemTrait.OPINION, <ItemTrait>[COOLK1D, ZAP]);
    WEAKSAUCE = new CombinedTrait("Weak Sauce",<String>["weaksauce"], 0.0,ItemTrait.OPINION, <ItemTrait>[BLUNT,COOLK1D, SHITTY]);
    SPICY = new CombinedTrait("Spicy",<String>["spicy", "picante"], 0.0,ItemTrait.OPINION, <ItemTrait>[ONFIRE, EDIBLE]);
    ICECREAM = new CombinedTrait("Popsicle",<String>["ice cream", "popsicle"], 0.0, ItemTrait.MATERIAL,<ItemTrait>[COLD, EDIBLE]);
    POPSICKLE = new CombinedTrait("Popsickle",<String>["popsickle"], 0.0, ItemTrait.MATERIAL,<ItemTrait>[COLD, EDIBLE,EDGED]);
    ICEPICK = new CombinedTrait("Icepick",<String>["icepick"], 0.0, ItemTrait.MATERIAL,<ItemTrait>[COLD, POINTY]);

    SCHEZWAN = new CombinedTrait("Schezwan",<String>["schezwan"], 0.0,ItemTrait.OPINION, <ItemTrait>[COOLK1D, EDIBLE]);
    VAPORWAVE = new CombinedTrait("Vaporwave",<String>["vaporwave"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[OBSCURING, MUSICAL, COOLK1D, ZAP]);
    MALLET = new CombinedTrait("Mallet",<String>["mallet"], 0.0,ItemTrait.SHAPE, <ItemTrait>[WOOD, BLUNT]);
    FIDGET = new CombinedTrait("Fidget",<String>["fidget"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[PLASTIC, COOLK1D]);
    GOLDFOIL = new CombinedTrait("Gold Foil",<String>["gold foil"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[METAL, PAPER, VALUABLE]);
    CAVIAR = new CombinedTrait("Caviar",<String>["caviar"], 0.0, ItemTrait.MATERIAL,<ItemTrait>[EDIBLE, VALUABLE]);
    RADNUCLEAR = new CombinedTrait("RADioactive",<String>["RADioactive"], 0.0,ItemTrait.OPINION, <ItemTrait>[NUCLEAR, COOLK1D]);
    GLAM = new CombinedTrait("Glam",<String>["glam"], 0.0,ItemTrait.OPINION, <ItemTrait>[STONE, MUSICAL, PRETTY]);
    HAIRMETAL = new CombinedTrait("Hair Metal",<String>["hair metal"], 0.0,ItemTrait.OPINION, <ItemTrait>[METAL, MUSICAL, PRETTY]);
    ELVEN = new CombinedTrait("Elven",<String>["elven", "fae", "sylvan"], 0.0,ItemTrait.OPINION, <ItemTrait>[MAGICAL, PRETTY]);
    SHINY = new CombinedTrait("Shiny",<String>["shiny"], 0.0,ItemTrait.OPINION, <ItemTrait>[METAL, PRETTY]);
    BESPOKE = new CombinedTrait("Bespoke",<String>["bespoke", "well-tailored", "glamorous","haute couture"], 0.0,ItemTrait.OPINION, <ItemTrait>[VALUABLE, PRETTY, CLASSY]);
    OPERATIC = new CombinedTrait("Operatic",<String>["operatic"], 0.0,ItemTrait.OPINION, <ItemTrait>[VALUABLE, MUSICAL, CLASSY]);
    ICE = new CombinedTrait("Diamond",<String>["ice", "diamond"], 0.0, ItemTrait.MATERIAL,<ItemTrait>[VALUABLE, COLD]);
    ICYHOT = new CombinedTrait("Icy Hot",<String>["icy hot","cold fire"], 0.0,ItemTrait.OPINION, <ItemTrait>[ONFIRE, COLD]);

    ICECOLD = new CombinedTrait("Cold As Fuck",<String>["ice cold", "cold as fuck"], 0.0,ItemTrait.OPINION, <ItemTrait>[COOLK1D, COLD]);
    WINTER = new CombinedTrait("Winter's",<String>["winter's", "season's"], 0.0, ItemTrait.ORIGIN,<ItemTrait>[CALMING, COLD]);
    CHRISTMAS = new CombinedTrait("Christmas",<String>["santa's", "christmas", "xmas"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[MAGICAL, COLD]);
    SANTASAWS = new CombinedTrait("Santa Saws",<String>["Santa Saws"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[MAGICAL, COLD,EDGED]);
    SANTASAWS2 = new CombinedTrait("Santa Sleighs",<String>["Santa Sleighs"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[SANTA, EDGED]);
    SANTACLAWS = new CombinedTrait("Santa Claws",<String>["Santa Claws"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[SANTA, CLAWS]);
    SANDYCLAWS = new CombinedTrait("Sandy Claws",<String>["Sandy Claws"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[SANTA, CLAWS,STONE]);
    SILENTNIGHT = new CombinedTrait("Silent Night",<String>["Silent Night"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[SANTA, OBSCURING]);
    HALLOWEEN = new CombinedTrait("Ghost's",<String>["ghost's", "Bloody Mary", "Halloween"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[SCARY, GHOSTLY]);
    MUTANT = new CombinedTrait("Mutant",<String>["ghoul", "mutant"], 0.0, ItemTrait.MATERIAL,<ItemTrait>[FLESH, NUCLEAR, UGLY]);
    SKATEBOARD = new CombinedTrait("Skateboard",<String>["skate", "skateboard"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[COOLK1D, METAL]);
    MICROWAVE = new CombinedTrait("Microwave",<String>["microwave"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[NUCLEAR, ZAP, EDIBLE]);
    ORBITAL = new CombinedTrait("Orbital",<String>["orbital"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[NUCLEAR, ZAP, EDIBLE,SHOOTY]);
    DUMBSMART = new CombinedTrait("",<String>[], 0.0,ItemTrait.PURPOSE, <ItemTrait>[BLUNT, SMART]);
    URANIUM = new CombinedTrait("Uranium",<String>["uranium"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[NUCLEAR, STONE]);
    MOUSEPAD = new CombinedTrait("Mousepad",<String>["mousepad", "jar opener"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[PAPER, RUBBER]);
    FLINT1 = new CombinedTrait("Sharpened Flint",<String>["flint"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[EDGED, STONE]);
    FLINT2 = new CombinedTrait("Pointed Flint",<String>["flint"], 0.0, ItemTrait.MATERIAL,<ItemTrait>[POINTY, STONE]);
    PICNIC = new CombinedTrait("Picnic",<String>["picnic"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[PLASTIC, POINTY]);
    XTREME = new CombinedTrait("Xtreme Xplosion",<String>["xtreme xplosion"], 0.0, ItemTrait.OPINION,<ItemTrait>[COOLK1D, EXPLODEY]);
    LAWN = new CombinedTrait("Lawn",<String>["lawn"], 0.0, ItemTrait.PURPOSE,<ItemTrait>[PLASTIC, COMFORTABLE]);
    UPHOLSTERED = new CombinedTrait("Upholstered",<String>["upholstered"], 0.0, ItemTrait.MATERIAL,<ItemTrait>[CLOTH, COMFORTABLE]);
    LEATHER = new CombinedTrait("Leather",<String>["leather"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[FLESH, COMFORTABLE]);
    SHAG = new CombinedTrait("Shag",<String>["shag"], 0.0, ItemTrait.MATERIAL,<ItemTrait>[FUR, COMFORTABLE]);
    LOYAL = new CombinedTrait("Loyal",<String>["loyal"], 0.0, ItemTrait.OPINION,<ItemTrait>[BLUNT, ROMANTIC]);
    PORCELAIN = new CombinedTrait("Porcelain",<String>["porcelain"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[PRETTY, CERAMIC]);
    PORKHOLLOW = new CombinedTrait("Pork Hollow",<String>["pork hollow", "piggy bank"], 0.0, ItemTrait.SHAPE,<ItemTrait>[VALUABLE, CERAMIC]);
    KATANA = new CombinedTrait("Katana",<String>["n1nj4","katana"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[COOLK1D, EDGED]);
    CHOCOLATES = new CombinedTrait("Chocolate",<String>["chocolate"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[ROMANTIC, EDIBLE]);
    FOILCHOCOLATES = new CombinedTrait("Wrapped Chocolate",<String>["wrapped chocolate"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[ROMANTIC, EDIBLE,PAPER,METAL]);
    SCRATCHNSNIFF = new CombinedTrait("Scratch-n-sniff",<String>["scratch-n-sniff"], 0.0, ItemTrait.MATERIAL, <ItemTrait>[COOLK1D, PAPER]);
    MYTHRIL = new CombinedTrait("Mythril",<String>["mythril","orichalcum"],0.0, ItemTrait.MATERIAL, <ItemTrait>[MAGICAL, METAL]);
    TITANIUM = new CombinedTrait("Titanium",<String>["titanium","steel"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[BLUNT, METAL]);
    LEAD = new CombinedTrait("Lead",<String>["lead"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[HEAVY, METAL]);
    ONION = new CombinedTrait("Satire",<String>["satire","parody","onion"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[FAKE, FUNNY]);
    COMEDYGOLD = new CombinedTrait("Comedy Gold",<String>["comedy gold"], 0.0, ItemTrait.OPINION, <ItemTrait>[VALUABLE, FUNNY]);
    DRY = new CombinedTrait("Dry",<String>["dry", "sensible chuckle"], 0.0, ItemTrait.OPINION,<ItemTrait>[CLASSY, FUNNY]);
    POLITE = new CombinedTrait("Polite",<String>["polite"], 0.0,ItemTrait.OPINION, <ItemTrait>[COMFORTABLE, FAKE]);
    STRADIVARIUS = new CombinedTrait("Stradivarius",<String>["stradivarius"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[CLASSY, VALUABLE, WOOD, MUSICAL]);
    SCIENTISTIC = new CombinedTrait("Scientistic",<String>["scientistic"], 0.0,ItemTrait.OPINION, <ItemTrait>[SMART,FAKE]); //<3 you fallout
    AI = new CombinedTrait("AI",<String>["AI"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[ZAP, SENTIENT]);
    ROBOTIC2 = new CombinedTrait("Robotic",<String>["robotic"], 0.0, ItemTrait.CONDITION,<ItemTrait>[METAL, ZAP, SENTIENT]);
    SHRAPNEL = new CombinedTrait("Shrapnel",<String>["shrapnel"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[WOOD, EXPLODEY]);
    VOCALOID = new CombinedTrait("Vocaloid",<String>["vocaloid"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[SENTIENT,ZAP, MUSICAL]);
    HYUNAE = new CombinedTrait("*Hyun-ae",<String>["*Hyun-ae"], 0.0, ItemTrait.ORIGIN,<ItemTrait>[SENTIENT,ZAP, ROMANTIC]); //is it a reference?
    BUCKSHOT = new CombinedTrait("Buckshot",<String>["buckshot"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[WOOD, SHOOTY]);
    CANON = new CombinedTrait("Cannon",<String>["cannon"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[HEAVY, SHOOTY]);//bitches love canons
    STATIONARY = new CombinedTrait("Stationary",<String>["stationary"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[CLASSY, PAPER]);
    PAPERBOOK = new CombinedTrait("",<String>[], 0.0,ItemTrait.PURPOSE, <ItemTrait>[BOOK, PAPER]); //we can fucking assume this dunkass
    METALGUN = new CombinedTrait("",<String>[], 0.0, ItemTrait.PURPOSE,<ItemTrait>[METAL, SHOOTY]); //we can fucking assume this dunkass
    PAPERCUT = new CombinedTrait("Papercut",<String>["papercut"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[EDGED, PAPER]);
    SQUEAKY = new CombinedTrait("Squeaky",<String>["squeaky"], 0.0,ItemTrait.CONDITION, <ItemTrait>[BLUNT, RUBBER]);
    KAZOO = new CombinedTrait("Kazoo",<String>["kazoo"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[FAKE, MUSICAL]);
    BANDAID = new CombinedTrait("Bandaid",<String>["bandaid"], 0.0, ItemTrait.PURPOSE,<ItemTrait>[HEALING, PAPER]);
    GUSHERS = new CombinedTrait("Gushers",<String>["gushers"], 0.0, ItemTrait.PURPOSE,<ItemTrait>[HEALING, EDIBLE]);
    MEDIC = new CombinedTrait("Medic",<String>["medic"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[HEALING, SHOOTY]);
    SICKNASTY = new CombinedTrait("Sick Nasty",<String>["sick nasty","ill"], 0.0,ItemTrait.CONDITION, <ItemTrait>[COOLK1D, POISON]);
    GILDED = new CombinedTrait("Gilded",<String>["gilded","gold leaf"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[METAL, WOOD]);
    CHARGING = new CombinedTrait("Charging",<String>["charging","power cord"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[PLASTIC, ZAP]);
    SAFETY1 = new CombinedTrait("Rubber Safety",<String>["safety"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[RUBBER, EDGED]);
    SAFETY2 = new CombinedTrait("Plastic Safety",<String>["safety"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[PLASTIC, EDGED]);
    THUNDER = new CombinedTrait("Thunderous",<String>["thunderous","thor's"], 0.0,ItemTrait.OPINION, <ItemTrait>[LOUD, ZAP]);
    SCREECHING = new CombinedTrait("Screeching",<String>["screeching","dial up"], 0.0,ItemTrait.OPINION, <ItemTrait>[LOUD, ZAP,SMART]);
    MIRROR = new CombinedTrait("Mirrored",<String>["mirrored","reflective"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[GLASS, METAL]);
    CRYSTALBALL = new CombinedTrait("Far Seeing",<String>["far seeing","sighted"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[GLASS, STONE, MAGICAL]);
    DISABLING = new CombinedTrait("Nonlethal",<String>["disabling","non lethal"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[RUBBER, SHOOTY]);
    FASHIONABLE = new CombinedTrait("Fashionable",<String>["fasionable"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[PRETTY, CLASSY]);
    IRONICFUNNYCOOL = new CombinedTrait("Ironic Type 2",<String>["ironic"], 0.0,ItemTrait.OPINION, <ItemTrait>[FUNNY, COOLK1D]);
    IRONICSHITTYFUNNY = new CombinedTrait("Ironic Type 3",<String>["ironic"], 0.0,ItemTrait.OPINION, <ItemTrait>[SHITTY, FUNNY]);
    POSTIRONIC = new CombinedTrait("Post Ironic",<String>["post-ironic"], 0.0,ItemTrait.OPINION, <ItemTrait>[FAKE, COOLK1D,CLASSY]);
    MONSTOROUS = new CombinedTrait("Monstrous",<String>["monstrous"], 0.0,ItemTrait.OPINION, <ItemTrait>[UGLY,LOUD, SCARY]);
    ROOTY = new CombinedTrait("Rooty Tooty Point and Shooty",<String>["rooty tooty point and shooty"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[SHOOTY, COOLK1D,CLASSY]);
    GOLDEN = new CombinedTrait("Golden",<String>["golden"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[METAL,VALUABLE]);
    PLATINUM = new CombinedTrait("Platinum",<String>["platinum"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[GLOWING,METAL]);
    HORSESHOE = new CombinedTrait("Horseshoe",<String>["horseshoe"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[LUCKY,METAL]);
    FELT = new CombinedTrait("Felt",<String>["felt"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[CLOTH,FUR]);
    MARBLE = new CombinedTrait("Marble",<String>["marble"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[STONE,CLASSY]);
    GRANITE = new CombinedTrait("Marble",<String>["marble"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[STONE,HEAVY]);
    GLITCHED = new CombinedTrait("Glitched",<String>["glitched"], 0.0,ItemTrait.CONDITION, <ItemTrait>[CORRUPT,ZAP]);
    DEBUGGING = new CombinedTrait("Debugging",<String>["debugging"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[HEALING,ZAP]);

    METALIC = new CombinedTrait("Metalic",<String>["Iron Maiden","Metalic"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[METAL,LOUD, MUSICAL]);
    SIMULCRUM = new CombinedTrait("Simulacrum",<String>["Simulacrum"], 0.0,ItemTrait.OPINION, <ItemTrait>[SENTIENT,FAKE]);
    A = new CombinedTrait("Imitation",<String>["Imitation"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[EDIBLE,FAKE]);
    DEBUGGING = new CombinedTrait("Placebo",<String>["Placebo"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[HEALING,FAKE]);
    DEBUGGING = new CombinedTrait("Counterfeit",<String>["counterfeit"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[VALUABLE,FAKE]);
    DEBUGGING = new CombinedTrait("Surreal",<String>["Surreal"], 0.0,ItemTrait.OPINION, <ItemTrait>[COOLK1D,UNCOMFORTABLE,FUNNY]);
    DEBUGGING = new CombinedTrait("Brainy",<String>["Brainy"], 0.0,ItemTrait.OPINION, <ItemTrait>[SMART,FLESH]);
    DEBUGGING = new CombinedTrait("Incendiary",<String>["Incendiary"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[ONFIRE,EXPLODEY]);
    DEBUGGING = new CombinedTrait("C-4",<String>["C-4"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[EXPLODEY,PLASTIC]);
    DEBUGGING = new CombinedTrait("Fae",<String>["fae"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[MAGICAL,GLOWING, CORRUPT]);
    DEBUGGING = new CombinedTrait("Plutonium",<String>["Plutonium"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[METAL,NUCLEAR]);
    DEBUGGING = new CombinedTrait("Lithium",<String>["Lithium"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[METAL,ZAP]);
    DEBUGGING = new CombinedTrait("Molten",<String>["Molten"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[METAL,ONFIRE]);
    DEBUGGING = new CombinedTrait("Magma",<String>["Magma","Lava"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[STONE,ONFIRE]);
    DEBUGGING = new CombinedTrait("Rusty",<String>["Rusty"], 0.0,ItemTrait.CONDITION, <ItemTrait>[METAL,SHITTY]);
    DEBUGGING = new CombinedTrait("Fonzie",<String>["Fonzie"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[EDGED,COOLK1D, CLASSY]);
    DEBUGGING = new CombinedTrait("Romcom",<String>["Romcom"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[ROMANTIC,FUNNY]);
    DEBUGGING = new CombinedTrait("Alluring",<String>["Alluring"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[PRETTY,GLOWING]);
    DEBUGGING = new CombinedTrait("Masquerade",<String>["Masquerade"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[PRETTY,OBSCURING]);
    DEBUGGING = new CombinedTrait("Stoneskin",<String>["Stoneskin","Petrified"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[STONE,FLESH]);
    DEBUGGING = new CombinedTrait("Psionic",<String>["Psionic"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[MAGICAL,SMART]);
    DEBUGGING = new CombinedTrait("Dwarven",<String>["Dwarven"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[MAGICAL,STONE]);
    DEBUGGING = new CombinedTrait("Elemental",<String>["Elemental"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[MAGICAL,SENTIENT]);
    DEBUGGING = new CombinedTrait("Gourmet",<String>["Gourmet"], 0.0,ItemTrait.OPINION, <ItemTrait>[EDIBLE,CLASSY]);
    DEBUGGING = new CombinedTrait("Stained Glass",<String>["Stained Glass"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[GLASS,PRETTY, VALUABLE]);
    DEBUGGING = new CombinedTrait("Gauze",<String>["Gauze"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[HEALING,CLOTH]);
    DEBUGGING = new CombinedTrait("Locked",<String>["Locked"], 0.0,ItemTrait.CONDITION, <ItemTrait>[RESTRAINING,ENRAGING]);
    DEBUGGING = new CombinedTrait("Etched",<String>["Etched"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[STONE,PAPER]);
    DEBUGGING = new CombinedTrait("Papyrus",<String>["Papyrus"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[PAPER,PLANT]);
    DEBUGGING = new CombinedTrait("Film",<String>["film"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[PAPER,PLASTIC]);
    DEBUGGING = new CombinedTrait("Saucey",<String>["Saucey"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[CORRUPT,ENRAGING,UGLY]);
    DEBUGGING = new CombinedTrait("Lottery",<String>["Lottery"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[PAPER,LUCKY]);
    DEBUGGING = new CombinedTrait("Blindfolded",<String>["Blindfolded"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[OBSCURING,CLOTH]);
    DEBUGGING = new CombinedTrait("Possessed",<String>["Possessed"], 0.0,ItemTrait.CONDITION, <ItemTrait>[GHOSTLY,FLESH]);
    DEBUGGING = new CombinedTrait("Infernal",<String>["debugging"], 0.0,ItemTrait.OPINION, <ItemTrait>[GHOSTLY,ONFIRE]);
    DEBUGGING = new CombinedTrait("Geppetto",<String>["Geppetto's"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[WOOD,REAL,PUPPET,SENTIENT]);
    DEBUGGING = new CombinedTrait("Abominable",<String>["Abominable"], 0.0,ItemTrait.OPINION, <ItemTrait>[FLESH,CORRUPT]);
    DEBUGGING = new CombinedTrait("Ashen",<String>["Ashen"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[ROMANTIC,DOOMED]);
    DEBUGGING = new CombinedTrait("Pale",<String>["Pale"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[ROMANTIC,CALMING]);
    DEBUGGING = new CombinedTrait("Pitch",<String>["debugging"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[ROMANTIC,ENRAGING]);
    DEBUGGING = new CombinedTrait("Lit",<String>["debugging"], 0.0,ItemTrait.OPINION, <ItemTrait>[COOLK1D,ONFIRE]);
    DEBUGGING = new CombinedTrait("Hypnotizing",<String>["Hypnotizing"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[MAGICAL,CALMING]);
    DEBUGGING = new CombinedTrait("Tranquilizing",<String>["Tranquilizing"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[CALMING,RESTRAINING]);
    DEBUGGING = new CombinedTrait("",<String>[], 0.0,ItemTrait.PURPOSE, <ItemTrait>[CALMING,ENRAGING]);
    DEBUGGING = new CombinedTrait("Ghost Rider",<String>["Ghost Rider's"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[CHAIN,ONFIRE,GHOSTLY]);
    DEBUGGING = new CombinedTrait("Logical",<String>["Logical"], 0.0,ItemTrait.OPINION, <ItemTrait>[SMART,COLD]);
    DEBUGGING = new CombinedTrait("Duelist's",<String>["Duelist's"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[SHOOTY,CLASSY]);
    DEBUGGING = new CombinedTrait("Silenced",<String>["Silenced"], 0.0,ItemTrait.CONDITION, <ItemTrait>[SHOOTY,OBSCURING]);
    DEBUGGING = new CombinedTrait("Deudly",<String>["Deudly"], 0.0,ItemTrait.CONDITION, <ItemTrait>[SHOOTY,SHITTY]);
    DEBUGGING = new CombinedTrait("Screaming",<String>["Screaming"], 0.0,ItemTrait.CONDITION, <ItemTrait>[LOUD,SCARY]);
    DEBUGGING = new CombinedTrait("Cacophonous",<String>["Cacophonous"], 0.0,ItemTrait.OPINION, <ItemTrait>[UGLY,MUSICAL]);
    DEBUGGING = new CombinedTrait("Sublime",<String>["Sublime"], 0.0,ItemTrait.OPINION, <ItemTrait>[UGLY,PRETTY]);
    DEBUGGING = new CombinedTrait("Masterwork",<String>["Masterwork"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[REAL,VALUABLE]);
    DEBUGGING = new CombinedTrait("BroodFester",<String>["BroodFester"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[SENTIENT,SCARY, CORRUPT,MAGICAL]);
    DEBUGGING = new CombinedTrait("[REDACTED]",<String>["[REDACTED]"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[CORRUPT,OBSCURING]);
    DEBUGGING = new CombinedTrait("Pop Rocks",<String>["Pop Rocks"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[EDIBLE,EXPLODEY]);
    DEBUGGING = new CombinedTrait("Disguised",<String>["Disguised"], 0.0,ItemTrait.CONDITION, <ItemTrait>[OBSCURING,FAKE]);
    DEBUGGING = new CombinedTrait("Haunted",<String>["Haunted"], 0.0,ItemTrait.CONDITION, <ItemTrait>[UNCOMFORTABLE,GHOSTLY]);
    DEBUGGING = new CombinedTrait("Cognitohazardous",<String>["Cognitohazardous"], 0.0,ItemTrait.CONDITION, <ItemTrait>[CORRUPT,SMART]);
    DEBUGGING = new CombinedTrait("Staticy",<String>["Staticy"], 0.0,ItemTrait.CONDITION, <ItemTrait>[UNCOMFORTABLE,ZAP]);
    DEBUGGING = new CombinedTrait("Jadite",<String>["Jadite"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[GLASS,NUCLEAR]);
    DEBUGGING = new CombinedTrait("Tickling",<String>["Tickling"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[FUNNY,UNCOMFORTABLE]);
    DEBUGGING = new CombinedTrait("Composite",<String>["Composite"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[METAL,CERAMIC]);
    DEBUGGING = new CombinedTrait("High-Powered",<String>["High-Powered"], 0.0,ItemTrait.CONDITION, <ItemTrait>[EXPLODEY,SHOOTY]);
    DEBUGGING = new CombinedTrait("Concussive",<String>["Concussive"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[EXPLODEY,BLUNT]);
    DEBUGGING = new CombinedTrait("Down",<String>["Down"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[COMFORTABLE,FEATHER]);
    DEBUGGING = new CombinedTrait("Prickly",<String>["Prickly"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[UNCOMFORTABLE,POINTY]);
    DEBUGGING = new CombinedTrait("Deep-Web",<String>["Deep-Web","Dark-Net"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[UNCOMFORTABLE,OBSCURING,ZAP]);
    DEBUGGING = new CombinedTrait("Jagged",<String>["Jagged","Sawtooth"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[POINTY,EDGED]);
    DEBUGGING = new CombinedTrait("Nanofiber",<String>["Nanofiber"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[CLOTH,SMART]);
    DEBUGGING = new CombinedTrait("Clanging",<String>["Clanging"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[METAL,LOUD]);
    DEBUGGING = new CombinedTrait("Silver",<String>["Silver"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[METAL,CLASSY]);
    DEBUGGING = new CombinedTrait("Withered",<String>["Withered"], 0.0,ItemTrait.CONDITION, <ItemTrait>[DOOMED,PLANT]);
    DEBUGGING = new CombinedTrait("Shattered",<String>["Shattered"], 0.0,ItemTrait.CONDITION, <ItemTrait>[GLASS,SHITTY]);
    DEBUGGING = new CombinedTrait("Potassium",<String>["Potassium"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[EDIBLE,METAL]);
    DEBUGGING = new CombinedTrait("Miner's",<String>["Miner's"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[STONE,METAL]);
    DEBUGGING = new CombinedTrait("Singing",<String>["Singing"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[MUSICAL,SENTIENT]);
    DEBUGGING = new CombinedTrait("Mitochondrial",<String>["Mitochondrial"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[FLESH,ZAP]);
    DEBUGGING = new CombinedTrait("Blackout",<String>["Blackout","EMP"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[OBSCURING,ZAP]);
    DEBUGGING = new CombinedTrait("Asbestos",<String>["Asbestos"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[STONE,POISON]);
    DEBUGGING = new CombinedTrait("Mercurial",<String>["Mercurial"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[POISON,METAL]);
    DEBUGGING = new CombinedTrait("Bulletproof",<String>["Bulletproof"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[CLOTH,BLUNT]);
    DEBUGGING = new CombinedTrait("Cotton",<String>["Cotton"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[PLANT,CLOTH]);
    DEBUGGING = new CombinedTrait("Blinding",<String>["Blinding","Flashbang","Solar Flare"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[ENRAGING,GLOWING]);
    DEBUGGING = new CombinedTrait("Brilliant",<String>["Brilliant"], 0.0,ItemTrait.OPINION, <ItemTrait>[GLOWING,SMART]);
    DEBUGGING = new CombinedTrait("Offensive",<String>["Offensive"], 0.0,ItemTrait.OPINION, <ItemTrait>[ENRAGING,SMART]);
    DEBUGGING = new CombinedTrait("Poached",<String>["Poached"], 0.0,ItemTrait.CONDITION, <ItemTrait>[FLESH,VALUABLE]);
    DEBUGGING = new CombinedTrait("Tapestry",<String>["Tapestry"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[CLOTH,PRETTY]);
    DEBUGGING = new CombinedTrait("Itchy",<String>["Itchy"], 0.0,ItemTrait.OPINION, <ItemTrait>[CLOTH,UNCOMFORTABLE]);
    DEBUGGING = new CombinedTrait("Wishbone",<String>["Wishbone"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[LUCKY,BONE]);
    DEBUGGING = new CombinedTrait("Rattling",<String>["Rattling"], 0.0,ItemTrait.CONDITION, <ItemTrait>[LOUD,BONE]);
    DEBUGGING = new CombinedTrait("Cranial",<String>["Cranial"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[SMART,BONE]);
    DEBUGGING = new CombinedTrait("Humerus",<String>["Humerus"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[FUNNY,BONE]);
    DEBUGGING = new CombinedTrait("Massage",<String>["Massage"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[HEALING,COMFORTABLE]);
    DEBUGGING = new CombinedTrait("Pestersome",<String>["Pestersome"], 0.0,ItemTrait.OPINION, <ItemTrait>[LOUD,ENRAGING]);
    DEBUGGING = new CombinedTrait("Shockwave",<String>["Shockwave"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[LOUD,EXPLODEY]);
    DEBUGGING = new CombinedTrait("Antivenom",<String>["Antivenom"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[POISON,HEALING]);
    DEBUGGING = new CombinedTrait("Will O Wisp",<String>["Will O Wisp"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[ONFIRE,MAGICAL]);
    DEBUGGING = new CombinedTrait("Fiberglass",<String>["Fiberglass"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[CLOTH,GLASS]);
    DEBUGGING = new CombinedTrait("Skull",<String>["Skull"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[BONE,SCARY]);
    DEBUGGING = new CombinedTrait("Enchanted",<String>["Enchanted"], 0.0,ItemTrait.CONDITION, <ItemTrait>[MAGICAL,LUCKY]);
    DEBUGGING = new CombinedTrait("Berserker's",<String>["Berserker's"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[MAGICAL,ENRAGING]);
    DEBUGGING = new CombinedTrait("Clerical",<String>["Clerical"], 0.0,ItemTrait.ORIGIN, <ItemTrait>[MAGICAL,HEALING]);
    DEBUGGING = new CombinedTrait("Cauterizing",<String>["Cauterizing"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[HEALING,ONFIRE]);
    DEBUGGING = new CombinedTrait("X-Ray",<String>["X-Ray"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[NUCLEAR,GLOWING]);
    DEBUGGING = new CombinedTrait("Clever",<String>["Clever"], 0.0,ItemTrait.OPINION, <ItemTrait>[SMART,LUCKY]);
    DEBUGGING = new CombinedTrait("Fireplace",<String>["Fireplace"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[COMFORTABLE,ONFIRE]);
    DEBUGGING = new CombinedTrait("Crackling",<String>["Crackling"], 0.0,ItemTrait.CONDITION, <ItemTrait>[LOUD,ONFIRE]);
    DEBUGGING = new CombinedTrait("Thumping",<String>["Thumping"], 0.0,ItemTrait.CONDITION, <ItemTrait>[LOUD,HEAVY]);
    DEBUGGING = new CombinedTrait("Shrieking",<String>["Shrieking","Banshee"], 0.0,ItemTrait.CONDITION, <ItemTrait>[GHOSTLY,LOUD]);
    DEBUGGING = new CombinedTrait("Surreal",<String>["Surreal"], 0.0,ItemTrait.OPINION, <ItemTrait>[FUNNY,CORRUPT]);
    DEBUGGING = new CombinedTrait("Aloe",<String>["Aloe","Willowbark"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[HEALING,PLANT]);
    DEBUGGING = new CombinedTrait("Rose",<String>["Rose"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[ROMANTIC,PLANT]);
    DEBUGGING = new CombinedTrait("Knock Knock",<String>["Knock Knock"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[FUNNY,BLUNT]);
    DEBUGGING = new CombinedTrait("Lifesteal",<String>["Lifesteal"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[MAGICAL,POISON]);
    DEBUGGING = new CombinedTrait("Tragic",<String>["Tragic"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[PRETTY,DOOMED]);
    DEBUGGING = new CombinedTrait("Slapstick",<String>["Slapstick"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[EDGED,FUNNY]);
    DEBUGGING = new CombinedTrait("Gross Out",<String>["Gross Out"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[UGLY,FUNNY]);
    DEBUGGING = new CombinedTrait("Flowery",<String>["Flowery"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[PRETTY,PLANT]);
    DEBUGGING = new CombinedTrait("Poison Ivy",<String>["Poison Ivy"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[POISON,PLANT]);
    DEBUGGING = new CombinedTrait("Winged",<String>["Winged","Pegasus","Angelic"], 0.0,ItemTrait.CONDITION, <ItemTrait>[MAGICAL,FEATHER]);
    DEBUGGING = new CombinedTrait("Forbidden Fruit",<String>["Forbidden Fruit"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[PLANT,EDIBLE, DOOMED]);
    DEBUGGING = new CombinedTrait("Lawful",<String>["Lawful"], 0.0,ItemTrait.OPINION, <ItemTrait>[RESTRAINING,SENTIENT]);
    DEBUGGING = new CombinedTrait("Chaotic",<String>["Chaotic"], 0.0,ItemTrait.OPINION, <ItemTrait>[ENRAGING,SENTIENT]);
    DEBUGGING = new CombinedTrait("Hypothermic",<String>["Hypothermic"], 0.0,ItemTrait.CONDITION, <ItemTrait>[DOOMED,COLD]);
    DEBUGGING = new CombinedTrait("Hyperthermic",<String>["Hyperthermic"], 0.0,ItemTrait.CONDITION, <ItemTrait>[DOOMED,ONFIRE]);
    DEBUGGING = new CombinedTrait("Shackled",<String>["Shackled"], 0.0,ItemTrait.CONDITION, <ItemTrait>[RESTRAINING,HEAVY]);
    DEBUGGING = new CombinedTrait("Poetic",<String>["Poetic"], 0.0,ItemTrait.OPINION, <ItemTrait>[SMART,ROMANTIC]);
    DEBUGGING = new CombinedTrait("Holographic",<String>["Holographic"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[GLOWING,SMART,GLASS,ZAP]);
    DEBUGGING = new CombinedTrait("Casket",<String>["Casket","Coffin"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[WOOD,DOOMED]);
    DEBUGGING = new CombinedTrait("Spectral",<String>["Spectral"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[GHOSTLY,MAGICAL]);
    DEBUGGING = new CombinedTrait("Phoenix",<String>["Phoenix"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[ONFIRE,FEATHER]);
    DEBUGGING = new CombinedTrait("Tattered",<String>["Tattered"], 0.0,ItemTrait.CONDITION, <ItemTrait>[CLOTH,DOOMED]);
    DEBUGGING = new CombinedTrait("Woodwind",<String>["Woodwind","Reed"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[MUSICAL,WOOD]);
    DEBUGGING = new CombinedTrait("Bone Hurting",<String>["Bone Hurting"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[UNCOMFORTABLE,BONE]);
    DEBUGGING = new CombinedTrait("Bone Healing:",<String>["Bone Healing:"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[HEALING,BONE]);
    DEBUGGING = new CombinedTrait("Calcium",<String>["Calcium"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[BONE,HEALING,EDIBLE]);
    DEBUGGING = new CombinedTrait("Fleece",<String>["Fleece"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[CLOTH,ONFIRE]);
    DEBUGGING = new CombinedTrait("Potted",<String>["Potted"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[CERAMIC,PLANT]);
    DEBUGGING = new CombinedTrait("Diseased",<String>["Diseased"], 0.0,ItemTrait.CONDITION, <ItemTrait>[DOOMED,FLESH]);
    DEBUGGING = new CombinedTrait("Porcupine",<String>["Porcupine"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[POINTY,FUR]);
    DEBUGGING = new CombinedTrait("Fanged",<String>["Fanged"], 0.0,ItemTrait.CONDITION, <ItemTrait>[BONE,POINTY]);
    DEBUGGING = new CombinedTrait("Sulphuric",<String>["Sulphuric"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[STONE,ONFIRE]);
    DEBUGGING = new CombinedTrait("Basalt",<String>["Basalt"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[STONE,OBSCURING]);
    DEBUGGING = new CombinedTrait("Obsidian",<String>["Obsidian"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[GLASS,OBSCURING]);
    DEBUGGING = new CombinedTrait("Fenestrated",<String>["Fenestrated"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[GLASS,WOOD]);
    DEBUGGING = new CombinedTrait("Plexiglass",<String>["Plexiglass"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[GLASS,PLASTIC]);
    DEBUGGING = new CombinedTrait("Ceramic Wrap",<String>["Ceramic Wrap"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[CERAMIC,PAPER]);
    DEBUGGING = new CombinedTrait("Fungal",<String>["Fungal"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[PLANT,UGLY]);
    DEBUGGING = new CombinedTrait("Thorny",<String>["Thorny"], 0.0,ItemTrait.CONDITION, <ItemTrait>[PLANT,POINTY]);
    DEBUGGING = new CombinedTrait("Bulbed",<String>["Bulbed"], 0.0,ItemTrait.CONDITION, <ItemTrait>[PLANT,BLUNT]);
    DEBUGGING = new CombinedTrait("Glass Canon",<String>["Glass Canon"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[GLASS,SHOOTY]);
    DEBUGGING = new CombinedTrait("Caoutchouc",<String>["Caoutchouc"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[PLANT,RUBBER]);
    DEBUGGING = new CombinedTrait("Cellulose",<String>["Cellulose"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[PLANT,PLASTIC]);
    DEBUGGING = new CombinedTrait("Horrorcore",<String>["Horrorcore"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[MUSICAL,SCARY]);
    DEBUGGING = new CombinedTrait("Nightcore",<String>["Nightcore"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[CORRUPT,MUSICAL]);
    DEBUGGING = new CombinedTrait("Crazy Bus",<String>["Crazy Bus"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[CORRUPT,ZAP,MUSICAL]);
    DEBUGGING = new CombinedTrait("Burdock",<String>["Burdock"], 0.0,ItemTrait.MATERIAL, <ItemTrait>[PLANT,FUR]);
    DEBUGGING = new CombinedTrait("Debugging",<String>["debugging"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[HEALING,ZAP]);
    DEBUGGING = new CombinedTrait("Debugging",<String>["debugging"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[HEALING,ZAP]);
    DEBUGGING = new CombinedTrait("Debugging",<String>["debugging"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[HEALING,ZAP]);
    DEBUGGING = new CombinedTrait("Debugging",<String>["debugging"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[HEALING,ZAP]);
    DEBUGGING = new CombinedTrait("Debugging",<String>["debugging"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[HEALING,ZAP]);
    DEBUGGING = new CombinedTrait("Debugging",<String>["debugging"], 0.0,ItemTrait.PURPOSE, <ItemTrait>[HEALING,ZAP]);


  }

  static void initObjects() {
    //it's sharp, it's pointy and it's a sword
    GENERIC = new ItemObjectTrait(<String>["perfectly generic"], 0.1,ItemTrait.OPINION);
    SWORD = new ItemObjectTrait(<String>["a sword"], 0.4,ItemTrait.SHAPE);
    HAMMER = new ItemObjectTrait(<String>["a hammer"], 0.4,ItemTrait.SHAPE);
    RIFLE = new ItemObjectTrait(<String>["a rifle"], 0.4,ItemTrait.SHAPE);
    PISTOL = new ItemObjectTrait(<String>["a pistol"], 0.4,ItemTrait.SHAPE);
    BLADE = new ItemObjectTrait(<String>["a blade"], 0.4,ItemTrait.SHAPE);
    DAGGER = new ItemObjectTrait(<String>["a dagger"], 0.4,ItemTrait.SHAPE);
    SANTA = new ItemObjectTrait(<String>["a santa"], 0.4,ItemTrait.SHAPE);
    FIST = new ItemObjectTrait(<String>["a fist"], 0.4,ItemTrait.SHAPE);
    CLAWS = new ItemObjectTrait(<String>["claws"], 0.4,ItemTrait.SHAPE);
    GRENADE = new ItemObjectTrait(<String>["a grenade"], 0.4,ItemTrait.SHAPE);
    SAFE = new ItemObjectTrait(<String>["a freaking safe"], 0.4,ItemTrait.SHAPE);
    BALL = new ItemObjectTrait(<String>["a ball"], 0.4,ItemTrait.SHAPE);
    TRIDENT = new ItemObjectTrait(<String>["a trident"], 0.4,ItemTrait.SHAPE);
    CARD = new ItemObjectTrait(<String>["a card"], 0.4,ItemTrait.SHAPE);
    FRYINGPAN = new ItemObjectTrait(<String>["a frying pan"], 0.4,ItemTrait.SHAPE);
    PILLOW = new ItemObjectTrait(<String>["a pillow"], 0.4,ItemTrait.SHAPE);
    MACHINEGUN = new ItemObjectTrait(<String>["a machinegun"], 0.4,ItemTrait.SHAPE);
    SHURIKEN = new ItemObjectTrait(<String>["a shuriken"], 0.4,ItemTrait.SHAPE);
    SLING = new ItemObjectTrait(<String>["a sling"], 0.4,ItemTrait.SHAPE);
    YOYO = new ItemObjectTrait(<String>["a yoyo"], 0.4,ItemTrait.SHAPE);
    CANE = new ItemObjectTrait(<String>["a cane"], 0.4,ItemTrait.SHAPE);
    SHIELD = new ItemObjectTrait(<String>["a shield"], 0.4,ItemTrait.SHAPE);
    LANCE = new ItemObjectTrait(<String>["a lance"], 0.4,ItemTrait.SHAPE);
    AXE = new ItemObjectTrait(<String>["a ax"], 0.4,ItemTrait.SHAPE);
    ROADSIGN = new ItemObjectTrait(<String>["a sign"], 0.4,ItemTrait.SHAPE);
    BOOK = new ItemObjectTrait(<String>["a book"], 0.4,ItemTrait.SHAPE);
    BROOM = new ItemObjectTrait(<String>["a broom"], 0.4,ItemTrait.SHAPE);
    CLUB = new ItemObjectTrait(<String>["a club"], 0.4,ItemTrait.SHAPE);
    BOW = new ItemObjectTrait(<String>["a bow"], 0.4,ItemTrait.SHAPE);
    WHIP = new ItemObjectTrait(<String>["a whip"], 0.4,ItemTrait.SHAPE);
    STAFF = new ItemObjectTrait(<String>["a staff"], 0.4,ItemTrait.SHAPE);
    NEEDLE = new ItemObjectTrait(<String>["a needle"], 0.4,ItemTrait.SHAPE);
    DICE = new ItemObjectTrait(<String>["dice"], 0.4,ItemTrait.SHAPE);
    FORK = new ItemObjectTrait(<String>["a fork"], 0.4,ItemTrait.SHAPE);
    PIGEON = new ItemObjectTrait(<String>["a pigeon???"], 1.3,ItemTrait.SHAPE);
    CHAINSAW = new ItemObjectTrait(<String>["a chainsaw"], 0.4,ItemTrait.SHAPE);
    SICKLE = new ItemObjectTrait(<String>["a sickle"], 0.4,ItemTrait.SHAPE);
    SHOTGUN = new ItemObjectTrait(<String>["a shotgun"], 0.4,ItemTrait.SHAPE);
    STICK = new ItemObjectTrait(<String>["a stick"], 0.4,ItemTrait.SHAPE);
    CHAIN = new ItemObjectTrait(<String>["a chain"], 0.4,ItemTrait.SHAPE);
    WRENCH = new ItemObjectTrait(<String>["a wrench"], 0.4,ItemTrait.SHAPE);
    SHOVEL = new ItemObjectTrait(<String>["a shovel"], 0.4,ItemTrait.SHAPE);
    ROLLINGPIN = new ItemObjectTrait(<String>["a rolling pin"], 0.4,ItemTrait.SHAPE);
    PUPPET = new ItemObjectTrait(<String>["a puppet"], 0.4,ItemTrait.SHAPE);
    RAZOR = new ItemObjectTrait(<String>["a razor"], 0.4,ItemTrait.SHAPE);
    PEN = new ItemObjectTrait(<String>["a pen"], 0.4,ItemTrait.SHAPE);
    BUST = new ItemObjectTrait(<String>["a bust"], 0.4,ItemTrait.SHAPE);
    BOWLING = new ItemObjectTrait(<String>["a bowling ball"], 0.4,ItemTrait.SHAPE);
    GOLFCLUB = new ItemObjectTrait(<String>["a golf club"], 0.4,ItemTrait.SHAPE);
    KNIFE = new ItemObjectTrait(<String>["a knife"], 0.4,ItemTrait.SHAPE);
    SCISSOR = new ItemObjectTrait(<String>["scissors"], 0.4,ItemTrait.SHAPE);
  }

  static void initAppearances() {
    METAL = new ItemAppearanceTrait(<String>["metal"], 0.3,ItemTrait.MATERIAL);
    CERAMIC = new ItemAppearanceTrait(<String>["ceramic"], -0.3,ItemTrait.MATERIAL);
    BONE = new ItemAppearanceTrait(<String>["bone"], 0.2,ItemTrait.MATERIAL);
    WOOD = new ItemAppearanceTrait(<String>["wood"], -0.3,ItemTrait.MATERIAL);
    PLASTIC = new ItemAppearanceTrait(<String>["plastic"], -0.3,ItemTrait.MATERIAL);
    RUBBER = new ItemAppearanceTrait(<String>["rubber"], -0.3,ItemTrait.MATERIAL);
    PAPER = new ItemAppearanceTrait(<String>["paper"], -0.3,ItemTrait.MATERIAL);
    CLOTH = new ItemAppearanceTrait(<String>["cloth", "fabric"], -0.3,ItemTrait.MATERIAL);
    GLASS = new ItemAppearanceTrait(<String>["glass"], -0.3,ItemTrait.MATERIAL);
    GHOSTLY = new ItemAppearanceTrait(<String>["ghostly","ectoplasm"], -0.3,ItemTrait.MATERIAL);
    FLESH = new ItemAppearanceTrait(<String>["flesh", "meat","muscle"], -0.1,ItemTrait.MATERIAL);
    CORRUPT = new ItemAppearanceTrait(<String>["horrorterror", "tentacled","grimdark"], 3.1,ItemTrait.CONDITION);

    FUR = new ItemAppearanceTrait(<String>["fur", "fluff","fuzzy"], -0.1,ItemTrait.MATERIAL);
    PLANT = new ItemAppearanceTrait(<String>["plant", "leaf","vine"], -0.1,ItemTrait.MATERIAL);

    FEATHER = new ItemAppearanceTrait(<String>["feathery"], -0.1,ItemTrait.MATERIAL);

    UGLY = new ItemAppearanceTrait(<String>["gross", "ugly","unpleasant"], 0.1,ItemTrait.OPINION);
    SHITTY = new ItemAppearanceTrait(<String>["shitty", "poorly made","conksuck", "piece-of-shit"], -13.0,ItemTrait.OPINION);
    STONE = new ItemAppearanceTrait(<String>["stone", "rock", "concrete"], 0.3,ItemTrait.MATERIAL);
    LEGENDARY = new ItemAppearanceTrait(<String>["legendary"], 13.0,ItemTrait.FIRST);
  }

  static void initFunctions() {
    EDGED = new ItemFunctionTrait(["edged", "sharp", "honed", "keen", "bladed"], 0.3,ItemTrait.OPINION);
    GLOWING = new ItemFunctionTrait(["glowing", "bright", "illuminated"], 0.1,ItemTrait.PATTERN);
    OBSCURING = new ItemFunctionTrait(["obscuring", "dark", "shadowy"], 0.1,ItemTrait.PATTERN);
    CALMING = new ItemFunctionTrait(["calming", "pale", "placating","shooshing"], 0.1,ItemTrait.OPINION);
    NUCLEAR = new ItemFunctionTrait(["nuclear", "radioactive", "irradiated"], 1.0,ItemTrait.CONDITION);
    SCARY = new ItemFunctionTrait(["scary", "horrifying", "terrifying","spooky"], 0.2,ItemTrait.OPINION);
    LUCKY = new ItemFunctionTrait(["lucky", "fortunate", "gambler's", "favored", "charmed"], 0.3,ItemTrait.OPINION);
    DOOMED = new ItemFunctionTrait(["doomed", "cursed", "unlucky"], -0.3,ItemTrait.OPINION);
    POINTY = new ItemFunctionTrait(["pointy", "piercing", "sharp", "barbed", "piked", "sharpened","pronged", "pointed"], 0.3,ItemTrait.CONDITION);
    EXPLODEY = new ItemFunctionTrait(["exploding", "explosive", "detonating", "grenade"], 0.6,ItemTrait.PURPOSE);
    ZAP = new ItemFunctionTrait(["electrical", "zap", "lightning", "shock"], 0.6,ItemTrait.PURPOSE);
    RESTRAINING = new ItemFunctionTrait(["restraining", "imprisoning", "restricting"], 0.3,ItemTrait.PURPOSE);
    VALUABLE = new ItemFunctionTrait(["expensive", "valuable", "bling", "money"], 0.1,ItemTrait.OPINION);
    EDIBLE = new ItemFunctionTrait(["edible", "tasty", "delicious", "savory"], 0.1,ItemTrait.OPINION);
    CLASSY = new ItemFunctionTrait(["classy", "distinguished", "tasteful", "cultured"], 0.1,ItemTrait.OPINION);
    COOLK1D = new ItemFunctionTrait(["cool", "wicked","radical", "awesome", "groovy", "tubular","bitching","bodacious"], 0.1,ItemTrait.OPINION);
    SMART = new ItemFunctionTrait(["intelligent", "smart", "useful", "scientific","encyclopedic"], 0.1,ItemTrait.OPINION);
    SENTIENT = new ItemFunctionTrait(["sentient", "aware", "conscious", "awake","talking"], 0.1,ItemTrait.CONDITION);
    ROMANTIC = new ItemFunctionTrait(["romantic","amorous","tender","affectionate","lovey-dovey"], 0.1,ItemTrait.OPINION);
    FUNNY = new ItemFunctionTrait(["funny", "hilarious", "comedy"], 0.1,ItemTrait.OPINION);
    ENRAGING = new ItemFunctionTrait(["annoying", "enraging", "dickish", "asshole"], 0.1,ItemTrait.OPINION);
    MAGICAL = new ItemFunctionTrait(["magical", "mystical", "magickal", "wizardy"], 0.6,ItemTrait.OPINION);
    ASPECTAL = new ItemFunctionTrait(["aspecty", "imbued", "focused", "energized","awakened","infused"], 1.3,ItemTrait.FIRST);
    CLASSRELATED = new ItemFunctionTrait(["class-related", "appropriate", "themed"], 1.3,ItemTrait.FIRST);

    PRETTY = new ItemFunctionTrait(["pretty", "aesthetic", "beautiful"], 0.1,ItemTrait.OPINION);
    HEALING = new ItemFunctionTrait(["healing", "regenerating", "recovery", "life"], 0.3,ItemTrait.PURPOSE);
    UNCOMFORTABLE = new ItemFunctionTrait(["uncomfortable", "hard","unpleasant"], 0.1,ItemTrait.OPINION);

    COMFORTABLE = new ItemFunctionTrait(["comfortable", "comforting", "soft", "cozy", "snug", "pleasant"], -0.1,ItemTrait.OPINION);
    POISON = new ItemFunctionTrait(["poisonous", "venomous", "draining", "poison"], 0.6,ItemTrait.OPINION);
    COLD = new ItemFunctionTrait(["chilly", "chill", "cold", "freezing", "icy", "frozen", "ice"], 0.6,ItemTrait.OPINION);
    HEAVY = new ItemFunctionTrait(["heavy", "weighs a ton", "heavy","heavy enough to kill a cat"], 0.4,ItemTrait.OPINION);
    ONFIRE = new ItemFunctionTrait(["fire", "burning", "blazing", "hot", "heated", "on fire", "combusting", "flaming", "fiery"], 0.6,ItemTrait.OPINION);
    BLUNT = new ItemFunctionTrait(["blunt", "bludgeoning", "dull"], 0.3,ItemTrait.OPINION);
    SHOOTY = new ItemFunctionTrait(["shooty", "ranged", "projectile", "loaded", "long range"], 0.3,ItemTrait.PURPOSE);
    MUSICAL = new ItemFunctionTrait(["musical", "melodic", "harmonious", "tuneful", "euphonious", "mellifluous,"], 0.1,ItemTrait.OPINION);
    LOUD = new ItemFunctionTrait(["loud", "ear splitting", "noisy", "deafening", "thundering"], 0.3,ItemTrait.OPINION);
    FAKE = new ItemFunctionTrait(["fake", "false", "imitation", "simulated", "replica"], -0.3,ItemTrait.OPINION);
    REAL = new ItemFunctionTrait(["real", "actual", "believable", "geniune", "guaranteed","veritable"], 0.3,ItemTrait.OPINION);

  }
}
