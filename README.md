# Missile_Freeflight_Trajectory_Calculator
Calculate the freeflight trajectory according to the shutdown point parameters(shutdown altitude and velocity).
This is my assignment of undergraduate cource 'Aerospace Dynamics', School of Astronautics, Beihang University.

It may take you some time to run the 'main.m', for there is a two-layers of 'for' loops to realize parameterized scanning。
For your reference，it takes me about 3min to run the 'main.m' on my laptop.
If you don't need this function, just comment out the 'Parameter scanning' part and related figure-plot code.

function 'rv2element' and 'element2rv' realize the conversion between the position/velocity vector and the Kepler orbital element. Acturally these are copyed from another project of mine and both functions are disigned for three-dimensional situation. Here I use them to solve two-dimensional problem so I set two-dimensional vector in Y-Z plane, for example, itialize velocity vector as [0 vy vz].
