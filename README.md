# Model silnika klatkowego tr贸jfazowego - FEMM 馃嚨馃嚤
## Wst臋p
Stworzony w ramach zaj臋膰 laboratoryjnych, model ten s艂u偶y do symulacji zachowania silnika klatkowego tr贸jfazowego w r贸偶nych warunkach zasilania oraz dla r贸偶nych wariant贸w konstrukcyjnych. Ze wzgl臋du na du偶膮 ilo艣膰 komponent贸w oraz wymagane obliczenia model zosta艂 stworzony przy pomocy programu pobocznego - Octave. Octave jest programem s艂u偶膮cym g艂贸wnie do wykonywania skomplikowanych oblicze艅 numerycznych, ale posiada on r贸wnie偶 kompatybilno艣膰 z FEMM. Kilkana艣cie linijek kodu w Octave pozwala dok艂adnie narysowa膰 model silnika nawet dla rozbudowanych 偶艂obk贸w w nietypowych po艂o偶eniach. Zamiast rysowa膰 ka偶dy 偶艂obek osobno, wystarczy narysowa膰 jeden 偶艂obek z przypisanym materia艂em i skopiowa膰 go wzgl臋dem symetrii promieniowej. Octave jest w stanie r贸wnie偶 zautomatyzowa膰 proces symulacyjno-obliczeniowy. Wykonane obliczenia pozwoli艂y na analiz臋 zachowania silnika.
## Model
Jak wspomniano wcze艣niej, symulowany jest silnik tr贸jfazowy klatkowy. Jego g艂贸wne parametry to moc znamionowa Pn = 90 kW, napi臋cie znamionowe Un = 985 V o cz臋stotliwo艣ci f = 50 Hz, pr膮d znamionowy In = 170 A. Posiada on trzy fazy m = 3 oraz trzy bieguny p = 3. Pr臋dko艣膰 synchroniczna takiego silnika to ns = 1000 obr/min, a znamionowa z katalogu wynosi ns = 850 obr/min. Wzorami przybli偶onymi wyznaczono rozmiary fizyczne silnika. Jego d艂ugo艣膰 efektywna to le = 1.86 m, wnios wa艂u H = 315 mm, promienie wa艂a Rse = 260 mm oraz R = 190, promie艅 wirnika R = 190, szczelina 未 = 0.8 mm. 呕艂obki silnika s膮 skomplikowanymi elementami kt贸rych rozmiary zamieszczono tylko w projekcie.

![Model](https://github.com/Kacper-Hoffman/Electrical-Motor/blob/main/full.png)

![Quarter](https://github.com/Kacper-Hoffman/Electrical-Motor/blob/main/quarter.png)

![Stator](https://github.com/Kacper-Hoffman/Electrical-Motor/blob/main/stator_cog.png)

![Rotor](https://github.com/Kacper-Hoffman/Electrical-Motor/blob/main/rotor_cog.png)

## Obliczenia
Obliczenia wykonane w tym projekcie bazuj膮 na modelu zast臋pczym Steinmetza. Ten model reprezentuje rezystancj臋 uzwojenia, reaktancje rozproszenia, reaktancj臋 magnetyzacji oraz rezystancj臋 zast臋pcz膮 strat czynnych wirnika jako elementy uk艂adu elektrycznego. Takie podej艣cie pozwala na wyznaczenie r贸wnania macierzowego silnika a z niego pozosta艂e wa偶ne parametry. Po wykonaniu wszystkich przekszta艂ce艅 uzyskujemy poni偶sze r贸wnania:

![Equivalent Circuit](https://github.com/Kacper-Hoffman/Electrical-Motor/blob/main/equivalent_circuit.png)

![Matrix Equation](https://github.com/Kacper-Hoffman/Electrical-Motor/blob/main/matrix.png)

![Reversed Matrix Equation](https://github.com/Kacper-Hoffman/Electrical-Motor/blob/main/reverse_matrix.png)

![Equations](https://github.com/Kacper-Hoffman/Electrical-Motor/blob/main/equations.png)

## Symulacja
Do narysowania silnika u偶yto komend z Octave. Posiada on szereg funkci s艂u偶膮cych do rysowania komponent贸w w FEMM. Na pocz膮tku nale偶y programistycznie otworzy膰 FEMM, stworzy膰 nowy problem magnetyczny oraz zdefiniowa膰 problem. Tak wpisuje si臋 dane pocz膮tkowe, tj. cz臋stotliwo艣膰, jednostk臋 d艂ugo艣ci, typ symulacji, dok艂adno艣膰 oraz k膮t siatki dyskretyzacyjnej. W naszym przypadku warto r贸wnie偶 wy艂膮czy膰 Smart Mesh. Ta opcja tworzy bardzo dok艂adn膮 siatk臋 dyskretyzacyjn膮, ale dla modeli du偶ych ona bardzo spowalnia obliczenia. Nie potrzebujemy tutaj wyj膮tkowo dok艂adnej siatki, poniewa偶 dok艂adno艣膰 z definicji problemu wystarcza ca艂kowicie. Nast臋pnie rysuje si臋 jeden 偶艂obek stojana, wype艂nia materia艂em i pr膮dem a na koniec kopiuje wzgl臋dem symetrii promieniowej. Proces ten powtarza si臋 dla 偶艂obka wirnika. Poni偶ej fragment u偶ytego kodu.

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

Po narysowaniu silnika mo偶liwe jest wykonanie symulacji. Tutaj w tym celu zastosowano kompatybilno艣膰 Octave-FEMM. Octave wysy艂a do FEMM komend臋 do wykonania oblicze艅 wst臋pnych metod膮 element贸w sko艅czonych. Potem pobiera on dane wynikowe oraz wykonuje obliczenia wcze艣niej okre艣lone do wyznaczenia parametr贸w silnika. Na sam koniec wykonuje si臋 zmian臋 parametru w modelu i obliczenia s膮 powtarzane. Poni偶ej przedstawiono wyniki analizy por贸wnawczej dla nast臋puj膮cych warto艣ci zmiennych: napi臋cie zasilania, cz臋stotliwo艣膰 zasilania, ilo艣膰 偶艂obk贸w wirnika oraz pr膮d zasilania.

![Full](https://github.com/Kacper-Hoffman/Electrical-Motor/blob/main/full_results.png)

![Compare Voltage](https://github.com/Kacper-Hoffman/Electrical-Motor/blob/main/results_compare_0908Un.png)

![Compare Frequency](https://github.com/Kacper-Hoffman/Electrical-Motor/blob/main/results_compare_0908fs.png)

![Compare Rotor Slots](https://github.com/Kacper-Hoffman/Electrical-Motor/blob/main/results_compare_6468Qr.png)

![Compare Current](https://github.com/Kacper-Hoffman/Electrical-Motor/blob/main/results_compare_Un33A.png)

Uzyskane wyniki symulacji s膮 zgodne z teoretycznymi za艂o偶eniami. Pe艂ny opis u偶ytego kodu z Octave oraz szczeg贸艂y oblicze艅 dost臋pne s膮 z [moim projekcie](https://github.com/Kacper-Hoffman/Electrical-Motor/blob/main/Kacper%20Hoffman%20-%20FEMM%20Projekt.pdf).

---
# Three phase squirrel-cage motor model - FEMM 馃嚞馃嚙
## Introduction
Created as part of laboratory classes, this model is used to simulate the behaviour of a three phase quirrel cage motor in different power supply conditions and different construction details. Due to the large amount of components necessary and compex calculations I have used a companion program - Octave. Octave is used mainly to preform complicated mathematical calculations, but it's also compatible with FEMM. Several lines of code allow you to create even a very advanced model of an electric motor. Instead or drawing each slot independently you can simply draw one slot and then copy it in accordance with radial symmetry. Octave can simulate the process of simulation and calculation. Those calculations were used to determine how the motor's behaviour.
## Model
As mentioned before, we are simulating a three phase squirrel cage motor. It's main parameters are its rated power Pn = 90 kW, voltage Un = 985 V with frequency f = 50 Hz, rated current In = 170 A. It has three phases m = 3 and three poles p = 3. The synchronic speed of such a motor is ns = 1000 obr/min, while it's rated speed from catalogue is ns = 850 obr/min. Using approximate equations the physical dimensions of the motor were calculated. It's effective length is le = 1.86 m, shaft length H = 315 mm, stator radii Rse = 260 mm and R = 190, rotor radius R = 190, gap 未 = 0.8 mm. Slots themselves are geometrically complex and have only been described in the project.

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

These results are comparable to theoretical values. Full description of the used code and details of calculations are available in [my project (馃嚨馃嚤 only)](https://github.com/Kacper-Hoffman/Electrical-Motor/blob/main/Kacper%20Hoffman%20-%20FEMM%20Projekt.pdf).
