Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959AF55CA14;
	Mon, 19 Oct 2026 14:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418544; cv=none; b=ZHOjaumLS9nw7p93FWJFDvrEHPY9E82wmDjQ38ORwkJB90TyWJbVBhJbzxfNWMpgZrd81ef2zYh9YvkmgFaD6HyCdtY0GUkPGxCkNO/zNNAPOh5VLfJ09S0MvWMK2dFqSN9yTGgmtJZ4WFQ3jhGGnw87yqfS7ZMBGApTmqrdGek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418544; c=relaxed/simple;
	bh=UDq5053jnIp0nACalX/WLj/JAyswSDu0oN7/MP8AyKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=APX0TJQggCSfzPKPKYfGRf6gKoCazAW8ISGeOse1ryT0Lfnx/iLBrAATh298d4ul3hqP6c2j4jKhQONzSV79Ctb4dvnjAHSwqS4C0U8nXCeRt3xo/9ZxPNkWbo1OUYSD/6hVxZgV8XAqbDL0LUlVrHoEKMWruN9hnUZG00+n9TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MLrgiH9l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MLrgiH9l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C0811F000C9;
	Mon, 19 Oct 2026 14:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418540;
	bh=ML5Ogu5sz5ZvjQpb+auDtP+seRlGoKMEgtVP1eyM/so=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MLrgiH9lqyFdyDN8tPbm0azHyvUI+DYljXiM+0qWbHWoj6zFnRcpF9LRff0E4JAk4
	 yYKk104Ef0IERi17kJjajcIz5OmIb6/8+3TrwBqSmJdw7HUGaNaxJtyYOfOmlireee
	 Er9B9Bv0EuExddgcqLgqff6Mj1Fz19zaI7glb7HEAX+PR3sheXXdfOqMvmr+mpbR0Q
	 019MBl8xAhotkF9oaDC0fH3uZ3vElPgjhWEVfubZXswvAuQb7Gu7EZ39/zwZN3ZNyk
	 Ad5zfdEuFv9qMdK7QkRTaT4tq0u9Gu43BMEqCTeCfGD6pze9Itzo8vEu2ieGFD9iPr
	 kdIWmsgr7hA1A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yun Zhou <yun.zhou@windriver.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Ts'o <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ext4: set EXT4_STATE_NO_EXPAND in ext4_evict_inode
Date: Mon, 19 Oct 2026 09:50:12 -0400
Message-ID: <20261019135441.1420968-321-sashal@kernel.org>
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

From: Yun Zhou <yun.zhou@windriver.com>

[ Upstream commit 2c0e4fb511f97467dafc91b6afb3414100289081 ]

An inode being evicted will never need its extra isize expanded.  Set
EXT4_STATE_NO_EXPAND before ext4_mark_inode_dirty() in ext4_evict_inode()
to make this explicit and prevent any unnecessary work in
ext4_try_to_expand_extra_isize().

This also provides defense-in-depth for the s_writepages_rwsem deadlock
during mount-time orphan cleanup, ensuring the expand path is blocked
for inodes under eviction regardless of how they are reached.

Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260623061903.2148767-2-yun.zhou@windriver.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have the series context, Jan Kara’s review, and the syzbot stack.
Compiling the nine-phase analysis and the backport verdict for this
tree.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[ext4] [set] set EXT4_STATE_NO_EXPAND in ext4_evict_inode**

- Subsystem: `ext4`
- Action verb: **set** (the body also uses “prevent” and “ensuring … is
  blocked”)
- Claimed intent: mark an inode under eviction so extra-isize expansion
  is skipped

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- **Reviewed-by:** Jan Kara `<jack@suse.cz>` (ext4 reviewer / long-time
  maintainer)
- **Link:** `https://patch.msgid.link/20260623061903.2148767-2-
  yun.zhou@windriver.com` (patch **2/2**)
- **Signed-off-by:** Yun Zhou `<yun.zhou@windriver.com>` (author)
- **Signed-off-by:** Theodore Ts'o `<tytso@mit.edu>` (ext4 maintainer;
  merged)
- **No Fixes:** tag on the committed version (expected for this review
  pipeline)
- **No Cc: stable** (expected)
- **No Reported-by / Closes** on this revision (those tags live on patch
  1/2)

Notable: this is explicitly patch **2/2** of a two-patch series.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug description:** An evicted inode never needs extra isize
  expanded. Doing that work is unnecessary and can participate in the
  `s_writepages_rwsem` deadlock during mount-time orphan cleanup.
- **Symptom/failure mode:** Circular lock dependency / deadlock
  (`s_writepages_rwsem` → jbd2 handle → `xattr_sem` →
  `s_writepages_rwsem`).
- **Version information:** none in this commit; sibling patch 1/2 has
  `Fixes: c8585c6fcaf2` (v4.7-rc1).
- **Author’s root-cause framing:** skip expansion by setting
  `EXT4_STATE_NO_EXPAND` before `ext4_mark_inode_dirty()` in
  `ext4_evict_inode()`. Described as making the invariant explicit
  **and** as defense-in-depth for the mount-time orphan deadlock.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: **Yes — this is a hidden/downplayed deadlock-path fix, not mere
cleanup.**

The committed text says “unnecessary work” and “defense-in-depth”. The
**v1** of this exact one-line change was titled *“skip extra isize
expansion on inode eviction to avoid deadlock”*, carried the syzbot
`Reported-by`/`Closes`/`Fixes:` tags, and the syzbot stack is
`ext4_orphan_cleanup` → `evict` → **`ext4_evict_inode`** →
`__ext4_mark_inode_dirty` → `ext4_try_to_expand_extra_isize`. The tags
moved to patch 1/2 (`!SB_ACTIVE`) after Jan Kara asked for the real
lock-order fix; this line remained as the eviction-path closer.

---

## PHASE 2: DIFF ANALYSIS - LINE BY LINE

**Step 2.1: INVENTORY THE CHANGES**

Record:
- **Files:** `fs/ext4/inode.c` — **+1 / −0**
- **Function:** `ext4_evict_inode()`
- **Scope:** single-file, one-line surgical change

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record:
- **Before:** deletion path sets `i_size = 0`, then calls
  `ext4_mark_inode_dirty()`. That calls `__ext4_mark_inode_dirty()` → if
  `i_extra_isize < s_want_extra_isize`,
  `ext4_try_to_expand_extra_isize()`, which may take `xattr_sem`, move
  xattrs, and `iput()` EA inodes.
- **After:** `ext4_set_inode_state(inode, EXT4_STATE_NO_EXPAND)` runs
  first. `ext4_try_to_expand_extra_isize()` already returns `-EOVERFLOW`
  when that flag is set (check present since 2017), so expansion is
  skipped for this and later `ext4_mark_inode_dirty()` calls in the same
  eviction.
- **Path:** deletion path only (after the `i_nlink` / `is_bad_inode`
  early outs; not the cache-drop `no_delete` path).

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record:
- **Category:** deadlock / lock-ordering (plus skipping pointless
  expansion that can `iput` EA inodes under a jbd2 handle).
- **Mechanism:** mount-time orphan cleanup (`!SB_ACTIVE`) of a deleted
  inode (`i_nlink == 0`) hits `ext4_evict_inode` → expand extra isize →
  `ext4_xattr_block_set` → `iput(ea_inode)` → `write_inode_now()` →
  `s_writepages_rwsem`, while a jbd2 handle and `xattr_sem` are held.
  Setting `EXT4_STATE_NO_EXPAND` removes that edge for every inode under
  eviction.

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- **Quality:** obviously correct. An inode being deleted cannot benefit
  from extra isize. The flag’s save/restore in `ext4_write_lock_xattr` /
  `ext4_write_unlock_xattr` keeps it set (`*save == 1` → do not clear).
- **Regression risk:** very low. One inode-state bit on an inode that is
  about to be freed. No API, locking, or on-disk format change.
- **Red flags:** none (1 line, one function). It is patch 2/2 but does
  **not** depend on patch 1’s `!SB_ACTIVE` check.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- Added line: commit **`2c0e4fb511f97`** (this change, 2026-06-23).
- Surrounding `inode->i_size = 0` / `ext4_mark_inode_dirty()`: Dave
  Kleikamp 2006 / Ted Ts’o **`bc965ab3f2b4b7`** (2008). Extra-isize
  expansion from dirtying: **`6dd4ee7cab7e3`** (2007).
  `EXT4_STATE_NO_EXPAND` early-out in `ext4_try_to_expand_extra_isize`:
  **`cf0a5e818fe216`** (2017, from **`2e81a4eeedcaa`** in 2016).
- This path has been in-tree for many years; not a newly introduced
  subsystem.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: **No Fixes: tag on this commit.** Sibling **`7461c60b9c6a8`**
(patch 1/2, parent of this commit) has `Fixes: c8585c6fcaf2` (“ext4: fix
races between changing inode journal mode and ext4_writepages”,
2016-04-25, **v4.7-rc1**). That commit is an ancestor of this tree. It
introduced `s_writepages_rwsem` (originally `s_journal_flag_rwsem`),
which is the lock in the cycle.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record:
- **`7461c60b9c6a8`** — skip expansion when `!SB_ACTIVE` (primary mount-
  time fix).
- **`2c0e4fb511f97`** — this commit (eviction-path flag).
- **`4f48af3dc7554` / `a54778243e88f`** — later deferred `iput` for EA
  inodes (Jan Kara’s deeper lock-order fix; larger).
- This change is **standalone**: it only uses `ext4_set_inode_state()`
  and a flag check that has existed since 2017. It is part of a series
  but is not patch-X-that-needs-Y to compile or run.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Yun Zhou is a regular ext4 contributor (orphan/xattr/deadlock
work in this area), not the maintainer. Ted Ts’o merged it; Jan Kara
reviewed it. Related author commits: the `!SB_ACTIVE` skip, then
deferred EA `iput` helpers.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: **No hard prerequisites beyond code that is already old.** Needs
`EXT4_STATE_NO_EXPAND` and the test at the top of
`ext4_try_to_expand_extra_isize()` (2016–2017). Does **not** need patch
1. Applies as a single insertion before the existing
`ext4_mark_inode_dirty()` call.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- **b4 dig:** `[PATCH 2/2] ext4: set EXT4_STATE_NO_EXPAND in
  ext4_evict_inode` — `https://patch.msgid.link/20260623061903.2148767-
  2-yun.zhou@windriver.com`
- **Revisions:** evolved from standalone v1 (2026-06-11) through v5–v8
  of a larger xattr-iput series, then a simplified 2-patch series that
  Ted applied. Applied version is that final 2/2.
- **v6/v8 cover letter (author):** “Patch 2 is a belt-and-suspenders
  semantic improvement: an inode under eviction never needs extra isize
  expansion.” “v1 … Only fixes the syzbot reproducer, not the underlying
  lock ordering violation.”
- **Jan Kara (2026-06-11) on the original identical change:** agrees
  expansion is pointless in `ext4_evict_inode`; says it **does not fix
  the real lock-order bug**, only the particular syzbot reproducer. No
  NAK of this line; he wanted a deeper fix as well.
- **No NAK** of setting the flag. Ted merged it with Jan’s Reviewed-by.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record (b4 dig -w): `tytso@mit.edu`, `adilger.kernel@dilger.ca`,
`libaokun@linux.alibaba.com`, `jack@suse.cz`, `ojaswin@linux.ibm.com`,
`ritesh.list@gmail.com`, `yi.zhang@huawei.com`, `linux-
ext4@vger.kernel.org`. Subsystem maintainers/reviewers were on To/Cc.
Jan Kara reviewed; Ted merged.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record:
- Syzbot: `https://syzkaller.appspot.com/bug?extid=5d19358d7eb30ffb0cc5`
  — **possible deadlock in wait_transaction_locked**, prio:high, C
  repro, Denial-of-service via filesystem mount.
- Stack (verified): `ext4_orphan_cleanup` → `evict` →
  **`ext4_evict_inode`** → `__ext4_mark_inode_dirty` →
  `ext4_try_to_expand_extra_isize` → `ext4_expand_extra_isize_ea` →
  `ext4_xattr_block_set` → `iput` → `write_inode_now` →
  `ext4_writepages` / `s_writepages_rwsem`.
- Still reported on linux-5.15 / 6.1 / 6.6 at the time of the dashboard
  snapshot. Syzbot’s “fix commit” is **`7461c60b9c6a`** (patch 1),
  because that commit carries the tags; this commit closes the **same**
  `ext4_evict_inode` frame.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Series is (1) skip expansion during mount, (2) this flag in
evict, then later deferred-iput patches. Patch 1 covers all `!SB_ACTIVE`
callers (including `ext4_process_orphan` → `ext4_truncate`). Patch 2
covers **all** eviction, including post-mount. They complement; this one
is not incomplete on its own for the syzbot stack.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: No stable-list thread found for this subject. Absence of Cc:
stable is expected for this pipeline.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**

Record: **`ext4_evict_inode()`** (modified). Indirectly
**`__ext4_mark_inode_dirty()`**, **`ext4_try_to_expand_extra_isize()`**.

**Step 5.2: TRACE CALLERS**

Record:
- `ext4_evict_inode` is `ext4_sops.evict_inode` (`fs/ext4/super.c`).
  Called from VFS `evict()` on last `iput` when `i_nlink == 0`.
- Reachable from unlink/close, and from **`ext4_process_orphan()` →
  `iput()`** during `ext4_orphan_cleanup()` at mount
  (`fs/ext4/orphan.c`). That is the syzbot path.

**Step 5.3: TRACE CALLEES**

Record: After the new flag: `ext4_mark_inode_dirty` →
`__ext4_mark_inode_dirty` → `ext4_try_to_expand_extra_isize` (now a no-
op via `-EOVERFLOW`) → later `ext4_truncate`, `ext4_xattr_delete_inode`,
`ext4_free_inode`. No new callees.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: **Yes, userspace-reachable.** Unprivileged unlink hits eviction
(no deadlock there once `SB_ACTIVE` is set). The deadlock needs mount-
time orphan cleanup (`!SB_ACTIVE`), typically `mount(2)` (admin /
crafted image). Syzbot reproduced it. Assessment: DoS, filesystem
trigger.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: Only this site sets `EXT4_STATE_NO_EXPAND` outside the xattr
lock helpers. No sibling-driver clone. Patch 1 is the related early-
return in `ext4_try_to_expand_extra_isize`.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record:
- Local tree: **`v7.3-rc4-27-gf0100363d8c37`**, `make kernelversion` =
  **7.3.0-rc4** (mainline, not a `*.y` stable branch).
- `ext4_evict_inode` + `ext4_mark_inode_dirty` + expand-on-dirty all
  exist.
- This commit **is already an ancestor** of HEAD (`2c0e4fb511f97`). That
  is expected (source tree), not a reason to treat it as “already
  selected for stable”.
- Bug class dates to extra-isize expansion (2007) plus
  `s_writepages_rwsem` (2016 / v4.7).

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Clean apply.** Insert one call between long-stable
`inode->i_size = 0` and `ext4_mark_inode_dirty()`. No refactor of that
sequence. `EXT4_STATE_NO_EXPAND` exists here.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: Patch 1 (`7461c60b9c6a8`) and later deferred-iput work are also
in this mainline checkout. They do not make this line wrong or redundant
for stable: patch 1 is mount-only; this flag also covers post-mount
eviction and is the direct closer of the syzbot `ext4_evict_inode`
frame.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: **ext4 (`fs/ext4/`)** — **IMPORTANT** (default filesystem on a
large fraction of Linux systems; mount/orphan cleanup is a common path
after crash).

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: Actively developed (recent writeback, xattr, orphan, deadlock
fixes). The eviction dirtying sequence itself has been stable for many
years; this is a small invariant on old code, not a feature on new code.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: **Filesystem-specific (ext4), but a very large user
population.** Triggered on mount of a filesystem with orphans that still
need extra-isize expansion and have xattrs that must move.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record:
- **Deadlock:** mount-time orphan cleanup, inode with `i_extra_isize <
  s_want_extra_isize`, expansion moves xattrs, `!SB_ACTIVE` forces
  `write_inode_now` on EA `iput`. Syzbot has a C repro.
- **Post-mount:** every deletion of such an inode would previously
  attempt a pointless expand (not this deadlock).
- **Unprivileged mount:** generally no; crafted/unclean ext4 images and
  admin mount yes. Syzbot still reached it from syscall fuzzing.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record: **Deadlock / lockdep circular dependency → hang or lockdep
splat. Severity: HIGH (DoS on mount/orphan cleanup).** Not a data-
corruption bug.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- **Benefit:** high for a 1-line closer of a documented, syzbot-
  reproduced deadlock path on ext4 eviction; also stops pointless expand
  (xattr shuffle / EA `iput`) on every delete.
- **Risk:** very low (1 line, existing flag, deletion-only).
- **Ratio:** strongly favorable.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR backporting:**
- Syzbot C-repro deadlock; stack is exactly `ext4_evict_inode` → mark
  dirty → expand extra isize.
- 1-line, obviously correct; Jan Kara Reviewed-by; Ted Ts’o merged.
- Uses a flag and check that have existed since 2016–2017; no new API.
- Independent of patch 1; complements the `!SB_ACTIVE` skip.
- Defense-in-depth on a HIGH-severity hang in a core filesystem.
- Applies cleanly to this tree’s `ext4_evict_inode`.

**AGAINST:**
- Final message frames it as “unnecessary work” / “defense-in-depth”;
  author called v1 incomplete vs the real lock-order bug.
- Patch 2/2; the tagged “real” mount fix is patch 1.
- Jan Kara: this line alone does not fix `ext4_xattr_block_set` taking
  `s_writepages_rwsem` under a handle.
- Deadlock is mount-time / orphan-specific, not every unlink.

**UNRESOLVED:** lore.kernel.org returned 403 to WebFetch; discussion
recovered via b4 dig, openwall/lkml mirrors, patchew, and the syzbot
dashboard. No stable@ thread found.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — 1-line invariant; Reviewed-
   by Jan Kara; in mainline; syzbot exercised the path.
2. Fixes a real bug that affects users? **PASS** — same path as the
   syzbot deadlock; also skips harmful extra work on delete.
3. Important issue (crash, security, corruption, deadlock)? **PASS** —
   deadlock / DoS (HIGH), not theoretical.
4. Small and contained? **PASS** — +1 line, one function.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — call site and
   `EXT4_STATE_NO_EXPAND` are present; insertion is mechanical.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: Not a device-ID/quirk/DT/docs/build exception. It is a normal
small correctness/deadlock-path fix.

**Step 9.4: MAKE YOUR DECISION**

This tree is **7.3-rc4 mainline**. The eviction dirtying path exists;
the extra-isize expand-on-dirty path exists; the syzbot stack is this
function. The committed wording is modest, but the change is the direct
closer of a real, reproduced deadlock edge, not a refactor or a new
feature. Risk is negligible. It should be backported.

---

### What the commit solves for stable users

On ext4, `ext4_mark_inode_dirty()` may try to grow `i_extra_isize`.
During **mount-time orphan cleanup**, that runs from
**`ext4_evict_inode`** while `!SB_ACTIVE`. Expanding can move xattrs and
`iput()` EA inodes, which then calls `write_inode_now()` and takes
`s_writepages_rwsem` under a jbd2 handle and `xattr_sem`. Syzbot
reproduced that cycle. Setting `EXT4_STATE_NO_EXPAND` before the dirty
call is correct (the inode is being deleted) and stops that expand/iput
edge for every eviction.

### Stable rules / risk

Meets all six criteria: one line, reviewed, real deadlock path, no new
API, applies cleanly. Sibling patch 1 (`!SB_ACTIVE`) is the broader
mount fix; this line does not need it, and it still helps post-mount by
skipping pointless expansion.

### Concerns

Incomplete as the *only* lock-order fix (Jan Kara). That is a reason to
also want patch 1 / deferred iput, not a reason to drop this 1-liner. No
backport rework needed on this tree.

---

Verification:
- [Phase 1] Subject/tags: ext4 set NO_EXPAND; Reviewed-by Jan Kara; Link
  patch 2/2; Ted Ts’o SOB; no Fixes/Reported-by on this revision
- [Phase 1] Body: skip expand on evict; defense-in-depth for
  s_writepages_rwsem deadlock
- [Phase 2] Diff: +1 line in `ext4_evict_inode` before
  `ext4_mark_inode_dirty`
- [Phase 2] Expand skip: `ext4_try_to_expand_extra_isize` returns
  `-EOVERFLOW` if `EXT4_STATE_NO_EXPAND` (inode.c:6597)
- [Phase 2] Flag restore: `ext4_write_unlock_xattr` clears only if
  `*save == 0` (xattr.h:166-170)
- [Phase 3] `git describe HEAD`: v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion`: 7.3.0-rc4
- [Phase 3] `git merge-base --is-ancestor 2c0e4fb511f97 HEAD`: yes
  (mainline already has it)
- [Phase 3] Blame: `i_size=0` 2006; `mark_inode_dirty` in evict
  `bc965ab3f2b4b7` 2008; expand-on-dirty `6dd4ee7cab7e3` 2007; NO_EXPAND
  check `cf0a5e818fe216` 2017
- [Phase 3] Sibling 7461c60b9c6a8 Fixes: c8585c6fcaf2 (v4.7-rc1);
  `merge-base --is-ancestor c8585c6fcaf2 HEAD`: yes
- [Phase 4] `b4 dig -c 2c0e4fb511f97`: msgid 20260623061903.2148767-2
- [Phase 4] `b4 dig -a`: v5–v8 larger series then final 2-patch series
- [Phase 4] `b4 dig -w`: tytso, adilger, jack@suse.cz, linux-ext4 on
  To/Cc
- [Phase 4] Jan Kara 2026-06-11 (openwall/lkml): agrees with the flag;
  says it only covers the syzbot reproducer, not the full lock-order bug
  — no NAK
- [Phase 4] Cover letter: “belt-and-suspenders semantic improvement”
- [Phase 4] Syzbot bug extid=5d19358d7eb30ffb0cc5: stack through
  `ext4_evict_inode`; prio high; C repro; linux-5.15/6.1/6.6 still
  listed
- [Phase 4] lore.kernel.org WebFetch: 403; used b4 + mirrors. Stable
  list search: no hits
- [Phase 5] Caller: `ext4_sops.evict_inode`; orphan:
  `ext4_process_orphan` → `iput` (orphan.c:359)
- [Phase 6] Local `ext4_evict_inode` already contains the line at
  inode.c:268; apply would be clean on the pre-patch form of the same
  function
- [Phase 7] ext4, IMPORTANT, actively developed
- [Phase 8] Failure: circular lockdep / deadlock on mount orphan
  cleanup; severity HIGH; risk very low
- UNVERIFIED: live lore.kernel.org HTML of the thread (403);
  reconstructed from b4, openwall, patchew, syzbot

**YES**

 fs/ext4/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index bbc437be5e63b..9a5c08650bd1e 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -261,6 +261,7 @@ void ext4_evict_inode(struct inode *inode)
 	if (ext4_inode_is_fast_symlink(inode))
 		memset(EXT4_I(inode)->i_data, 0, sizeof(EXT4_I(inode)->i_data));
 	inode->i_size = 0;
+	ext4_set_inode_state(inode, EXT4_STATE_NO_EXPAND);
 	err = ext4_mark_inode_dirty(handle, inode);
 	if (err) {
 		ext4_warning(inode->i_sb,
-- 
2.53.0

