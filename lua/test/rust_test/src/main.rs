// macro_rules! var_name {
//     ($var: ident) => {
//         stringify!($var);
//     };
// }

fn score_counter(mut number: u8, mut result: u32, trilets_factor: u32, singles_factor: u32) -> u32 {
    // let num_string = var_name!(number);

    // println!("{}", num_string);

    // match id {
    //     1=> factor = 10,
    //     2=> factor = 2,
    //     3=> factor = 3,
    //     4=> factor = 4,
    //     5=> factor = 5,
    //     6=> factor = 6,
    //     _=> println!("Unaccaptable identifier!!"),
    // }

    while (number > 0) {
        if (number >= 3) {
            result += 10 * trilets_factor;
            number -= 3;
        } else {
            result += 50 * singles_factor;
            number -= 1;
        }
    }

    // println!("inside: {}", result);

    result
}

fn score(dice: [u8; 5]) -> u32 {
    let mut result: u32 = 0;
    let (mut ones, mut twos, mut threes, mut fores, mut fives, mut sixes): (
        u8,
        u8,
        u8,
        u8,
        u8,
        u8,
    ) = (0, 0, 0, 0, 0, 0);
    for num in dice {
        println!("{}", num);
        match num {
            1 => ones += 1,
            2 => twos += 1,
            3 => threes += 1,
            4 => fores += 1,
            5 => fives += 1,
            6 => sixes += 1,
            _ => println!("the number {} is not allowed", num),
        };
    }
    println!("ones {}", ones);

    result = score_counter(ones, result, 100, 2);
    result = score_counter(twos, result, 20, 0);
    result = score_counter(threes, result, 30, 0);
    result = score_counter(fores, result, 40, 0);
    result = score_counter(fives, result, 50, 1);
    result = score_counter(sixes, result, 60, 0);
    // println!("outside: {}", result);

    //match ones {
    //     0=> result += 0,
    //     1=> result += 100,
    //     2=> result += 200,
    //     3=> result += 1000,
    //     4=> result += 1100,
    //     5=> result += 1200,
    //
    //
    // }
    result
}

fn main() {
    //let res = alphabet_position("ABCZ abcz 01239"); // returns "(123) 456-7890"
    //let asci_bytes = test.as_bytes();
    let dice: [u8; 5] = [5, 1, 3, 4, 1];
    let res = score(dice);
    println!("result: {}", res);
}
