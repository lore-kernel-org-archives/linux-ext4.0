Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2CEB4D990E;
	Mon, 20 Apr 2026 13:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776692020; cv=none; b=pKGvks4ZdgRT9M5JhrTEOUm63km21Cl16a3rrEpzV+ehsYFRjUR704gfJUB9SPhZMwXBInRjs+BL98Y39QfdtK35tGvpPYzD9YuIXn34bwLOYJ8ZXQWvKA+s+RoKyslKTuRpjYM+T9lzd5K/oUwT1k+jAVNiyHCx5uj48KvHLXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776692020; c=relaxed/simple;
	bh=zzGA0Wc964p7b/96QFkBKZb0Tphg1htYfn8JQ0+EHbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CmjHxO7mkDmqK4eoo8Y/AA7m+wfbLdvhLuyNWImBrNcz2mr/Zu6A/JtyV6WhUFZKZfEAFz4ggKP3Nu5EGLsSyVBaW5R26Svt6MeMO2pCk0vjxtTbOrEh/yFftnqE5/CZjwJwX/ze/jrS4+w0eUCYuEWljJvd8Tvj2bQ4hKFj72g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GPYB+IP6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GPYB+IP6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4627C2BCB7;
	Mon, 20 Apr 2026 13:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776692019;
	bh=zzGA0Wc964p7b/96QFkBKZb0Tphg1htYfn8JQ0+EHbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GPYB+IP6CrKhcnTy85O259gbo6Gqo/Sv28HvLCFc/rpu0hI/2xXwCbVRpk/QNHDdt
	 lWMMTi31hKFGKwNSN3eP3VO1VbQZ/Z28XslRWfUvHRKxK9f40OZAIFpsBwetGD/Uio
	 /4cpVAY6VH8rXxqHDZMN4fsO4VUAO2C9eu78XsEY3Tgi+/yTgrHZSoQCokt3LT5lXP
	 HJGiO66bBfJiZj8iF2h7BASDmjzw225TrLbx1HpV7FTorhVZgvlnxZWEjrt5Hg2FAl
	 D6gZ/w+tX7xsnkHCwhpvaf4vbSqoXnUX6gj2GrOhtMTga7Mh3bCmC8LTouLD3Nht9x
	 mLRFG64o0CM0g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+b0a0670332b6b3230a0a@syzkaller.appspotmail.com,
	Matthew Wilcox <willy@infradead.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.1] ext4: unmap invalidated folios from page tables in mpage_release_unused_pages()
Date: Mon, 20 Apr 2026 09:22:00 -0400
Message-ID: <20260420132314.1023554-326-sashal@kernel.org>
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

From: Deepanshu Kartikey <kartikey406@gmail.com>

[ Upstream commit 9b25f381de6b8942645f43735cb0a4fb0ab3a6d1 ]

When delayed block allocation fails (e.g., due to filesystem corruption
detected in ext4_map_blocks()), the writeback error handler calls
mpage_release_unused_pages(invalidate=true) which invalidates affected
folios by clearing their uptodate flag via folio_clear_uptodate().

However, these folios may still be mapped in process page tables. If a
subsequent operation (such as ftruncate calling ext4_block_truncate_page)
triggers a write fault, the existing page table entry allows access to
the now-invalidated folio. This leads to ext4_page_mkwrite() being called
with a non-uptodate folio, which then gets marked dirty, triggering:

    WARNING: CPU: 0 PID: 5 at mm/page-writeback.c:2960
    __folio_mark_dirty+0x578/0x880

    Call Trace:
     fault_dirty_shared_page+0x16e/0x2d0
     do_wp_page+0x38b/0xd20
     handle_pte_fault+0x1da/0x450

The sequence leading to this warning is:

1. Process writes to mmap'd file, folio becomes uptodate and dirty
2. Writeback begins, but delayed allocation fails due to corruption
3. mpage_release_unused_pages(invalidate=true) is called:
   - block_invalidate_folio() clears dirty flag
   - folio_clear_uptodate() clears uptodate flag
   - But folio remains mapped in page tables
4. Later, ftruncate triggers ext4_block_truncate_page()
5. This causes a write fault on the still-mapped folio
6. ext4_page_mkwrite() is called with folio that is !uptodate
7. block_page_mkwrite() marks buffers dirty
8. fault_dirty_shared_page() tries to mark folio dirty
9. block_dirty_folio() calls __folio_mark_dirty(warn=1)
10. WARNING triggers: WARN_ON_ONCE(warn && !uptodate && !dirty)

Fix this by unmapping folios from page tables before invalidating them
using unmap_mapping_pages(). This ensures that subsequent accesses
trigger new page faults rather than reusing invalidated folios through
stale page table entries.

Note that this results in data loss for any writes to the mmap'd region
that couldn't be written back, but this is expected behavior when
writeback fails due to filesystem corruption. The existing error message
already states "This should not happen!! Data will be lost".

Reported-by: syzbot+b0a0670332b6b3230a0a@syzkaller.appspotmail.com
Tested-by: syzbot+b0a0670332b6b3230a0a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b0a0670332b6b3230a0a
Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Link: https://patch.msgid.link/20251205055914.1393799-1-kartikey406@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have sufficient information to complete the forensic analysis.

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1 — Subject line parse**
- Record: Subsystem `ext4:`; action verb `unmap` (describes the fix
  mechanism, but semantically a fix); one-line summary: invalidated
  folios in the writeback error path must also be unmapped from user
  page tables to avoid a `__folio_mark_dirty` WARN.

**Step 1.2 — Commit message tags**
- Record:
  - `Reported-by: syzbot+b0a0670332b6b3230a0a@syzkaller.appspotmail.com`
  - `Tested-by: syzbot+...@syzkaller.appspotmail.com` (auto-test bot
    confirmed fix)
  - `Closes:
    https://syzkaller.appspot.com/bug?extid=b0a0670332b6b3230a0a`
  - `Suggested-by: Matthew Wilcox <willy@infradead.org>` (MM maintainer)
  - `Signed-off-by: Deepanshu Kartikey` + `Signed-off-by: Theodore Ts'o`
    (ext4 maintainer)
  - `Link:` to lore message id
  - No Fixes:, no Cc: stable (expected – that's why this is up for
    review)

**Step 1.3 — Commit body analysis**
- Record: Very detailed 10-step reproduction flow. The author identifies
  the exact sequence: mmap write → dirty/uptodate folio → delayed-alloc
  failure (e.g., corruption) →
  `mpage_release_unused_pages(invalidate=true)` → folio invalidated but
  still mapped → later write fault (e.g., from
  `ext4_block_truncate_page()`) hits `ext4_page_mkwrite()` with
  `!uptodate` folio → `WARN_ON_ONCE(warn && !uptodate && !dirty)` fires
  in `__folio_mark_dirty()`. Author explicitly states this is not
  theoretical — syzbot has a C reproducer. Also notes data-loss is
  intentional/expected on writeback failure ("This should not happen!!
  Data will be lost" message is pre-existing).

**Step 1.4 — Hidden bug fix?**
- Record: Not hidden — the subject names the mechanism, and the body
  explicitly documents a WARN and a concrete syscall sequence. This is
  clearly a fix.

## PHASE 2: DIFF ANALYSIS

**Step 2.1 — Inventory**
- Record: 1 file changed (`fs/ext4/inode.c`), +15/-1 lines, all in
  `mpage_release_unused_pages()`. Single-file surgical fix, scope = very
  small.

**Step 2.2 — Code flow change**
- Record: Before: when `invalidate=true` and `folio_mapped(folio)` was
  true, we only `folio_clear_dirty_for_io(folio)` to clear the PTE-dirty
  bits (from 2016 commit `4e800c0359d9a`), then
  `block_invalidate_folio()` + `folio_clear_uptodate()`, and left the
  mapping in place. After: we additionally call
  `unmap_mapping_pages(folio->mapping, folio->index,
  folio_nr_pages(folio), false)` to tear the folio out of every
  process's page tables, so no stale PTE can resurface the now-
  invalidated folio.

**Step 2.3 — Bug mechanism classification**
- Record: Memory-safety / correctness in error path. Stale PTE pointing
  at an invalidated folio → `fault_dirty_shared_page()` reaches
  `__folio_mark_dirty()` with `!uptodate && !dirty`, firing a KERNEL
  WARN. It is a bug (WARN = kernel bug signal to syzbot) and also opens
  the door to suspicious follow-on state (dirty bits on a folio the
  filesystem has already written off).

**Step 2.4 — Fix quality**
- Record: Obvious and correct. `unmap_mapping_pages()` is the standard
  MM helper for exactly this purpose (used by truncate_pagecache,
  `filemap_fault` race handling, etc.). It runs only under
  `invalidate=true` — i.e., only on the writeback-failure path — so the
  runtime cost in the non-error case is zero. Very low regression risk:
  the worst case is forcing future access to re-fault, which is benign.

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1 — Blame**
- Record: The surrounding construct (`if (folio_mapped())
  folio_clear_dirty_for_io(...)`, then `block_invalidate_folio` +
  `folio_clear_uptodate`) was added by commit `4e800c0359d9a` ("ext4:
  bugfix for mmaped pages in mpage_release_unused_pages()"), released in
  v4.9-rc1 (2016). So the incomplete handling has existed since v4.9 —
  every current stable tree is affected.

**Step 3.2 — Fixes: tag**
- Record: No `Fixes:` tag is in the commit (expected — this is a
  candidate under review). The bug is logically introduced by
  `4e800c0359d9a` (v4.9), which is present in every active stable tree.

**Step 3.3 — File history**
- Record: Recent touches to `mpage_release_unused_pages()` include
  `d8be7607de039` (ext4: Move mpage_page_done() calls after error
  handling), `fb5a5be05fb45` (convert to filemap_get_folios),
  `a297b2fcee461` (unlock unused_pages timely). None address this
  specific stale-PTE issue. This patch is self-contained; not part of a
  series.

**Step 3.4 — Author**
- Record: `Deepanshu Kartikey` is a regular syzbot-driven contributor
  (many small fixes across ext4, gfs2, netfs, mac80211). Not the
  maintainer, but the commit was reviewed and applied by ext4 maintainer
  Theodore Ts'o.

**Step 3.5 — Dependencies**
- Record: Only depends on `unmap_mapping_pages()`, which exists since
  v4.16 (mm commit `977fbdcd5986c`) — verified present in every stable
  tree checked (5.10, 5.15, 6.1, 6.6, 6.12). No patch-series dependency.

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1 — Original submission**
- Record: `b4 dig -c 9b25f381...` resolved to the v3 thread at `https://
  lore.kernel.org/all/20251205055914.1393799-1-kartikey406@gmail.com/`.
  `b4 dig -a` shows this is v3 (earlier attempts v1/v2 tried to fix it
  in `ext4_page_mkwrite()` — see syzbot Discussions table linking
  `20251122015742.362444-1-...` and `20251121131305.332698-1-...`). The
  v3 approach was suggested by Matthew Wilcox and preferred by Ted Ts'o.
  Ted applied v3 directly with "Applied, thanks!" (mbox saved by b4
  shows `commit: 9b25f381de6b...`).

**Step 4.2 — Reviewers**
- Record: To/Cc from `b4 dig -w` includes `tytso@mit.edu` (ext4
  maintainer — applied), `adilger.kernel@dilger.ca` (ext4 co-
  maintainer), `willy@infradead.org` (MM maintainer — suggested the
  fix), `djwong@kernel.org`, `yi.zhang@huaweicloud.com`, `linux-
  ext4@vger.kernel.org`, `linux-kernel@vger.kernel.org`. Appropriate
  audience reviewed the change.

**Step 4.3 — Bug report**
- Record: Fetched
  https://syzkaller.appspot.com/bug?extid=b0a0670332b6b3230a0a. Syzbot
  has a C reproducer. First crash 254 days before fetch, last 5d ago.
  Label `Fix commit: 9b25f381de6b` confirms this commit closed the
  upstream bug. The sample crash shows `__folio_mark_dirty` WARN with
  call trace `block_dirty_folio → fault_dirty_shared_page → do_wp_page →
  handle_mm_fault → do_user_addr_fault` — exact match to the commit
  message. Linux-6.6 has a sibling report labeled `origin:lts-only` and
  linux-6.1 one labeled `missing-backport`, indicating stable trees
  still need a fix.

**Step 4.4 — Related patches**
- Record: This is a single-patch series (v3); v1/v2 were alternative
  approaches to the same bug, superseded. No dependent patches.

**Step 4.5 — Stable ML**
- Record: No explicit Cc: stable in the applied patch. Syzbot label
  `missing-backport` on 6.1 is effectively a public request for stable
  coverage of this bug.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1 — Functions in diff**
- Record: Only `mpage_release_unused_pages()` is modified.

**Step 5.2 — Callers**
- Record: Two call sites in `ext4_do_writepages()`:
  `mpage_release_unused_pages(mpd, false)` (normal completion, no
  invalidate) and `mpage_release_unused_pages(mpd, give_up_on_write)`
  (error path). The fix only triggers on the second (writeback-failure)
  path.

**Step 5.3 — Callees**
- Record: After fix adds `unmap_mapping_pages(folio->mapping,
  folio->index, folio_nr_pages(folio), false)` — standard MM helper that
  tears down PTEs for the given pgoff range (non-even-cows). Existing
  callees: `folio_clear_dirty_for_io`, `block_invalidate_folio`,
  `folio_clear_uptodate`, `folio_unlock`.

**Step 5.4 — Call chain / reachability**
- Record: `ext4_do_writepages` is called from the ordinary writeback
  path (syscalls such as `fsync`, `sync`, `msync`, memory-pressure-
  driven writeback). The `give_up_on_write=true` branch is taken when
  `ext4_map_blocks()` returns an error — e.g., on corruption detected by
  the extent tree. So an unprivileged user with a mmap of a corrupt ext4
  image can trigger it, which is exactly what syzbot does.

**Step 5.5 — Similar patterns**
- Record: Related earlier fix in the same function — commit
  `4e800c0359d9a` from 2016 — covered the PTE-dirty bit but not the PTE
  itself. The new patch completes that earlier partial fix. The same
  philosophy (unmap before invalidating) is used by
  `truncate_inode_pages_range()` and `invalidate_inode_pages2_range()`
  in mm/truncate.c, so this brings ext4 in line with the mm convention.

## PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

**Step 6.1 — Code exists in stable**
- Record: Verified the vulnerable pattern exists:
  - `stable/linux-6.19.y`: `folio_mapped(folio) →
    folio_clear_dirty_for_io` without unmap ✓
  - `stable/linux-6.18.y`: same ✓
  - `stable/linux-6.17.y`: same ✓
  - `stable/linux-6.12.y`: same ✓
  - `stable/linux-6.6.y`: same ✓
  - `stable/linux-6.1.y`: same ✓
  - `stable/linux-5.15.y`, `5.10.y`: same logic but pre-folio
    (`page_mapped(page) → clear_page_dirty_for_io`) — needs port to page
    API.

**Step 6.2 — Backport complications**
- Record: For 6.1..6.19 the hunk is effectively identical and should
  apply cleanly or with trivial offsets. For 5.15/5.10, the patch must
  be re-expressed using `unmap_mapping_pages(page->mapping, page->index,
  compound_nr(page), false)` or `1` for non-compound.
  `unmap_mapping_pages()` itself is available since v4.16, so available
  in all these trees.

**Step 6.3 — Already fixed?**
- Record: `git log --grep="unmap invalidated folios"` in
  `stable/linux-6.1/6.6/6.12/6.17/6.18/6.19` returned nothing. Not yet
  backported.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1 — Subsystem**
- Record: `fs/ext4/` — one of the most widely deployed filesystems.
  Criticality: IMPORTANT (affects a large population of users,
  especially enterprise and Android).

**Step 7.2 — Activity**
- Record: ext4/inode.c is very actively maintained; the specific
  `mpage_release_unused_pages()` function has had targeted fixes before
  (2016, 2024). Writeback error path is exercised any time delayed
  allocation fails.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1 — Affected users**
- Record: Any user of ext4 who has a mmapped file where delayed block
  allocation fails (FS corruption, ENOSPC under certain delalloc
  conditions, etc.). Unprivileged users can trigger it with a
  crafted/corrupt image (syzbot proved this).

**Step 8.2 — Trigger conditions**
- Record: Mmap a file on ext4, dirty it, then force writeback to fail
  (syzbot does this with a corrupt FS image). A concrete C reproducer
  exists and still crashes unpatched 6.6.y as of ~5 days ago.

**Step 8.3 — Failure mode / severity**
- Record: Kernel WARN (`WARN_ON_ONCE(warn && !uptodate && !dirty)`),
  plus the page stays accessible via stale PTEs after invalidation. On
  systems with `panic_on_warn`, this is a kernel panic (DoS). Even
  without panic_on_warn, the invariant violation signals a genuine
  state-machine bug and can mislead subsequent writeback/truncate logic.
  Severity: MEDIUM-HIGH (WARN / potential DoS / invariant violation; a
  security-relevant WARN class that syzbot tracks specifically).

**Step 8.4 — Risk-benefit**
- Record: Benefit — closes a syzbot-tracked bug with public C
  reproducer, stops WARN/panic on corrupt FS workloads, on a core
  filesystem. Risk — fix is 15 lines, only executes in the writeback-
  error path, uses a well-understood MM API, reviewed by MM + ext4
  maintainers, and has syzbot `Tested-by`. Ratio strongly favors
  backporting.

## PHASE 9: SYNTHESIS

**Step 9.1 — Evidence**
- For: syzbot-reported + reproducible, WARN on a core filesystem, tiny
  surgical change, reviewed by the MM maintainer who suggested it and
  applied by the ext4 maintainer, Tested-by syzbot, the buggy code
  exists in every active stable tree, sibling syzbot reports on 6.1.y
  and 6.6.y explicitly labeled `missing-backport` / `origin:lts-only`,
  dependency `unmap_mapping_pages()` is present since v4.16.
- Against: No `Cc: stable` tag (not a decisive signal — this is
  precisely why it's under review). For 5.10/5.15 a minor port from
  folio to page API is needed.
- Unresolved: None that would flip the decision.

**Step 9.2 — Stable rules checklist**
1. Obviously correct and tested — YES (syzbot Tested-by; straightforward
   mm API use).
2. Fixes a real bug — YES (WARN with C reproducer).
3. Important issue — YES (kernel WARN/potential panic, invariant
   violation in core filesystem).
4. Small and contained — YES (+15/-1 in one function, error path only).
5. No new features — YES.
6. Can apply to stable — YES for 6.1+ cleanly; minor hand-port for
   5.15/5.10.

**Step 9.3 — Exception category**
- Not a device-ID/quirk/DT case; this is a straightforward bug fix that
  qualifies on its own merits.

**Step 9.4 — Decision**
- Backport.

## Verification
- [Phase 1] Parsed tags from the commit body: `Reported-by:
  syzbot+b0a0670332b6b3230a0a@...`, `Tested-by: syzbot+...`, `Suggested-
  by: Matthew Wilcox`, `Signed-off-by: Theodore Ts'o`, `Closes:
  syzkaller URL`. No Fixes: or Cc: stable (expected for candidates).
- [Phase 2] Ran `git show 9b25f381de6b...` — confirmed diff is +15/-1 in
  `fs/ext4/inode.c`, only inside `mpage_release_unused_pages()`'s `if
  (invalidate)` block, adds `unmap_mapping_pages(folio->mapping,
  folio->index, folio_nr_pages(folio), false)`.
- [Phase 3] `git log --oneline --grep="mpage_release_unused_pages"` —
  found 8 historical touches including the 2016 partial fix
  `4e800c0359d9a` ("ext4: bugfix for mmaped pages..."). `git describe
  --contains 4e800c0359d9a` → v4.9-rc1 — confirms the vulnerable
  construct has been in stable trees since v4.9.
- [Phase 3] Confirmed no Fixes: tag in commit; logical predecessor is
  `4e800c0359d9a`.
- [Phase 3] `git log --author="Deepanshu Kartikey"` — author is a
  syzbot-focused contributor with many accepted small fixes across
  subsystems.
- [Phase 4] `b4 dig -c 9b25f381de6b...` returned the v3 submission URL `
  https://lore.kernel.org/all/20251205055914.1393799-1-
  kartikey406@gmail.com/`.
- [Phase 4] `b4 dig -c ... -a` showed this is v3; earlier v1/v2 took a
  different (rejected) approach in `ext4_page_mkwrite()`.
- [Phase 4] `b4 dig -c ... -w` confirmed willy, tytso, adilger, djwong,
  yi.zhang, linux-ext4 were CC'd and reviewed.
- [Phase 4] `b4 dig -c ... -m` and read the mbox — Ted Ts'o applied v3
  with "Applied, thanks!", commit `9b25f381de6b`.
- [Phase 4] Fetched syzkaller URL — confirmed public C reproducer, `Fix
  commit: 9b25f381de6b`, still first-crashed 254 days ago and last seen
  5 days ago on unpatched trees. Sibling bugs `a92b613efd5e` (linux-6.1,
  label `missing-backport`) and `d429f1fb4bc9` (linux-6.6, label
  `origin:lts-only`) indicate stable trees still need the fix.
- [Phase 5] Manually traced: only two call sites in
  `ext4_do_writepages()`, the patched branch only hits the
  `give_up_on_write` error path. Confirmed `unmap_mapping_pages` is used
  elsewhere in mm/ with same pattern (truncate/invalidate).
- [Phase 6] Read `fs/ext4/inode.c` in stable/linux-6.1.y, 6.6.y, 6.12.y,
  6.17.y, 6.18.y, 6.19.y — all contain the unchanged vulnerable `if
  (folio_mapped(folio)) folio_clear_dirty_for_io(folio);
  block_invalidate_folio(...); folio_clear_uptodate(...);` pattern. Read
  5.10.y/5.15.y — contain the pre-folio `page_mapped(page) /
  clear_page_dirty_for_io / block_invalidatepage / ClearPageUptodate`
  pattern (needs small port).
- [Phase 6] `git log stable/linux-6.{1,6,12,17,18,19}.y --grep="unmap
  invalidated folios"` — none contain this fix yet.
- [Phase 6] Confirmed `unmap_mapping_pages` is defined in `mm/memory.c`
  of every stable tree checked; `git describe --contains 977fbdcd5986c`
  = v4.16-rc1.
- [Phase 7] `fs/ext4/` is a core, widely-used filesystem;
  `mpage_release_unused_pages()` touched by multiple targeted fixes over
  the years.
- [Phase 8] Failure mode verified from the sample syzbot crash:
  `block_dirty_folio → fault_dirty_shared_page → do_wp_page →
  handle_mm_fault → exc_page_fault`, exactly matching the commit
  message's description.
- UNVERIFIED: I did not attempt an actual patch apply against
  5.10.y/5.15.y — expect a minor manual port (folio→page API), not a
  semantic change.

The fix is small, surgical, obviously correct, syzbot-reported with a
reproducer, reviewed by ext4+MM maintainers, touches only the writeback-
error path, and the vulnerable code pattern is present in every active
stable tree. It satisfies all stable-kernel rules with very low
regression risk.

**YES**

 fs/ext4/inode.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1123d995494b5..025ea8f0c41bd 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1757,8 +1757,22 @@ static void mpage_release_unused_pages(struct mpage_da_data *mpd,
 			BUG_ON(!folio_test_locked(folio));
 			BUG_ON(folio_test_writeback(folio));
 			if (invalidate) {
-				if (folio_mapped(folio))
+				if (folio_mapped(folio)) {
 					folio_clear_dirty_for_io(folio);
+					/*
+					 * Unmap folio from page
+					 * tables to prevent
+					 * subsequent accesses through
+					 * stale PTEs. This ensures
+					 * future accesses trigger new
+					 * page faults rather than
+					 * reusing the invalidated
+					 * folio.
+					 */
+					unmap_mapping_pages(folio->mapping,
+						folio->index,
+						folio_nr_pages(folio), false);
+				}
 				block_invalidate_folio(folio, 0,
 						folio_size(folio));
 				folio_clear_uptodate(folio);
-- 
2.53.0

