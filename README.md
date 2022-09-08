⚠️ WIP ⚠️
# Model silnika klatkowego trójfazowego - FEMM 🇵🇱
## Wstęp
Stworzony w ramach zajęć laboratoryjnych, model ten służy do symulacji zachowania silnika klatkowego trójfazowego w różnych warunkach zasilania oraz dla różnych wariantów konstrukcyjnych. Ze względu na dużą ilość komponentów oraz wymagane obliczenia model został stworzony przy pomocy programu pobocznego - Octave. Octave jest programem służącym głównie do wykonywania skomplikowanych obliczeń numerycznych, ale posiada on również kompatybilność z FEMM. Kilkanaście linijek kodu w Octave pozwala dokładnie narysować model silnika nawet dla rozbudowanych żłobków w nietypowych położeniach. Zamiast rysować każdy żłobek osobno, wystarczy narysować jeden żłobek z przypisanym materiałem i skopiować go względem symetrii promieniowej. Octave jest w stanie również zautomatyzować proces symulacyjno-obliczeniowy. Wykonane obliczenia pozwoliły na analizę zachowania silnika.
## Model
Jak wspomniano wcześniej, symulowany jest silnik trójfazowy klatkowy. Jego główne parametry to moc znamionowa Pn = 90 kW, napięcie znamionowe Un = 985 V o częstotliwości f = 50 Hz, prąd znamionowy In = 170 A. Posiada on trzy fazy m = 3 oraz trzy bieguny p = 3. Prędkość synchroniczna takiego silnika to ns = 1000 obr/min, a znamionowa z katalogu wynosi ns = 850 obr/min. Wzorami przybliżonymi wyznaczono rozmiary fizyczne silnika. Jego długość efektywna to le = 1.86 m, wnios wału H = 315 mm, promienie wała Rse = 260 mm oraz R = 190, promień wirnika R = 190, szczelina δ = 0.8 mm. Żłobki silnika są skomplikowanymi elementami których rozmiary zamieszczono tylko w projekcie.

![Model](https://github.com/Kacper-Hoffman/Electrical-Motor/blob/main/full.png)

![Quarter](https://github.com/Kacper-Hoffman/Electrical-Motor/blob/main/quarter.png)

![Stator](https://github.com/Kacper-Hoffman/Electrical-Motor/blob/main/stator_cog.png)

![Rotor](https://github.com/Kacper-Hoffman/Electrical-Motor/blob/main/rotor_cog.png)

## Obliczenia
Obliczenia wykonane w tym projekcie bazują na modelu zastępczym Steinmetza. Ten model reprezentuje rezystancję uzwojenia, reaktancje rozproszenia, reaktancję magnetyzacji oraz rezystancję zastępczą strat czynnych wirnika jako elementy układu elektrycznego. Takie podejście pozwala na wyznaczenie równania macierzowego silnika a z niego pozostałe ważne parametry. Po wykonaniu wszystkich przekształceń uzyskujemy poniższe równania:

![Matrix Equation](https://github.com/Kacper-Hoffman/Electrical-Motor/blob/main/matrix.png)

![Reversed Matrix Equation](https://github.com/Kacper-Hoffman/Electrical-Motor/blob/main/reverse_matrix.png)

![Equations](https://github.com/Kacper-Hoffman/Electrical-Motor/blob/main/equations.png)

## Symulacja
Do narysowania silnika użyto komend z Octave. Posiada on szereg funkci służących do rysowania komponentów w FEMM. Na początku należy programistycznie otworzyć FEMM, stworzyć nowy problem magnetyczny oraz zdefiniować problem. Tak wpisuje się dane początkowe, tj. częstotliwość, jednostkę długości, typ symulacji, dokładność oraz kąt siatki dyskretyzacyjnej. W naszym przypadku warto również wyłączyć Smart Mesh. Ta opcja tworzy bardzo dokładną siatkę dyskretyzacyjną, ale dla modeli dużych ona bardzo spowalnia obliczenia. Nie potrzebujemy tutaj wyjątkowo dokładnej siatki, ponieważ dokładność z definicji problemu wystarcza całkowicie. Następnie rysuje się jeden żłobek stojana, wypełnia materiałem i prądem a na koniec kopiuje względem symetrii promieniowej. Proces ten powtarza się dla żłobka wirnika.

Po narysowaniu silnika możliwe jest wykonanie symulacji. Tutaj w tym celu zastosowano kompatybilność Octave-FEMM. Octave wysyła do FEMM komendę do wykonania obliczeń wstępnych metodą elementów skończonych. Potem pobiera on dane wynikowe oraz wykonuje obliczenia wcześniej określone do wyznaczenia parametrów silnika. Na sam koniec wykonuje się zmianę parametru w modelu i obliczenia są powtarzane. Poniżej przedstawiono wyniki analizy porównawczej dla następujących wartości zmiennych: napięcie zasilania, częstotliwość zasilania, ilość żłobków wirnika oraz prąd zasilania.

![Full](https://github.com/Kacper-Hoffman/Electrical-Motor/blob/main/full_results.png)

![Compare Voltage](https://github.com/Kacper-Hoffman/Electrical-Motor/blob/main/results_compare_0908Un.png)

![Compare Frequency](https://github.com/Kacper-Hoffman/Electrical-Motor/blob/main/results_compare_0908fs.png)

![Compare Rotor Slots](https://github.com/Kacper-Hoffman/Electrical-Motor/blob/main/results_compare_6468Qr.png)

![Compare Current](https://github.com/Kacper-Hoffman/Electrical-Motor/blob/main/results_compare_Un33A.png)

Uzyskane wyniki symulacji są zgodne z teoretycznymi założeniami. Pełny opis użytego kodu z Octave oraz szczegóły obliczeń dostępne są z ![moim projekcie](https://github.com/Kacper-Hoffman/Electrical-Motor/blob/main/Kacper%20Hoffman%20-%20FEMM%20Projekt.pdf).

---
# Three phase squirrel-cage motor model - FEMM 🇬🇧
