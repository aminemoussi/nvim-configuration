// macro_rules! var_name {
//     ($var: ident) => {
//         stringify!($var);
//     };
// }

fn is_solved(board: &[&[u8; 3]; 3]) -> i8 {
    let (mut xs_in_line, mut os_in_line, mut empty_spot_inline, mut element): (u8, u8, u8, u8);
    let mut saturated: bool = true;

    for mode in 0..4 {
        for r in 0..3 {
            (xs_in_line, os_in_line, empty_spot_inline) = (0, 0, 0);
            for c in 0..3 {
                match mode {
                    0 => element = board[r][c], //rows fixed - iteraring columns
                    1 => element = board[c][r],
                    3 => element = board[c][c],
                    _ => element = board[c][2 - c],
                }

                match element {
                    0 => empty_spot_inline += 1,
                    1 => xs_in_line += 1,
                    2 => os_in_line += 1,
                    _ => println!("error"),
                }
            }
            if xs_in_line == 3 {
                return 1;
            } else if os_in_line == 3 {
                return 2;
            }

            if (empty_spot_inline != 0) {
                saturated = false;
            }

            if (mode == 2) || (mode == 3) {
                break;
            }
        }
    }
    if saturated {
        return 0;
    }
    return -1;
}

fn main() {
    let board: &[&[u8; 3]; 3] = &[&[1, 2, 1], &[1, 2, 0], &[0, 2, 0]];
    let res = is_solved(board);
    println!("result: {}", res);
}
