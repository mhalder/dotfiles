---
name: security-audit
description: Audit system security configuration for vulnerabilities. Use when the user says "audit security", "harden server", "check security", "is my server secure", "security review", or asks about server hardening.
allowed-tools: Bash, Read, Grep
---

# Security Audit

Audit Linux system security configurations and recommend hardening measures.

## Instructions

1. Check each security category below
2. Document findings with severity
3. Provide specific remediation steps
4. Prioritize critical issues

## SSH configuration

```bash
# Check SSH config
grep -E "^(PermitRootLogin|PasswordAuthentication|PubkeyAuthentication|Port)" /etc/ssh/sshd_config

# Recommended settings
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
```

**Critical:** Flag if `PermitRootLogin yes` or `PasswordAuthentication yes`

## Firewall

```bash
# UFW status
ufw status verbose

# iptables
iptables -L -n -v
ip6tables -L -n -v

# nftables
nft list ruleset
```

**Critical:** Flag if firewall is disabled or allows 0.0.0.0/0 on sensitive ports

## User accounts

```bash
# Users with login shells
grep -v '/nologin\|/false' /etc/passwd

# Users with empty passwords
awk -F: '($2 == "") {print $1}' /etc/shadow

# Sudoers
grep -v '^#' /etc/sudoers /etc/sudoers.d/* 2>/dev/null

# Check for unauthorized sudo
grep NOPASSWD /etc/sudoers /etc/sudoers.d/*
```

## File permissions

```bash
# World-writable files
find / -type f -perm -002 2>/dev/null

# SUID/SGID binaries
find / -type f \( -perm -4000 -o -perm -2000 \) 2>/dev/null

# SSH key permissions
ls -la ~/.ssh/
```

## Services and ports

```bash
# Listening services
ss -tuln

# Enabled services
systemctl list-unit-files --state=enabled

# Running services
systemctl list-units --type=service --state=running
```

## Updates

```bash
# Pending security updates
apt list --upgradable 2>/dev/null | grep -i security
dnf check-update --security 2>/dev/null

# Kernel version
uname -r
```

## Output format

```
## Critical Issues
- [ ] SSH allows root login with password

## Warnings
- [ ] Firewall allows port 22 from any IP

## Recommendations
- [ ] Enable automatic security updates
- [ ] Configure fail2ban

## Passed Checks
- [x] No users with empty passwords
```

## Rules

- MUST check all categories before concluding
- MUST prioritize by severity (critical > warning > info)
- MUST provide specific remediation commands
- Never disable security features without explicit approval
- Never expose found credentials or sensitive data
- Always recommend backup before making changes
