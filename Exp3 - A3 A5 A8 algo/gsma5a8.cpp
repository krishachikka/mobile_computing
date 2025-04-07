#include <iostream>
#include <string>
#include <iomanip>
#include <sstream>
#include <cstdint>

using namespace std;

string toHex(uint32_t value) {
    stringstream ss;
    ss << setw(8) << setfill('0') << hex << value;
    return ss.str();
}

// Simple XOR-based "session key generation" for A5 (stream cipher simulation)
uint32_t generateSessionKey(uint32_t RAND, uint32_t K) {
    return RAND ^ K;  // In real systems, this would involve more complex steps
}

// A simplified A5 stream cipher encryption using the session key
uint32_t a5Encrypt(uint32_t input, uint32_t sessionKey) {
    return input ^ sessionKey;  // Simulate stream cipher using XOR
}

// A8 Algorithm: Generate an SRES using RAND and K
uint32_t a8SRES(uint32_t RAND, uint32_t K) {
    uint32_t sessionKey = generateSessionKey(RAND, K);  // Generate a "session key"
    return RAND ^ sessionKey;  // Use the session key to generate SRES (simplified)
}

int main() {
    uint32_t RAND_sim = 3634532327;  // Random number for SIM
    uint32_t RAND_network = 3634532327;  // Random number for Network
    uint32_t K = 987654321;     // Secret key

    cout << "Step 1: Generate session key and send to SIM" << endl;
    uint32_t sessionKey_sim = generateSessionKey(RAND_sim, K);
    cout << "Session key for SIM: " << toHex(sessionKey_sim) << " is generated and sent to SIM." << endl;

    cout << "\nStep 2: Encrypt RAND using A5 (stream cipher simulation) and send to network" << endl;
    uint32_t sim_A5 = a5Encrypt(RAND_sim, sessionKey_sim);
    cout << "SIM sends RAND to network (encrypted): " << toHex(sim_A5) << endl;

    cout << "\nStep 3: Generate SRES using A8 (simplified simulation)" << endl;
    uint32_t sim_SRES = a8SRES(RAND_sim, K);
    cout << "SIM generates SRES: " << toHex(sim_SRES) << endl;

    cout << "\nStep 4: Generate session key for network and send to network" << endl;
    uint32_t sessionKey_network = generateSessionKey(RAND_network, K);
    cout << "Session key for network: " << toHex(sessionKey_network) << " is generated and sent to network." << endl;

    cout << "\nStep 5: Encrypt RAND using A5 (stream cipher simulation) and send to SIM" << endl;
    uint32_t network_A5 = a5Encrypt(RAND_network, sessionKey_network);
    cout << "Network sends RAND to SIM (encrypted): " << toHex(network_A5) << endl;

    cout << "\nStep 6: Generate SRES using A8 (simplified simulation)" << endl;
    uint32_t network_SRES = a8SRES(RAND_network, K);
    cout << "Network generates SRES: " << toHex(network_SRES) << endl;

    // Output the results
    cout << "\nStep 7: Final Output" << endl;
    cout << "SIM SRES: " << toHex(sim_SRES) << endl;
    cout << "Network SRES: " << toHex(network_SRES) << endl;

    // Compare the two SRES values
    cout << "\nStep 8: Authentication Check" << endl;
    if (sim_SRES == network_SRES) {
        cout << "Authentication Successful!" << endl;
    } else {
        cout << "Authentication Failed!" << endl;
    }

    return 0;
}