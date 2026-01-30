import secrets
import string

def get_random_password_string(length):
    # pass_chars = string.ascii_letters + string.digits + string.punctuation
    pass_chars = string.ascii_letters + string.digits
    password = ''.join(secrets.choice(pass_chars) for _ in range(length))
    return password

print(get_random_password_string(10))
print(get_random_password_string(13))
print(get_random_password_string(8))

