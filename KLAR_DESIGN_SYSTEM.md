# Klar-Webdesignsystem

Die Produktseiten von RauchKlar, KlinikKlar und HierKlar verwenden ein gemeinsames, responsives Designsystem. Waymino bleibt davon bewusst unabhängig.

## Gemeinsame Bausteine

- `assets/klar-design.css`: Layout, Typografie, Navigation, Marken-Kopf, Schaltflächen, Vorteilskarten, Screenshot-Galerie, Status-, Abdeckungs- und Hinweiskarten sowie RideRight-Footer
- `rauchklar/styles.css`, `klinikklar/styles.css`, `hierklar/styles.css`: ausschließlich produktspezifische Farben und Akzente
- semantisch gleiche Seitengerüste für Produktkopf, Nutzen, Vorteile, Nachweise, Status und Pflichtnavigation
- responsive Stufen für iPhone, Tablet und Desktop sowie Light Mode, Dark Mode, Tastaturfokus und reduzierte Bewegung

## Pflege

Globale Änderungen erfolgen in `assets/klar-design.css`. Produktspezifische Farben werden nur in der jeweiligen `styles.css` geändert. Fachliche, medizinische, rechtliche und datenschutzbezogene Inhalte der Pflichtseiten bleiben davon getrennt.

RauchKlar und KlinikKlar zeigen ausschließlich Screenshots aus den vorhandenen finalen App-Store-Assets. Für HierKlar werden erst dann Screenshots ergänzt, wenn finale Store-Aufnahmen vorliegen.

## Prüfung

Vom Repository-Stamm aus ausführen:

```sh
ruby scripts/check-klar-site.rb
git diff --check
```

Die Prüfung validiert Pflichtseiten, interne Links und Assets, kanonische Kleinbuchstabenpfade, Alias-Logik sowie die Unverändertheit bestehender fachlicher und rechtlicher Hauptinhalte gegenüber dem Vorher-Tag `klar-family-pre-redesign-20261003`.
