#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>

int part1(char *input) {
    char *i = input;
    uint64_t result = 0;
    uint16_t dummy;

    while (*i != '\0') {
        uint64_t a, b, count = 0;
        sscanf(i, "%*[^m]%n", &count);
        i += count;
        if (sscanf(i, "mul(%u,%u%1[)]%n", &a, &b, &dummy, &count) == 3) {
            i += count;
            result += a * b;
        } else {
            ++i;
        }
    }

    return result;
}

int part2(char *input) {
    char *i = input;
    uint64_t result = 0;
    uint16_t dummy;
    bool mul = true;

    while (*i != '\0') {
        uint64_t a, b, count = 0;
        sscanf(i, "%*[^md]%n", &count);
        i += count;
        if (mul && sscanf(i, "mul(%u,%u%1[)]%n", &a, &b, &dummy, &count) == 3) {
            i += count;
            result += a * b;
        } else if (sscanf(i, "do(%1[)]%n", &dummy, &count) == 1) {
            mul = true;
            i += count;
        } else if (sscanf(i, "don't(%1[)]%n", &dummy, &count) == 1) {
            mul = false;
            i += count;
        } else {
            ++i;
        }
    }

    return result;
}

int main() {
    char *input = malloc(32000);
    char *i = input;
    while (feof(stdin) == 0) {
        fgets(i, 24000, stdin);
        i += strlen(i);
    }
    printf("Part 1: %d\n", part1(input));
    printf("Part 2: %d\n", part2(input));
}
