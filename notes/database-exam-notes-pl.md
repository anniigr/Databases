# Bazy Danych — Notatki do Egzaminu

---

## Spis treści

- [Wykład 2 — Podstawy relacyjnego modelu danych](#wykład-2--podstawy-relacyjnego-modelu-danych)
- [Wykład 3 — Integralność danych i modele ERD](#wykład-3--integralność-danych-i-modele-erd)
- [Wykład 6 — Transakcje i model ACID](#wykład-6--transakcje-i-model-acid)
- [Wykład 8 — Indeksy i wydajność](#wykład-8--indeksy-i-wydajność)
- [Wykład 9 — JDBC i programowanie baz danych](#wykład-9--jdbc-i-programowanie-baz-danych)
- [Wykład 11 — Współbieżność i izolacja transakcji](#wykład-11--współbieżność-i-izolacja-transakcji)
- [Wykład 12 — Procedury składowane i wyzwalacze](#wykład-12--procedury-składowane-i-wyzwalacze)
- [Wykład 13 — Bazy rozproszone i replikacja](#wykład-13--bazy-rozproszone-i-replikacja)
- [Wykład 14 — OLTP vs. OLAP i hurtownie danych](#wykład-14--oltp-vs-olap-i-hurtownie-danych)
- [Wykład 15 — Big Data i Hadoop](#wykład-15--big-data-i-hadoop)
- [Wykład 16 — NoSQL i twierdzenie CAP](#wykład-16--nosql-i-twierdzenie-cap)
- [Wykład 17 — Oracle Net Services](#wykład-17--oracle-net-services)
- [Wykład 18 — Bezpieczeństwo i audyt](#wykład-18--bezpieczeństwo-i-audyt)
- [Wykład 19 — Przestrzenne bazy danych (GIS)](#wykład-19--przestrzenne-bazy-danych-gis)
- [Wykład 20 — Bazy wektorowe i embeddings](#wykład-20--bazy-wektorowe-i-embeddings)

---

## Wykład 2 — Podstawy relacyjnego modelu danych

### Definicje i reguły obowiązkowe do zapamiętania

**Relacja (Tabela)**

Struktura służąca do organizacji i przechowywania danych. Obowiązujące reguły:

- Każda relacja oraz każda kolumna w relacji musi mieć unikalną nazwę.
- Wszystkie wartości w danej kolumnie muszą być tego samego typu.
- Wyłącznie wartości atomowe są dozwolone (brak zbiorów/list wartości w jednym polu).
- Każdy rekord musi być unikalny (niedozwolone są duplikaty całych wierszy).
- Kolejność kolumn oraz wierszy nie ma znaczenia.
- Brak odwołań za pomocą indeksu wiersza.

**Klucze w relacyjnych bazach danych**

- **Klucz główny (Primary Key — PK):** Minimalny zbiór kolumn, którego wartości jednoznacznie identyfikują każdy rekord w tabeli. Wartości te nie mogą być puste.
- **Klucz potencjalny (Candidate Key):** Każdy zbiór kolumn, który jednoznacznie identyfikuje rekord i nie jest podzbiorem innego klucza. Jeśli w tabeli jest ich więcej, jeden z nich zostaje kluczem głównym.
- **Klucz złożony (Composite Key):** Klucz składający się z więcej niż jednej kolumny. Żadna z kolumn wchodzących w jego skład nie może przyjmować wartości NULL.
- **Klucz obcy (Foreign Key — FK):** Deklaracja wymuszająca, aby każda wartość w danej kolumnie znajdowała się w kluczu głównym referowanej tabeli.

**Wartości NULL**

Oznaczają wartość „nieznaną" lub „niedostępną". NULL to nie jest wartość pusta — nie jest równoznaczne z liczbą 0 ani pustym ciągiem znaków `''`. Każde porównanie z wartością NULL zwraca wynik fałszywy, przez co rekordy z NULL omijają standardowe warunki filtrowania.

**Spójność referencyjna (Referential Integrity)**

Zasada gwarantująca, że każdej wartości klucza obcego odpowiada istniejąca wartość klucza głównego w powiązanej tabeli. Zapobiega tworzeniu rekordów osieroconych (*orphan records*). DBMS blokuje operacje wstawiania, usuwania i aktualizacji, które łamałyby tę spójność.

### Porównania i zestawienia

**Klucz Główny (PK) a Klucz Obcy (FK)**

| Cecha | Klucz Główny (PK) | Klucz Obcy (FK) |
|---|---|---|
| Funkcja | Unikalnie identyfikuje rekord w obrębie własnej tabeli | Tworzy relację z inną tabelą, odwołując się do jej PK |
| Unikalność | Wartości muszą być całkowicie unikalne | Wartości mogą się powtarzać |
| Wartości NULL | Bezwzględnie niedozwolone | Dozwolone (o ile reguły biznesowe na to pozwalają) |
| Wymóg istnienia | Musi istnieć samodzielnie | Musi odwoływać się do fizycznie istniejącej wartości PK |

**Postacie normalne**

| Postać normalna | Warunek konieczny | Kluczowa reguła | Cel wdrożenia |
|---|---|---|---|
| 1NF | Tabela jest relacją | Zdefiniowany PK; wartości wyłącznie atomowe | Eliminacja struktur wielowartościowych |
| 2NF | Tabela jest w 1NF | Atrybuty niekluczowe zależą od **całego** PK (istotne przy kluczach złożonych) | Eliminacja częściowych zależności |
| 3NF | Tabela jest w 2NF | Atrybuty niekluczowe zależą **wyłącznie** od PK | Standard OLTP; wydajność INSERT i UPDATE |
| 4NF | Tabela jest w 3NF | Brak niezależnych atrybutów wielowartościowych (MVD) | Zaawansowana eliminacja anomalii |

### Typowe błędy i pułapki egzaminacyjne

- Traktowanie NULL jako równoznacznej z liczbą zero lub pustym tekstem. Wyrażenie `Wartość = NULL` zawsze zwraca fałsz.
- Zależność częściowa w 2NF może wystąpić **tylko** w przypadku kluczy złożonych — szukanie jej w tabelach z kluczem jednokolumnowym jest błędem.
- W 3NF należy odróżnić zależność od klucza głównego od zależności od innego atrybutu niekluczowego. Przykład: `employee_email` to cecha pracownika, nie zamówienia.

---

## Wykład 3 — Integralność danych i modele ERD

### Definicje i reguły obowiązkowe do zapamiętania

- **Integralność encji:** Klucz główny musi być unikalny i nie może zawierać wartości NULL. DBMS wymusza to automatycznie za pomocą indeksu unikalnego.
- **Spójność referencyjna:** Każda wartość FK musi fizycznie istnieć jako PK w tabeli nadrzędnej. Blokuje powstawanie rekordów osieroconych.
- **Klucz zastępczy (surrogate key):** Sztuczny, numeryczny klucz główny generowany automatycznie. Nie ma znaczenia biznesowego; stosowany, gdy brak klucza naturalnego lub gdy klucz naturalny jest złożony.

**Trzy poziomy modelowania:**

1. **Pojęciowy (CDM):** Wysoki poziom biznesowy, ogranicza się do ok. 20 najważniejszych pojęć i relacji.
2. **Logiczny (LDM):** Szczegółowy opis struktur (encje, atrybuty, dziedziny, relacje) niezależny od technologii.
3. **Fizyczny (PDM):** Konkretna implementacja techniczna (tabele, kolumny, typy danych, indeksy dla danego DBMS).

**Kardynalność relacji:** Minimalna wynosi 0 lub 1; maksymalna wynosi 1 lub Wiele (M).

**Relacja rekurencyjna:** Powiązanie encji z samą sobą, realizowane przez klucz obcy wskazujący na PK tej samej tabeli. Reprezentuje struktury hierarchiczne (np. podwładny–przełożony).

**Relacja XOR:** Encja może uczestniczyć tylko w jednym z wzajemnie wykluczających się powiązań (np. zamówienie posiada albo paragon, albo fakturę).

### Typowe błędy i pułapki egzaminacyjne

- Relacja M:N jest dozwolona wyłącznie w modelach pojęciowych i logicznych. W modelu fizycznym **musi** zostać rozbita na tabelę pośredniczącą z dwoma kluczami obcymi.
- Każde połączenie na diagramie ERD musi posiadać jednoznaczną etykietę czasownikową (np. *„składa się z"*). Stosowanie ogólników typu *„ma"* lub *„posiada"* jest błędem projektowym.
- Dane wynikające ze współdziałania dwóch encji (np. ocena studenta z danego kursu) nie mogą być samodzielną encją — muszą stanowić atrybut tabeli pośredniczącej w relacji M:N.

---

## Wykład 6 — Transakcje i model ACID

### Definicje i reguły obowiązkowe do zapamiętania

**Transakcja**

Sekwencja poleceń SQL, która musi zostać wykonana razem jako pojedyncza jednostka logiczna (np. transfer środków: odjęcie z jednego konta i dodanie na drugie).

**Model ACID**

| Cecha | Definicja |
|---|---|
| Atomicity (Atomowość) | Zasada „wszystko albo nic". Cała sekwencja jest zatwierdzana (COMMIT) albo w całości odrzucana (ROLLBACK). |
| Consistency (Spójność) | Baza danych po zakończeniu transakcji musi pozostać spójna i nie naruszać więzów integralności. |
| Isolation (Izolacja) | Niedokończone transakcje nie mogą wpływać na wyniki innych operacji. Zmiany są widoczne dopiero po zatwierdzeniu. |
| Durability (Trwałość) | Zmiany wynikające z zatwierdzonej transakcji są zapisywane na stałe i są odporne na awarie sprzętowe. |

**Reguły i polecenia SQL**

- `BEGIN TRANSACTION` — otwiera blok transakcji (wymagane w MS SQL Server; Oracle domyślnie traktuje koniec poprzedniej transakcji jako start nowej).
- `COMMIT` — trwale zapisuje wszystkie zmiany.
- `ROLLBACK` — cofa wszystkie niezatwierdzone zmiany do momentu rozpoczęcia transakcji lub do określonego punktu zapisu.
- **Dziennik transakcji (Transaction log):** Zapisuje informacje o prowadzonych operacjach. Pozwala zidentyfikować niedokończone transakcje i wycofać je podczas restartu serwera po awarii.
- W praktyce operacji DDL (tworzenie/usuwanie struktur) nie należy mieszać z operacjami DML (edycja danych) w ramach tej samej transakcji.

### Porównania i zestawienia

**Typy transakcji**

| Typ | Charakterystyka |
|---|---|
| Jawne (Explicit) | Kontrolowane manualnie przez `BEGIN TRANSACTION` oraz `COMMIT` lub `ROLLBACK`. |
| Niejawne (Implicit) | Pojedyncze instrukcje DML. System gwarantuje, że zmiana obejmie wszystkie pasujące wiersze lub nie zaktualizuje żadnego. |

### Typowe błędy i pułapki egzaminacyjne

- **Atomowość a Izolacja:** Atomowość chroni przed częściowym wykonaniem własnego skryptu. Izolacja chroni przed interakcją z działaniami innych użytkowników.
- **DDL w transakcji:** W MS SQL Server `ROLLBACK` usunie tabelę utworzoną przez `CREATE TABLE`. W Oracle DDL jest automatycznie zatwierdzane — `ROLLBACK` nie usunie tabeli.
- Transakcje nie poprawiają przepustowości bazy danych — wręcz przeciwnie, zapewnienie właściwości ACID zawsze zmniejsza maksymalną przepustowość, wymuszając kolejkowanie współbieżnych operacji.

---

## Wykład 8 — Indeksy i wydajność

### Definicje i reguły obowiązkowe do zapamiętania

- **Indeks:** Zapisywana na dysku struktura danych (zazwyczaj B-drzewo) służąca do przyspieszenia wyszukiwania (`WHERE`, `JOIN`) i sortowania (`ORDER BY`).
- **Klucz indeksowy:** Kolumna lub zestaw kolumn, na których zbudowana jest struktura indeksu.
- **Sterta (Heap):** Tabela bez indeksu zgrupowanego. Rekordy są zapisywane w sposób nieuporządkowany.
- Indeksy przyspieszają odczyt (SELECT), ale **spowalniają zapis** (INSERT, UPDATE, DELETE), ponieważ przy każdej modyfikacji DBMS musi zaktualizować drzewa indeksów.

**Kiedy tworzyć indeks:**

1. Aby wymusić unikalność klucza głównego.
2. **Zawsze na kluczach obcych** — przyspiesza JOIN i sprawdzanie więzów integralności.
3. W dużych tabelach (>1000 rekordów) dla kolumn często używanych w `WHERE` lub `ORDER BY`.
4. Gdy kolumna charakteryzuje się **wysoką selektywnością** (dużo unikalnych wartości).

### Porównania i zestawienia

**Indeks Zgrupowany (Clustered) vs. Niezgrupowany (Nonclustered)**

| Cecha | Indeks Zgrupowany | Indeks Niezgrupowany |
|---|---|---|
| Wpływ na dane | Wymusza fizyczne, posortowane ułożenie rekordów na dysku | Tworzy niezależną strukturę ze wskaźnikami do rekordów |
| Limit na tabelę | **Tylko 1** | Wiele |
| Zastosowanie | Zapytania zwracające zakresy danych (np. daty) | Precyzyjne wyszukiwanie po konkretnych atrybutach (PESEL, nazwisko) |

### Typowe błędy i pułapki egzaminacyjne

- Tabela może mieć **maksymalnie jeden** indeks zgrupowany, ponieważ fizycznie determinuje on kolejność zapisu całej tabeli na dysku.
- Zbyt duża liczba indeksów drastycznie obniża wydajność operacji DML.
- Indeks na kolumnie o **niskiej selektywności** (np. „Płeć") jest błędem — DBMS i tak przeskanuje połowę tabeli, tracąc dodatkowo czas na przeszukiwanie B-drzewa.
- Brak indeksu na FK powoduje, że przy każdej próbie usunięcia rekordu z tabeli nadrzędnej baza wykonuje pełne skanowanie tabeli podrzędnej.

---

## Wykład 9 — JDBC i programowanie baz danych

### Definicje i reguły obowiązkowe do zapamiętania

**JDBC (Java Database Connectivity)**

Standardowy interfejs API dla języka Java umożliwiający niezależne od platformy i bazy danych łączenie się z różnymi źródłami danych.

**Kluczowe interfejsy i klasy JDBC (pakiet `java.sql`):**

- `Connection` — reprezentuje sesję z bazą danych; służy do zarządzania transakcjami (`commit()`, `rollback()`).
- `Statement` — obiekt do uruchamiania statycznych zapytań SQL.
- `PreparedStatement` — wstępnie skompilowane zapytanie; plan wykonania jest cachowany po stronie DBMS, co przyspiesza ponowne wykonanie. Przyjmuje parametry przez znak `?`.
- `ResultSet` — tabela wyników zapytania zwracana przez `executeQuery()`; kursor przesuwany metodą `next()`.

**Pula połączeń (Connection Pooling)**

Mechanizm, w którym pula gotowych połączeń jest tworzona z góry i utrzymywana w pamięci. Metoda `getConnection()` pobiera istniejące połączenie z puli zamiast tworzyć nowe. Metoda `close()` nie zamyka fizycznego połączenia, lecz zwraca je do puli. Zapewnia istotny wzrost wydajności w aplikacjach wielodostępnych.

**SQL Injection**

Atak polegający na doklejeniu złośliwego kodu SQL do parametrów wejściowych budowanych przez konkatenację stringów. Jedyną skuteczną metodą obrony na poziomie JDBC jest stosowanie zapytań parametryzowanych (`PreparedStatement`).

### Porównania i zestawienia

**Metody nawiązywania połączenia**

| Cecha | DriverManager (Tradycyjna) | DataSource (Rekomendowana) |
|---|---|---|
| Parametry połączenia | Wpisane na sztywno w kodzie (hardcoded) | W zewnętrznym pliku konfiguracyjnym serwera |
| Pula połączeń | Brak | Wbudowana, zarządzana przez serwer aplikacji |
| Środowisko | Proste aplikacje desktopowe | Wymaga kontenera / serwera aplikacji |

### Typowe błędy i pułapki egzaminacyjne

- Jeśli zapytanie SQL ma być wykonywane wielokrotnie (np. w pętli), zawsze należy użyć `PreparedStatement`. Zwykły `Statement` zmusza DBMS do ponownej kompilacji przy każdym wywołaniu.
- Obiekty `Connection`, `Statement` oraz `ResultSet` muszą być zamykane jak najszybciej — wycieki zasobów blokują bazę.
- Automatyczne zamykanie `Connection` przez `try-with-resources` może wywołać niejawny commit lub rollback, zależnie od implementacji sterownika. Bezpieczniej jest zarządzać zatwierdzeniem transakcji jawnie przed zamknięciem połączenia.

---

## Wykład 11 — Współbieżność i izolacja transakcji

### Definicje i reguły obowiązkowe do zapamiętania

Pełna izolacja transakcji oznaczałaby wykonywanie ich szeregowo, co drastycznie obniżyłoby wydajność. Dlatego DBMS pozwala na zrównoleglenie operacji kosztem potencjalnych anomalii.

**Zakleszczenie (Deadlock)**

Sytuacja, w której dwie lub więcej transakcji blokują się nawzajem. Deadlock nie rozwiąże się sam — DBMS musi go wykryć i wykonać `ROLLBACK` na jednej z transakcji. Aby zapobiec zakleszczeniom, aplikacje muszą zawsze blokować zasoby w **tej samej kolejności**.

**Punkty zapisu (Save points)**

Mechanizm pozwalający na nałożenie etykiety wewnątrz długiej transakcji (np. `SAVE TRAN B`). Umożliwia częściowe cofnięcie zmian (`ROLLBACK TRAN B`) bez wycofywania całej transakcji. Częściowy rollback nie zwalnia blokad założonych przed punktem zapisu.

### Porównania i zestawienia

**Kluczowe anomalie transakcyjne**

| Anomalia | Opis |
|---|---|
| Dirty read (Brudny odczyt) | Odczyt danych zmienionych przez inną transakcję, która jeszcze nie wykonała COMMIT. |
| Lost update (Utracona aktualizacja) | Dwie transakcje odczytują tę samą wartość i nadpisują się nawzajem — zmiana pierwszej zostaje bezpowrotnie skasowana. |
| Non-repeatable read (Niepowtarzalny odczyt) | Ten sam rekord odczytany dwukrotnie daje różne wyniki, ponieważ inna transakcja zrobiła UPDATE lub DELETE. |
| Phantoms (Fantomy) | Powtórne wykonanie zapytania z WHERE zwraca inną liczbę wierszy, ponieważ inna transakcja wstawiła pasujące rekordy. |

**Poziomy izolacji w MS SQL Server**

| Poziom izolacji | Dirty read | Non-repeatable read | Phantoms |
|---|:---:|:---:|:---:|
| READ UNCOMMITTED | TAK | TAK | TAK |
| READ COMMITTED (częsty domyślny) | NIE | TAK | TAK |
| REPEATABLE READ | NIE | NIE | TAK |
| SERIALIZABLE | NIE | NIE | NIE |
| SNAPSHOT | NIE | NIE | NIE |

**Główne tryby blokad**

| Rodzaj blokady | Wyzwalacz | Skutek |
|---|---|---|
| Shared (Współdzielona) | `SELECT` | Inne transakcje mogą czytać, ale nie mogą modyfikować. |
| Exclusive (Wyłączna) | `INSERT`, `UPDATE`, `DELETE` | Nikt inny nie może ani modyfikować, ani (przy domyślnej izolacji) czytać danych. |

### Typowe błędy i pułapki egzaminacyjne

- **Non-repeatable read vs. Phantom:** Non-repeatable read — inna transakcja zrobiła UPDATE/DELETE istniejącego wiersza. Phantom — inna transakcja wstawiła nowy wiersz przez INSERT.
- Przy domyślnym poziomie izolacji transakcja próbująca odczytać wiersz zablokowany przez inną (Exclusive) zostanie wstrzymana do momentu COMMIT lub ROLLBACK.
- Wzorzec „Odczytaj-Zmień-Zapisz" w Javie (SELECT → modyfikacja zmiennej w RAM → UPDATE) bez blokad transakcyjnych prowadzi do anomalii **Lost update**.

---

## Wykład 12 — Procedury składowane i wyzwalacze

### Definicje i reguły obowiązkowe do zapamiętania

**Procedura składowana (Stored Procedure)**

Program napisany w języku proceduralnym bazy danych (np. T-SQL), przechowywany i uruchamiany bezpośrednio przez DBMS. Silnik bazy tworzy plan wykonania raz i cachuje go, eliminując narzut parsowania zapytań ad-hoc.

**Wyzwalacz (Trigger)**

Specjalny rodzaj procedury składowanej uruchamianej **automatycznie** jako reakcja na operacje `INSERT`, `UPDATE`, `DELETE` na określonej tabeli lub widoku. Jeśli jedno polecenie SQL modyfikuje wiele rekordów naraz, wyzwalacz uruchomi się **tylko raz** dla całej grupy wierszy.

**SQL Server Agent**

Wbudowana usługa MS SQL Server odpowiedzialna za automatyczne, cykliczne uruchamianie zadań (Jobs) o określonych porach.

### Porównania i zestawienia

**Architektura komunikacji: zapytania bezpośrednie vs. procedury składowane**

| Cecha | Zapytania bezpośrednie (Ad-hoc) | Procedury składowane |
|---|---|---|
| Ruch sieciowy | Wysoki — aplikacja ciągle wysyła tekst zapytania | Minimalny — aplikacja wysyła `EXEC`, przetwarzanie odbywa się na serwerze |
| Wydajność | Każde zapytanie parsowane i optymalizowane na nowo | Gotowy, skompilowany plan z pamięci cache |
| Bezpieczeństwo | Rozproszone — każda aplikacja ma bezpośredni dostęp do tabel | Centralne — można odebrać dostęp do tabel, zostawiając wyłącznie dostęp do SP |

**Typy wyzwalaczy w MS SQL Server**

| Typ | Moment wykonania | Główne zastosowanie |
|---|---|---|
| AFTER | Po pomyślnym wykonaniu operacji | Logowanie operacji, aktualizacja liczników |
| INSTEAD OF | Zamiast oryginalnej operacji | Modyfikacja danych przez nieedytowalne widoki |

### Typowe błędy i pułapki egzaminacyjne

- Wyzwalacz `AFTER INSERT` uruchomi się **dokładnie raz**, nawet jeśli `INSERT ... SELECT` wstawi 500 rekordów.
- Kod `SELECT CustomerId FROM inserted` zadziała poprawnie tylko przy wstawianiu jednego rekordu. Przy pakiecie rekordów pobierze losową wartość lub zgłosi błąd — w wyzwalaczach należy operować na całych tabelach `inserted`/`deleted` przy użyciu JOIN, a nie zmiennych skalarnych.
- Logika w T-SQL nie zadziała na Oracle (PL/SQL) ani MySQL — procedury składowane drastycznie ograniczają przenaszalność aplikacji.
- Kursory przetwarzają dane wiersz po wierszu — operacje zestawowe (set-based SQL) są zawsze wydajniejsze.

---

## Wykład 13 — Bazy rozproszone i replikacja

### Definicje i reguły obowiązkowe do zapamiętania

**Transakcje rozproszone (Distributed Transactions)**

Transakcja modyfikująca dane na więcej niż jednym serwerze bazodanowym, gwarantująca właściwości ACID. Realizowana przez **Dwufazowy protokół zatwierdzania (Two-Phase Commit — 2PC)**:

- **Faza 1 (Prepare):** Koordynator pyta wszystkie bazy: „Czy jesteście gotowe?"
- **Faza 2 (Commit):** Jeśli wszystkie odpowiedziały „TAK" — COMMIT wszędzie. Jeśli choć jedna odpowiedziała „NIE" — ROLLBACK wszędzie.

Wada: działają synchronicznie — awaria jednego serwera blokuje całą transakcję we wszystkich węzłach.

**Replikacja**

Asynchroniczne kopiowanie danych w tle, pozwalające uniknąć blokowania systemu przy awariach sieci między oddziałami.

### Porównania i zestawienia

**Typy replikacji**

| Typ | Mechanizm | Najlepsze zastosowanie |
|---|---|---|
| Transakcyjna | Agent nasłuchuje loga transakcyjnego i przesyła operacje SQL na bieżąco | Systemy wymagające krótkiego czasu opóźnienia (np. raportowanie w centrali) |
| Snapshot | Kopiuje całą tabelę w danym momencie; nie śledzi pojedynczych zmian | Dane zmieniające się rzadko i pobierane w całości (np. cenniki) |
| Merge | Obie strony mogą zmieniać dane niezależnie; system periodycznie łączy wersje | Handlowcy w terenie bez stałego dostępu do sieci |

**Klastry wysokiej dostępności (HA)**

| Model | Działanie | Zaleta / Wada |
|---|---|---|
| Active/Passive | Serwer B w trybie czuwania — przejmuje ruch po awarii serwera A | Prosta architektura; płacisz za serwer stojący bezczynnie |
| Active/Active | Oba serwery obsługują ruch jednocześnie (load balancing) | Pełne wykorzystanie sprzętu; przykład: Oracle RAC |

---

## Wykład 14 — OLTP vs. OLAP i hurtownie danych

### Definicje i reguły obowiązkowe do zapamiętania

**Modelowanie wymiarowe — kluczowe pojęcia:**

- **Fakt (Fact):** Pojedyncze zdarzenie biznesowe podlegające mierzeniu (np. sprzedaż produktu, zgłoszenie reklamacji).
- **Wymiar (Dimension):** Atrybut lub hierarchia atrybutów, według którego grupujemy fakty (np. Czas: rok → kwartał → miesiąc → dzień).
- **Miara (Measure):** Liczbowa wartość opisująca fakt, którą można agregować (np. wartość sprzedaży w PLN).

**Schemat Gwiazdy (Star Schema)**

Podstawowy model fizyczny w hurtowni. Centralna Tabela Faktów (klucze obce + miary liczbowe) otoczona Tabelami Wymiarów (opisy tekstowe). Tabele wymiarów nie są połączone między sobą.

**Kostka Danych (Data Cube)**

Wielowymiarowa reprezentacja danych. Krawędzie kostki to atrybuty wymiarów; komórki to wartości miar. Operacja **Drill-down** pozwala użytkownikowi zjechać w dół hierarchii wymiaru, aby zobaczyć więcej szczegółów.

### Porównania i zestawienia

**OLTP vs. OLAP**

| Cecha | OLTP | OLAP |
|---|---|---|
| Główny cel | Obsługa bieżących operacji firmy | Wsparcie decyzji, analiza trendów, raportowanie |
| Dane | Aktualne; starsze dane są archiwizowane | Historyczne, z wielu lat, połączone z wielu systemów |
| Optymalizacja | Szybkie zapisy (INSERT, UPDATE) | Ciężkie zapytania agregujące (SELECT, GROUP BY) |
| Struktura | Mocno znormalizowana | Zdenormalizowana; modelowanie wymiarowe |

**Proces analityczny (ETL pipeline)**

Systemy źródłowe → ETL (Extract, Transform, Load) → Data Warehouse → OLAP / Kostki danych → Business Intelligence (BI)

Uwaga: posiadanie Data Warehouse nie oznacza posiadania systemu BI. DWH to zaplecze (dane), BI to interfejs użytkownika.

---

## Wykład 15 — Big Data i Hadoop

### Definicje i reguły obowiązkowe do zapamiętania

**Zasada 3V (Gartner)**

- **Volume:** Ogromna ilość danych (terabajty, petabajty).
- **Velocity:** Dane napływają błyskawicznie i muszą być analizowane w czasie bliskim rzeczywistemu.
- **Variety:** Dane nieustrukturyzowane lub na wpół ustrukturyzowane (logi serwerów, posty z mediów społecznościowych, dane z czujników IoT).

**Apache Hadoop**

Rozproszony system operacyjny dla gigantycznych zbiorów danych. Filozofia: zamiast przesyłać dane do programu (co zapycha sieć), wysyłamy mały program wprost do danych.

Kluczowe komponenty:
- **HDFS (Hadoop Distributed File System):** Pozwala traktować setki dysków na różnych serwerach jak jeden folder. Automatycznie dzieli i replikuje pliki (zazwyczaj 3 kopie).
- **MapReduce:** Silnik przetwarzania danych. Rozdziela zadania analityczne na mniejsze porcje i każdy węzeł przetwarza swój lokalny fragment.

### Porównania i zestawienia

**Skalowanie RDBMS vs. Big Data**

| Cecha | RDBMS | Big Data / Sharding |
|---|---|---|
| Skalowanie | W górę — zakup coraz potężniejszych serwerów | Poziome — setki tanich komputerów połączonych w klaster |
| Architektura dysków | Shared disk — węzły współdzielą macierze dyskowe | Shared-nothing — każdy węzeł ma własny, lokalny dysk |
| Integralność danych | Pełna integralność referencyjna | Brak ścisłej integralności; stawiamy na elastyczność i szybkość |

**Schema-on-Write vs. Schema-on-Read**

- **Schema-on-Write (RDBMS):** Przed wstawieniem danych należy zaprojektować sztywną strukturę tabel i kolumn.
- **Schema-on-Read (Hadoop):** Dane wrzucamy do HDFS w dowolnej formie; o strukturze i znaczeniu decydujemy dopiero w momencie odczytu i analizy.

---

## Wykład 16 — NoSQL i twierdzenie CAP

### Definicje i reguły obowiązkowe do zapamiętania

**NoSQL = „Not Only SQL"**

Wiele baz NoSQL posiada własne dialekty podobne do SQL. Główne cechy: brak sztywnego schematu zdefiniowanego z góry (schemat istnieje jako **domniemany** w kodzie aplikacji) oraz skalowalność pozioma w klastrach.

**Twierdzenie CAP (Brewer)**

System rozproszony opiera się na trzech właściwościach, z których można mieć **tylko dwie naraz**:

- **C (Consistency):** Każdy odczyt zwraca absolutnie najnowszą zapisaną wartość.
- **A (Availability):** Każde zapytanie dostaje odpowiedź inną niż błąd, nawet przy awarii części systemu.
- **P (Partition Tolerance):** System działa, nawet jeśli padnie sieć między serwerami.

W rzeczywistych systemach rozproszonych awarie sieci (P) są nieuniknione, dlatego wybiera się między architekturą CP (poświęca dostępność) a AP (poświęca ścisłą spójność na rzecz *Eventual Consistency*).

**Apache Cassandra — architektura Masterless**

Każdy węzeł jest równy — brak serwera nadrzędnego i pojedynczego punktu awarii. Hierarchia: Klaster → Centra Danych → Stelaże → Węzły. System automatycznie unika zapisywania replik w tym samym stelażu.

### Porównania i zestawienia

**Cztery główne rodziny baz NoSQL**

| Typ | Zasada działania | Przykłady |
|---|---|---|
| Klucz-Wartość | Pobieranie danych przez unikalny klucz | Redis, Riak |
| Dokumentowe | Dane w dokumentach JSON; baza może analizować wnętrze dokumentu | MongoDB, RavenDB |
| Rodziny Kolumn | Wiersze z różną liczbą i rodzajem kolumn; grupowanie w rodziny | Apache Cassandra, HBase |
| Grafowe | Węzły i krawędzie; szybkie przeszukiwanie sieci powiązań; działają na jednym serwerze i **wspierają pełne ACID** | Neo4j, FlockDB |

**Podejście do agregatów**

| Podejście | Bazy | Zaleta | Wada |
|---|---|---|---|
| Aggregate-based | MongoDB, Cassandra | Rewelacyjne dla shardingu; cały agregat na jednym węźle | Brak pełnych transakcji ACID między różnymi agregatami |
| Aggregate-ignorant | RDBMS, bazy grafowe | Pełne transakcje ACID obejmujące wiele tabel | Trudniejsze do rozproszenia w klastrze |

**Kiedy co wybrać**

| Cecha | RDBMS | Apache Hadoop | NoSQL |
|---|---|---|---|
| Główne zastosowanie | ERP, systemy finansowe i księgowe | Przetwarzanie wsadowe gigantycznych zbiorów plików i logów | Szybki losowy dostęp do wielkich danych (profile użytkowników, clickstream) |
| Transakcje ACID | Pełne wsparcie | Brak | Ograniczone — zazwyczaj tylko na poziomie jednego rekordu |
| Integralność | Baza pilnuje rygorystycznie | Aplikacja pilnuje we własnym kodzie | Aplikacja pilnuje we własnym kodzie |

---

## Wykład 17 — Oracle Net Services

### Definicje i reguły obowiązkowe do zapamiętania

**TNS (Transparent Network Substrate)**

Technologia będąca fundamentem Oracle Net. Sprawia, że połączenia są niezależne od systemu operacyjnego i warstwy transportowej. Domyślny protokół to TCP/IP na porcie **1521**.

**Oracle Net Listener**

Proces uruchomiony na serwerze, który nasłuchuje przychodzących żądań od klientów. Po odebraniu pakietu `CONNECT` uruchamia dedykowany proces serwera (`server process`), który od tej pory przejmuje obsługę danej sesji. Jeden Listener może obsługiwać wiele instancji bazy danych. Wyłączenie Listenera nie przerywa istniejących sesji — blokuje jedynie nawiązywanie nowych połączeń.

**Pliki konfiguracyjne** (standardowa lokalizacja: `<oracle_home>/network/admin/`)

| Plik | Strona | Zadanie |
|---|---|---|
| `sqlnet.ora` | Klient/Serwer | Ogólne reguły Oracle Net; preferowane metody rozwiązywania nazw |
| `tnsnames.ora` | Klient | Mapowanie aliasów na pełne deskryptory połączeń (IP, port, nazwa instancji) |
| `listener.ora` | Serwer | Definicja procesów nasłuchujących, ich portów i obsługiwanych instancji (SID) |

**Metody rozwiązywania nazw**

- **Easy Connect:** Nie wymaga konfiguracji po stronie klienta. Składnia: `użytkownik/hasło@host:port/service_name`. Ograniczona do TCP/IP.
- **Local Naming:** Korzysta z pliku `tnsnames.ora`; najczęstsza metoda w środowiskach firmowych.
- **Directory Naming:** Centralny serwer LDAP; administrator zmienia adres serwera w jednym miejscu zamiast edytować `tnsnames.ora` na każdej stacji roboczej.
- **External Naming:** Integracja z zewnętrznymi systemami nazw (np. NIS).

**Narzędzia konsolowe**

- `lsnrctl start/stop/status` — zarządzanie Listenerem.
- `tnsping <alias>` — testuje komunikację do Listenera. Ważne: potwierdza jedynie, że Listener „żyje" — nie sprawdza, czy instancja bazy danych działa poprawnie.

---

## Wykład 18 — Bezpieczeństwo i audyt

### Definicje i reguły obowiązkowe do zapamiętania

**Zasada Najmniejszych Uprawnień**

Użytkownik lub aplikacja powinni mieć tylko takie uprawnienia, jakie są im absolutnie niezbędne. Nieużywane konta muszą być zablokowane (`account lock`). Wszystko nadane pseudo-użytkownikowi `PUBLIC` staje się dostępne dla każdego użytkownika — np. uprawnienie do pakietu `UTL_FILE` (czytanie i zapisywanie plików OS) nie może być publiczne.

**Architektura bezpieczeństwa Oracle**

1. **Konta użytkowników** — unikalne tożsamości w bazie.
2. **Uprawnienia systemowe** — operacje w skali całej bazy (np. `CREATE TABLE`).
3. **Uprawnienia obiektowe** — dotyczą konkretnego obiektu (np. `SELECT ON HR.EMPLOYEES`).
4. **Role** — nazwane zestawy uprawnień przypisywane użytkownikom zamiast nadawania każdego uprawnienia osobno.
5. **Profile** — ograniczają zasoby sprzętowe i wymuszają politykę haseł.

**Parametry profilu — polityka haseł**

| Parametr | Działanie |
|---|---|
| `FAILED_LOGIN_ATTEMPTS` | Liczba nieudanych prób logowania przed zablokowaniem konta |
| `PASSWORD_LOCK_TIME` | Czas blokady konta w dniach |
| `PASSWORD_LIFE_TIME` | Cykl życia hasła; po jego upływie system wymusi zmianę |
| `PASSWORD_VERIFY_FUNCTION` | Funkcja PL/SQL sprawdzająca złożoność nowego hasła |

**Parametr `AUDIT_TRAIL`** (wymaga restartu bazy):

| Wartość | Działanie |
|---|---|
| `NONE` / `FALSE` | Audyt wyłączony |
| `OS` | Logi w plikach systemu operacyjnego |
| `DB` / `TRUE` | Logi w tabeli systemowej `SYS.AUD$` |
| `DB_EXTENDED` | Jak `DB`, dodatkowo zapisuje treść zapytań SQL ze zmiennymi |

**Ewolucja metod audytu**

| Metoda | Możliwości | Ograniczenia |
|---|---|---|
| Audyt Standardowy | Monitorowanie komend, błędnych logowań | Brak rejestrowania wartości kolumn |
| Trigger-based (Value-based) | Stare i nowe wartości przy UPDATE | Nie monitoruje SELECT; obciąża bazę |
| Fine-Grained Auditing (FGA) | SELECT i DML dla konkretnych kolumn lub warunków | Wymaga konfiguracji pakietem `DBMS_FGA` |
| Unified Auditing | Logi ze wszystkich źródeł w jednej tabeli tylko do odczytu (schemat `AUDSYS`) | Nowoczesne podejście, najkompletniejsze |

### Typowe błędy i pułapki egzaminacyjne

- **Shadow Data:** Wyciąganie wrażliwych danych z bazy i zapisywanie ich w plikach CSV/Excel na stacjach roboczych.
- **Konta z nadmiernymi uprawnieniami:** Aplikacja łącząca się z bazą jako `DBA`.
- **SQL Injection:** Konkatenacja danych użytkownika z tekstem zapytania.

---

## Wykład 19 — Przestrzenne bazy danych (GIS)

### Definicje i reguły obowiązkowe do zapamiętania

Przestrzenne bazy danych (geobazy) przechowują współrzędne geograficzne obiektów i oferują narzędzia do ich przetwarzania. Dane prezentowane są w formie map numerycznych podzielonych na **warstwy (layers)** — kolekcje obiektów tej samej kategorii.

**Warstwy rastrowe (Raster)**

Siatki pikseli przypisane do współrzędnych geograficznych. Przykłady: zdjęcia satelitarne, ortofotomapy. Służą głównie jako podkład mapowy; nie pozwalają na zaawansowane analizy przestrzenne.

**Warstwy wektorowe (Vector)**

Kolekcje obiektów matematycznych z geometrią, współrzędnymi i tabelą atrybutów opisowych. Można je skalować bez utraty jakości. Trzy podstawowe typy geometrii:

- **Punkt (Point):** hydrant, drzewo, punkt adresowy
- **Linia łamana (Polyline):** rzeka, droga, kabel energetyczny
- **Wielobok (Polygon):** obrys budynku, granica działki, jezioro

**Przechowywanie danych GIS**

- **Podejście plikowe:** Formaty ESRI Shapefile (`.shp`), CAD (`.dxf`). Wada: brak możliwości jednoczesnej edycji przez wielu użytkowników; plik zostaje zablokowany przez pierwszego edytującego.
- **Podejście korporacyjne:** Dane przestrzenne przechowywane w RDBMS (np. Oracle Spatial, MS SQL Server). Pełna kontrola uprawnień, transakcyjność, wersjonowanie, praca setek użytkowników jednocześnie.

**Standardy OGC (komunikacja sieciowa)**

| Standard | Co przesyła | Zastosowanie |
|---|---|---|
| WMS (Web Map Service) | Gotowy obrazek (kafle rastrowe) | Podkłady mapowe; lekkie dla klienta |
| WFS (Web Feature Service) | Surowe dane wektorowe (współrzędne i atrybuty) | Klikanie w obiekty, edycja, sprawdzanie atrybutów |

### Zastosowania w przedsiębiorstwach użyteczności publicznej

GIS pozwala łączyć atrybuty przestrzenne z opisowymi, np.: „Znajdź wszystkie budynki betonowe w odległości mniejszej niż 100 m od rzeki". Przykłady korzyści: modelowanie sieci wodociągowych, automatyczne wskazywanie zaworów do zamknięcia przy awarii, planowanie inwestycji na podstawie przepustowości istniejącej sieci.

---

## Wykład 20 — Bazy wektorowe i embeddings

### Definicje i reguły obowiązkowe do zapamiętania

**Problem tradycyjnych RDBMS**

Operator `LIKE` szuka dokładnych dopasowań znaków — baza nie rozumie semantyki. Nie potrafi stwierdzić, że „pies" i „szczeniak" znaczą to samo, ani wyszukać podobnych obrazów.

**Embeddings (Osadzenia)**

Proces konwersji tekstu, obrazu lub dźwięku na wektor o dużej liczbie wymiarów za pomocą modeli uczenia maszynowego (np. SBERT). Wektorowe DBMS (VDBMS) przechowują te wektory i umożliwiają błyskawiczne wyszukiwanie wektorów „najbliższych" do zapytania użytkownika.

**Ekosystem baz wektorowych**

- **Dedykowane bazy:** Pinecone, Milvus, Qdrant.
- **Rozszerzenia dla RDBMS:** PostgreSQL + `pgvector` — tradycyjne dane tabelaryczne i wektory w jednym miejscu.

**Miary podobieństwa (pgvector)**

| Miara | Operator | Opis |
|---|---|---|
| Odległość Euklidesowa (L₂) | `<->` | Odległość w linii prostej między dwoma wektorami |
| Podobieństwo Kosinusowe | `<=>` | Kąt między wektorami; ignoruje długość wektora |

Przykład zapytania:

```sql
SELECT * FROM items ORDER BY embedding <=> '[3,2,2.5]' LIMIT 2;
```

**Typy wyszukiwania wektorowego**

- **Exact search (kNN — k-Nearest Neighbors):** Porównanie z każdym rekordem. Gwarantuje idealny wynik, ale zbyt wolne przy miliardach wektorów.
- **Approximate search (ANN — Approximate Nearest Neighbor):** Algorytmy grafów lub podziału przestrzeni na klastry. Kosztem minimalnego spadku precyzji odpowiedzi w milisekundach.

---

*Powodzenia na egzaminie.*
