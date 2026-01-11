#!/usr/bin/env python3
"""
Stop hook that detects learning signals in the conversation and suggests running /autoskill.

Learning signals include:
- Corrections ("No, use X instead", "that's wrong", "I said X not Y")
- Repeated patterns or preferences ("We always do X", "I prefer X")
- Style/convention feedback ("use template literals", "use arrow functions")
"""

import hashlib
import json
import re
import sys
from pathlib import Path

# State directory for tracking processed messages per session
STATE_DIR = Path("/tmp/claude_autoskill_state")


def get_session_id(transcript_path: str) -> str:
    """Derive a unique session ID from the transcript path."""
    return hashlib.md5(transcript_path.encode()).hexdigest()[:12]


def get_state_file(session_id: str) -> Path:
    """Get the state file path for a session."""
    STATE_DIR.mkdir(exist_ok=True)
    return STATE_DIR / f"{session_id}.json"


def load_state(session_id: str) -> int:
    """Load the last processed message count for this session."""
    state_file = get_state_file(session_id)
    try:
        if state_file.exists():
            data = json.loads(state_file.read_text())
            return data.get("processed_count", 0)
    except (json.JSONDecodeError, PermissionError):
        pass
    return 0


def save_state(session_id: str, count: int) -> None:
    """Save the processed message count for this session."""
    state_file = get_state_file(session_id)
    try:
        state_file.write_text(json.dumps({"processed_count": count}))
    except PermissionError:
        pass


def load_transcript(transcript_path: str) -> list[dict]:
    """Load the JSONL transcript file."""
    entries = []
    try:
        with open(transcript_path, "r") as f:
            for line in f:
                line = line.strip()
                if line:
                    try:
                        entries.append(json.loads(line))
                    except json.JSONDecodeError:
                        pass
    except (FileNotFoundError, PermissionError):
        pass
    return entries


def extract_user_messages(transcript: list[dict]) -> list[str]:
    """Extract user messages from the transcript."""
    messages = []
    for entry in transcript:
        if entry.get("type") == "user":
            content = entry.get("message", {}).get("content", "")
            if isinstance(content, str):
                messages.append(content.lower())
            elif isinstance(content, list):
                for item in content:
                    if isinstance(item, dict) and item.get("type") == "text":
                        messages.append(item.get("text", "").lower())
    return messages


def has_learning_signals(messages: list[str]) -> bool:
    """Check if messages contain learning signals worth capturing."""

    # Correction patterns
    correction_patterns = [
        r"\bno[,.]?\s+(use|do|make|try|it'?s|that'?s|i said|i meant|i want)",
        r"\bthat'?s (wrong|incorrect|not right|not what)",
        r"\bi said\b",
        r"\bi meant\b",
        r"\binstead\b",
        r"\bnot\s+\w+[,.]?\s+(use|do|make|try)",
        r"\bactually[,.]?\s+(use|do|make|it'?s|i)",
        r"\bplease (don'?t|stop|avoid)",
        r"\bwrong\b",
        r"\bincorrect\b",
    ]

    # Preference patterns
    preference_patterns = [
        r"\bi (always|prefer|like to|want to|usually)\b",
        r"\bwe (always|prefer|like to|want to|usually)\b",
        r"\b(always|never) use\b",
        r"\bour (convention|style|standard|pattern)\b",
        r"\bin this (project|repo|codebase)\b",
    ]

    all_patterns = correction_patterns + preference_patterns

    for message in messages:
        for pattern in all_patterns:
            if re.search(pattern, message):
                return True

    return False


def main():
    try:
        # Read hook input from stdin
        input_data = json.load(sys.stdin)

        # Check if stop hook is already active (prevent loops)
        if input_data.get("stop_hook_active", False):
            print(json.dumps({"decision": "approve"}))
            sys.exit(0)

        # Get transcript path
        transcript_path = input_data.get("transcript_path", "")
        if not transcript_path or not Path(transcript_path).exists():
            print(json.dumps({"decision": "approve"}))
            sys.exit(0)

        # Get session ID and load previous state
        session_id = get_session_id(transcript_path)
        last_processed_count = load_state(session_id)

        # Load and analyze transcript
        transcript = load_transcript(transcript_path)
        user_messages = extract_user_messages(transcript)
        current_count = len(user_messages)

        # Only check new messages since last run
        new_messages = user_messages[last_processed_count:]

        # Always update state to current count
        save_state(session_id, current_count)

        # Check for learning signals in new messages only
        if new_messages and has_learning_signals(new_messages):
            # Exit code 2 with stderr shows message to user
            print(
                "Tip: Run /autoskill to capture this session's learnings",
                file=sys.stderr,
            )
            sys.exit(2)
        else:
            print(json.dumps({"decision": "approve"}))
            sys.exit(0)

    except Exception:
        # Fail gracefully
        print(json.dumps({"decision": "approve"}))
        sys.exit(0)


if __name__ == "__main__":
    main()
