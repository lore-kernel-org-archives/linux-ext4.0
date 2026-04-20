Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225973C061F;
	Mon, 20 Apr 2026 13:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691589; cv=none; b=ZHQW2kdpmomho6owITTKBbYE6CHuZIbCyqcB9xf/xmiGb6zj8a+U+xZQhyftbdp/NSwlQ7e0YYhrWIsFDiRHQCKZnTfDchGuVNEfUElTFR/yz0uTO7m3+orZ7o4Eahn5OlbAHLAdUcQIri5GGbsNvqkGaFwd+spt1qI+Wev1JlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691589; c=relaxed/simple;
	bh=sPJMW+s3Rw8NpLqbkTOQEfA5njLVPWmC6JhJ/4UxirM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hnsa5+ifmUbu/MS8ll4XQNPQtdwTgt5GJGMW1bGS9CCxni8RQzFzclTmkYiJ9/ZUXRZ02FsXw4Gh6bdLlma8joGFhMN46ScSjO/d9coH/KH0ZPR52xGJQlajrhfQZdZYQdjwD5J6M3GhIDICjV/AZPYfzysHuIVOc8j8Ow/lWUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qljNbAxG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qljNbAxG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10603C2BCB8;
	Mon, 20 Apr 2026 13:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691589;
	bh=sPJMW+s3Rw8NpLqbkTOQEfA5njLVPWmC6JhJ/4UxirM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qljNbAxGr/VTDUgrDSMGNJBj1ICapNSt65y1Wkqum+ul6oaYKPLw6pxsTk8rD5gYR
	 2pZhq5XZJi4lM0krL8mT5e/u/1+wEKXzdnFhqisGoyW4Gs1kpGb+MUzGe6AGYa97fn
	 SZy2p3g8ouWeszqkHtwhvlFaB6JOSu8UqeuWtL/MuUmrQtIy5k+IibObuSpnglSpaZ
	 oL/BcYvMSUD3vrx8M4L6fBx8HP8WDOaL1hWV3Tk3QF0ySbI/g7tL5lpCWV7KUGnvNy
	 uzdNhrrj0f+ZUdz0WS0b3PC/LfStcfLke5bgDW9lF0CohM4u2Cs6kPHnAzHqW3pewp
	 4hz2C51xzvmPg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Milos Nikic <nikic.milos@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>,
	jack@suse.com,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] ext2: replace BUG_ON with WARN_ON_ONCE in ext2_get_blocks
Date: Mon, 20 Apr 2026 09:18:32 -0400
Message-ID: <20260420132314.1023554-118-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Milos Nikic <nikic.milos@gmail.com>

[ Upstream commit 0cf9c58bf654d0f27abe18005281dbf9890de401 ]

If ext2_get_blocks() is called with maxblocks == 0, it currently triggers
a BUG_ON(), causing a kernel panic.

While this condition implies a logic error in the caller, a filesystem
should not crash the system due to invalid arguments.

Replace the BUG_ON() with a WARN_ON_ONCE() to provide a stack trace for
debugging, and return -EINVAL to handle the error gracefully.

Signed-off-by: Milos Nikic <nikic.milos@gmail.com>
Link: https://patch.msgid.link/20260207010617.216675-1-nikic.milos@gmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for my analysis. Let me compile
the complete assessment.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem:** ext2
- **Action verb:** "replace" (BUG_ON with WARN_ON_ONCE)
- **Summary:** Converts a crash-inducing assertion into a graceful error
  return in ext2 block allocation

Record: [ext2] [replace] [Convert BUG_ON to WARN_ON_ONCE + return
-EINVAL for maxblocks==0 assertion]

### Step 1.2: Tags
- **Signed-off-by:** Milos Nikic (author) and Jan Kara (ext2 maintainer,
  merged)
- **Link:** `https://patch.msgid.link/20260207010617.216675-1-
  nikic.milos@gmail.com`
- No Fixes: tag (expected for AUTOSEL candidate)
- No Reported-by: tag
- No Cc: stable tag

Record: Signed-off by ext2 maintainer Jan Kara. No Fixes, no Reported-
by, no syzbot. No explicit stable nomination.

### Step 1.3: Commit Body
The commit explains that when `ext2_get_blocks()` is called with
`maxblocks == 0`, it triggers a `BUG_ON()` causing a kernel panic. The
author argues a filesystem should not crash the system due to invalid
arguments.

Record: [Bug: BUG_ON causes kernel panic on invalid argument] [Symptom:
kernel panic/crash] [Root cause: overly aggressive assertion for a
condition that should be handled gracefully]

### Step 1.4: Hidden Bug Fix Detection
This is a defensive hardening change. BUG_ON() is itself a bug when a
graceful recovery is possible. The kernel community has been
systematically converting such assertions.

Record: This is a fix for "BUG_ON is a bug" - the assertion behavior is
itself the problem.

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **Files:** `fs/ext2/inode.c` only
- **Lines changed:** -1 / +2 (net +1 line)
- **Function modified:** `ext2_get_blocks()`
- **Scope:** Single-file, single-function, surgical fix

### Step 2.2: Code Flow Change
**Before:** `BUG_ON(maxblocks == 0)` — triggers kernel panic, system
crashes
**After:** `if (WARN_ON_ONCE(maxblocks == 0)) return -EINVAL;` — prints
stack trace once, returns error code gracefully

The change affects the entry validation of `ext2_get_blocks()`, before
any actual work is done.

### Step 2.3: Bug Mechanism
Category: **Logic/correctness fix** (defensive assertion improvement).
The BUG_ON() unconditionally panics the system for a condition that can
be handled by returning an error.

### Step 2.4: Fix Quality
- Obviously correct: YES. This is a standard, well-understood pattern.
- Minimal: YES. 2 lines.
- Regression risk: Extremely low. The only behavior change is: if
  `maxblocks == 0`, instead of crashing, return -EINVAL. Both callers
  (`ext2_get_block` and `ext2_iomap_begin`) check return values
  properly.

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
The `BUG_ON(maxblocks == 0)` was introduced by commit `7ba3ec5749ddb6`
(Jan Kara, 2013-11-05, "ext2: Fix fs corruption in ext2_get_xip_mem()").
This commit first appeared in v3.13-rc1, meaning the buggy BUG_ON has
been present in **every stable tree** since v3.13 (~11 years).

### Step 3.2: Original Commit Context
The original commit `7ba3ec5749ddb6` fixed a real bug in
`ext2_get_xip_mem()` where 0 blocks were being requested. The BUG_ON was
added as a defensive assertion to catch similar bugs. The actual XIP bug
was also fixed in the same commit. The BUG_ON was always a "shouldn't
happen" assertion.

### Step 3.3: File History
`fs/ext2/inode.c` has had moderate churn (~44 changes since v5.15, ~65
since v5.4), but the specific BUG_ON line has been untouched since 2013.
No related fixes in this area.

### Step 3.4: Author
Milos Nikic is not the subsystem maintainer, but the patch was accepted
and signed-off by Jan Kara, who is the ext2 maintainer and who
originally added the BUG_ON.

### Step 3.5: Dependencies
None. This is a standalone 2-line change with no dependencies.

## PHASE 4: MAILING LIST RESEARCH

From the mbox thread:
1. **v1 submitted:** Feb 6, 2026
2. **Author ping:** Feb 26, 2026 — "Just a friendly ping on this patch"
3. **Jan Kara reply:** Feb 27, 2026 — "Thanks merged now."

No NAKs, no objections, no explicit stable nomination. Minimal
discussion — the maintainer accepted it without requesting changes. No
one mentioned stable.

Record: Single-version patch, accepted without changes by ext2
maintainer.

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Functions Modified
Only `ext2_get_blocks()` is modified (static function in
`fs/ext2/inode.c`).

### Step 5.2: Callers
`ext2_get_blocks()` is called from:
1. `ext2_get_block()` (line 791) — where `max_blocks = bh_result->b_size
   >> inode->i_blkbits`
2. `ext2_iomap_begin()` (line 835) — where `max_blocks = (length + (1 <<
   blkbits) - 1) >> blkbits`

`ext2_get_block()` is called from numerous VFS paths:
`mpage_read_folio`, `mpage_readahead`, `block_write_begin`,
`generic_block_bmap`, `mpage_writepages`, `block_truncate_page`, and
`__block_write_begin`.

### Step 5.3-5.4: Reachability
The code is reachable from common filesystem operations (read, write,
truncate, bmap). In `ext2_get_block()`, `max_blocks` could theoretically
be 0 if `bh_result->b_size` is less than `(1 << i_blkbits)`. In
`ext2_iomap_begin()`, `max_blocks` would be 0 only if `length == 0`.
Both should be prevented by callers, but are not explicitly validated in
the callee.

### Step 5.5: Similar Patterns
There are other BUG_ON instances in ext2 (`balloc.c`, `dir.c`, `acl.c`).
The kernel has been systematically converting such assertions across
filesystems (e.g., `ext4: convert some BUG_ON's in mballoc`, `nilfs2:
convert BUG_ON in nilfs_finish_roll_forward`, `quota: Remove BUG_ON from
dqget()`).

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Code Existence in Stable
The BUG_ON line exists in ALL active stable trees (introduced in v3.13).
The line `BUG_ON(maxblocks == 0)` at the same location is unchanged
since 2013.

### Step 6.2: Backport Complications
The patch should apply cleanly to all stable trees — the surrounding
code is identical across all branches (verified via blame: the context
lines are from 2005/2007).

### Step 6.3: No related fixes already in stable for this issue.

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem Criticality
- **Subsystem:** ext2 filesystem
- **Criticality:** IMPORTANT — ext2 is still used in embedded systems,
  older systems, and as a simple/reliable FS choice
- A panic in filesystem code can cause data loss and is especially
  disruptive

### Step 7.2: Activity
ext2 is a mature, low-activity subsystem. The code being fixed has been
stable for 11 years.

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Affected Users
All ext2 users across all kernel versions since v3.13. Ext2 is still
used in embedded, IoT, and some server configurations.

### Step 8.2: Trigger Conditions
Currently, no known caller passes maxblocks == 0. However:
- A corrupted filesystem image could potentially lead to invalid
  parameters
- A future kernel bug (like the XIP bug that motivated the BUG_ON) could
  trigger it
- The condition is a "shouldn't happen" scenario, but if it does, the
  system panics

### Step 8.3: Failure Mode Severity
- **Without fix:** Kernel panic (BUG_ON) → CRITICAL (system crash,
  potential data loss)
- **With fix:** WARN_ON_ONCE + -EINVAL → LOW (warning message, graceful
  error handling)

### Step 8.4: Risk-Benefit Ratio
- **Benefit:** Prevents kernel panic if condition ever triggers.
  Converts crash to graceful error.
- **Risk:** Essentially zero. 2 lines, obviously correct, well-
  understood pattern. The -EINVAL return is properly handled by both
  callers.
- **Ratio:** Extremely favorable.

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Compilation

**FOR backporting:**
- Prevents kernel panic (BUG_ON → WARN_ON_ONCE)
- 2-line change, minimal regression risk
- Obviously correct pattern
- Accepted by ext2 maintainer Jan Kara (who wrote the original BUG_ON)
- Code exists in ALL stable trees since v3.13
- Will apply cleanly to all stable trees
- Filesystem code should never crash the system on input validation
- No dependencies, completely standalone

**AGAINST backporting:**
- No known trigger in current code — the condition is theoretical
- No syzbot report, no user reports of the BUG_ON firing
- Could be considered defensive hardening rather than fixing a real bug
- No explicit stable nomination by anyone

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **YES** — trivial, well-understood
   pattern, merged by maintainer
2. Fixes a real bug? **YES** — BUG_ON causing unnecessary kernel panic
   IS a bug in filesystem code
3. Important issue? **YES if triggered** — kernel panic is CRITICAL
   severity
4. Small and contained? **YES** — 2 lines in 1 file
5. No new features or APIs? **YES** — purely defensive improvement
6. Can apply to stable? **YES** — code is unchanged since v3.13

### Step 9.3: Exception Categories
Not strictly an exception category, but "BUG_ON to WARN_ON_ONCE
conversion in filesystem code" is a well-accepted pattern that has been
backported before.

### Step 9.4: Decision
The change is a tiny (2-line), obviously correct fix that prevents a
kernel panic in a filesystem. While the trigger condition is currently
theoretical, the risk of the backport is essentially zero, and the
benefit if triggered (preventing a crash vs. graceful error) is
significant. The ext2 maintainer accepted it. The BUG_ON has existed in
all stable trees for 11+ years.

## Verification

- [Phase 1] Parsed tags: Signed-off-by Milos Nikic and Jan Kara. Link to
  lore. No Fixes/Reported-by/Cc:stable.
- [Phase 2] Diff analysis: 1 line removed (`BUG_ON`), 2 lines added (`if
  (WARN_ON_ONCE(...)) return -EINVAL`), in `ext2_get_blocks()`.
- [Phase 3] git blame: `BUG_ON(maxblocks == 0)` introduced by commit
  `7ba3ec5749ddb6` (Jan Kara, 2013-11-05), first in v3.13-rc1. Present
  in ALL stable trees.
- [Phase 3] git show `7ba3ec5749ddb6`: Original commit was "ext2: Fix fs
  corruption in ext2_get_xip_mem()" — BUG_ON added as defensive
  assertion alongside actual XIP fix.
- [Phase 3] git log -20 on file: No related fixes or prerequisites for
  this change.
- [Phase 3] Author check: Milos Nikic also authored `bac3190a8e79b`
  (jbd2 hardening). Jan Kara is ext2 maintainer.
- [Phase 4] b4 mbox retrieved thread: 3 messages — original patch,
  author ping, Jan Kara "Thanks merged now." No review comments, no
  NAKs, no stable nomination.
- [Phase 5] Callers: `ext2_get_block()` (VFS callback, many callers) and
  `ext2_iomap_begin()` (iomap path). Both handle negative return values
  properly.
- [Phase 5] Trigger analysis: `max_blocks` computed from `b_size >>
  i_blkbits` or ceiling division of `length`. Currently prevented by
  callers but not validated in callee.
- [Phase 6] BUG_ON line unchanged since 2013, applies cleanly to all
  stable trees.
- [Phase 6] ext2/inode.c: 44 changes since v5.15 but none near the
  BUG_ON line.
- [Phase 8] Risk: essentially zero (2 lines, pattern is standard).
  Benefit: prevents panic if triggered.
- UNVERIFIED: Could not access lore.kernel.org web UI due to Anubis bot
  protection, but successfully retrieved full thread via b4 mbox.

**YES**

 fs/ext2/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index dbfe9098a1245..18bf1a91dbc24 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -638,7 +638,8 @@ static int ext2_get_blocks(struct inode *inode,
 	int count = 0;
 	ext2_fsblk_t first_block = 0;
 
-	BUG_ON(maxblocks == 0);
+	if (WARN_ON_ONCE(maxblocks == 0))
+		return -EINVAL;
 
 	depth = ext2_block_to_path(inode,iblock,offsets,&blocks_to_boundary);
 
-- 
2.53.0

