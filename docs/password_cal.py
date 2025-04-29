def calculate_password(algorithm, otp):
    otp = otp & 0x3F  # Only keep 6 bits (maximum 63)
    if algorithm == 0:
        password = otp * 2 + 1
    elif algorithm == 1:
        password = (otp << 2) ^ 0xA3
    elif algorithm == 2:
        password = (otp * 3) + (otp >> 1)
    elif algorithm == 3:
        password = ~(otp * 5) & 0xFFF
    elif algorithm == 4:
        password = (otp * otp) % 4096
    elif algorithm == 5:
        password = ((otp << 3) - otp) ^ 0x3C3
    elif algorithm == 6:
        lower_bits = otp & 0b111  # Take lower 3 bits
        higher_bits = (otp >> 3) & 0b111  # Take higher 3 bits
        combined = (lower_bits << 3) | higher_bits
        password = combined + 0x55A
    elif algorithm == 7:
        password = (otp * 9) & 0xFFF
    else:
        raise ValueError("Invalid algorithm number (should be 0-7)")
    return password & 0xFFF  # Only keep 12 bits


def main():
    try:
        alg = int(input("Enter the algorithm number (decimal 0-7): "))
        if not (0 <= alg <= 7):
            raise ValueError

        otp_str = input("Enter a 6-bit binary number: ")
        if len(otp_str) != 6 or any(c not in '01' for c in otp_str):
            raise ValueError("Please input a valid 6-bit binary number.")

        otp = int(otp_str, 2)
        password = calculate_password(alg, otp)
        password_bin = format(password, '012b')  # Format as 12-bit binary
        print(f"The generated password is: {password_bin}")

    except ValueError as e:
        print("Input error. Please rerun the program and enter valid values.")


if __name__ == "__main__":
    main()
