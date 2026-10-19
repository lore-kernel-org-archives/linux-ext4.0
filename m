Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0FB95D9D97;
	Mon, 19 Oct 2026 14:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418525; cv=none; b=P3hybLzjR43/q6dCEhCIRs8Lo9qYs0XGmPo0VoWH0ePVzcuXMMQGJi/w/WKsy7drTEPbFdJrKfkZ4e80h9zQ1zfuOZil9otXusNBLYo7zWejEWCH1HYgB/ivVnJ0BwuEg0pc5CTdNNaNoOawmfFELskfBlVgQsSgOVUjnfQ1dZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418525; c=relaxed/simple;
	bh=HWU39KNqQaW6mRCYZGyKIsIVE5a4TkNDiJLtp751LYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YeZxvgX7jd6n9pi5FPPqJ2z2F2PoVh/jgj8ctO/X2cHxWds44Xs9h46wfz4DcIqv8VFCKyyypg9H4Hm4biabTAuL0CAqv5GY1TsK2GIsYhmkENIHz779j4H9gwrJdS6Tq2NMyFfIIAePcz4DIjM31wVcb9neZ6GQ/vkotq1+B50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AXvUb+o6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AXvUb+o6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C2FF1F000C4;
	Mon, 19 Oct 2026 14:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418522;
	bh=at/eGBD5LOOerqpoJEWHNdcxGFSF0uKjnyFVsmUIpVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AXvUb+o6M8Ncq9sSfDQ1ZCDvykg38KcP4skCbX5mwlX67ANOlxL2NX6D1qBZdNFBr
	 wIeEKDnfWyTCtjLX91OAwPvXeL1HjtzupFSwr8exrkzDKNp+qwa05OdjO305y1Y9kR
	 JGoHDptfeuSqVms/KWA+fSWDzpkRMl55m03ZnpNuT7HYlUiUi1HYZTPUkn2XBKn4TD
	 S7uFBQkUjM1q9HjmnAzD45B9E8vI9un8vuXopf5A9GhP5G5Tyf4bwD893FdZFjzcPY
	 cIkLnAtTrngm7KiFfkf1q2LAONZLNTdPYdDtPrvYG2mMy8DtzVhTg7aDnMw5jNYOB3
	 OJNNnS72mMmLg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Junzhe Yu <junzheyu1@gmail.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ext4: guard against NULL s_group_info in ext4_get_group_info
Date: Mon, 19 Oct 2026 09:49:59 -0400
Message-ID: <20261019135441.1420968-308-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Transfer-Encoding: 8bit

From: Junzhe Yu <junzheyu1@gmail.com>

[ Upstream commit 8f3901fbb40745046e513226ad84e8b84492632d ]

Resend: previous attempt was rejected by vger for containing HTML.

==================================================================

ext4_mark_group_bitmap_corrupted() already treats a NULL return from
ext4_get_group_info() as "nothing to do", but ext4_get_group_info()
indexes s_group_info without checking whether the array exists.

During mount, fast-commit replay runs inside jbd2_journal_load() from
ext4_load_and_init_journal(), which is before ext4_mb_init() allocates
s_group_info. Replaying an FC UNLINK for an inode whose bitmap bit is
already clear takes:

   ext4_fc_replay_unlink -> iput -> ext4_evict_inode -> ext4_free_inode
     -> ext4_mark_group_bitmap_corrupted -> ext4_get_group_info

and faults on the NULL s_group_info base. Userspace only mounts a dirty
ext4 image; this is a supported recovery path.

Return NULL when s_group_info (or the per-block grp_info row) is unset
so the existing caller check is effective during early mount.

Tested on Linux v6.6.145 KASAN: crafted FC-unlink image previously
triggered KASAN null-ptr-deref / panic in ext4_get_group_info; with this
patch, mount succeeds (EXT4 "bit already cleared" may still log). Also
observed on v6.6.144; still present on torvalds/linux as of
f5098b6bae76 (2026-07-26).

A self-contained Docker/QEMU reproducer (craft + mount + patch verify) is
available on request.

Signed-off-by: Yu Junzhe <junzheyu1@gmail.com>
Link: https://patch.msgid.link/65c955b0-716b-4599-b925-59c2782e38b4@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1 — Subject**
Record: **[ext4] [guard / prevent] NULL `s_group_info` dereference in
`ext4_get_group_info`**. “Guard against” is a bug-fix verb: add a
missing safety check.

**Step 1.2 — Tags**
Record:
- `Signed-off-by: Yu Junzhe <junzheyu1@gmail.com>` (author)
- `Link: https://patch.msgid.link/65c955b0-716b-4599-b925-
  59c2782e38b4@gmail.com`
- `Signed-off-by: Theodore Ts'o <tytso@mit.edu>` (ext4 maintainer
  applied it)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, or `Cc: stable` (absence is expected in this pipeline)
- Upstream SHA after maintainer application:
  `8f3901fbb40745046e513226ad84e8b84492632d`

**Step 1.3 — Body**
Record:
- **Bug:** `ext4_get_group_info()` indexes `s_group_info` without
  checking that the array exists.
- **Symptom:** KASAN null-ptr-deref / panic in `ext4_get_group_info`
  while mounting a dirty ext4 image that needs fast-commit UNLINK
  replay.
- **Path:** `ext4_fc_replay_unlink` → `iput` → `ext4_evict_inode` →
  `ext4_free_inode` → `ext4_mark_group_bitmap_corrupted` →
  `ext4_get_group_info`
- **Root cause:** FC replay runs inside `jbd2_journal_load()` from
  `ext4_load_and_init_journal()`, **before** `ext4_mb_init()` allocates
  `s_group_info`.
- **Author testing:** KASAN on v6.6.145 (also seen on v6.6.144); still
  present on torvalds/linux as of `f5098b6bae76` (2026-07-26). Mount
  succeeds with the patch.

**Step 1.4 — Hidden bug fix?**
Record: Not hidden. This is an explicit NULL-deref fix. The “already-
cleared bitmap bit” path looks like a recovery edge case, but it is a
real oops on a supported mount/recovery path.

## Phase 2: Diff analysis

**Step 2.1 — Inventory**
Record:
- File: `fs/ext4/balloc.c` only (`+4 / -0`)
- Function: `ext4_get_group_info()`
- Scope: **single-file surgical fix**

**Step 2.2 — Code flow**
Record (verified against local `fs/ext4/balloc.c`):

Before:
```
if (group >= s_groups_count) return NULL;
indexv/indexh = ...
grp_info = sbi_array_rcu_deref(..., s_group_info, indexv);  //
NULL[index] if array missing
return grp_info[indexh];
```

After:
```
if (group >= s_groups_count) return NULL;
if (!s_group_info) return NULL;          // new
... deref row ...
if (!grp_info) return NULL;              // new
return grp_info[indexh];
```

This is an early-mount / missing-table path, not a new feature path.

**Step 2.3 — Bug mechanism**
Record: **NULL pointer dereference (memory safety)**.
`sbi_array_rcu_deref()` does
`rcu_dereference(sbi->s_group_info)[index]`. `sbi` is `kzalloc`’d, so
`s_group_info` is NULL until `ext4_mb_alloc_groupinfo()` /
`rcu_assign_pointer`. The per-row check covers `ext4_mb_add_groupinfo()`
error paths that set `group_info[idx] = NULL`.

**Step 2.4 — Fix quality**
Record: Obviously correct. Matches the existing contract
(`ext4_get_group_info()` may return NULL;
`ext4_mark_group_bitmap_corrupted()` already does `if (!grp || !gdp)
return;`). Four `unlikely()` lines, no API/lock/data-structure change.
Regression risk is very low: after `ext4_mb_init()`, `s_group_info` is
non-NULL and these checks are no-ops. Returning NULL instead of oopsing
cannot be worse for callers that already handle NULL.

## Phase 3: Git history

**Step 3.1 — Blame**
Record: Current function body in this tree is from the 6.4-era change
“allow `ext4_get_group_info()` to fail” (this history: `b4319e457d6e3`;
mainline `5354b2af34064`, 2023-05-13) plus `fa285d799d1d5` (“drop
`ext4_error()` from `ext4_get_group_info()`”). Those commits taught the
helper to return NULL for a bad group number and taught callers to check
NULL — but they never checked the array pointer itself.

**Step 3.2 — Fixes: tag**
Record: None. Reachability comes from fast-commit replay, added in
`6866d7b3f2bb4` (“ext4 / jbd2: add fast commit initialization”,
`tags/v5.10-rc1~59^2~7`). Journal load still runs before
`ext4_mb_init()` in this tree.

**Step 3.3 — File history**
Record: Recent `fs/ext4/balloc.c` commits here are unrelated
(capability-check reorder, fault-injection race, kunit stubs). No
prerequisite series. Standalone 1/1 patch.

**Step 3.4 — Author**
Record: Yu Junzhe is not the ext4 maintainer. Theodore Ts’o applied it
by hand after noting mangled whitespace, then posted “Applied, thanks!”
with commit `8f3901fbb407`.

**Step 3.5 — Dependencies**
Record: None. The helper, `s_group_info`, FC replay, and the caller NULL
check all exist in this checkout. Applies standalone.

## Phase 4: Mailing list / external

**Step 4.1 — Original discussion**
Record:
- Lore/msgid: https://patch.msgid.link/65c955b0-716b-4599-b925-
  59c2782e38b4@gmail.com
- Direct lore WebFetch: **403** (could not read lore HTML)
- Openwall/LKML mirrors and `b4` succeeded
- `b4 dig -a`: **v1 only** (no v2/v3)
- Thread: author submission; tytso note about gmail whitespace (still
  applied); tytso “Applied, thanks!” — **no NAK**
- No reviewer `Cc: stable` in the thread (tytso also did not add it when
  committing)

**Step 4.2 — Recipients (`b4 dig -w`)**
Record: Junzhe Yu, Theodore Ts’o, Andreas Dilger, linux-ext4, linux-
kernel. Both ext4 maintainers were on the original To/Cc.

**Step 4.3 — Bug report**
Record: No syzbot/bugzilla link. Author reports KASAN on a crafted FC-
unlink image and offers a Docker/QEMU reproducer. I did not run that
reproducer (UNVERIFIED empirically; the code path is verified).

**Step 4.4 — Series**
Record: Standalone `[PATCH]` 1/1. Related-in-time FC-replay crashes
(writeback rwsem not initialized, RO mount replay) are separate bugs,
not prerequisites.

**Step 4.5 — Stable list**
Record: lore.kernel.org/stable WebFetch returned **403**. No stable-list
discussion found via search. No evidence it was rejected for stable.

## Phase 5: Semantic / call-chain analysis

**Step 5.1 — Functions**
Record: `ext4_get_group_info()` only. (No semcode MCP in this
environment; used `git grep` + reads.)

**Step 5.2 — Callers**
Record: Many, across `fs/ext4/{balloc,ialloc,mballoc,super}.c`. Almost
all already handle NULL (`if (!grp)` / `if (!grinfo)`), because of the
6.4 “allow to fail” work. The crashing caller is
`ext4_mark_group_bitmap_corrupted()` in `fs/ext4/super.c`, which already
returns on NULL.

**Step 5.3 — Callees**
Record: `sbi_array_rcu_deref()` →
`rcu_dereference(s_group_info)[indexv]`. That is the NULL deref.

**Step 5.4 — Reachability**
Record: User-reachable: mount an ext4 filesystem with a journal that
still has fast-commit UNLINK tags, when the inode bitmap bit is already
clear. `ext4_fc_init()` installs `j_fc_replay_callback` even if fast
commit is currently off, so leftover FC blocks still replay. Mount of a
dirty ext4 image is a normal recovery path (crash, unclean unmount, or
an untrusted image). Typically needs mount privilege, but the failure is
a **kernel oops**, not a userspace error.

Verified mount order in this tree (`fs/ext4/super.c`):
1. `ext4_load_and_init_journal()` → `ext4_load_journal()` →
   `jbd2_journal_load()` (FC replay)
2. much later: `ext4_mb_init()` (allocates `s_group_info`)

Verified free path: `ext4_free_inode()` skips the group-info corruption
check under `EXT4_FC_REPLAY`, then on `!cleared` still calls
`ext4_error` + `ext4_mark_group_bitmap_corrupted()`.

**Step 5.5 — Similar patterns**
Record: `ext4_count_free_clusters()` already does `if
(EXT4_SB(sb)->s_group_info)` before calling `ext4_get_group_info()`.
Bitmap validators skip work under `EXT4_FC_REPLAY`. The hole is
specifically the helper used by `ext4_mark_group_bitmap_corrupted()`.

## Phase 6: This checkout (6.12.y)

**Step 6.1 — Does the buggy code exist here?**
Record: **Yes.** Local tree is **6.12.111** (`pending-6.12`; `git
describe` was `p-6.12-3-g88406e77611c6` at start).
`ext4_get_group_info()` in `fs/ext4/balloc.c` still has only the
`s_groups_count` check. `git merge-base --is-ancestor 8f3901fbb407 HEAD`
→ **not an ancestor**. `git grep` for the new `!s_group_info` guard →
**not present**. Fast commit and the journal-before-mballoc order
**are** present.

**Step 6.2 — Backport difficulty**
Record: **Clean apply.** Local function text matches the upstream hunk
context exactly. Confirmed by reading the function and by comparing to
`git show 8f3901fbb407`.

**Step 6.3 — Related fixes already here?**
Record: The “allow to fail” / drop-`ext4_error` work is here
(`b4319e457d6e3`, `fa285d799d1d5`). That is why the caller already
treats NULL as success-noop — and why this four-line guard is
sufficient. No alternate fix for this crash is in the tree.
`origin/master` has `8f3901fbb407` as the latest `balloc.c` change; no
follow-up revert/amend on that function.

## Phase 7: Subsystem context

**Step 7.1**
Record: **ext4 (fs/ext4). Criticality: IMPORTANT** (default Linux
filesystem; not quite mm/VFS core, but production-critical).

**Step 7.2**
Record: Actively maintained (tytso/Dilger, linux-ext4). The hole is old
(FC since 5.10 + helper NULL contract since 6.4), not a brand-new
subsystem.

## Phase 8: Impact and risk

**Step 8.1 — Who is affected**
Record: Anyone mounting an ext4 filesystem that still has fast-commit
journal data to replay (crash recovery, or a crafted/dirty image). That
is a large, real population — not an obscure driver.

**Step 8.2 — Trigger**
Record: Mount-time FC UNLINK replay when the inode bitmap bit is already
clear. Not every boot, but a **supported recovery path**. Unprivileged
users cannot usually mount; a user who can mount a malicious ext4 image
(containers, loop, removable media with automount) can panic the kernel.

**Step 8.3 — Failure mode**
Record: **NULL deref → KASAN report / oops / panic during mount.**
Severity: **CRITICAL** (host crash while recovering a dirty filesystem).

**Step 8.4 — Risk/benefit**
Record: **Benefit: high** (prevents oops on ext4 recovery). **Risk: very
low** (4 lines, existing NULL contract, hot path unchanged after
`ext4_mb_init()`). Ratio strongly favors backport.

Note: `ext4_error("bit already cleared...")` can still log or remount-ro
depending on `errors=`; the author states mount succeeds with this
patch. That `ext4_error` is pre-existing, not introduced here.

## Phase 9: Synthesis

**Step 9.1 — Evidence**

FOR:
- Real NULL deref on a supported ext4 mount/recovery path
- KASAN-confirmed; author tested the patch
- Call path and journal-before-`mb_init` order verified in **this** 6.12
  tree
- 4-line, obviously correct guard; callers already handle NULL
- Ext4 maintainer applied it upstream (`8f3901fbb407`); it is on
  `origin/master`
- No dependencies; applies cleanly
- Ext4 is widely used; FC exists since 5.10

AGAINST:
- No `Fixes:` / `Cc: stable` (expected; not a negative)
- Trigger is an FC replay edge (already-cleared bit), not every mount
- I did not run the author’s QEMU reproducer
- tytso did not nominate stable in the apply mail

UNRESOLVED:
- Empirical reproducer not run here
- lore.kernel.org HTML and stable-list search returned HTTP 403 (thread
  recovered via b4/openwall)

**Step 9.2 — Stable rules**
1. Obviously correct and tested? **PASS** (KASAN + maintainer apply;
   logic matches existing NULL contract)
2. Real bug affecting users? **PASS** (oops on dirty-ext4 mount / FC
   replay)
3. Important (crash/security/corruption/deadlock)? **PASS** — kernel
   oops/panic, severity CRITICAL
4. Small and contained? **PASS** — +4 lines, one function
5. No new features/APIs? **PASS**
6. Can apply to this tree? **PASS** — buggy code present, clean context

**Step 9.3 — Exceptions**
Record: Not an ID/quirk/DT/docs exception. It is a normal crash fix.

**Step 9.4 — Decision**
This tree is 6.12.y. The bug exists here; the fix is a four-line NULL
guard with no prerequisites. It should be backported.

---

### What this solves for stable users

Mounting a dirty ext4 filesystem with leftover fast-commit UNLINK
records can take `ext4_free_inode()` →
`ext4_mark_group_bitmap_corrupted()` **before** mballoc has allocated
`s_group_info`. The helper then does `NULL[index]` and oopses. The patch
makes the helper return NULL so the existing caller check is a no-op and
mount/recovery can continue.

### Risk vs benefit

Benefit is a real mount-time crash fix on the default Linux filesystem.
Risk is a pair of `unlikely()` NULL returns in a helper that is already
allowed to fail. After `ext4_mb_init()`, behavior is unchanged.

### Concerns

None that block backport. No missing commits, no API change, no follow-
up on `origin/master` that reworks this function.

---

Verification:
- [Phase 1] Parsed subject/tags/body from the candidate message and from
  `git show 8f3901fbb407`
- [Phase 1] Confirmed no Fixes/Cc:stable; maintainer SOB present
- [Phase 2] Diff is +4 lines in `ext4_get_group_info()`; local function
  matches the hunk
- [Phase 2] `sbi_array_rcu_deref` indexes `s_group_info` without a NULL
  check (`fs/ext4/ext4.h`)
- [Phase 2] `ext4_mark_group_bitmap_corrupted()` already returns if
  `!grp` (`fs/ext4/super.c`)
- [Phase 3] Blame: helper NULL-for-bad-group from `b4319e457d6e3` /
  `fa285d799d1d5` in this history
- [Phase 3] Fast commit added in `6866d7b3f2bb4` (v5.10-rc1); present
  here
- [Phase 3] `git log --grep` on `fs/ext4/`: this subject is **not** in
  HEAD
- [Phase 4] `b4 am` / `b4 dig -c 8f3901fbb407`: thread at msgid
  `65c955b0-716b-4599-b925-59c2782e38b4@gmail.com`; v1 only
- [Phase 4] `b4 dig -w`: tytso + Dilger + linux-ext4 on the original
  mail
- [Phase 4] tytso applied as `8f3901fbb407`; noted whitespace but no NAK
- [Phase 4] lore.kernel.org WebFetch: 403; used openwall + b4 mbox
  instead
- [Phase 5] Callers of `ext4_get_group_info` grepped; crashing caller
  checks NULL
- [Phase 5] `ext4_free_inode()` FC_REPLAY skip + “bit already cleared” →
  `ext4_mark_group_bitmap_corrupted()` verified
- [Phase 5] Mount order: `jbd2_journal_load` in `ext4_load_journal()`
  before `ext4_mb_init()` verified
- [Phase 5] `sbi = kzalloc` zeroes `s_group_info`; assigned later via
  `rcu_assign_pointer` in mballoc
- [Phase 6] `make kernelversion` / Makefile: **6.12.111**; branch
  `pending-6.12`
- [Phase 6] `git merge-base --is-ancestor 8f3901fbb407 HEAD` → not in
  this tree
- [Phase 6] Same SHA **is** an ancestor of `origin/master`; no later
  balloc.c follow-up on that fix
- [Phase 6] Clean apply context present in local `ext4_get_group_info()`
- [Phase 8] Failure mode: NULL deref oops on mount/recovery, severity
  CRITICAL
- UNVERIFIED: Did not run the author’s crafted-image/QEMU reproducer
- UNVERIFIED: Could not search lore.kernel.org/stable HTML (HTTP 403)

**YES**

 fs/ext4/balloc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index c9329ed5c094e..08556dd45760d 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -331,9 +331,13 @@ struct ext4_group_info *ext4_get_group_info(struct super_block *sb,
 
 	if (unlikely(group >= EXT4_SB(sb)->s_groups_count))
 		return NULL;
+	if (unlikely(!EXT4_SB(sb)->s_group_info))
+		return NULL;
 	indexv = group >> (EXT4_DESC_PER_BLOCK_BITS(sb));
 	indexh = group & ((EXT4_DESC_PER_BLOCK(sb)) - 1);
 	grp_info = sbi_array_rcu_deref(EXT4_SB(sb), s_group_info, indexv);
+	if (unlikely(!grp_info))
+		return NULL;
 	return grp_info[indexh];
 }
 
-- 
2.53.0

