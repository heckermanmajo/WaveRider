# Refactoring

-> Ordentliche Ordnerstruktur
  -> ALle controller in einen ordner ohne sub folder
-> Ordentliches Main Menu mit gutem Hintergrund
-> Auskommentierten BS löschen 
-> Kommentare schreiben
-> Namen groß schreiben in den Dateien

- Game Views : Into src
- Dataclasses in GameViews
- lib debug
- lib 
- lib / ui 


# Balancing

-> Die Roten so stark wie die grünen
-> die gründen Leben x 4 
-> Dann schwarz durch hellgün austauschen 
-> und schwarz, schneller als den Player machen

# Feature to Add List

- Create a base to defend
- Wandering enemies attack the player if he is near by
- Wandering enemies attack the Troopers
- A stationary mg
- Add the spawning ammo to the wave, so if no wave spawns ammo, health and money also did not spawn
- Shoot from the middle of the player and the middle of the trooper
- Add better weapons and more ammo types
    - start pistol, low damage, lor firerate
    - mp, low damage high firerate
    - rifle: high damage, low fire rate, high accuracy
    - assault rifle, medium damage, high firerate
    - MG, high damage, hig firerate, low accuracy
    - shotgun, geringe frequenz
    - shotgun 2 Medium frequenz
    - trommel-shotgun hohe frequenz
    - Granaten und Rakjeten trennen
    - Granaten fliegen nur begrenzte reichweite
    - Flammenwerfer: Feuer brennt und bigt zombies damage wenn sie durchrennen

- zombies antizipieren in welche richtung der player grade läuft und schneiden ihm den weg ab
- reichweite einfügen und bei schüssen mehr typen
- sowie Ursprungswaffe für damage
- Real reloading und magazingröße
- better weapon sounds
- Gigantenzombies und Zombies die spucken
- lebensbalken der Zombies mit gründen punkten anzeigen, die für 1 leben stehen
- Dann waffen und Leben auf diese neue Schadensskala anpassen

- Wenn man Zombies killt dann zerplatzen die

## UI für ausgewählte Waffen
- Schöne Grafiken für die Waffen

## Kampangnenmodus
- Man hat ein lager und verteidigt das gegen Zombiehorden
- Jede mission ist ein neues lager, obwohl alte lager auch einfach angegriffen werden können
- Angriffe auf bereits befestigte lager passieren in horden


## Weitere Updates
- Fahrzeuge
-


####

# MVP of Waverider

-> Tiles erstmal in simpel
-> Zwei Movement modes: Pfeiltasten und Maus
-> Collision: Eine var in jedem Zombie für die fornce, und dann die
nächste Kollision nach 0.5 sekunden berechnen
-> Kleinere Maps: Nicht so groß, sondern 3200 reicht
-> Einfaches Menu + Finish-Screen
-> Die Kampange
-> Freischalten der ganzen Sachen
-> Munition auf der Map verstecken
+ Händer wo man was kaufen kann
+ Mini Geld wenn man einen großen oder schellen Zombie killt
+ einfaches platzieren von Geschütztürmen
+ Platzieren von Blokaden, wenn ein Zombie mit den Kollidiert
  dann kämpft er gegen die Blokade und deine
  Einheiten gehen nicht drauf
+ Icons im Buy mode für die units, und dann kann man
  auf die Buttons draufklicken.
+ Logiken in Controller auslagern
+ Code aufräumen
+ Feuer das Zombies Schaden gibt
+ Flammenwerfer -> Feuer das sich etwas ausbreitet
+ Kluge Zombies
+ Nahkampfanimation für die Zombies
+ Deine Soldaten können dir folgen, wenn du
  sie auswählst und dann folgen eingibst
+ rts-multiauswahl
+ Luftschlag
  =>

5 min of fun
10 min of fun
15 min of fun
30 min of fun
1 hour of fun
2 hour of fun 