
#[cfg(test)]
mod tests {
    #[test]
    fn it_works() {
        let idk = "ax".as_bytes();
        for ix in 0..1000 {
            let mut i = true;
            let mut idkx = 0;
            if i {
                println!("{}", idk[idkx]);
                i = !i;
                idkx = 1;
            }else {
                println!("{}", idk[idkx]);
                i = !i;
                idkx = 0;
            }
            println!("{}", ix);
        }
    }
}

fn main() {}