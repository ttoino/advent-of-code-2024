use std::io;
use std::sync::mpsc;
use std::thread;

#[derive(Default, Clone)]
struct State {
    register_a: usize,
    register_b: usize,
    register_c: usize,

    instruction_pointer: usize,
    program: Vec<usize>,
    output: Vec<usize>,
}

fn get_input() -> State {
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
    result.program = buffer.trim().split(' ').last().unwrap()
        .split(',').map(|n| n.parse::<usize>().unwrap())
        .collect(); 

    result
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

    fn solve(self: &mut State) {
        while self.instruction_pointer < self.program.len() {
            let operation = self.program[self.instruction_pointer];
            let operand = self.program[self.instruction_pointer + 1];

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
                    self.output.push(self.combo(operand) % 8);
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
    }
}

fn part1(state: &mut State) -> String {
    state.solve();
    state.output.iter().map(usize::to_string).reduce(|a, s| format!("{a},{s}")).unwrap()
}

fn part2(state: &mut State) -> usize {
    let (_tx, rx) = mpsc::channel();
    let count = thread::available_parallelism().unwrap().into();

    for t in 0..count {
        let mut state = state.clone();
        let tx = _tx.clone();

        thread::spawn(move || {
            for i in (t..).step_by(count) {
                state.register_a = i;
                state.register_b = 0;
                state.register_c = 0;
                state.instruction_pointer = 0;
                state.output.clear();

                state.solve();

                if state.program.len() == state.output.len() 
                && state.program.iter().zip(state.output.iter()).all(|(a, b)| a == b) {
                    tx.send(i).unwrap();
                    return;
                }
            }
        });
    }

    rx.recv().unwrap()
}

fn main() {
    let mut input = get_input();

    let result1 = part1(&mut input);
    println!("Part 1: {result1}");
    let result2 = part2(&mut input);
    println!("Part 2: {result2}");
}
