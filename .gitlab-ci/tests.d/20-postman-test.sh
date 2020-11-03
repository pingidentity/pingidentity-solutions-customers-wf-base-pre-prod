POSTMANRUN=$(docker run -t postman/newman run --insecure https://api.getpostman.com/collections/12861248-d9c7ed52-6d0e-4750-b685-6ac6e41bb889?apikey=PMAK-5fa05c0fc71f0b0034f573fa-bdbe88e369e218ea4fc92d2c86bec6b555)
RESULT=$(echo "$POSTMANRUN" | grep -A 8 "iterations" | awk '{print $6}' | sed -e '/^$/d' | tr -d '\n')

if [[ "$RESULT" != "00000" ]]; then
    echo "One or more tests failed..."
    echo "$POSTMANRUN"
    exit 1
else
    echo "Tests completed successfully..."
    echo "$POSTMANRUN"
    exit 0
fi