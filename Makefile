.DEFAULT_GOAL := action.plan.md

# Phase 1 — Fan-out (parallel)

quality.md: codebase.txt
	cat codebase.txt | ./ask "Analyze the code quality of this code. Focus on \
readability, structure, and duplication. Output exactly 5 to 7 bullet \
points in the format: problem → fix" > quality.md

perf.md: codebase.txt
	cat codebase.txt | ./ask "Analyze the performance of this code. Focus on \
bottlenecks and inefficiencies. Output exactly 5 to 7 bullet points in \
the format: issue → optimization" > perf.md

security.md: codebase.txt
	cat codebase.txt | ./ask "Analyze the security of this code. Focus on \
vulnerabilities and unsafe patterns. Output exactly 5 to 7 bullet points \
in the format: risk → mitigation" > security.md

# Phase 2 — Local summarization (parallel)

quality.sum.md: quality.md
	cat quality.md | ./ask "Compress this to exactly 5 bullets. Keep only \
actionable items." > quality.sum.md

perf.sum.md: perf.md
	cat perf.md | ./ask "Compress this to exactly 5 bullets. Keep only \
actionable items." > perf.sum.md

security.sum.md: security.md
	cat security.md | ./ask "Compress this to exactly 5 bullets. Keep only \
actionable items." > security.sum.md

# Phase 3 — Concat (no LLM)

concatenated.md: quality.sum.md perf.sum.md security.sum.md
	echo "## Code Quality" > concatenated.md
	cat quality.sum.md >> concatenated.md
	echo "" >> concatenated.md
	echo "## Performance" >> concatenated.md
	cat perf.sum.md >> concatenated.md
	echo "" >> concatenated.md
	echo "## Security" >> concatenated.md
	cat security.sum.md >> concatenated.md

# Phase 4 — Refine

refined.md: concatenated.md
	cat concatenated.md | ./ask "You are given a technical report with three \
sections: Code Quality, Performance, and Security. Remove duplicates, \
keep only high-signal issues, and output a clean deduplicated list \
organized by the same three sections." > refined.md

# Phase 5 — Action plan

action.plan.md: refined.md
	cat refined.md | ./ask "Generate a final Engineering Action Plan from this \
report. For each item include: priority (High / Medium / Low), effort \
estimate (Small / Medium / Large), and suggested execution order. Format \
the output as markdown." > action.plan.md

# Cleanup

.PHONY: clean
clean:
	rm -f quality.md perf.md security.md \
	      quality.sum.md perf.sum.md security.sum.md \
	      concatenated.md refined.md action.plan.md