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

![Equivalent Circuit](https://github.com/Kacper-Hoffman/Electrical-Motor/blob/main/equivalent_circuit.png)

![Matrix Equation](https://github.com/Kacper-Hoffman/Electrical-Motor/blob/main/matrix.png)

![Reversed Matrix Equation](https://github.com/Kacper-Hoffman/Electrical-Motor/blob/main/reverse_matrix.png)

![Equations](https://github.com/Kacper-Hoffman/Electrical-Motor/blob/main/equations.png)

## Symulacja
Do narysowania silnika użyto komend z Octave. Posiada on szereg funkci służących do rysowania komponentów w FEMM. Na początku należy programistycznie otworzyć FEMM, stworzyć nowy problem magnetyczny oraz zdefiniować problem. Tak wpisuje się dane początkowe, tj. częstotliwość, jednostkę długości, typ symulacji, dokładność oraz kąt siatki dyskretyzacyjnej. W naszym przypadku warto również wyłączyć Smart Mesh. Ta opcja tworzy bardzo dokładną siatkę dyskretyzacyjną, ale dla modeli dużych ona bardzo spowalnia obliczenia. Nie potrzebujemy tutaj wyjątkowo dokładnej siatki, ponieważ dokładność z definicji problemu wystarcza całkowicie. Następnie rysuje się jeden żłobek stojana, wypełnia materiałem i prądem a na koniec kopiuje względem symetrii promieniowej. Proces ten powtarza się dla żłobka wirnika. Poniżej fragment użytego kodu.

```
 %Otwarcie FEMM
 openfemm();
 %Otwarcie nowego problemu magnetycznego
 newdocument(0);
 %Definicja problemu
 mi_probdef(fs,'meters','planar',1.e-8,le,30);
 %Wylaczenie Smart Mesh
 %Smart Mesh generuje bardzo dokladna siatke,
 %ale dla duzych modeli bardzo spowalnia analize
 smartmesh(0);
 %Rysowanie stojana
 mi_drawarc(center+rse,center,center,center+rse,90,1);
 mi_drawarc(center,center+rse,center-rse,center,90,1);
 mi_drawarc(center-rse,center,center,center-rse,90,1);
 mi_drawarc(center,center-rse,center+rse,center,90,1);
 %Rysowanie zlobka stojana
 mi_drawline(center-bs1/2,sypoint+hs1,center-3*bs1/4,sypoint+hs2);
 mi_drawline(center-3*bs1/4,sypoint+hs2,centerds2/2,sypoint+hs3);
 mi_drawarc(center+ds2/2,sypoint+hs3,centerds2/2,sypoint+hs3,180);
 mi_drawline(center+ds2/2,sypoint+hs3,center+3*bs1/4,sypoint+hs2);
 mi_drawline(center+3*bs1/4,sypoint+hs2,center+bs1/2,sypoint+hs1);
 mi_drawline(center-bs1/2,sypoint,center-bs1/2,sypoint+hs1);
 mi_drawline(center+bs1/2,sypoint,center+bs1/2,sypoint+hs1);
```

Po narysowaniu silnika możliwe jest wykonanie symulacji. Tutaj w tym celu zastosowano kompatybilność Octave-FEMM. Octave wysyła do FEMM komendę do wykonania obliczeń wstępnych metodą elementów skończonych. Potem pobiera on dane wynikowe oraz wykonuje obliczenia wcześniej określone do wyznaczenia parametrów silnika. Na sam koniec wykonuje się zmianę parametru w modelu i obliczenia są powtarzane. Poniżej przedstawiono wyniki analizy porównawczej dla następujących wartości zmiennych: napięcie zasilania, częstotliwość zasilania, ilość żłobków wirnika oraz prąd zasilania.

![Full](https://github.com/Kacper-Hoffman/Electrical-Motor/blob/main/full_results.png)

![Compare Voltage](https://github.com/Kacper-Hoffman/Electrical-Motor/blob/main/results_compare_0908Un.png)

![Compare Frequency](https://github.com/Kacper-Hoffman/Electrical-Motor/blob/main/results_compare_0908fs.png)

![Compare Rotor Slots](https://github.com/Kacper-Hoffman/Electrical-Motor/blob/main/results_compare_6468Qr.png)

![Compare Current](https://github.com/Kacper-Hoffman/Electrical-Motor/blob/main/results_compare_Un33A.png)

Uzyskane wyniki symulacji są zgodne z teoretycznymi założeniami. Pełny opis użytego kodu z Octave oraz szczegóły obliczeń dostępne są z ![moim projekcie](https://github.com/Kacper-Hoffman/Electrical-Motor/blob/main/Kacper%20Hoffman%20-%20FEMM%20Projekt.pdf).

---
# Three phase squirrel-cage motor model - FEMM 🇬🇧
## Introduction
Created as part of laboratory classes, this model is used to simulate the behaviour of a three phase quirrel cage motor in different power supply conditions and different construction details. Due to the large amount of components necessary and compex calculations I have used a companion program - Octave. Octave is used mainly to preform complicated mathematical calculations, but it's also compatible with FEMM. Several lines of code allow you to create even a very advanced model of an electric motor. Instead or drawing each slot independently you can simply draw one slot and then copy it in accordance with radial symmetry. Octave can simulate the process of simulation and calculation. Those calculations were used to determine how the motor's behaviour.
## Model
As mentioned before, we are simulating a three phase squirrel cage motor. It's main parameters are its rated power Pn = 90 kW, voltage Un = 985 V with frequency f = 50 Hz, rated current In = 170 A. It has three phases m = 3 and three poles p = 3. The synchronic speed of such a motor is ns = 1000 obr/min, while it's rated speed from catalogue is ns = 850 obr/min. Using approximate equations the physical dimensions of the motor were calculated. It's effective length is le = 1.86 m, shaft length H = 315 mm, stator radii Rse = 260 mm and R = 190, rotor radius R = 190, gap δ = 0.8 mm. Slots themselves are geometrically complex and have only been described in the project.

![Model](https://github.com/Kacper-Hoffman/Electrical-Motor/blob/main/full.png)

![Quarter](https://github.com/Kacper-Hoffman/Electrical-Motor/blob/main/quarter.png)

![Stator](https://github.com/Kacper-Hoffman/Electrical-Motor/blob/main/stator_cog.png)

![Rotor](https://github.com/Kacper-Hoffman/Electrical-Motor/blob/main/rotor_cog.png)

## Calculations
The calculations in this project are based on the Steinmetz equivalent circuit. This model represents the winding resistance, leakage reactance, magnetization reactance and the equivalent resistance of power losses in the rotor as elements of an electric circuit. This approach allows us to calculate the matrix equation of the motor, and with it the rest of important parameters of the motor. After all the mathematical transformation we get the following equations:

![Equivalent Circuit](https://github.com/Kacper-Hoffman/Electrical-Motor/blob/main/equivalent_circuit.png)

![Matrix Equation](https://github.com/Kacper-Hoffman/Electrical-Motor/blob/main/matrix.png)

![Reversed Matrix Equation](https://github.com/Kacper-Hoffman/Electrical-Motor/blob/main/reverse_matrix.png)

![Equations](https://github.com/Kacper-Hoffman/Electrical-Motor/blob/main/equations.png)

## Simulation
To draw the motor we used Octave. It has many commands used to draw elements in FEMM. At first we have to programmatically open FEMM, create a new magnetic problem and define it. This way we input the base values, such as frequency, unit of length, type of symulation, accuracy and the angle of the discretisation mesh. In our case we should also turn off the Smart Mesh. This option creates a very accurate mesh, but for larger models it significantly slows down calculations. We don't need it, because the previously defined accuracy if good enough. Then we draw one stator slot, fill it with material and current and copy it with radial symmetry. This process is repeated for the rotor slot. Below is a fragment of the used code.

```
 %Otwarcie FEMM
 openfemm();
 %Otwarcie nowego problemu magnetycznego
 newdocument(0);
 %Definicja problemu
 mi_probdef(fs,'meters','planar',1.e-8,le,30);
 %Wylaczenie Smart Mesh
 %Smart Mesh generuje bardzo dokladna siatke,
 %ale dla duzych modeli bardzo spowalnia analize
 smartmesh(0);
 %Rysowanie stojana
 mi_drawarc(center+rse,center,center,center+rse,90,1);
 mi_drawarc(center,center+rse,center-rse,center,90,1);
 mi_drawarc(center-rse,center,center,center-rse,90,1);
 mi_drawarc(center,center-rse,center+rse,center,90,1);
 %Rysowanie zlobka stojana
 mi_drawline(center-bs1/2,sypoint+hs1,center-3*bs1/4,sypoint+hs2);
 mi_drawline(center-3*bs1/4,sypoint+hs2,centerds2/2,sypoint+hs3);
 mi_drawarc(center+ds2/2,sypoint+hs3,centerds2/2,sypoint+hs3,180);
 mi_drawline(center+ds2/2,sypoint+hs3,center+3*bs1/4,sypoint+hs2);
 mi_drawline(center+3*bs1/4,sypoint+hs2,center+bs1/2,sypoint+hs1);
 mi_drawline(center-bs1/2,sypoint,center-bs1/2,sypoint+hs1);
 mi_drawline(center+bs1/2,sypoint,center+bs1/2,sypoint+hs1);
```

After drawing the motor we can begin the simulation. Here we also use the Octave-FEMM compatibility. Octave sends to FEMM the command to begin finite element method calculations. Then it takes the results and uses them to calculate motor parameters. Finally it changes one parameter of the model and repeats the calculations. Below are the results of calculations for the following changed parameters: supply voltage, frequency, number of rotor slots and the supply current.

![Full](https://github.com/Kacper-Hoffman/Electrical-Motor/blob/main/full_results.png)

![Compare Voltage](https://github.com/Kacper-Hoffman/Electrical-Motor/blob/main/results_compare_0908Un.png)

![Compare Frequency](https://github.com/Kacper-Hoffman/Electrical-Motor/blob/main/results_compare_0908fs.png)

![Compare Rotor Slots](https://github.com/Kacper-Hoffman/Electrical-Motor/blob/main/results_compare_6468Qr.png)

![Compare Current](https://github.com/Kacper-Hoffman/Electrical-Motor/blob/main/results_compare_Un33A.png)

These results are comparable to theoretical values. Full description of the used code and details of calculations are available in ![my project (🇵🇱 only)](https://github.com/Kacper-Hoffman/Electrical-Motor/blob/main/Kacper%20Hoffman%20-%20FEMM%20Projekt.pdf).
