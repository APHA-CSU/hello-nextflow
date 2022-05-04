set -eo pipefail

python -c "print(1/0)" | cat

echo "hello $?"
