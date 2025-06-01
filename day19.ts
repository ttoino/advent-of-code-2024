import { createInterface } from "node:readline/promises";
import { stdin } from "node:process";

type Input = {
    towels: string[];
    designs: string[];
}

const getInput = async (): Promise<Input> => {
    const int: AsyncIterator<string> = createInterface({ input: stdin })[Symbol.asyncIterator]();

    const towels = (await int.next()).value.split(', ');

    await int.next();

    const designs = await Array.fromAsync(int);

    return {
        towels,
        designs,
    };
};

const waysToMakeDesign = (towels: string[]) => {
    const cache = new Map<string, number>();

    const fn = (design: string): number => {
        if (cache.has(design)) return cache.get(design)!;

        if (design.length === 0) return 1;

        let count = 0;

        for (const towel of towels) {
            if (design.length >= towel.length && design.startsWith(towel)) {
                const remainingDesign = design.slice(towel.length);

                count += fn(remainingDesign);
            }
        }

        cache.set(design, count);
        return count;
    };

    return fn;
}

{
    const input = await getInput();

    const fn = waysToMakeDesign(input.towels);
    const ways = input.designs.map(fn);

    const part1 = ways.filter((count) => count > 0).length;
    const part2 = ways.reduce((acc, count) => acc + count, 0);

    console.log(`Part 1: ${part1}`);
    console.log(`Part 2: ${part2}`);
}
