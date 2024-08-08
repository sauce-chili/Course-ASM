#include <iostream>
#include <limits.h>

#define max_size_bin_array 32

using namespace std;

extern "C" {
	int __stdcall add_32bin_num(unsigned int*, unsigned int*, int, unsigned int*);
	int __stdcall sub_32bin_num(unsigned int*, unsigned int*, int, unsigned int*);
}


/**

Конвертирует целое число в двоичный массив.

@param num Целое число для конвертации.

@param bin_array Указатель на массив, в который будет сохранен результат в развернутом виде.

@return Количество значимых битов в двоичном представлении числа.
*/
int convert_int_to_bin_array(unsigned int num, unsigned int bin_array[])
{

	memset(bin_array, 0, sizeof(unsigned int) * max_size_bin_array);
	int number_counter = 0;

	while (num > 0)
	{
		bin_array[number_counter] = num % 2;
		number_counter++;

		num /= 2;
	}

	return number_counter;
}


void println_32bin_num(unsigned int arr[], int size)
{
	for (int i = size - 1; i > 0; i--)
	{
		cout << arr[i];
	}
	cout << endl;
}


/**

Конвертирует развёрнутый двоичный массив в беззнаковое целое число.

@param reversed_bin_array развернутый двоичный массив.

@param size Размер массива (по умолчанию равен max_size_bin_array).

@return Беззнаковое целое число, полученное из обратного двоичного представления.
*/
unsigned int convert_bin_array_to_int(unsigned int reversed_bin_array[], int size = max_size_bin_array)
{
	unsigned int num = 0;

	for (int i = 0; i < size; i++)
	{
		num += reversed_bin_array[i] * (unsigned int)pow(2, i);
	}

	return num;
}

unsigned int add_num32(unsigned int num1, unsigned int num2)
{
	unsigned int bin_num1[max_size_bin_array];
	int size1 = convert_int_to_bin_array(num1, bin_num1);

	unsigned int bin_num2[max_size_bin_array];
	int size2 = convert_int_to_bin_array(num2, bin_num2);

	int length = max(size1, size2);
	unsigned int result[max_size_bin_array] = { 0 };

	int overflow = add_32bin_num(bin_num1, bin_num2, length, result);

	return convert_bin_array_to_int(result);
}


unsigned int sub_num32(unsigned int num1, unsigned int num2)
{
	unsigned int bin_num1[max_size_bin_array];
	int size1 = convert_int_to_bin_array(num1, bin_num1);

	unsigned int bin_num2[max_size_bin_array];
	int size2 = convert_int_to_bin_array(num2, bin_num2);

	int length = max(size1, size2);
	unsigned int result[max_size_bin_array] = { 0 };
	int overflow = 0;

	if (num1 > num2)
	{
		overflow = sub_32bin_num(bin_num1, bin_num2, length, result);
	}
	else
	{
		overflow = sub_32bin_num(bin_num2, bin_num1, length, result);
	}

	return convert_bin_array_to_int(result);
}

int main()
{

	cout << "Please, enter 2 positive numbers:" << endl;
	
	__int64 in_x;
	cout << "x = ";
	cin >> in_x;
	
	if (in_x > UINT_MAX)
	{
		cout << "The value of `x` is greater than the allowed value. The maximum possible value is 4.294.967.295 .\n";
		cout << "Please, restart the program with correct input data" << endl;
		return 0;
	}
	else if (in_x < 0)
	{
		cout << "The `x` value is less than the allowed value. The minimum value is 0 .\n";
		cout << "Please, restart the program with correct input data" << endl;
		return 0;
	}
	
	cout << "y = ";
	__int64 in_y;
	cin >> in_y;
	
	if (in_y > UINT_MAX)
	{
		cout << "The value of `y` is greater than the allowed value. The maximum possible value is 4.294.967.295 .\n";
		cout << "Please, restart the program with correct input data" << endl;
		return 0;
	}
	else if (in_y < 0)
	{
		cout << "The `y` value is less than the allowed value. The minimum value is 0 .\n";
		cout << "Please, restart the program with correct input data" << endl;
		return 0;
	}
	
	unsigned int x = (unsigned int)in_x;
	unsigned int y = (unsigned int)in_y;
	
	cout << "x + y = ";
	cout << add_num32(x, y) << endl;
	
	cout << "x - y = ";
	cout << sub_num32(x, y) << endl;
}
