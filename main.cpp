#include <iostream>

extern "C" void random_generator(uint64_t seed, size_t size, double* arr);

int main()
{
	uint64_t seed, size;
	std::cout << "Enter a seed: ";

	std::cin >> seed;

	std::cout << "Enter the number of random numbers: ";

	std::cin >> size;

	double* arr = new double[size];

	random_generator(seed, size, arr);

	for (size_t i = 0; i < size; i++)
	{
		std::cout << arr[i] << std::endl;
	}

	delete[] arr;

	return 0;
}
