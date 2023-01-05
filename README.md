# Bachelor Thesis: Logic Locking - Theoretical Foundations and Implementation of Demo Circuit
This design is a demonstration of the logic locking technique SFLL-HD (stripped functionality logic locking - Hamming distance).
SFLL-HD strips the functionality of the original circuit by introducing errors. It uses a seperate restore unit 
to restore the introduced errors upon application of the correct key. 
The switches 17,...,9 are interpreted as key inputs, whereas the switches 8,...,0 are the user inputs. Upon application of 
the correct key the design will output the decimal representation of the users inputs on the seven segment displays.
If a incorrect key is applied the result on the SSD will be erroneous for a large number of inputs. The error rate
can be influenced by specifying the Hamming distance.

