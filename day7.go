package main

import (
	"bufio"
	"fmt"
	"math"
	"os"
	"strconv"
	"strings"
)

type Equation struct {
	result int
	operands []int
}

func GetInput() []Equation {
	reader := bufio.NewReader(os.Stdin)

	var input []Equation
	for {
		line, err := reader.ReadString('\n')
		if err != nil {
			break
		}
		
		split := strings.Split(strings.TrimSpace(line), ": ")
		result, err := strconv.Atoi(split[0])

		if err != nil {
			fmt.Println(err)
			os.Exit(1)
		}

		equation := Equation{
			result: result,
			operands: []int{},
		}

		for _, operand := range strings.Split(split[1], " ") {
			operand, err := strconv.Atoi(operand)

			if err != nil {
				fmt.Println(err)
				os.Exit(1)
			}

			equation.operands = append(equation.operands, operand)
		}

		input = append(input, equation)
	}

	return input
}

func solveEquation(concat bool, result, current int, operands []int) bool {
	if len(operands) == 0 {
		return result == current
	}

	return solveEquation(concat, result, current + operands[0], operands[1:]) || 
		solveEquation(concat, result, current * operands[0], operands[1:]) ||
		(concat && solveEquation(concat, result, current * int(math.Pow10(int(math.Log10(float64(operands[0])) + 1))) + operands[0], operands[1:]))
}

func Solve(input []Equation, part2 bool) int {
	count := 0

	for _, equation := range input {
		if solveEquation(part2, equation.result, equation.operands[0], equation.operands[1:]) {
			count += equation.result
		}
	}

	return count
}

func main() {
	input := GetInput()
	fmt.Printf("Part 1: %d\n", Solve(input, false))
	fmt.Printf("Part 1: %d\n", Solve(input, true))
}
