Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075654FD29B;
	Mon, 19 Oct 2026 13:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418093; cv=none; b=jzZJ2tvs0M87PxJvNzpSd6r1fS9uTaZLrQQKIbdRYXF4It+VYf7dYrf0eD+mHSv8k6x6y5Yr8bbqx0P2+f44cemKonELm5Gct7xOzUxtf4Qrz27Pg+j3upzWCk6ZmHoD4zciLdwjnZDrniWJThUEykMCdYGyLZnapOecKrB3ZPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418093; c=relaxed/simple;
	bh=OWLb2TiGJ9IwlMCPEq24zD1+vzwirIdMUHo2W1pZaBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X1PRhM8zbFBHF7h7cH/AhyJSizdaasKVSJGkMzB4wXRKVbVE3n40pNPq6Vy4viht2MpNP9A23JsLj53e99v7wI8CS5K3dif4Op5Co0GWyP9nlViAZh4wU1zB6uES8ZRzYYp6xiAfMk8jLiXQ1cnE+KqyEhBj5yFZYYmPTUKrxQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OtBPssNy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OtBPssNy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC9521F000C8;
	Mon, 19 Oct 2026 13:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418089;
	bh=HnQ43w9Y9f8r4GagshV8oopPcggbOu3LYuh/KbApEkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OtBPssNyl7km5VBF+pbIwU+EJYhjfG0z03aw9QqEZMtezxjtjWzEa+DlQyATPGEhD
	 KZAcbYF3xXtN58FSKkFz51hn3z4NLXWRwFLm4lg/FerR+E6eh6UgWog4sfat1bnchh
	 oQgVm5l5LxSwpL5sFD9wbstHKTRBxEmd/zNPtRA4LDIeciM+IvLGs9Z2cvLyzdk4kV
	 ZWLYj7VU+sSYtXN2e7XiM+QdX4daI/uNBPPEuCYL2mKUUuzObfKZ1gMzMQynb6qNxj
	 vILwLgsgWM8gQcTs3FCH55j9lR23aLzRndywLiBs912mBcisHC03RWo0O7gjigOQri
	 cnZM7uWky568w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Ts'o <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] ext4: use FGP_WRITEBEGIN for tail block zeroing
Date: Mon, 19 Oct 2026 09:44:56 -0400
Message-ID: <20261019135441.1420968-5-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit e1cf7b5f5c8ad1e00d00c50c61c3e8fdc79cd422 ]

ext4_load_tail_bh() returns a locked folio that callers immediately
mutate through folio_zero_range() and mark_buffer_dirty().  Use
FGP_WRITEBEGIN so that, on backing devices that require stable writes,
__filemap_get_folio() waits for writeback to finish before returning
the folio; on regular devices the wait is a no-op.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260714080044.4038124-2-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough to decide: this is a one-line stable-writes data-integrity
fix in a userspace-reachable ext4 tail-zeroing path, and the helper and
`FGP_WRITEBEGIN` both exist in this 7.3-rc4 tree.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[ext4] [use] use FGP_WRITEBEGIN for tail block zeroing**

Subsystem prefix `ext4:`. Verb is “use” (correctness change of folio-get
flags, not a feature). Claimed intent: get the tail folio with the
write-begin flag set so writeback finishes before the folio is mutated.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Verified from `git show e1cf7b5f5c8ad1e00d00c50c61c3e8fdc79cd422`:

- **Fixes:** none (expected for this review pipeline)
- **Reported-by:** none
- **Tested-by:** none
- **Reviewed-by:** Jan Kara \<jack@suse.cz\> (ext4 co-maintainer)
- **Acked-by:** none
- **Link:** https://patch.msgid.link/20260714080044.4038124-2-
  yi.zhang@huaweicloud.com
- **Cc: stable:** none (expected; not a negative signal)
- **Signed-off-by:** Zhang Yi \<yi.zhang@huawei.com\> (author); Theodore
  Ts'o \<tytso@mit.edu\> (ext4 maintainer)

No syzbot, no kernel-test-robot, no multiple reporters.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:

- **Bug:** `ext4_load_tail_bh()` returns a locked folio that callers
  immediately mutate with `folio_zero_range()` and
  `mark_buffer_dirty()`, without waiting for in-flight writeback.
- **Symptom/failure mode:** On backing devices that require stable
  writes, page-cache contents can change while DMA/writeback is in
  progress, which can corrupt the in-flight write or break integrity
  checksums. On ordinary devices the extra wait is a no-op.
- **Version information:** none in the message. History shows the helper
  landed in v7.1-rc1 and this fix in v7.3-rc1.
- **Root cause:** folio obtained with `FGP_LOCK | FGP_ACCESSED |
  FGP_CREAT` (no `FGP_STABLE` / `FGP_WRITE`).

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: **Yes, this is a real bug fix**, not cleanup. The cover letter
for the series (v4) states it explicitly: “Add patch 1 to use
FGP_WRITEBEGIN in ext4_load_tail_bh(), fixing a pre-existing stable-
writes bug exposed by patch 4's reordering.”

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**

Record:

- File: `fs/ext4/inode.c` — **1 insertion, 1 deletion**
- Function: `ext4_load_tail_bh()`
- Scope: **single-file surgical fix** (one flag expression)

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record:

**Before:** `__filemap_get_folio(..., FGP_LOCK | FGP_ACCESSED |
FGP_CREAT, ...)`. Locks/creates the folio and marks it accessed. Does
**not** wait for writeback.

**After:** `__filemap_get_folio(..., FGP_WRITEBEGIN | FGP_ACCESSED,
...)`.

`FGP_WRITEBEGIN` is defined in `include/linux/pagemap.h` as:

`FGP_LOCK | FGP_WRITE | FGP_CREAT | FGP_STABLE`

Net additions: `FGP_WRITE` and `FGP_STABLE`. `FGP_STABLE` calls
`folio_wait_stable()` after the folio is locked (`mm/filemap.c`). That
waits for writeback only if `mapping_stable_writes()` is set.

Path affected: every caller of `ext4_load_tail_bh()` immediately zeros
the folio (`ext4_block_do_zero_range()`,
`ext4_block_journalled_zero_range()`). This is a **normal mutator
path**, not an error-only path.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record:

- **Category:** memory-safety / data integrity (stable-pages race with
  writeback), plus a small GFP/idle-flag side effect from `FGP_WRITE`
- **Mechanism:** On `AS_STABLE_WRITES` mappings, in-flight writeback
  DMA’s from page cache. Zeroing the folio without `folio_wait_stable()`
  can mix old and new contents in the I/O. `FGP_WRITEBEGIN` is the
  established write-begin flag set that waits first.

**Step 2.4: ASSESS THE FIX QUALITY**

Record:

- **Quality:** obviously correct. Same flags every `->write_begin`
  implementation uses. `folio_wait_stable()` is a no-op when
  `mapping_stable_writes()` is false, so typical disks are unchanged.
- **Regression risk:** very low. Waiting while the folio is locked is
  the documented write-begin pattern (`folio_wait_stable` comment: if
  unlocked, writeback can restart). `FGP_ACCESSED | FGP_WRITEBEGIN`
  still takes the `FGP_ACCESSED` branch in `__filemap_get_folio()`, so
  idle-flag clearing does not change vs the old flags; `FGP_WRITE` only
  adds `__GFP_WRITE` on allocation.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**

Record:

- Current line is `e1cf7b5f5c8ad` (this commit).
- Same flags were already in `__ext4_block_zero_page_range()` before the
  helper was factored out (`3b312a6f510ca`, v7.1-rc1, “ext4: factor out
  journalled block zeroing range”).
- Folio conversion `9d3973de9a374` (“ext4: Convert
  __ext4_block_zero_page_range() to use a folio”, v6.4 era) replaced
  `find_or_create_page()` with `FGP_LOCK | FGP_ACCESSED | FGP_CREAT`.
  `find_or_create_page()` also did **not** wait for stable writeback, so
  the gap is older than the helper.
- Helper `ext4_load_tail_bh` first appeared in **v7.1-rc1**
  (`3b312a6f510ca`).

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: **No Fixes: tag.** Not applicable. The immediate pre-image is
the helper as introduced in `3b312a6f510ca`, which copied the old flags.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record: This is **patch 1/9** of Zhang Yi’s series “ext4: fix unaligned
edge handling in FALLOC_FL_WRITE_ZEROES”, landed together around
2026-07-22:

1. `e1cf7b5f5c8ad` this commit
2. `2fff82f081401` skip tail zeroing for inline data
3. `705a3fd3bac16` check `ext4_get_block()` return
4. `b16e9d27a643a` move partial zeroing earlier in `ext4_zero_range()`
   (the reorder that **exposes** the stable-writes bug)
5–9. WRITE_ZEROES edge-handling / orphan-list work

This patch does **not** depend on 2–9. Later patches that increase tail-
zeroing (especially 4) depend on this one for correctness on stable-
write devices.

Related earlier commit `df0b5afc62f33` (“ext4: remove the redundant
folio_wait_stable()”) is a different path (`ext4_da_write_begin`); it
only shows that ext4 already treats `FGP_WRITEBEGIN` as implying the
stable wait.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Zhang Yi is a regular, high-volume ext4 contributor (tail-
zeroing, WRITE_ZEROES, journal paths). This series was reviewed by Jan
Kara and applied by Ted Ts'o. Related commits in the same week are the
rest of the 1/9 series.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record:

- Prerequisite API: `FGP_WRITEBEGIN` from `e999a5c5a19cf` (“fs: Add
  FGP_WRITEBEGIN”), present since **v6.4-rc1**. Present in this tree.
- Prerequisite function: `ext4_load_tail_bh()` since **v7.1-rc1**.
  Present in this tree.
- **Can apply standalone:** yes. One flag change; no new helpers.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:

- `b4 dig -c e1cf7b5f5c8ad` → https://patch.msgid.link/20260714080044.40
  38124-2-yi.zhang@huaweicloud.com
- Series revisions: **v3** (2026-07-08) and **v4** (2026-07-14). Cover
  letter: v4 has **no code changes** vs v3; v2 **added this patch**.
- Cover letter quote (verified in saved mbox): “Add patch 1 to use
  FGP_WRITEBEGIN in ext4_load_tail_bh(), fixing a pre-existing stable-
  writes bug exposed by patch 4's reordering.”
- Ted Ts'o applied the series; patch 9 was dropped separately over
  error-handling concerns.
- No NAK on this patch. No reviewer asked for `Cc: stable` on patch 1
  (patches 7/8 in the same mbox do have `Cc: stable`, for WRITE_ZEROES-
  specific bugs).
- WebFetch of lore.kernel.org returned **403**; discussion recovered via
  `b4 dig -m /tmp/ext4-fgp.mbox`.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

`b4 dig -w` recipients included linux-ext4, linux-fsdevel, tytso,
adilger, Jan Kara, Ojaswin Mujoo, Ritesh Harjani, Huawei ext4
developers.

Record: **Jan Kara Reviewed-by** (in the patch); **Ted Ts'o** applied
it. Right maintainers were on the thread.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: **No standalone bugzilla/syzbot report.** The bug was found
while reworking WRITE_ZEROES unaligned edges. Severity from the author:
pre-existing **stable-writes data-integrity** bug.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Standalone as a fix. The rest of 1/9 is WRITE_ZEROES contract
work and two other pre-existing helper fixes (inline-data skip;
propagate `ext4_get_block()` errors). This commit does not require those
to be correct.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: lore.kernel.org/stable WebFetch returned **403**. No evidence in
the ext4 thread that this patch 1 was requested for stable or rejected
for stable. **UNVERIFIED** whether linux-stable@ discussed it.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**

Record: **`ext4_load_tail_bh()`** only.

**Step 5.2: TRACE CALLERS**

Verified in this tree:

- `ext4_block_do_zero_range()` → `folio_zero_range()` +
  `mark_buffer_dirty()`
- `ext4_block_journalled_zero_range()` → journal write access +
  `folio_zero_range()`
- Both from `ext4_block_zero_range()`
- That is used by:
  - `ext4_block_zero_eof()` — truncate (`ext4_truncate`), append
    (`ext4_write_checks` in `fs/ext4/file.c`), extent operations
    (`fs/ext4/extents.c`)
  - `ext4_zero_partial_blocks()` — punch hole / zero_range /
    WRITE_ZEROES (`ext4_punch_hole`, `ext4_zero_range`, extents
    WRITE_ZEROES)

Record: **Common filesystem operations**, process context, folio locked.
Not IRQ.

**Step 5.3: TRACE CALLEES**

Record: `__filemap_get_folio()` → on `FGP_STABLE`, `folio_wait_stable()`
→ `folio_wait_writeback()` if `mapping_stable_writes()`. Then
`create_empty_buffers` / `ext4_get_block` / `ext4_read_bh_lock` as
before.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: **Userspace-reachable** without privilege beyond write access to
an ext4 file: `truncate`,
`fallocate(PUNCH_HOLE|ZERO_RANGE|WRITE_ZEROES)`, append `write()`.
**HIGH** reachability.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: Other ext4 write paths already use `FGP_WRITEBEGIN`
(`fs/ext4/inline.c`, `fs/ext4/move_extent.c`) and/or explicit
`folio_wait_stable()` (`ext4_write_begin`, `ext4_page_mkwrite`). Tail-
block zeroing was the outlier.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record:

- Local tree: **`git describe HEAD` = `v7.3-rc4-27-gf0100363d8c37`**,
  `VERSION=7 PATCHLEVEL=3 SUBLEVEL=0 EXTRAVERSION=-rc4`. Origin is
  torvalds/linux (mainline), detached HEAD.
- `ext4_load_tail_bh()` exists at `fs/ext4/inode.c` (currently already
  using `FGP_WRITEBEGIN | FGP_ACCESSED` because `e1cf7b5f5c8ad` **is an
  ancestor of HEAD**).
- Buggy pre-image (helper with `FGP_LOCK | FGP_ACCESSED | FGP_CREAT`)
  existed from **v7.1-rc1** (`3b312a6f510ca`) until this fix in
  **v7.3-rc1**.
- `FGP_WRITEBEGIN` exists here (`include/linux/pagemap.h:720`).

The pipeline instruction is to ignore “already selected” markers, not to
treat mainline already containing the original commit as a reason to
reject a backport-worthy fix. The code and prerequisites are in this
tree.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Clean apply** on this tree (one-line flag change;
`FGP_WRITEBEGIN` present). `git log --oneline -10 -- fs/ext4/inode.c`
shows normal ext4 churn; nothing that would conflict with this hunk.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: This exact change **is** HEAD’s current code (`git blame` on the
flags line is `e1cf7b5f5c8ad`). No alternate fix for the same stable-
writes hole in `ext4_load_tail_bh()`. Other `folio_wait_stable()` sites
in ext4 do not cover this helper.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: **Subsystem: fs/ext4. Criticality: IMPORTANT** (widely used
filesystem; data-integrity on stable-write devices). Not core mm/VFS,
but truncate/punch/zero are universal ext4 operations.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: **Actively developed** (WRITE_ZEROES series, iomap conversion,
journal/writeback fixes in 7.3). The helper itself is recent (v7.1) but
the missing stable wait is the same pattern as the older zero-page-range
code.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: **ext4 users whose backing device requires stable writes**, i.e.
`bdev_stable_writes()`: integrity checksums (`CONFIG_BLK_DEV_INTEGRITY`)
**or** `BLK_FEAT_STABLE_WRITES`.

Verified setters of `BLK_FEAT_STABLE_WRITES` in this tree include NVMe
(when `data_digest` is enabled), RAID5 `skip_copy`, dm-integrity, zram,
RBD, iSCSI TCP, MMC, DRBD. Superblock then sets `SB_I_STABLE_WRITES` and
inode mappings get `AS_STABLE_WRITES`.

Not universal, but not a toy config: enterprise integrity, RAID, dm-
integrity, some NVMe.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record:

- Trigger: tail/partial-block zeroing while that folio is under
  writeback.
- How common: truncate, punch, zero_range, append past EOF —
  **routine**. The race still needs concurrent writeback of that folio,
  so it is **timing-dependent**.
- Cover letter: patch 4’s reorder **widens** the window; the bug is
  still pre-existing without patch 4. This tree **already has patch 4**
  (`b16e9d27a643a`).
- Unprivileged users with write access **can** trigger the operations.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record: **Failure mode: in-flight writeback sees torn folio contents /
integrity checksum mismatch.** **Severity: CRITICAL** (data corruption),
limited to stable-write devices. Not a panic path.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:

- **Benefit: high** for ext4 on stable-write devices (prevents silent
  data corruption on common ops). **Low** for everyone else (wait is a
  no-op).
- **Risk: very low** (1 line, standard flags, no API change, no new
  locking order).
- **Ratio: strongly favors applying.**

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

**FOR backporting:**

- Author and cover letter call it a **pre-existing stable-writes bug**.
- Mutating a folio under writeback on `AS_STABLE_WRITES` is a known
  class of **data corruption**.
- Reachable from truncate / fallocate / append.
- One-line, matches `FGP_WRITEBEGIN` used everywhere else.
- Reviewed by Jan Kara; applied by Ted Ts'o.
- `FGP_WRITEBEGIN` and `ext4_load_tail_bh()` both exist in this 7.3-rc4
  tree.
- This tree also has the later reorder (`b16e9d27a643a`) that
  **exposes** the race more.

**AGAINST backporting:**

- No Fixes tag, no user/syzbot report (not a valid NO by pipeline
  rules).
- Nested in a 9-patch WRITE_ZEROES series; later patches are feature-
  contract fixes. This patch is still self-contained.
- Author did not `Cc: stable` on patch 1 (other patches in the same
  series did).
- Bug existed in spirit since `find_or_create_page()`; field reports are
  absent, so the race may be rare without the v7.3 reorder.

**UNRESOLVED:**

- linux-stable@ archives could not be fetched (HTTP 403).
- Full v2 mailing-list review text for this hunk was not retrieved (lore
  403); Jan’s Reviewed-by on the committed patch is verified.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — one flag change to the
   standard write-begin set; reviewed by Jan Kara; in mainline since
   v7.3-rc1.
2. Fixes a real bug that affects users? **PASS** — stable-writes devices
   (NVMe digest, RAID5 skip_copy, dm-integrity, zram, T10 PI, etc.).
3. Important issue? **PASS** — data corruption on in-flight writeback,
   not a crash, but explicitly in the stable rules list.
4. Small and contained? **PASS** — 1 line, one function.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — `FGP_WRITEBEGIN` and
   `ext4_load_tail_bh()` are here; the hunk is identical to what already
   landed.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: **None** (not a device ID, quirk, DT, build, or docs exception).
It qualifies as a normal data-integrity bug fix.

**Step 9.4: MAKE YOUR DECISION**

This tree is **Linux 7.3-rc4** (Linus mainline). The helper lives here,
`FGP_WRITEBEGIN` lives here, and callers still zero the folio
immediately. The change is a one-line restoration of the stable-write
wait that every other write-begin path already does. That is exactly the
kind of small, important data-integrity fix stable trees should take.
The surrounding WRITE_ZEROES series is not required for this hunk to be
correct.

### What the commit solves

`ext4_load_tail_bh()` was grabbing a locked folio without `FGP_STABLE`.
Callers then call `folio_zero_range()` and dirty the buffer. On devices
that set `AS_STABLE_WRITES` (integrity checksums or
`BLK_FEAT_STABLE_WRITES`), that can change page-cache bytes while
writeback DMA is still running. Switching to `FGP_WRITEBEGIN |
FGP_ACCESSED` waits for writeback first; elsewhere the wait is a no-op.

### Stable rules / risk vs benefit

Meets all six stable criteria. Benefit is preventing filesystem data
corruption on a real (if not universal) device class; risk is a single
established flag combination.

### Concerns

- Nested in a larger series, but this patch is standalone.
- No field report; the author found it while reordering zeroing. Still a
  concrete integrity bug, and this tree already contains the reorder
  that widens it.
- Lore stable-list search was blocked (403); that does not change the
  code-level conclusion.

Verification:
- [Phase 1] Parsed tags from `git show e1cf7b5f5c8ad`: Reviewed-by Jan
  Kara; Link msgid `...4038124-2...`; no Fixes/Reported-by/Cc:stable
- [Phase 1] Cover letter in `/tmp/ext4-fgp.mbox` msg 5: “pre-existing
  stable-writes bug exposed by patch 4's reordering”
- [Phase 2] Diff: 1 line in `ext4_load_tail_bh()`; flags
  `FGP_LOCK|FGP_ACCESSED|FGP_CREAT` → `FGP_WRITEBEGIN|FGP_ACCESSED`
- [Phase 2] `FGP_WRITEBEGIN` = `FGP_LOCK|FGP_WRITE|FGP_CREAT|FGP_STABLE`
  (`include/linux/pagemap.h:720`)
- [Phase 2] `__filemap_get_folio` calls `folio_wait_stable()` when
  `FGP_STABLE` (`mm/filemap.c:1986-1987`)
- [Phase 2] `folio_wait_stable()` only waits if
  `mapping_stable_writes()` (`mm/page-writeback.c:3105-3108`)
- [Phase 3] `git describe --contains --match 'v7.*' 3b312a6f510ca` →
  v7.1-rc1 (helper introduced)
- [Phase 3] `git describe --contains --match 'v7.*' e1cf7b5f5c8ad` →
  v7.3-rc1 (this fix)
- [Phase 3] `git merge-base --is-ancestor e1cf7b5f5c8ad HEAD` true;
  `3b312a6f510ca` also ancestor
- [Phase 3] `git show 9d3973de9a374`: folio conversion used the same
  non-stable flags; previously `find_or_create_page()`
- [Phase 3] `git show 3b312a6f510ca`: factor-out copied those flags into
  `ext4_load_tail_bh()`
- [Phase 4] `b4 dig -c e1cf7b5f5c8ad`: lore URL; v3 then v4; v4 no code
  change
- [Phase 4] `b4 dig -w`: linux-ext4, tytso, Jan Kara, adilger, Ojaswin,
  Ritesh on Cc
- [Phase 4] `b4 dig -m /tmp/ext4-fgp.mbox`: Ted applied 1–8; patch 9
  dropped; no NAK on patch 1
- [Phase 4] WebFetch lore.kernel.org 403 — UNVERIFIED stable-list
  discussion
- [Phase 5] Callers: `ext4_block_do_zero_range` /
  `ext4_block_journalled_zero_range` → `ext4_block_zero_range` →
  `ext4_block_zero_eof` / `ext4_zero_partial_blocks` (truncate, punch,
  zero_range, WRITE_ZEROES, append)
- [Phase 5] Other ext4 write paths already use `FGP_WRITEBEGIN` or
  `folio_wait_stable()`
- [Phase 6] `git describe HEAD` = v7.3-rc4-27-gf0100363d8c37; Makefile
  7.3.0-rc4
- [Phase 6] Current `fs/ext4/inode.c:4042-4043` already has
  `FGP_WRITEBEGIN | FGP_ACCESSED`
- [Phase 7] fs/ext4, important filesystem
- [Phase 8] `bdev_stable_writes()` = integrity csum OR
  `BLK_FEAT_STABLE_WRITES` (`include/linux/blkdev.h:1410-1414`)
- [Phase 8] `BLK_FEAT_STABLE_WRITES` set by nvme (data_digest), raid5
  skip_copy, dm-integrity, zram, rbd, iscsi_tcp, mmc, drbd
- [Phase 8] Failure: data corruption on stable-write devices; wait is
  no-op otherwise
- UNVERIFIED: linux-stable mailing list history (HTTP 403)
- UNVERIFIED: full v2 review mail body for this hunk (lore 403);
  Reviewed-by on the commit is verified

**YES**

 fs/ext4/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 2e3f7ba1a924b..c3fb5f16f6e39 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4092,7 +4092,7 @@ static int __ext4_block_zero_page_range(handle_t *handle,
 	int err = 0;
 
 	folio = __filemap_get_folio(mapping, from >> PAGE_SHIFT,
-				    FGP_LOCK | FGP_ACCESSED | FGP_CREAT,
+				    FGP_WRITEBEGIN | FGP_ACCESSED,
 				    mapping_gfp_constraint(mapping, ~__GFP_FS));
 	if (IS_ERR(folio))
 		return PTR_ERR(folio);
-- 
2.53.0

