#include <string>

#include <iostream>

#include <cstring>



extern "C" {
int __cdecl _find_reversed_substring(char *, int, char *, int);
}


int main() {
    char src[] = "Hello,Mike and Alex";
    int src_len = strlen(src);
    char substr[] = "ekiM";
    int substr_len = strlen(substr);

    int ind = _find_reversed_substring(src, src_len, substr, substr_len);

    std::cout << "Index of occurrence of reversed substring: " << ind << std::endl;

    return 0;
}




