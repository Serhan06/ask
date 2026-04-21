# Contributing to ask

Thanks for taking the time to contribute.

## Getting Started

```bash
git clone https://github.com/Serhan06/ask.git
cd ask
chmod +x ask
```

## Making Changes

1. Fork the repository
2. Create a new branch for your change:
```bash
   git checkout -b fix/describe-your-fix
```
3. Make your changes
4. Test manually before committing (see Testing below)
5. Commit with a clear message:
```bash
   git commit -m "fix: describe what you changed and why"
```
6. Open a pull request against the `main` branch

## Testing

There is no test suite yet. Test manually by setting the environment variables and running the script:

```bash
export ASK_API_URL="https://api.groq.com/openai/v1/chat/completions"
export ASK_MODEL="llama-3.3-70b-versatile"
export ASK_API_KEY="your-api-key"

./ask "Hello"
echo "some piped text" | ./ask "Explain:"
./ask "Multiple" "arguments" "test"
```

Make sure all three usage modes work before submitting.

## Code Style

- Keep the script POSIX-friendly where possible
- Use meaningful variable names
- Add a comment when the intent isn't immediately obvious
- Do not introduce new dependencies beyond `curl` and `jq`

## Reporting Issues

Open an issue on GitHub with a clear description of the problem and the steps to reproduce it.