# Air-Data-Corrector
This project addresses an issue of utmost importance of ADIRUs in flights displaying incorrect information, which results in the plane ascending or descending randomly. If left unchecked, this issue can potentially endanger the lives of the passengers and the crew aboard the plane. 

This problem is caused by a bitflip, where a bit flips from a 0 to a 1 or vice-versa. The bitflip occurs when a particle from a cosmic ray descending from the sky, hits a transistor which changes the value stored in it. The aim of my project is to ultimately eliminate most of the errors caused by a bitflip, in displaying important information in a flight’s ADIRU.

## Functionality
To address this issue, the project uses the method of Hamming code. Hamming Code is a way of error detecting and correcting, created specifically to tackle bitflips. 

The implementation takes an 11-bit value from the user/sender and converts it to a 16-bit Hamming encoded value, which is sent to the receiver. The receiver uses the implementation to decode that 16-bit Hamming encoding into the original 11-bit value. In the decoding process, if an error is found due to a bitflip, it is corrected. If 2 errors are found, the receiver is made aware that there are 2 errors in the received data. Then, the receiver could prompt the sender to send the data again.
