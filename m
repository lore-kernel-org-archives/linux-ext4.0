Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D63C656F5AD;
	Mon, 19 Oct 2026 13:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418291; cv=none; b=LcRAzLqS4raaZ9x0TzEG7olddXTbcFaDKJPLjR7nZy6eddYZhPJLxTAN4iJ8tXj8mjLEV65qwjL1aVOGqP+JcfvWBszTvc6WEz7eH/OBx/Ltz3p32GUKa635/I72NKOTERQw0CF0dkFsAxtrgrm9JniKdFI19audTmH+INOwm4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418291; c=relaxed/simple;
	bh=mzty+ws1sKtDmSkzjIdIec4AMpgjXVrDoYqBTWcLT7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kFQYNE3umkC3lCi7HH2H6tRmyOHfP+uEVMMrhLPGEVJEMlAbH33+B2HsBwUPOq0x9ZMdO+lloc6u/qK+uhVggR5dvC44eMYwAm0G2Es0Gy24iyHB1fwKKUy8kR+0W7C9TUUoVfpFM7gFploap2AujyhVaT9hmncE3FQBcPFt16E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HgNRhGoG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HgNRhGoG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 815411F000C6;
	Mon, 19 Oct 2026 13:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418288;
	bh=4tv8ydoFGM/MRd2Ch8NgorMLvUS1dYbChvJFqN0lylI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HgNRhGoGghLZul2qxsbU3epsCG/Mm7PHqCPHGYO26VuHfgjzIWRIjh/v8WxOTV6e1
	 Yob2wsQOmR5ySHvIU6PP4caBDgFIjCiriUHCf3LktjV9ZpYtLG/8QHBEFuyo8qQhC1
	 F8GoKh1Di0GN2FxQ/GW15Qc67VlbFsHiUrG0APsgLDolj3JKfbYl+XZh4BmtKOjOkz
	 t9PsSRWtmwaj/45h0bkR+IiPhcDRjs8d/rKA9ADBJAqycChCi/cK1JLlwZ98oMwORc
	 q/k+r3Oj2kvO7N6qWQtU3z9l2A0L3pQPY9SkwG3biIOkyC7c1A6eAqE//l1XISTiTu
	 Sn7kf3pSXfEKQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Ts'o <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ext4: check return value of ext4_get_block() in ext4_load_tail_bh()
Date: Mon, 19 Oct 2026 09:47:12 -0400
Message-ID: <20261019135441.1420968-141-sashal@kernel.org>
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

[ Upstream commit 705a3fd3bac167f1dabe3d3bba46cd484c5528dd ]

ext4_load_tail_bh() ignores the return value of ext4_get_block(), so an
I/O or allocation failure is silently discarded. buffer_mapped(bh) stays
false and the function returns NULL, which callers such as
ext4_block_do_zero_range() treat as "nothing to do" and return success.
This can mask real failures during zero-range, truncate, or punch-hole
operations, potentially exposing stale data if the block was not
actually a hole and needed zeroing. So propagate the error to the
callers.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260714080044.4038124-4-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Local tree

This checkout is **v7.3-rc4** (`7.3.0-rc4`, HEAD `f0100363d8c37`).
`ext4_load_tail_bh()` exists here (since v7.1-rc1). The candidate
`705a3fd3bac16` is already an ancestor of HEAD (merged in v7.3-rc1). The
verdict is whether this fix belongs in **this** tree on technical merit,
not because it was already applied.

---

## Phase 1: Commit message forensics

**Step 1.1 — Subject**
- Record: **[ext4] [check] check return value of `ext4_get_block()` in
  `ext4_load_tail_bh()`**
- Verb “check” here means propagate a previously ignored error.

**Step 1.2 — Tags**
- Record:
  - `Signed-off-by: Zhang Yi <yi.zhang@huawei.com>` (author; ext4
    reviewer in MAINTAINERS)
  - `Reviewed-by: Jan Kara <jack@suse.cz>` (ext4 reviewer)
  - `Link: https://patch.msgid.link/20260714080044.4038124-4-
    yi.zhang@huaweicloud.com` (v4 3/9)
  - `Signed-off-by: Theodore Ts'o <tytso@mit.edu>` (ext4 maintainer)
  - No `Fixes:`, no `Cc: stable`, no `Reported-by`, no syzbot. Absence
    of those tags is expected for this review.

**Step 1.3 — Body**
- Record: **Bug:** `ext4_load_tail_bh()` ignores `ext4_get_block()`
  errors. On failure `buffer_mapped(bh)` stays false, the helper returns
  `NULL`, and callers such as `ext4_block_do_zero_range()` treat that as
  “hole / nothing to do” and return success.
- **Symptom:** Silent success of zero-range, truncate, or punch-hole
  while the tail block was not zeroed.
- **Failure mode:** Stale data can later be exposed if the block was not
  a hole.
- **Root cause:** Error conflated with “unmapped hole”.
- **No version range** in the message.

**Step 1.4 — Hidden bug fix?**
- Record: **Not hidden.** It is an explicit error-propagation / stale-
  data fix. Cover letter later confirms patches 2 and 3 were “pre-
  existing fixes … originally going to be sent separately,” then folded
  into the WRITE_ZEROES series.

---

## Phase 2: Diff analysis

**Step 2.1 — Inventory**
- Record: **One file**, `fs/ext4/inode.c`: **+3 / −1**. One function:
  `ext4_load_tail_bh()`. Surgical, single-file.

**Step 2.2 — Flow**
- Record: **Before:** unmapped bh → `ext4_get_block(..., create=0)`
  return ignored → if still unmapped, `goto unlock` with `err == 0` →
  `return NULL`.
- **After:** negative return sets `err` and `goto unlock` → existing
  `return err ? ERR_PTR(err) : NULL`.
- Path: mapping lookup on the tail block during partial-block zeroing
  (error path only).

**Step 2.3 — Bug mechanism**
- Record: **Logic / correctness (ignored error → false success).**
  Category closest to “return value checking / missing error handling.”
  Not UAF, leak, or race.
- Mechanism: I/O or allocation failure from `ext4_get_block()` is
  treated as a hole, so truncate/punch/zero-range skip tail zeroing and
  still succeed.

**Step 2.4 — Fix quality**
- Record: **Obviously correct.** Callers already do `IS_ERR_OR_NULL(bh)`
  / `PTR_ERR_OR_ZERO(bh)` (present since the helper was factored out).
  Unlock/put already runs on the `unlock` path. Regression risk is low
  **in this tree** because parent `2fff82f081401` skips inline-data EOF
  zeroing (otherwise append writes on inline files could see `-ERANGE`).
  No API change.

---

## Phase 3: Git history

**Step 3.1 — Blame**
- Record: Ignored `ext4_get_block()` call dates to **`d863dc3614e489`
  (2013, Lukas Czerner)** inside `__ext4_block_zero_page_range`. Helper
  **`ext4_load_tail_bh`** was factored out in **`3b312a6f510ca` (“ext4:
  factor out journalled block zeroing range”, Zhang Yi, 2026-03)** and
  kept the same ignored return. First in this lineage: **v7.1-rc1**.

**Step 3.2 — Fixes: tag**
- Record: **None.** Introducing commit for the helper is
  `3b312a6f510ca`, ancestor of this HEAD. The ignored-return bug is
  older than the helper.

**Step 3.3 — File history**
- Record: Same v4 series around this commit:
  1. `e1cf7b5f5c8ad` FGP_WRITEBEGIN
  2. `2fff82f081401` skip inline-data tail zeroing **(prerequisite)**
  3. **`705a3fd3bac16` this fix**
  4. `b16e9d27a643a` move partial zeroing earlier
  5. `012e6a2c9ff4d` comment-only return-semantics clarification
  6–9. WRITE_ZEROES edge handling (some of those have `Cc: stable`)
- This patch is **standalone** given (2). (5) is comments only; 6–9 are
  WRITE_ZEROES, not required for this error check.

**Step 3.4 — Author**
- Record: **Zhang Yi** is an ext4 **Reviewer** in MAINTAINERS; 178 ext4
  commits in this tree. Not a drive-by.

**Step 3.5 — Dependencies**
- Record: Needs `ext4_load_tail_bh()` + `ERR_PTR` return +
  `IS_ERR_OR_NULL` callers — all present since `3b312a6f510ca` (v7.1).
  Needs **`2fff82f081401`** so inline-data append does not start
  failing. Both are in this tree. **Applies standalone on top of that
  parent.**

---

## Phase 4: Mailing list

**Step 4.1 — Original discussion**
- Record: `b4 dig -c 705a3fd3bac16` → **https://patch.msgid.link/2026071
  4080044.4038124-4-yi.zhang@huaweicloud.com**
- Series: **[PATCH v4 0/9] ext4: fix unaligned edge handling in
  FALLOC_FL_WRITE_ZEROES**
- Revisions: v1 → v4. v4 vs v3: **no code change** on this patch; v3
  collected Jan’s R-b.
- Cover letter: patches 2 and 3 were **pre-existing fixes folded in**,
  not WRITE_ZEROES-only prep.
- No NAK found on this patch. Ted merged it.

**Step 4.2 — Recipients (`b4 dig -w`)**
- Record: `linux-ext4`, `linux-fsdevel`, **tytso@mit.edu**,
  **jack@suse.cz**, adilger, libaokun, ojaswin, ritesh.list —
  maintainers/reviewers were on Cc. Jan reviewed; Ted committed.

**Step 4.3 — Bug report**
- Record: **No external bugzilla/syzbot report.** Issue found by code
  inspection (author). Severity is argued in the commit: silent success
  + possible stale data.

**Step 4.4 — Series**
- Record: 9 patches. This one is independently useful. Sibling patches
  7–9 carry `Cc: stable` for WRITE_ZEROES; this one does not. That is
  **not** used as a NO vote (tags are expected to be absent here).

**Step 4.5 — stable@**
- Record: **UNVERIFIED.** lore.kernel.org WebFetch returned 403; no
  separate stable-thread confirmation. `b4 dig` matched the ext4 thread.

---

## Phase 5: Semantic / call graph

**Step 5.1 — Functions**
- Record: **`ext4_load_tail_bh`** only.

**Step 5.2 — Callers**
- Record (this tree):
  - `ext4_block_do_zero_range()` → `IS_ERR_OR_NULL` / `PTR_ERR_OR_ZERO`
  - `ext4_block_journalled_zero_range()` → same
  - via `ext4_block_zero_range()`:
    - `ext4_block_zero_eof()` — truncate (`ext4_truncate`), setattr
      grow, append (`ext4_write_checks` in `fs/ext4/file.c`)
    - `ext4_zero_partial_blocks()` — punch-hole (`ext4_punch_hole`),
      `ext4_zero_range()` / WRITE_ZEROES in `fs/ext4/extents.c`

**Step 5.3 — Callees**
- Record: `__filemap_get_folio`, `ext4_get_block` (lookup only),
  `ext4_read_bh_lock`, folio lock/put.

**Step 5.4 — Reachability**
- Record: **Yes, from userspace:** `truncate`/`ftruncate`, `fallocate`
  (punch/zero/WRITE_ZEROES), append `write`. Unprivileged processes on
  their own files can hit the path. The **error** itself needs
  `ext4_get_block()` failure (I/O error, ENOMEM, corruption), not a
  normal happy path.

**Step 5.5 — Similar patterns**
- Record: Same ignored return lived in `__ext4_block_zero_page_range`
  since 2013. No second copy of this exact bug in current
  `ext4_load_tail_bh`.

---

## Phase 6: This checkout

**Step 6.1 — Buggy code here?**
- Record: **Yes.** Helper is in `fs/ext4/inode.c` (~4033). Introduced
  **v7.1-rc1** (`3b312a6f510ca`). This 7.3-rc4 tree has that code. The
  ignored-return bug existed until `705a3fd3bac16` (v7.3-rc1).

**Step 6.2 — Backport difficulty**
- Record: **Clean apply** onto the parent in this tree
  (`2fff82f081401`). Three lines. Later `b4e409c18c797` removed fs-layer
  fscrypt decrypt from this function; that is after/around the same
  merge window and does not change the get_block check.

**Step 6.3 — Related fixes already here?**
- Record: Prerequisite `2fff82f081401` is in HEAD. Follow-up
  `012e6a2c9ff4d` is comments only. No competing alternate fix.

---

## Phase 7: Subsystem

**Step 7.1**
- Record: **ext4 (`fs/ext4`)** — **IMPORTANT** (default Linux
  filesystem; data integrity).

**Step 7.2**
- Record: **Active** in 7.3 (WRITE_ZEROES series, iomap, fastcommit,
  etc.). Helper itself is recent (7.1) but the ignored-return pattern is
  old.

---

## Phase 8: Impact and risk

**Step 8.1 — Who**
- Record: **Filesystem-specific:** ext4 users doing truncate, punch-
  hole, zero-range, append, WRITE_ZEROES.

**Step 8.2 — Trigger**
- Record: Partial-block zeroing **plus** `ext4_get_block()` failure.
  Uncommon (I/O error / ENOMEM / bad metadata). Unprivileged users can
  invoke the operations; they cannot usually force get_block failure
  except under memory/IO pressure.

**Step 8.3 — Failure mode**
- Record: **Stale data / false success** on truncate/punch/zero-range.
  Not a panic. **Severity: HIGH** for a filesystem (classic “truncate
  succeeded but tail not zeroed → later extend exposes old data”). Not
  CRITICAL (no oops/deadlock).

**Step 8.4 — Ratio**
- Record: **Benefit: high** for ext4 data integrity on error paths.
  **Risk: very low** (3 lines, existing ERR_PTR path, Jan + Ted).
  Prerequisite for inline data is already in this tree.

---

## Phase 9: Synthesis

**Step 9.1 — Evidence**

**For:**
- Real correctness bug: mapping lookup failure reported as success.
- Concrete data-integrity outcome on truncate/punch/zero-range.
- Userspace-reachable (common ext4 ops).
- 3-line, obviously correct; callers already handle `ERR_PTR`.
- Reviewed by Jan Kara, merged by Ted Ts'o; author is an ext4 reviewer.
- Cover letter: intended as a standalone pre-existing fix.
- Buggy helper **is in this 7.3 tree** (since 7.1).
- Prerequisite inline-data skip **is in this tree**.

**Against:**
- Error-path only; no syzbot/user `Reported-by`.
- Bundled in a 9-patch WRITE_ZEROES series (mitigated: explicitly called
  out as a separate pre-existing fix).
- Trigger requires get_block failure (rare).

**Unresolved:** stable@ archive (lore 403); full v1 review text beyond
the on-commit `Reviewed-by`.

**Step 9.2 — Stable rules**
1. Obviously correct and tested? **PASS** (trivial check; R-b Jan; in
   7.3-rc1)
2. Real bug affecting users? **PASS** (false success + possible stale
   data)
3. Important (crash/security/corruption/deadlock)? **PASS** (stale data
   / integrity, HIGH)
4. Small and contained? **PASS** (+3/−1, one function)
5. No new features/APIs? **PASS**
6. Can apply to this tree? **PASS** (helper + callers + prerequisite
   present)

**Step 9.3 — Exceptions**
- Record: **None** (not a device ID/quirk/DT/build/doc exception).
  Ordinary bugfix.

**Step 9.4 — Decision**
This is a small, reviewed ext4 integrity fix for code that exists in
this 7.3-rc4 tree. Callers already propagate `ERR_PTR`. The inline-data
prerequisite is present, so the change does not turn append-on-inline-
data into `-ERANGE`. It meets stable criteria for **this** tree.

---

## Why it matters here

On this 7.3 tree, `ext4_load_tail_bh()` is the shared tail-zero helper
for truncate, punch-hole, fallocate zero/WRITE_ZEROES, and post-EOF
append. Ignoring `ext4_get_block()` makes a failed extent lookup look
like a hole, so those operations can succeed without zeroing a mapped
tail. Later grow/read can then expose stale bytes. Checking the return
and using the existing `ERR_PTR` path is the right, minimal fix.

Risk is low: three lines, no locking/API change, prerequisite
`2fff82f081401` already in this checkout.

---

## Verification

- **[Phase 1]** Parsed commit
  `705a3fd3bac167f1dabe3d3bba46cd484c5528dd`: Zhang Yi, R-b Jan Kara,
  SOB Ted Ts'o, Link msgid `…4038124-4…`. No Fixes/Cc:stable/Reported-
  by.
- **[Phase 2]** `git show 705a3fd3bac16`: +3/−1 in `ext4_load_tail_bh`;
  `err = ext4_get_block(...); if (err < 0) goto unlock`.
- **[Phase 2]** Confirmed unlock already returns `err ? ERR_PTR(err) :
  NULL` before the patch (`git show 705a3fd3bac16^:fs/ext4/inode.c`).
- **[Phase 2]** Callers at the fix: `IS_ERR_OR_NULL` / `PTR_ERR_OR_ZERO`
  (`git grep` on `705a3fd3bac16`).
- **[Phase 3]** `git blame 705a3fd3bac16^` around the call:
  `d863dc3614e489` (2013).
- **[Phase 3]** `git log -S ext4_load_tail_bh -- fs/ext4/inode.c` →
  `3b312a6f510ca`; `git describe --contains` → **v7.1-rc1**.
- **[Phase 3]** `git merge-base --is-ancestor 3b312a6f510ca HEAD` true;
  `705a3fd3bac16` ancestor of HEAD true; **not** in v7.2; **in**
  v7.3-rc1.
- **[Phase 3]** Parent `2fff82f081401` documents `-ERANGE` on inline
  data if this check is added without the skip; that skip is in HEAD.
- **[Phase 4]** `b4 dig -c 705a3fd3bac16` → v4 3/9 lore URL; `-a` showed
  v3 and v4; `-w` listed ext4 maintainers.
- **[Phase 4]** Cover letter (mbox): “Fold in two pre-existing fixes
  (now patches 2 and 3)”.
- **[Phase 4]** WebFetch lore/msgid.link: **403**. Stable-list search:
  **UNVERIFIED**.
- **[Phase 5]** Grep callers: `ext4_block_do_zero_range`,
  `ext4_block_journalled_zero_range` → `ext4_block_zero_eof` /
  `ext4_zero_partial_blocks` → truncate, setattr, punch-hole,
  zero_range, `file.c` append.
- **[Phase 5]** Truncate: `ext4_truncate` → `ext4_block_zero_eof`; on
  error `goto out_trace` (does **not** keep shrinking after a failed
  zero). Punch-hole/`ext4_zero_range` return the error.
- **[Phase 6]** `git describe HEAD` = `v7.3-rc4-27-gf0100363d8c37`;
  `make kernelversion` = `7.3.0-rc4`.
- **[Phase 6]** Buggy helper present in this tree since v7.1;
  prerequisite and this commit both ancestors of HEAD.
- **[Phase 7]** MAINTAINERS: Zhang Yi is `R:` on EXT4; Jan Kara is `R:`;
  Ted is `M:`.
- **[Phase 8]** Failure mode verified from commit text + truncate/punch
  callers, not from a live repro (no reproducer in the message).
- **UNVERIFIED:** Whether `ext4_get_block` can return an error while
  leaving `BH_Mapped` set (fix still correct: any `err < 0` is
  propagated). No live I/O-error repro.

The patch is a small, reviewed ext4 integrity fix for code that exists
in this 7.3 tree, with callers already wired for `ERR_PTR` and the
inline-data prerequisite present.

**YES**

 fs/ext4/inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9a5c08650bd1e..2e3f7ba1a924b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4119,7 +4119,9 @@ static int __ext4_block_zero_page_range(handle_t *handle,
 	}
 	if (!buffer_mapped(bh)) {
 		BUFFER_TRACE(bh, "unmapped");
-		ext4_get_block(inode, iblock, bh, 0);
+		err = ext4_get_block(inode, iblock, bh, 0);
+		if (err < 0)
+			goto unlock;
 		/* unmapped? It's a hole - nothing to do */
 		if (!buffer_mapped(bh)) {
 			BUFFER_TRACE(bh, "still unmapped");
-- 
2.53.0

