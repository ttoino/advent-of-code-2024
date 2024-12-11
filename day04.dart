import 'dart:io';

List<String> getInput() {
    var input = <String>[];

    String? i;
    while ((i = stdin.readLineSync()) != null) 
        input.add(i!);
    
    return input;
}

final XMAS = RegExp(r'XMAS');

String reverse(String s) {
    return s.split('').reversed.join('');
}

List<String> reverseList(List<String> input) {
    return input.map(reverse).toList();
}

List<String> rotate(List<String> input) {
    var out = <String>[];
    for (var line in input) {
        for (var i = 0; i < line.length; i++) {
            if (out.length <= i) out.add("");
            out[i] += line[i];
        }
    }
    return out;
}

List<String> diagonals(List<String> input) {
    var out = <String>[];
    var height = input.length;
    var width = input[0].length;

    for (var j = 0; j < width; j++) {
        for (var i = height - 1; i >= 0; i--) {
            var diagonal = height + j - i - 1;
            if (out.length <= diagonal) out.add("");
            out[diagonal] += input[i][j];
        }
    }
    return out;
}

int part1(List<String> input) {
    var base = input + rotate(input) + diagonals(input) + diagonals(reverseList(input));
    var count = (base + reverseList(base))
        .map(XMAS.allMatches)
        .map((e) => e.length)
        .fold(0, (a, b) => a + b);
    return count;
}

int part2(List<String> input) {
    var count = 0;

    for (var i = 1; i < input.length - 1; i++) {
        for (var j = 1; j < input.length - 1; j++) {
            var diag1 = input[i - 1][j - 1] + input[i + 1][j + 1];
            var diag2 = input[i - 1][j + 1] + input[i + 1][j - 1];
            if (input[i][j] == 'A' && (diag1 == "MS" || diag1 == "SM") && (diag2 == "MS" || diag2 == "SM"))
                count++;
        }
    }

    return count;
}

void main() {
    var input = getInput();
    var p1 = part1(input);
    print("Part 1: $p1");
    var p2 = part2(input);
    print("Part 2: $p2");
}
