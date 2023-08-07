# Enigma

An app to practice decoding ciphers for the Science Olympiad Codebusters event. Built with Flutter by Google.

## Ciphers
This app supports 6 different ciphers, including K1 variations:
- Aristocrats
- Xenocrypts
- Patristocrats
- Pollux
- Morbit
- Hill

You can both practice decoding and use the encoding tool to make your own ciphers. 

## Solver
An algorithm that can solve aristocrats. This uses a [hill climbing algorithm](https://www.geeksforgeeks.org/introduction-hill-climbing-artificial-intelligence/amp/) and english [quadgrams](http://practicalcryptography.com/cryptanalysis/text-characterisation/quadgrams/#:~:text=This%20is%20achieved%20by%20counting,be%20used%20for%20this%20purpose.) to generate the best fit for a given ciphertext. The algorithm used in this app is based off the python implementation [here](https://gitlab.com/guballa/SubstitutionBreaker/-/tree/master?ref_type=heads).

Thank you for the support ❤