use std::io;
use std::collections::HashSet;

#[derive(Debug, Default, Clone, Eq, Hash, PartialEq)]
struct State {
    register_a: usize,
    register_b: usize,
    register_c: usize,

    instruction_pointer: usize,
}

type Program = Vec<usize>;

fn get_input() -> (State, Program) {
    let mut result = State::default();

    let mut buffer = String::new();

    io::stdin().read_line(&mut buffer).unwrap();
    result.register_a = buffer.trim().split(' ').last().unwrap()
        .parse::<usize>().unwrap();

    io::stdin().read_line(&mut buffer).unwrap();
    result.register_b = buffer.trim().split(' ').last().unwrap()
        .parse::<usize>().unwrap();

    io::stdin().read_line(&mut buffer).unwrap();
    result.register_c = buffer.trim().split(' ').last().unwrap()
        .parse::<usize>().unwrap();

    io::stdin().read_line(&mut buffer).unwrap();
    io::stdin().read_line(&mut buffer).unwrap();
    let program: Program = buffer.trim().split(' ').last().unwrap()
        .split(',').map(|n| n.parse::<usize>().unwrap())
        .collect();

    result.register_a = 190384625499151;

    (result, program)
}

impl State {
    fn combo(self: &State, op: usize) -> usize {
        match op {
            4 => self.register_a,
            5 => self.register_b,
            6 => self.register_c,
            7 => panic!(),
            _ => op
        }
    }

    fn solve(self: &mut State, program: &Program) -> Vec<usize> {
        let mut output = Vec::<usize>::new();

        while self.instruction_pointer < program.len() {
            let operation = program[self.instruction_pointer];
            let operand = program[self.instruction_pointer + 1];

            match operation {
                0 => { // adv
                    self.register_a /= 1 << self.combo(operand);
                },
                1 => { // bxl
                    self.register_b ^= operand;
                },
                2 => { // bst
                    self.register_b = self.combo(operand) % 8;
                },
                3 => if self.register_a != 0 { // jnz
                    self.instruction_pointer = operand;
                    continue;
                },
                4 => { //bxc
                    self.register_b ^= self.register_c;
                },
                5 => { // out
                    output.push(self.combo(operand) % 8);
                },
                6 => { // bdv
                    self.register_b = self.register_a / (1 << self.combo(operand));
                },
                7 => { // cdv
                    self.register_c = self.register_a / (1 << self.combo(operand));
                },
                _ => {},
            };
            self.instruction_pointer += 2;
        };

        output
    }
}

fn part1(state: State, program: &Program) -> String {
    let mut state = state;
    let output = state.solve(&program);
    output.iter().map(usize::to_string).reduce(|a, s| format!("{a},{s}")).unwrap()
}

fn part2_iter(original_state: State, program: &Program, result: &mut usize, cache: &mut HashSet<(usize, usize)>, current_a: usize, depth: usize) {
    if !cache.insert((current_a, depth)) {
        return;
    }

    for b in 0..=0b1111111111111 {
        let mut state = original_state.clone();
        let a = (current_a % (1 << (3 * depth))) ^ (b << (3 * depth));
        state.register_a = a;

        let output = state.solve(&program);

        if output.len() > program.len() {
            continue;
        }

        if output.len() == program.len() && output.iter().zip(program.iter()).all(|(a, b)| a == b) {
            if a < *result {
                *result = a;
                println!("Found new result: {a}");
            }
        }

        if output.len() > depth && output.iter().take(depth + 1).zip(program.iter()).all(|(a, b)| a == b) {
            part2_iter(original_state.clone(), &program, result, cache, a, depth + 1);
        }
    }
}

fn part2(state: State, program: &Program) -> usize {
    let mut result: usize = usize::MAX;
    part2_iter(state.clone(), program, &mut result, &mut HashSet::new(), 0, 0);
    result
}

fn main() {
    let (state, program) = get_input();

    let result1 = part1(state.clone(), &program);
    println!("Part 1: {result1}");
    let result2 = part2(state.clone(), &program);
    println!("Part 2: {result2}");
}
