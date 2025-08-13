fn rot13(message: &str) -> String {
    let mut char_vect: Vec<u8> = Vec::new();
    let (mut overflow, mut new): (u8, u8);
    let (small_range, capital_range) = (97..123, 65..91);

    let asci_bytes = message.as_bytes();
    for byte in asci_bytes {
        overflow = 0;
        new = *byte + 13;
        if !capital_range.contains(byte) && !small_range.contains(byte) {
            new = *byte;
            println!("1");
        } else if new > 90 && new <= 103 {
            overflow = new - 90;
            new = 64 + overflow;
            println!("2");
        } else if new > 122 && new <= 135 {
            overflow = new - 122;
            new = 96 + overflow;
            println!("3");
        }

        println!("Byte {}, overflow {}, new {}.", byte, overflow, new);
        char_vect.push(new);
    }

    // let x = String::from_utf8(char_vect);

    // println!("{}", x);

    let result = match String::from_utf8(char_vect) {
        Ok(val) => val, // val: String
        Err(err) => {
            println!("Error: {}", err);
            String::new()
        }
    };

    //println!("{}", result);
    // println!("vector stuff: ");
    // for b in char_vect {
    //     println!("{}", b);
    // }

    result
}

fn main() {
    let test = "a";

    //let asci_bytes = test.as_bytes();

    let result = rot13(test);
    println!("result: {}", result);
}

#[cfg(test)]
mod tests {
    use super::rot13;

    const ERR_MSG: &str = "\nYour result (left) did not match the expected output (right)";

    fn dotest(s: &str, expected: &str) {
        assert_eq!(rot13(s), expected, "{ERR_MSG} with message = \"{s}\"")
    }

    #[test]
    fn sample_tests() {
        dotest("test", "grfg");
        dotest("Test", "Grfg");
    }
}
