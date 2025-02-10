#include <iostream>
#include <string>
#include <iomanip>
#include <sstream>
#include <cstdint>  // This header defines uint32_t

using namespace std;

// Simple XOR encryption method (using a basic secret key K)
uint32_t xorEncrypt(uint32_t input, uint32_t key) {
    return input ^ key;  // XOR each byte of input with key
}

// Convert result to a readable hex format (for visualization)
string toHex(uint32_t value) {
    stringstream ss;
    ss << setw(8) << setfill('0') << hex << value;
    return ss.str();
}

int main() {
    uint32_t RAND_network = 3634532327;  // Network generates RAND
    uint32_t K = 987654321;              // Secret key

    cout << "Step 1: Network generates RAND and sends to SIM" << endl;
    cout << "RAND sent to SIM: " << toHex(RAND_network) << endl;

    uint32_t sim_SRES = xorEncrypt(RAND_network, K);  // SIM generates SRES using its secret key
    cout << "\nStep 2: SIM generates SRES" << endl;
    cout << "SIM SRES generated from RAND and K: " << toHex(sim_SRES) << endl;

    cout << "\nStep 3: SIM sends SRES to Network" << endl;
    cout << "SIM sends SRES: " << toHex(sim_SRES) << endl;

    uint32_t network_SRES = xorEncrypt(RAND_network, K);  // Network generates SRES using the same RAND and K
    cout << "\nStep 4: Network generates SRES" << endl;
    cout << "Network SRES generated from RAND and K: " << toHex(network_SRES) << endl;

    cout << "\nStep 5: Authentication check" << endl;
    cout << "SIM SRES: " << toHex(sim_SRES) << endl;
    cout << "Network SRES: " << toHex(network_SRES) << endl;

    if (network_SRES == sim_SRES) {
        cout << "Authentication Successful!" << endl;
    } else {
        cout << "Authentication Failed!" << endl;
    }

    return 0;
}