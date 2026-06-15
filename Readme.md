# 📚 Bazy Danych — Notatki do Egzaminu

> Skondensowane materiały z wykładów. Skupiamy się wyłącznie na konkretach, które powinieneś zapamiętać, aby zdać test.

---

## 📋 Spis treści

- [Wykład 2 — Podstawy relacyjnego modelu danych](#-wykład-2--podstawy-relacyjnego-modelu-danych)
- [Wykład 3 — Integralność danych i modele ERD](#-wykład-3--integralność-danych-i-modele-erd)
- [Wykład 6 — Transakcje i model ACID](#-wykład-6--transakcje-i-model-acid)
- [Wykład 8 — Indeksy i wydajność](#-wykład-8--indeksy-i-wydajność)
- [Wykład 9 — JDBC i programowanie baz danych](#-wykład-9--jdbc-i-programowanie-baz-danych)
- [Wykład 11 — Współbieżność i izolacja transakcji](#-wykład-11--współbieżność-i-izolacja-transakcji)
- [Wykład 12 — Procedury składowane i wyzwalacze](#-wykład-12--procedury-składowane-i-wyzwalacze)
- [Wykład 13 — Bazy rozproszone i replikacja](#-wykład-13--bazy-rozproszone-i-replikacja)
- [Wykład 14 — OLTP vs. OLAP i hurtownie danych](#-wykład-14--oltp-vs-olap-i-hurtownie-danych)
- [Wykład 15 — Big Data i Hadoop](#-wykład-15--big-data-i-hadoop)
- [Wykład 16 — NoSQL i twierdzenie CAP](#-wykład-16--nosql-i-twierdzenie-cap)
- [Wykład 17 — Oracle Net Services](#-wykład-17--oracle-net-services)
- [Wykład 18 — Bezpieczeństwo i audyt](#-wykład-18--bezpieczeństwo-i-audyt)
- [Wykład 19 — Przestrzenne bazy danych (GIS)](#-wykład-19--przestrzenne-bazy-danych-gis)
- [Wykład 20 — Bazy wektorowe i embeddings](#-wykład-20--bazy-wektorowe-i-embeddings)

---

## 🗂 Wykład 2 — Podstawy relacyjnego modelu danych

### Relacja (Tabela) — obowiązujące reguły

| Reguła | Opis |
|--------|------|
| Unikalne nazwy | Każda relacja i każda kolumna musi mieć unikalną nazwę |
| Jednorodność typów | Wszystkie wartości w danej kolumnie muszą być tego samego typu |
| Atomowość | Dozwolone są wyłącznie wartości atomowe (zakaz zbiorów/list w jednym polu) |
| Brak duplikatów | Każdy rekord musi być unikalny |
| Brak kolejności | Kolejność kolumn i wierszy nie ma znaczenia |
| Brak indeksowania | Brak odwołań za pomocą indeksu wiersza |

### Klucze w relacyjnych bazach danych

- **Klucz główny (PK)** — minimalny zbiór kolumn jednoznacznie identyfikujący każdy rekord; wartości nie mogą być puste
- **Klucz potencjalny (Candidate Key)** — każdy zbiór kolumn jednoznacznie identyfikujący rekord, który nie jest podzbiorem innego klucza
- **Klucz złożony (Composite Key)** — klucz składający się z więcej niż jednej kolumny; żadna z kolumn nie może przyjmować wartości NULL
- **Klucz obcy (FK)** — wymusza, aby wartości w danej kolumnie znajdowały się w kluczu głównym referowanej tabeli

### ⚠️ Wartości NULL

> **NULL ≠ 0 i NULL ≠ `''`**
>
> NULL oznacza wartość *nieznaną* lub *niedostępną*. Każde porównanie z NULL zwraca **fałsz**, przez co rekordy z NULL omijają standardowe warunki filtrowania.

### Klucz Główny (PK) vs. Klucz Obcy (FK)

| Cecha | Klucz Główny (PK) | Klucz Obcy (FK) |
|-------|-------------------|-----------------|
| **Funkcja** | Unikalnie identyfikuje rekord | Tworzy relację z inną tabelą |
| **Unikalność** | Wartości całkowicie unikalne | Wartości mogą się powtarzać |
| **NULL** | Bezwzględnie niedozwolone | Dozwolone (jeśli reguły biznesowe na to pozwalają) |
| **Istnienie** | Musi istnieć samodzielnie | Musi odwoływać się do istniejącego PK |

### Postacie normalne

| Postać normalna | Warunek | Kluczowa reguła | Cel |
|-----------------|---------|-----------------|-----|
| **1NF** | Tabela jest relacją | Zdefiniowany PK, wartości atomowe | Eliminacja struktur wielowartościowych |
| **2NF** | Tabela jest w 1NF | Atrybuty niekluczowe zależą od **całego** PK | Eliminacja częściowych zależności |
| **3NF** | Tabela jest w 2NF | Atrybuty niekluczowe zależą **wyłącznie** od PK | Standard OLTP |
| **4NF** | Tabela jest w 3NF | Brak niezależnych atrybutów wielowartościowych (MVD) | Zaawansowana eliminacja anomalii |

### 🚨 Typowe pułapki egzaminacyjne

- **NULL** — nigdy nie traktuj jako 0 lub pusty ciąg; `Wartość = NULL` zawsze zwraca fałsz
- **2NF** — zależność częściowa może wystąpić **tylko** przy kluczach złożonych
- **3NF** — uważaj na zależność przechodnią; `employee_email` to cecha pracownika, nie zamówienia

---

## 🔗 Wykład 3 — Integralność danych i modele ERD

### Integralność danych

- **Integralność encji** — PK musi być unikalny i nie może zawierać NULL; DBMS wymusza to automatycznie indeksem unikalnym
- **Spójność referencyjna** — każda wartość FK musi istnieć jako PK w tabeli nadrzędnej; blokuje tworzenie *orphan records*
- **Klucz zastępczy (surrogate key)** — sztuczny, numeryczny PK generowany automatycznie, bez znaczenia biznesowego

### Trzy poziomy modelowania

```
Pojęciowy (CDM)  →  ~20 najważniejszych pojęć i relacji (wysoki poziom biznesowy)
       ↓
Logiczny (LDM)   →  Encje, atrybuty, dziedziny, relacje (niezależny od technologii)
       ↓
Fizyczny (PDM)   →  Tabele, kolumny, typy danych, indeksy (konkretny DBMS)
```

### Kardynalność i rodzaje relacji

- **Minimalna kardynalność:** 0 lub 1
- **Maksymalna kardynalność:** 1 lub Wiele (M)
- **Relacja rekurencyjna** — encja powiązana z samą sobą (np. struktura podwładny-przełożony)
- **Relacja XOR** — encja uczestniczy w dokładnie jednym z wzajemnie wykluczających się powiązań

### 🚨 Typowe pułapki egzaminacyjne

- Relacja M:N **musi** być rozbita na tabelę pośredniczącą w modelu fizycznym
- Każde połączenie na ERD wymaga jednoznacznej **etykiety czasownikowej** (np. *"składa się z"*, nie *"ma"*)
- Dane wynikające ze współdziałania dwóch encji (np. ocena studenta z kursu) są **atrybutem tabeli pośredniczącej**, nie osobną encją

---

## ⚙️ Wykład 6 — Transakcje i model ACID

### Transakcja

Sekwencja poleceń SQL wykonywana jako **pojedyncza jednostka logiczna** (np. transfer środków: odjęcie z jednego konta + dodanie na drugie).

### Model ACID

| Cecha | Definicja |
|-------|-----------|
| **A**tomicity (Atomowość) | „Wszystko albo nic" — COMMIT albo pełny ROLLBACK |
| **C**onsistency (Spójność) | Baza po transakcji musi spełniać wszystkie więzy integralności |
| **I**solation (Izolacja) | Niedokończone transakcje nie wpływają na wyniki innych operacji |
| **D**urability (Trwałość) | Zatwierdzone zmiany są zapisane na dysku i odporne na awarie |

### Komendy SQL

```sql
BEGIN TRANSACTION  -- Otwiera blok transakcji (wymagane w MS SQL Server)
COMMIT             -- Trwale zapisuje wszystkie zmiany
ROLLBACK           -- Cofa wszystkie niezatwierdzone zmiany
SAVE TRAN <punkt>  -- Tworzy punkt zapisu (savepoint)
```

### Typy transakcji

| Typ | Charakterystyka |
|-----|-----------------|
| **Jawne (Explicit)** | Kontrolowane ręcznie przez `BEGIN … COMMIT/ROLLBACK` |
| **Niejawne (Implicit)** | Pojedyncze instrukcje DML (np. `UPDATE`, `INSERT`) |

### 🚨 Typowe pułapki egzaminacyjne

- **Atomowość ≠ Izolacja** — atomowość chroni przed częściowym wykonaniem; izolacja — przed interakcją z innymi użytkownikami
- **DDL w transakcji** — w MS SQL Server `ROLLBACK` cofnie `CREATE TABLE`; w Oracle DDL jest **autocommit** i nie zostanie cofnięte
- **Transakcje nie poprawiają przepustowości** — wręcz przeciwnie, zmniejszają ją, wymuszając kolejkowanie operacji

---

## 🔍 Wykład 8 — Indeksy i wydajność

### Podstawowe pojęcia

- **Indeks** — struktura danych (zazwyczaj B-drzewo) przyspieszająca wyszukiwanie (`WHERE`, `JOIN`) i sortowanie (`ORDER BY`)
- **Klucz indeksowy** — kolumna lub zestaw kolumn, na których zbudowany jest indeks
- **Sterta (Heap)** — tabela bez indeksu zgrupowanego; rekordy przechowywane w losowej kolejności

### Kiedy tworzyć indeks?

1. Aby wymusić unikalność klucza głównego (PK)
2. **Zawsze na kluczach obcych (FK)** — przyspiesza JOIN i sprawdzanie więzów integralności
3. W dużych tabelach (>1000 rekordów) dla kolumn często używanych w `WHERE` lub `ORDER BY`
4. Gdy kolumna ma **wysoką selektywność** (dużo unikalnych wartości)

### Indeks Zgrupowany vs. Niezgrupowany

| Cecha | Clustered (Zgrupowany) | Nonclustered (Niezgrupowany) |
|-------|------------------------|------------------------------|
| **Wpływ na dane** | Fizycznie porządkuje rekordy na dysku | Tworzy niezależną strukturę ze wskaźnikami |
| **Limit na tabelę** | **Tylko 1** | Wiele |
| **Zastosowanie** | Zakresy dat, grupy powiązanych rekordów | Precyzyjne wyszukiwanie po PESEL, nazwisku, mieście |

### 🚨 Typowe pułapki egzaminacyjne

- Tabela może mieć **maksymalnie jeden** indeks zgrupowany
- Zbyt wiele indeksów drastycznie obniża wydajność DML (INSERT, UPDATE, DELETE)
- Indeks na kolumnie z **niską selektywnością** (np. „Płeć") to błąd — DBMS i tak przeskanuje połowę tabeli

---

## 💻 Wykład 9 — JDBC i programowanie baz danych

### Kluczowe interfejsy JDBC (`java.sql`)

| Interfejs | Rola |
|-----------|------|
| `Connection` | Sesja z bazą danych; zarządzanie transakcjami (`commit()`, `rollback()`) |
| `Statement` | Uruchamianie statycznych zapytań SQL |
| `PreparedStatement` | Wstępnie skompilowane zapytanie; plan wykonania cachowany po stronie DBMS |
| `ResultSet` | Zestaw wyników zwracany przez `executeQuery()`; kursor przesuwany przez `next()` |

### Pula połączeń (Connection Pooling)

```
getConnection()  →  pobiera gotowe połączenie z puli (zamiast tworzyć nowe od zera)
close()          →  zwraca połączenie do puli (NIE zamyka fizycznego połączenia TCP/IP)
```

Zapewnia **ogromny wzrost wydajności** w aplikacjach wielodostępnych.

### SQL Injection — jedyna skuteczna obrona

```java
// ❌ PODATNE — konkatenacja stringa
String query = "SELECT * FROM users WHERE id = '" + userInput + "'";

// ✅ BEZPIECZNE — PreparedStatement
PreparedStatement ps = conn.prepareStatement("SELECT * FROM users WHERE id = ?");
ps.setString(1, userInput);
```

### DriverManager vs. DataSource

| Cecha | DriverManager (Tradycyjna) | DataSource (Rekomendowana) |
|-------|---------------------------|---------------------------|
| **Parametry** | Hardcoded w kodzie | W zewnętrznym pliku konfiguracyjnym |
| **Pula połączeń** | Brak | Wbudowana |
| **Środowisko** | Proste aplikacje desktopowe | Serwer aplikacji (Tomcat, WebLogic) |

### 🚨 Typowe pułapki egzaminacyjne

- W pętli zawsze używaj `PreparedStatement` — `Statement` zmusza DBMS do ponownej kompilacji przy każdym wywołaniu
- `Connection`, `Statement`, `ResultSet` muszą być zamykane **jak najszybciej** — wycieki zasobów blokują bazę
- Automatyczne zamknięcie `Connection` przez `try-with-resources` może wywołać niejawny commit lub rollback — lepiej zarządzać transakcjami jawnie

---

## 🔄 Wykład 11 — Współbieżność i izolacja transakcji

### Kluczowe anomalie transakcyjne

| Anomalia | Opis |
|----------|------|
| **Dirty read** | Odczyt danych zmienionych przez inną transakcję, która jeszcze nie zrobiła COMMIT |
| **Lost update** | Dwie transakcje odczytują tę samą wartość i nadpisują się nawzajem |
| **Non-repeatable read** | Ten sam rekord odczytany dwukrotnie daje różne wyniki (inna transakcja zrobiła UPDATE/DELETE) |
| **Phantoms** | Powtórne zapytanie z WHERE zwraca inną liczbę wierszy (inna transakcja zrobiła INSERT) |

### Poziomy izolacji w MS SQL Server

| Poziom izolacji | Dirty read | Non-repeatable read | Phantoms |
|-----------------|:----------:|:-------------------:|:--------:|
| READ UNCOMMITTED | ✅ TAK | ✅ TAK | ✅ TAK |
| READ COMMITTED *(domyślny)* | ❌ NIE | ✅ TAK | ✅ TAK |
| REPEATABLE READ | ❌ NIE | ❌ NIE | ✅ TAK |
| SERIALIZABLE | ❌ NIE | ❌ NIE | ❌ NIE |
| SNAPSHOT | ❌ NIE | ❌ NIE | ❌ NIE |

### Tryby blokad

| Blokada | Wyzwalacz | Skutek |
|---------|-----------|--------|
| **Shared (S)** | `SELECT` | Inne transakcje mogą czytać, ale nie mogą modyfikować |
| **Exclusive (X)** | `INSERT`, `UPDATE`, `DELETE` | Nikt inny nie może ani czytać, ani modyfikować |

### Zakleszczenie (Deadlock)

> Deadlock nie rozwiąże się sam — DBMS musi wykryć go i wykonać `ROLLBACK` na jednej z transakcji.
>
> **Złota zasada unikania:** zawsze blokuj zasoby w **tej samej kolejności**.

### 🚨 Typowe pułapki egzaminacyjne

- **Non-repeatable read vs. Phantom** — non-repeatable: UPDATE/DELETE istniejącego wiersza; phantom: INSERT nowego wiersza
- Blokada **Exclusive** wstrzymuje nawet `SELECT` przy domyślnym poziomie izolacji
- Wzorzec **Odczytaj-Zmień-Zapisz** bez blokad transakcyjnych prowadzi do **Lost update**

---

## 🛠 Wykład 12 — Procedury składowane i wyzwalacze

### Procedura składowana (Stored Procedure)

Program w języku T-SQL przechowywany i uruchamiany bezpośrednio przez DBMS. Plan wykonania jest **cachowany** — eliminuje narzut parsowania ad-hoc zapytań.

### Architektura komunikacji

| Cecha | Zapytania bezpośrednie | Procedury składowane |
|-------|------------------------|----------------------|
| **Ruch sieciowy** | Wysoki (ciągłe przesyłanie tekstu SQL) | Minimalny (`EXEC` + wynik) |
| **Wydajność** | Każde zapytanie parsowane na nowo | Skompilowany plan z cache |
| **Bezpieczeństwo** | Rozproszony dostęp do tabel | Centralny dostęp tylko do SP |

### Wyzwalacz (Trigger)

Procedura uruchamiana **automatycznie** jako reakcja na `INSERT`, `UPDATE`, `DELETE`.

> **Złota zasada:** Jeśli jedno polecenie SQL modyfikuje 1000 wierszy, wyzwalacz uruchomi się **dokładnie raz** dla całej grupy.

### Typy wyzwalaczy

| Typ | Moment | Zastosowanie |
|-----|--------|--------------|
| **AFTER** | Po wykonaniu operacji | Logowanie, aktualizacja liczników |
| **INSTEAD OF** | Zamiast operacji | Modyfikacja danych przez nieedytowalne widoki |

### 🚨 Typowe pułapki egzaminacyjne

- Wyzwalacz dla `INSERT ... SELECT` wstawiającego 500 wierszy wykona się **raz**, nie 500 razy
- Kod `SELECT CustomerId FROM inserted` bez JOIN zadziała **tylko** gdy wstawiany jest dokładnie jeden rekord — przy wielu rekordach zwróci losową wartość lub błąd
- Logika w procedurach składowanych T-SQL **nie zadziała** na Oracle (używa PL/SQL)
- Kursory przetwarzają dane **wiersz po wierszu** — operacje zestawowe są zawsze wydajniejsze

---

## 🌍 Wykład 13 — Bazy rozproszone i replikacja

### Dwufazowy protokół zatwierdzania (2PC)

```
Faza 1 — Prepare (Głosowanie):
  Koordynator → "Czy jesteście gotowe?" → Wszystkie bazy

Faza 2 — Commit:
  Jeśli WSZYSTKIE odpowiedziały "TAK" → COMMIT wszędzie
  Jeśli choć jedna odpowiedziała "NIE" → ROLLBACK wszędzie
```

**Wada:** Działanie synchroniczne — awaria jednego serwera blokuje całą transakcję.

### 3 Typy replikacji

| Typ | Mechanizm | Zastosowanie |
|-----|-----------|--------------|
| **Transakcyjna** | Agent nasłuchuje loga i przesyła operacje SQL na bieżąco | Raportowanie w centrali, krótkie opóźnienia |
| **Snapshot** | Kopiuje całą tabelę w danym momencie | Cenniki aktualizowane raz dziennie |
| **Merge** | Obie strony zmieniają niezależnie, system merguje zmiany | Handlowcy z laptopami w terenie bez internetu |

### Klastry o wysokiej dostępności (HA)

| Model | Działanie | Zaleta / Wada |
|-------|-----------|---------------|
| **Active/Passive** | Serwer B w trybie czuwania — przejmuje ruch po awarii A | Prosta architektura / płacisz za bezczynny serwer |
| **Active/Active** | Oba serwery obsługują ruch jednocześnie (load balancing) | Pełne wykorzystanie sprzętu / np. Oracle RAC |

---

## 📊 Wykład 14 — OLTP vs. OLAP i hurtownie danych

### OLTP vs. OLAP

| Cecha | OLTP | OLAP |
|-------|------|------|
| **Cel** | Bieżące operacje firmy | Analiza trendów, raportowanie |
| **Dane** | Aktualne, „tu i teraz" | Historyczne, z wielu lat |
| **Optymalizacja** | Szybkie zapisy (INSERT, UPDATE) | Ciężkie agregacje (SELECT, GROUP BY) |
| **Struktura** | Mocno znormalizowana | Zdenormalizowana (modelowanie wymiarowe) |

### Architektura analityczna (pipeline danych)

```
Systemy źródłowe (Oracle, MS SQL, ...)
         ↓
    ETL / ELT
  (Extract → Transform → Load)
         ↓
  Data Warehouse (DWH)
         ↓
     OLAP / Kostki
         ↓
   Business Intelligence
  (Tableau, PowerBI, ...)
```

### Słownik modelowania wymiarowego

| Pojęcie | Definicja | Przykład |
|---------|-----------|---------|
| **Fakt** | Pojedyncze zdarzenie biznesowe | Sprzedaż produktu |
| **Wymiar** | Atrybut/hierarchia grupowania faktów | Czas, Lokalizacja, Produkt |
| **Miara** | Liczbowa wartość podlegająca agregacji | Wartość sprzedaży w PLN |

### Schemat Gwiazdy (Star Schema)

```
         [Czas]
           |
[Produkt]—[FAKTY]—[Lokalizacja]
           |
       [Klient]
```

Tabela Faktów w centrum → klucze obce + liczbowe miary. Tabele Wymiarów na zewnątrz → opisy tekstowe.

---

## 🐘 Wykład 15 — Big Data i Hadoop

### Zasada 3V

| V | Opis |
|---|------|
| **Volume** | Ogromna ilość danych (terabajty, petabajty) |
| **Velocity** | Dane napływają błyskawicznie, analiza near-real time |
| **Variety** | Nieustrukturyzowane dane (logi, posty, sensory IoT) |

### Skalowanie RDBMS vs. Big Data

| Cecha | RDBMS | Big Data / Sharding |
|-------|-------|---------------------|
| **Skalowanie** | W górę (droższy serwer) | Poziome (setki tanich komputerów) |
| **Architektura dysków** | Shared disk | Shared-nothing (każdy węzeł z lokalnym dyskiem) |
| **Integralność** | Referencyjna (klucze obce) | Brak — elastyczność i szybkość |

### Apache Hadoop — kluczowe komponenty

- **HDFS** — rozproszony system plików; automatycznie dzieli i replikuje pliki (zazwyczaj 3 kopie)
- **MapReduce** — silnik przetwarzania; każdy węzeł przetwarza swój lokalny kawałek danych

### ⚡ Schema-on-Write vs. Schema-on-Read

```
Schema-on-Write (RDBMS):
  Zanim wrzucisz dane → musisz zaprojektować tabelę

Schema-on-Read (Hadoop):
  Wrzucasz co chcesz → o strukturze decydujesz przy odczycie
```

---

## 🍃 Wykład 16 — NoSQL i twierdzenie CAP

### NoSQL = „Not Only SQL"

Główne cechy:
- **Schemaless** — brak sztywnego schematu z góry (ale istnieje **schemat domniemany** w kodzie aplikacji)
- **Scale-out** — zaprojektowane do pracy w klastrach

### 4 Rodziny baz NoSQL

| Typ | Zasada | Przykłady |
|-----|--------|-----------|
| **Klucz-Wartość** | Pobieranie danych przez unikalny klucz | Redis, Riak |
| **Dokumentowe** | Dane w dokumentach JSON; baza potrafi zajrzeć do środka | **MongoDB**, RavenDB |
| **Rodziny Kolumn** | Wiersze z różną liczbą kolumn; grupowanie w „rodziny" | **Cassandra**, HBase |
| **Grafowe** | Węzły i krawędzie; szybkie przeszukiwanie sieci powiązań; **wspiera ACID** | Neo4j, FlockDB |

### ⚖️ Twierdzenie CAP — absolutny pewniak egzaminacyjny

```
C (Consistency)         — każdy odczyt zwraca najnowszą wartość
A (Availability)        — każde zapytanie dostaje odpowiedź (nie błąd)
P (Partition Tolerance) — system działa mimo awarii sieci między serwerami
```

> **Złota reguła: Z trzech własności możesz mieć tylko dwie naraz.**

| Architektura | Poświęca | Gwarantuje |
|-------------|----------|------------|
| **CP** | Dostępność (A) | Spójność przy awarii sieci |
| **AP** (np. Cassandra) | Ścisłą spójność (C) | Eventual Consistency — dane wyrównają się z czasem |

### Aggregate-based vs. Aggregate-ignorant

| Podejście | Bazy | Zaleta | Wada |
|-----------|------|--------|------|
| **Aggregate-based** | MongoDB, Cassandra | Rewelacyjne dla shardingu | Brak pełnych transakcji ACID między agregatami |
| **Aggregate-ignorant** | RDBMS, bazy grafowe | Pełne transakcje ACID | Trudniejsze rozproszenie w klastrze |

---

## 🔌 Wykład 17 — Oracle Net Services

### Oracle Net Listener

- Nasłuchuje na żądania klientów (domyślny port TCP/IP: **1521**)
- Odbiera pakiet `CONNECT` → uruchamia dedykowany **server process** dla sesji
- **Wyłączenie Listenera** nie przerywa istniejących sesji — tylko blokuje nowe połączenia

### „Święta Trójca" plików konfiguracyjnych

| Plik | Strona | Zadanie |
|------|--------|---------|
| `sqlnet.ora` | Klient/Serwer | Ogólne reguły Oracle Net, metody rozwiązywania nazw |
| `tnsnames.ora` | Klient | „Książka telefoniczna" — alias → adres IP, port, instancja |
| `listener.ora` | Serwer | Definicja procesów nasłuchujących, lista instancji (SID) |

Wszystkie pliki standardowo w: `<oracle_home>/network/admin/`

### Metody rozwiązywania nazw

| Metoda | Opis |
|--------|------|
| **Easy Connect** | `user/pass@host:port/service` — bez konfiguracji, tylko TCP/IP |
| **Local Naming** | Plik `tnsnames.ora` na kliencie |
| **Directory Naming** | Centralny serwer LDAP — zmiana adresu w jednym miejscu |
| **External Naming** | Integracja z zewnętrznymi systemami (np. NIS) |

### Narzędzia administratora

```bash
lsnrctl start/stop/status  # Zarządzanie Listenerem
tnsping <alias>             # Test połączenia do Listenera (NIE sprawdza instancji bazy!)
```

---

## 🔒 Wykład 18 — Bezpieczeństwo i audyt

### Zasada Najmniejszych Uprawnień

> Użytkownik lub aplikacja powinni mieć tylko takie uprawnienia, jakie są im absolutnie niezbędne.

Krytyczny przykład:
```sql
REVOKE EXECUTE ON utl_file FROM public;
-- UTL_FILE daje dostęp do plików OS serwera — nie może być publiczny!
```

### Architektura bezpieczeństwa Oracle (4 filary)

1. **Konta użytkowników** — unikalne tożsamości w bazie
2. **Uprawnienia** — systemowe (`CREATE TABLE`) i obiektowe (`SELECT ON HR.EMPLOYEES`)
3. **Role** — nazwane zestawy uprawnień (np. `DBA`, `CONNECT`)
4. **Profile** — limitowanie zasobów i polityka haseł

### Parametry profilu — polityka haseł

| Parametr | Działanie |
|----------|-----------|
| `FAILED_LOGIN_ATTEMPTS` | Liczba błędnych prób przed zablokowaniem konta |
| `PASSWORD_LOCK_TIME` | Czas blokady konta (w dniach) |
| `PASSWORD_LIFE_TIME` | Cykl życia hasła — po tym czasie wymagana zmiana |
| `PASSWORD_VERIFY_FUNCTION` | Funkcja PL/SQL sprawdzająca złożoność hasła |

### Ewolucja metod audytu

| Metoda | Możliwości | Ograniczenia |
|--------|------------|--------------|
| **Audyt Standardowy** | Logowanie komend, błędnych logowań | Brak wartości kolumn |
| **Trigger-based (Value-based)** | Stare i nowe wartości przy UPDATE | Nie monitoruje SELECT, obciąża bazę |
| **Fine-Grained Auditing (FGA)** | SELECT i DML dla konkretnych kolumn/warunków | Wymaga konfiguracji `DBMS_FGA` |
| **Unified Auditing** | Zbiera logi ze wszystkich źródeł w jednej tabeli (tylko do odczytu) | Nowoczesne, najkompletniejsze |

### ⚠️ Grzechy główne Data Scientistów

- **Shadow Data** — eksport wrażliwych danych do CSV/Excel na stacjach roboczych
- **Konta z nadmiernymi uprawnieniami** — aplikacja łącząca się jako `DBA`
- **SQL Injection** — konkatenacja zapytań z danymi użytkownika

---

## 🗺 Wykład 19 — Przestrzenne bazy danych (GIS)

### Modele danych

| Model | Opis | Przykłady |
|-------|------|-----------|
| **Rastrowy** | Siatka pikseli przypisana do współrzędnych | Zdjęcia satelitarne, ortofotomapy |
| **Wektorowy** | Obiekty matematyczne z geometrią i atrybutami | Mapy miast, sieci wodociągowe |

### Typy geometrii wektorowej

```
Punkt (Point)         → hydrant, drzewo, punkt adresowy
Linia (Polyline)      → rzeka, droga, kabel energetyczny
Wielobok (Polygon)    → obrys budynku, granica działki, jezioro
```

### Przechowywanie danych GIS

| Podejście | Technologia | Wady |
|-----------|-------------|------|
| **Plikowe** | Shapefile (.shp), CAD (.dxf) | Brak równoczesnej edycji, trudne zarządzanie |
| **Korporacyjne** | Oracle Spatial, MS SQL Server | Brak — pełna transakcyjność i wielodostępność |

### Standardy OGC (komunikacja sieciowa)

| Standard | Co przesyła | Zastosowanie |
|----------|-------------|--------------|
| **WMS** | Gotowy obrazek (kafle rastrowe) | Podkłady mapowe |
| **WFS** | Surowe dane wektorowe | Edycja, klikanie w obiekty, atrybuty |

---

## 🤖 Wykład 20 — Bazy wektorowe i embeddings

### Problem tradycyjnych RDBMS z danymi niestrukturyzowanymi

- Długi tekst → `CLOB`; pliki binarne → `BLOB` / `RAW`
- Operator `LIKE` szuka dokładnych znaków — nie rozumie semantyki
- Baza nie wie, że „pies" i „szczeniak" znaczą to samo

### Embeddings (Osadzenia)

```
Tekst / Obraz / Dźwięk  →  Model ML  →  Wektor liczb zmiennoprzecinkowych
                                         (np. R^384 — 384 wymiary)
```

### Miary podobieństwa w pgvector

| Miara | Operator | Opis |
|-------|----------|------|
| **Odległość Euklidesowa (L₂)** | `<->` | Odległość w linii prostej |
| **Podobieństwo Kosinusowe** | `<=>` | Kąt między wektorami |

```sql
-- Znajdź 2 najbardziej podobne rekordy
SELECT * FROM items ORDER BY embedding <=> '[3,2,2.5]' LIMIT 2;
```

### Typy wyszukiwania wektorowego

| Typ | Metoda | Zalety / Wady |
|-----|--------|---------------|
| **Exact (kNN)** | Porównanie z każdym rekordem | Idealny wynik / wolne przy miliardach wektorów |
| **Approximate (ANN)** | Grafy, klastry przestrzeni | Szybkość w milisekundach / minimalny spadek precyzji |

### Ekosystem baz wektorowych

- **Dedykowane:** Pinecone, Milvus, Qdrant
- **Rozszerzenia RDBMS:** PostgreSQL + `pgvector` — dane tabelaryczne i wektory w jednym miejscu

---

*Powodzenia na egzaminie! 🎓*
