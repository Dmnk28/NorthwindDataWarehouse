# Northwind Data Warehouse
__Aufgabenbeschreibung:__ Erstelle ein funktionales Data Warehouse zu den Northwind Beispieldaten. Verfasse hierzu Lasten- und Pflichtenheft, eine Konzeption und definiere Arbeitspakete. Berücksichtige hierbei auch automatisierte Lösungen zum Synchronisieren von Datenänderung im OLAP und zu Neuinitialisierungen des Warehouses. Einige Vorgaben, wie z.B. die verschiedenen OLAP-Tabellen existierten bereits.

__Zeitlimit:__ 3 Tage.

## IST-Analyse (Fiktiv)
### DB-Struktur
Die Firma Northwind verfügt über eine klassische OLTP Datenbank mit 11 Nutzertabellen im dbo Schema. Während einige Tabellen eher statischer Natur (Categories, Territories, Region) und nur selten Schreibzugriffen ausgesetzt sind, sind andere durch eine hohe Frequenz an Datenänderungen und -eintragungen geprägt (Customers, Orders, Order Details, ...). Es existiert pro Tabelle ein Primary Key und mehrere Indices, darunter kein Columstore Index. Eine Partitionierung von Tabellen oder Indizes liegt nicht vor.

### DB-Verwendung (Fiktiv)
Der Online-Shop von Northwind wird hat durchschnittlich ca. 10.000 Kundenbestellungen pro Tag zu verarbeiten. Die Kundschaft ist international und breit über die verschiedenen Liefergebiete verteilt, der Online-Shop/die DB muss folglich rund um die Uhr erreichbar und nutzbar sein, wobei die Hauptnutzlast auf den Nachmittag zwischen 13 und 18 Uhr fällt. Die Indices von Verkehrsdaten-tabellen werden alle zwei Tage vormittags neu erstellt, die von weniger frequentierten Datentabellen jeden Samstag um 11.00 Uhr.

Werktags werden um 17.00 Uhr ausführliche Analysen zum Tagesgeschehen (bis 16.00 Uhr) oder zu verschiedenen Projekt-/Kampagnen-bezogenen Schwerpunkten von Geschäftsleitung und/oder Marketingabteilung angefordert. Sonntagnacht um 23.59 Uhr werden standardisierte Wochenberichte für die vergangenen 7 Tage erstellt.  

Voll-/Diff-/Log-Backups sowie Server- und Datenbankwartungsarbeiten fallen in die Stunden nach 18.00 Uhr bis 07.00 Uhr des Folgetags. Zwischen 07.00 und 18.00 erfolgen TransLog-Backups alle 10 Minuten und alle eineinhalb Stunden ein differenzielles Backup.  

Die Berichtserstellung fällt oft mit der Hauptnutzungszeit der DB durch Kundenbestellungen zusammen und sowohl Geschäftsleitung als auch Bestelleinträge müssen Verzögerungen in der Verarbeitung erdulden. Da die Select-Anweisungen für die Berichte durch Xlocks von Bestellprozesse geblockt werden und Wenn die Analysen gefahren werden Slocks die Schreibprozesse der Bestellungen blockieren. Durch diverse Joins, die für die Marketing-Analysen benötigt werden, sind meist die für den Bestellprozess zentralen Tabellen (Orders, etc.) durch die verschiedenen Analysen längere Zeit geblockt.  
Die Erstellung von Analysen benötigt extrem viel Zeit, welche vorwiegend auf die Abfragen und Views zurückzugehen scheint.


## Lastenheft
### Ziele
* Die DB-Umgebung muss simultane Auswertungen in Kombination mit einem reibungslosen Bestellprozess simultan gewährleisten können.
* Die Indexierung von stark frequentierten Tabellen sollen täglich nach der Hauptbestellzeit ausgeführt werden können, ohne Analysen und Wartung zu beeinträchtigen. 
* Die Analysen sollen dabei möglichst aktuelle Daten nutzen und keiner größeren temporalen Verzögerung unterliegen.
* Die Erstellung von Analysen und Berichten soll massiv beschleunigt werden um auch experimentelle Abfragen schnell umsetzen zu können und so dem Marketing und der Geschäftsleitung mehr Flexibilität gewährleisten  
* Die Wartung und Instandhaltung soll mit möglichst geringem (Zusatz-)Aufwand verbunden sein, der von einem Datenbankadministrator abgedeckt werden kann.

### Bedingungen
* Die Bestehenden Prozesse in der Bestellabwicklung und Verwaltung haben sich bewährt, sie dürfen nicht durch die neue Architektur beeinträchtigt werden

### Sonstige Absprachen
* BLOBs sind keine Ressourcen für spätere Analysen 

### Lieferumfang
* Architektur
* Implementierung im Northwind-Server
* Schulungen zu Wartung und Pflege (2 Mitarbeiter, 5 Tage) 

## Pflichtenheft
* Aufbau einer Staging DB und einer OLAP DB
* Erstellung & Umsetzung eines Konzepts zum Datentransfer in Staging DB
* Denormalisierungsprozesse für die Staging DB und Erstellung eines Sternschemas
* Erstellung & Umsetzung eines Konzepts zum Datentransfer des Sternschemas von Staging DB zur OLAP DB
* Erstellung & Umsetzung eines Konzepts zum kontinuierlichen Datentransfer, nachgetragener Daten 
* Automatisierung für Initialisierung 

* Implementierung der DBs und Automatisierungsprozesse im Zielsystem (Azure Managed Instanz)
* Konzeption von Unterrichtseinheiten und erstellen von Lehrmaterial auf Basis der Dokumentation

## Konzeption
* Datawarehouse mit einer OLTP (existierende DB von Northwind), einer Staging DB und einer OLAP DB

### Arbeitspakete

#### Aufbau Staging DB
* [X] Einrichten der Staging DB in Testumgebung
* [X] Erstellung von Schemata für OLTP und OLAP

#### Datentransfer in Staging DB
* [ ] ~~Trigger in OLTP DB to write Datasets to a Deleted Table: Zusätzliche Spalten "Deleted" (DateTime), "Deleted_By" (varchar(50)) werden durch Trigger gesetzt auf 1, getdate und original_login().~~ _EDIT: Eig. Gute Idee. Wurde verworfen, rein aus Zeitgründen. Ggf. wären Prozeduren für DML-Anweisungen sinnvoller gewesen, da in die deleted-Tabellen von Triggern keine BLOB/CLOB-Daten geladen werden und diese so nicht hätten gesichert werden können._
* [ ] ~~Create Deleted Tables in OLTP DB~~
* [X] Aufbau von Nutzertabellen nach Vorbild der OLTP, zusätzliche Spalten "Deleted" (DateTime), "Deleted_By" (varchar(50))  
* [X] "Select Into"s für die einzelnen Tabellen bei Initialisierung erstellen
_Constraints Indices, Views und Prozeduren sind nicht zu transferieren denn die verlangsamen nur_

#### Denormalisierungsprozesse für die Staging DB und erstellung eines Sternschemas
* [X] DimDate erstellen
* [X] DimCustomer erstellen
* [X] DimProducts erstellen
* [X] DimEmployees erstellen
* [X] DimCategories erstellen
* [X] DimGeography erstellen
* [X] DimSuppliers erstellen
* [X] FactOrderEvents erstellen
* [X] "Select into"s für die Initialisierung erstellen. 

#### Aufbau OLAP
* [X] Einrichten der OLAP DB in Testumgebung
* [X] Erstellen der Schemata für Facts und Dimension

#### Datentransfer des Sternschemas von Staging DB zur OLAP DB
* [X] Importieren der Fact & Dim Tabellen aus der Staging DB
* [X] Erstellen der Primary Keys in den Dimensionstabellen
* [X] Erstellen des Primary Keys und der Foreign Keys für die Facts 
* [ ] Wartungspläne für die Index-Erstellung schreiben 

#### Synchronisierung
* [X] Merge-Befehle zwischen OLTP und Staging schreiben
* [ ] Merge-Befehle für Datenaufbereitung auf Staging schreiben
* [ ] Merge-Befehle zwischen Staging und OLAP schreiben
* [ ] Wartungsplan aus MergeBefehlen und Prozeduren zusammenstellen
* [ ] Indizierungsprozesse auf OLAP automatisieren (Wartungspläne)


#### Initialisierungs-Wartungsplan
* [ ] Transferieren gelöschter Datensätze in temporäre Tabellen vor Initialisierung und Rückspielung in die OLAP Tabellen
* [ ] Prozeduren abrufen über Wartungsplan

#### Optional: Run the Cube
* [ ] Einen Cube basteln

## Potenzielle Probleme
* Identities werden bei select into mitgenommen! Könnten später Probleme verursachen
* Bei halbjährigen Neuinitialisierungen würden ohne Tabellen für in der OLTP gelöschte Datensätze mit jeder Neuinitialisierung die vormals nur logisch gelöschten (via Merge Befehle) Datensätze e 

## Testing
* [ ] Kontrolle der Select Into's via ```exec sp_help <Tabellenname>``` und stichprobenartig auch inhaltlich via ```select * from <Tabellenname>``` 
* [ ] Kontrolle der Merge-Befehle auf Inhaltlicher Ebene (nach Eingebe neuer Informationen in OLTP) 
* [ ] Kontrolle von eventuell fehlenden Indices via geschätzten Ausführungsplan anzeigen lassen bei üblichen Abfragen von Northwind auf der OLAP DB
* [ ] Kontrolle der Verwendung aller erstellten Indices via Ausführungsplan anzeigen lassen bei üblichen Abfragen von Northwind auf der OLAP DB 
* [ ] Kontrolle der Verwendung der vorhandenen Indices vie Ausführungsplan anzeigen lassen 

### Tests
* [ ] 

### Auswertung


## Fazit

### FAILS
*   Die Daten von DimDate in date zu konvertieren statt als datetime zu lassen (Vorgriff, Datenverlust + prinzipiell auch Verlust von Eindeutigkeit bei Zuweisungen von Außen, da Millisekunden nun fehlen [auch wenn die Zeitangaben in der Northwind DB alle bei 00:00:00.000 stehen :D ])
*   DimDate-Zuweisungen massiv erschwert, ebenso bei Geo. Vorteil: Keine Personenbezogenen Daten; Nachteil: Event-Bezug auch kaum wiederherstellbar. _Gäbe es hier einen besseren Ansatz?_
*   Logisches Löschen failed completely. Trigger-Ansatz war vielversprechend, hätte weiter verfolgt werden sollen, statt der merge-Lösung. So wären die Löschvorgänge auch nachvollziehbarer (und akkurater auswertbar) geworden.  