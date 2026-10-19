Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 217746155E5;
	Mon, 19 Oct 2026 14:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418646; cv=none; b=qRC/AqLYN6+AaO8zkqxOKNZ4GhfF7S4GsIXKu9JWq2yG0szwGL0p7fYoySdL4tqOpBwvu70Rwo073EOtuw6JvQOFcJsZcFw6+XsPWdHA6AcllLaU81z6yrHfblp9jM7y76/PmrOBuIV5E5SjSI/K2c3VpUn0PKqohFq8i30nnsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418646; c=relaxed/simple;
	bh=+/ypNo36wf4Ql7eYbPPvFhi1Cfm7Z60hC9Y4SQ8C5QY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L88xpurAkmRyhR2OTwowFTp/Fg+mbUukss7vtFkJ8wPvqIP2zGoQBnTEi3yulElNQyjI0tAFp6ZlQjuAv6fmssb3HB0CJ7Uh6fYzs3GqGN9hGm22ssqag0vH87+DYvB10rA3NzPmFvvzUYMHWYW9EVvjt0esFMihyGqY/o3dd7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TclOweDp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TclOweDp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0615E1F000C6;
	Mon, 19 Oct 2026 14:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418644;
	bh=mNSDhQxe9BsTOT3/0dXnHOE0ysBTFFf6fwLURtgJ8gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TclOweDpwGPFrj+iwhVLv5PKlHJl9NsnDhHFSvy1gnzC+d8xKpg/SrnStFeG+B7qU
	 WLr5uJX4tHUBRoJtXQ7gZuZixUDTGONCfPKDa0HqJQhm39bo76oCfRjmz5XlckKwSZ
	 V2YKfMlZK4yLBWo+3Rc6b3mrofTY9UZWSnj1JPTAxkBB7QQMCNtj1Pu9U1RT5MoyHq
	 T0NVYgKF7bTaDEhy1Q9tXUrpZfJ9XmCZOlynRoxjjeIS1ZdrWd+KwjwjEGq67UElhd
	 7Z8p9xFutg0U2xbg7waP03ESwflRpuyfxLbkx5HZDt9mKsOTaW4Zu1t13oI/wSd8zg
	 GKaxCjCWUcIhA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Baokun Li <libaokun@linux.alibaba.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Sashiko <sashiko-bot@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Zhang Yi <yi.zhang@huawei.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] ext4: reject mount if clusters/inodes per group are not 8-aligned
Date: Mon, 19 Oct 2026 09:51:26 -0400
Message-ID: <20261019135441.1420968-395-sashal@kernel.org>
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

From: Baokun Li <libaokun@linux.alibaba.com>

[ Upstream commit d42dc7726a003262b73ffef2b744ff57a5488799 ]

The block and inode bitmap checksums are computed over a whole number of
bytes: ext4_inode_bitmap_csum_*() use EXT4_INODES_PER_GROUP(sb) >> 3 and
ext4_block_bitmap_csum_*() use EXT4_CLUSTERS_PER_GROUP(sb) / 8 as the
length passed to ext4_chksum().

If s_inodes_per_group or s_clusters_per_group is not a multiple of 8, the
trailing fractional bits are excluded from the checksum.  Those bits are
then unprotected, and any incremental csum update path that assumes a
byte-aligned bitmap can compute a checksum inconsistent with the full
recalculation, corrupting the on-disk bitmap checksum.

Reject such filesystems at mount time by adding the missing " & 7"
alignment checks alongside the existing range validation.

Suggested-by: Theodore Ts'o <tytso@mit.edu>
Link: https://patch.msgid.link/h3n7jlfhyna64dn5o76qxcspnhxdddcs6crpxftmy7gnl7b3sx@jenszfpcsnit
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260508121539.4174601-1-libaokun%40linux.alibaba.com?part=10
Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Link: https://patch.msgid.link/20260608111150.827117-2-libaokun@linux.alibaba.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a small ext4 mount-time geometry check. Local tree is
**7.3.0-rc4** (`v7.3-rc4-27-gf0100363d8c37`). The candidate is
`d42dc7726a003`. The checksum path still uses byte-truncated lengths, so
the bug this closes is real in this tree.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[ext4] [reject] reject mount if clusters/inodes per group are
not 8-aligned**

Subsystem `ext4`. Verb `reject` is a defensive mount-time check, not a
feature or refactor.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- **Suggested-by:** Theodore Ts'o `<tytso@mit.edu>` (ext4 maintainer)
- **Link:** `https://patch.msgid.link/h3n7jlfhyna64dn5o76qxcspnhxdddcs6c
  rpxftmy7gnl7b3sx@jenszfpcsnit` (Ted’s suggestion)
- **Reported-by:** Sashiko `<sashiko-bot@kernel.org>` (static-analysis
  bot, not syzbot)
- **Closes:** sashiko.dev URL pointing at RFC series part 10
- **Signed-off-by:** Baokun Li `<libaokun@linux.alibaba.com>` (author)
- **Reviewed-by:** Jan Kara `<jack@suse.cz>` (ext4 co-maintainer)
- **Reviewed-by:** Zhang Yi `<yi.zhang@huawei.com>`
- **Link:** `https://patch.msgid.link/20260608111150.827117-2-
  libaokun@linux.alibaba.com` (v2 1/3)
- **Signed-off-by:** Theodore Ts'o `<tytso@mit.edu>` (applied)
- **No Fixes:** tag (expected)
- **No Cc: stable** (expected)
- Ignore pipeline markers: none of `[Upstream commit]` / Sasha Levin SOB
  on this commit

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** inode/block bitmap checksums hash a whole number of bytes
  (`EXT4_INODES_PER_GROUP >> 3`, `EXT4_CLUSTERS_PER_GROUP / 8`). If
  those counts are not multiples of 8, the last 1–7 bits are omitted
  from the CRC.
- **Symptom:** those bits are unprotected; an incremental CRC path that
  assumes byte alignment can disagree with a full recalculation and
  write a bad on-disk bitmap checksum.
- **Version info:** none in the message.
- **Root cause (author):** missing `& 7` checks next to the existing
  range checks in `ext4_handle_clustersize()` /
  `ext4_block_group_meta_init()`.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: **Not hidden.** Explicit mount rejection for invalid superblock
geometry. Cover letter (`[PATCH v2 0/3]`) states the series prevents
crafted images from causing bitmap checksum corruption, integer
overflow, or OOB inode-table access. This patch is the
checksum/alignment piece.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**

Record:
- **File:** `fs/ext4/super.c` only (`+6 / -4`)
- **Functions:** `ext4_handle_clustersize()`,
  `ext4_block_group_meta_init()`
- **Scope:** single-file surgical fix, two existing `if` conditions

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record:
- **Hunk 1 (`ext4_handle_clustersize`):** previously rejected only
  `s_clusters_per_group > blocksize * 8`. After: also reject
  `s_clusters_per_group & 7`. Error text becomes `"invalid #clusters per
  group"`.
- **Hunk 2 (`ext4_block_group_meta_init`):** previously rejected inodes-
  per-group outside `[inodes_per_block, blocksize*8]`. After: also
  reject `s_inodes_per_group & 7`. Trailing `\n` in the format string
  dropped.
- **Path:** mount / `__ext4_fill_super()` only. Legitimate 8-aligned
  filesystems are unchanged.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record: **[Logic / correctness + metadata integrity]**

Verified in `fs/ext4/bitmap.c`:

```31:31:fs/ext4/bitmap.c
        sz = EXT4_INODES_PER_GROUP(sb) >> 3;
```

```68:68:fs/ext4/bitmap.c
        int sz = EXT4_CLUSTERS_PER_GROUP(sb) / 8;
```

Set and verify use the same truncated length, so kernel-internal CRC is
consistent. Trailing bits are still live inode/cluster bits
(`ext4_set_bit` in alloc/free) but are **not** covered by
`metadata_csum`. `ialloc.c` zeros with `(EXT4_INODES_PER_GROUP(sb) + 7)
/ 8` (round up) while CRC uses `>> 3` (round down).

The “incremental csum update” failure mode is what Sashiko flagged in
**unmerged** RFC helper `ext4_inode_bitmap_csum_set_fast()`.
`crc32c_flip_range` is **not** in this tree. The gap that **is** in this
tree is unprotected trailing bitmap bits plus disagreement with any tool
that hashes a different length.

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- **Quality:** obviously correct. `& 7` matches the CRC byte length.
  Same style as the existing upper-bound checks.
- **Regression risk:** only rejects non-8-aligned geometries. Ted
  documented that old Android `make_ext4fs` could emit those; he also
  said that was fixed more than a decade ago and those devices should be
  gone. Follow-up `a34de48f329b2` only adds another conjunct on the same
  `if`; it does not revert this check.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- Cluster range check introduced in `40da553f5da02` (“ext4: verify
  s_clusters_per_group even without bigalloc”, 2024-03-07, Jan Kara).
- Inode range check lived in this helper since `107d2be90116a` (2023
  factor-out); the `blocksize * 8` bound is older (`c8267c51425ab` moved
  a local).
- Bitmap CRC with `/ 8` / `>> 3` dates to `41a246d1ff75a` /
  `fa77dcfafeaa6` (2012, metadata_csum).
- Alignment checks themselves are `d42dc7726a003` (this commit).

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: **No Fixes: tag.** Buggy assumption is as old as metadata_csum
(2012), not a recent regression.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record:
- Same series, independent patches:
  - `d42dc7726a003` — this commit (v2 1/3)
  - `afa3caf2fbc41` — max cluster size (v2 2/3)
  - `a34de48f329b2` — inodes_per_group % inodes_per_block (v2 3/3)
- Cover letter: patches 2 and 3 are “independent of Patch 1”.
- This patch does not need 2/3.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Baokun Li is a regular ext4 contributor (many DIO/DAX and
validation patches). Not the maintainer; Ted applied it. Jan Kara and
Zhang Yi reviewed.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: **Standalone.** Touches existing `if`s in helpers that exist
here (`ext4_handle_clustersize` at `super.c:4461`,
`ext4_block_group_meta_init` at `super.c:5294`). No new helpers, no
incremental CRC.

`git merge-base --is-ancestor d42dc7726a003 HEAD` → **yes** (exit 0).
Already in this checkout via `ext4_for_linus-7.3-rc1`.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- **b4 dig -c d42dc7726a003:** `https://patch.msgid.link/20260608111150.
  827117-2-libaokun@linux.alibaba.com`
- **Revisions:**
  - v1 RFC: part of 17-patch incremental CRC series (`lib/crc: add
    crc32c_flip_range()`), 2026-05-08
  - v2: `[PATCH v2 0/3] ext4: tighten mount-time superblock geometry
    validation`, 2026-06-08 (this is what landed)
- v2 vs v1 for **this** patch: only dropped a spurious `\n` in the error
  format.
- **Reviews:** Zhang Yi “Looks good”; Jan Kara “Looks good”; Ted
  “Applied, thanks!” with the three SHAs.
- **No NAKs.** No reviewer asked for `Cc: stable`.
- lore.kernel.org HTTP **403**; thread recovered via `b4 dig -m`.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record (**b4 dig -w**): linux-ext4, Ted Ts'o, Andreas Dilger, Jan Kara,
Zhang Yi, Ojaswin Mujoo, Ritesh, Sashiko. Subsystem maintainers were on
To/Cc. Jan Kara and Zhang Yi reviewed this patch; Ted applied it.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: Sashiko High finding on RFC 10/17
`ext4_inode_bitmap_csum_set_fast()`: incremental CRC would corrupt the
checksum if `INODES_PER_GROUP` is not a multiple of 8.

Ted’s reply (verified from mbox
`h3n7jlfhyna64dn5o76qxcspnhxdddcs6crpxftmy7gnl7b3sx@jenszfpcsnit`):

- Kernel historically **did not** enforce 8-alignment because old
  Android `make_ext4fs` (MIT, pre-e2fsprogs) sometimes created non-
  multiples of 8.
- That hit e2fsck ([sourceforge e2fsprogs bug
  292](https://sourceforge.net/p/e2fsprogs/bugs/292/)).
- “Fixed long ago (over a decade ago)… any such mobile handsets are in
  the landfill, so we probably should fix this by adding a check in
  ext4_fill_super().”

So this is maintainer-directed policy: stop mounting geometries e2fsck
already treats as invalid.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: v2 is three independent mount checks. Incremental CRC RFC was
**not** merged (`crc32c_flip_range` absent). This patch does not pull in
that series.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: **UNVERIFIED** — lore.kernel.org/stable returned 403. No stable
discussion in the ext4 mbox.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**

Record: `ext4_handle_clustersize`, `ext4_block_group_meta_init`.
Supporting: `ext4_inode_bitmap_csum_{set,verify}`,
`ext4_block_bitmap_csum_{set,verify}`.

**Step 5.2: TRACE CALLERS**

Record: both are called only from `__ext4_fill_super()` (`super.c:5443`
and `5451`). Mount path, not hot I/O. Reaching the bug is “mount this
filesystem” (loop, USB, etc.).

**Step 5.3: TRACE CALLEES**

Record: read superblock fields, `ext4_msg`, `return -EINVAL`. No alloc,
no new locks.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: `mount` / `fsopen` → `ext4_fill_super` → these checks.
Unprivileged users can hit it with a crafted image on a loop device if
they can mount (or via automount). **Userspace-reachable.**

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: same file already rejects other invalid geometry (blocks vs
clusters, inodes_per_block). Series patch 3 adds `% inodes_per_block` on
the same inode `if`. `ext4_count_free()` debug paths also use `/ 8`, so
free-count vs last bits can disagree on unaligned groups.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record: **Yes.** This tree is **7.3.0-rc4**. `bitmap.c` still uses `>>
3` and `/ 8`. The alignment checks are already present at
`super.c:4494-4498` and `5327-5333` because `d42dc7726a003` is an
ancestor of HEAD. The bug the commit addresses (CRC length vs bit count)
is inherent in that checksum code, which has been here since
metadata_csum.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Clean apply on this tree** — already applied; helpers and
surrounding checks match the diff. (Older stables that still have these
checks inline in `ext4_fill_super` would need context adjustment; that
is **not** this checkout.)

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: this exact fix is in the tree. No alternate fix. `a34de48f329b2`
extends the inode `if` but does not replace the `& 7` check.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: **ext4 (`fs/ext4/`) — IMPORTANT.** Default Linux filesystem;
corruption/integrity issues matter to a large user base.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: active (recent 7.3 merges, DIO/DAX, writeback, fastcommit).
Superblock validation is mature; this fills a long-standing hole.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: **filesystem-specific**, ext4 with `metadata_csum` (and bitmap
ops generally). Trigger is a superblock with `s_inodes_per_group` or
`s_clusters_per_group` not divisible by 8. Normal `mke2fs` images are
8-aligned (group size `blocksize * 8`). Population: crafted/fuzzed
images, plus theoretically ancient Android `make_ext4fs` images Ted
believes are gone.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record: mount of such an image. Not every boot of a normal distro disk.
Unprivileged trigger if the user can mount a file. Not a race.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record:
- **Without the check:** trailing bitmap bits omitted from
  `metadata_csum` → integrity hole; debug free-counts ignore those bits;
  incremental CRC (not in this tree) could write a wrong checksum.
- **With the check:** mount fails with `-EINVAL` and a clear error.
- **Severity: MEDIUM–HIGH** for crafted images (metadata integrity /
  checksum vs tools). **Not** a panic on a normal disk. Fits the stable
  “oh, that’s not good” / data-integrity class more than oops/deadlock.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- **Benefit:** stops mounting invalid geometry; closes unprotected
  bitmap bits; matches e2fsck/Ted’s request. High for anyone mounting
  untrusted ext4 images; low for typical servers with `mke2fs` disks.
- **Risk:** very low on this tree — 6 lines, mount-time only, no
  locking/API change. Residual risk is refusing a 10+ year-old Android
  image; maintainer explicitly accepted that.
- **Ratio:** favorable.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR backporting**
- Real metadata-integrity bug: CRC covers `n/8` bytes, bitmaps have `n`
  bits.
- Crafted-image mount path is userspace-reachable.
- 6-line, obviously correct addition to existing validation.
- Suggested and applied by Ted Ts'o; Reviewed-by Jan Kara and Zhang Yi;
  no NAKs.
- Independent of the rest of the v2 series and of the unmerged CRC RFC.
- Code and helpers exist in this 7.3-rc4 tree; patch applies as written.
- Cover letter: “preventing crafted filesystem images from causing
  bitmap checksum corruption”.

**AGAINST**
- Incremental CRC that would *write* a wrong checksum is **not** in this
  kernel.
- No production oops/syzbot repro on a normal filesystem.
- Possible mount refusal of ancient `make_ext4fs` images (Ted:
  landfill).
- Sashiko is static analysis, not a user crash.

**UNRESOLVED**
- Stable list archives (lore 403).
- Current e2fsprogs source not in this repo (Ted’s historical e2fsck
  conflict is documented).

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — `& 7` next to existing
   bounds; reviewed by two ext4 developers; applied by maintainer.
2. Fixes a real bug that affects users? **PASS** — unprotected bitmap
   bits and crafted-image checksum/integrity mismatch; maintainer
   treated it as a real fill_super hole.
3. Important issue (crash, security, corruption, deadlock)? **PASS** —
   metadata checksum integrity / crafted-image corruption; not a panic,
   but on-disk checksum and `metadata_csum` bypass for trailing bits.
4. Small and contained? **PASS** — 6 insertions / 4 deletions, one file.
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — already applies; context
   matches.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: none (not a device ID, quirk, DT, build, or docs patch).
Qualified on the normal bug-fix path.

**Step 9.4: MAKE YOUR DECISION**

This belongs on this tree: the checksum code still truncates to whole
bytes, mount already validates these fields, and adding `& 7` is the
missing invariant the CRC and bitmaps assume. It is small, maintainer-
directed, and does not depend on the incremental-CRC series that never
landed.

### What problem it solves and why it matters here

`metadata_csum` hashes inode/block bitmaps in byte units. A superblock
with inodes or clusters per group not divisible by 8 leaves up to 7 bits
out of the CRC while alloc/free still uses those bits. That is an
integrity hole and a footgun for any checksum updater that assumes byte
alignment. Rejecting that geometry at mount is the same class of check
this file already does for “too big” groups.

### Risk vs benefit

Benefit is closing that hole and refusing crafted images. Risk is a
failed mount of a pathological superblock. Ted already signed off that
remaining Android `make_ext4fs` cases are historical.

---

Verification:
- [Phase 1] Parsed tags: Suggested-by Ted Ts'o; Reported-by Sashiko;
  Reviewed-by Jan Kara, Zhang Yi; msgid 827117-2; no Fixes/Cc-stable
- [Phase 1] Cover letter in mbox: crafted images → bitmap checksum
  corruption / overflow / OOB inode table
- [Phase 2] Diff: +6/-4 in `fs/ext4/super.c`; `s_clusters_per_group & 7`
  and `s_inodes_per_group & 7`
- [Phase 2] `bitmap.c`: `>> 3` and `/ 8` confirmed; set and verify share
  length
- [Phase 2] `ialloc.c:173`: memset uses `(n+7)/8` vs CRC `>> 3`
- [Phase 2] `crc32c_flip_range`: no matches — incremental CRC not in
  this tree
- [Phase 3] `git describe HEAD` / `make kernelversion`: **v7.3-rc4 /
  7.3.0-rc4**
- [Phase 3] `git merge-base --is-ancestor d42dc7726a003 HEAD`: yes
- [Phase 3] blame: cluster bound `40da553f5da02` (2024); inode bound via
  `107d2be90116a`; CRC since `41a246d1ff75a` (2012)
- [Phase 3] series: `afa3caf2fbc41` and `a34de48f329b2` independent;
  cover letter says so
- [Phase 4] `b4 dig -c`: patch.msgid.link/20260608111150.827117-2-…; v1
  RFC 17-patch CRC, v2 3-patch validation
- [Phase 4] `b4 dig -a/-w/-m`: Zhang Yi + Jan Kara R-b; Ted applied;
  recipients linux-ext4 + maintainers
- [Phase 4] Ted mbox: Android make_ext4fs history; add fill_super check
- [Phase 4] lore HTTP 403; used b4 instead
- [Phase 5] callers: only `__ext4_fill_super` at lines 5443 and 5451
- [Phase 6] local `super.c` already has both `& 7` checks; bitmap CRC
  still truncated
- [Phase 7] ext4, important, actively merged in 7.3
- [Phase 8] failure mode: unprotected trailing bitmap bits / crafted-
  image integrity; mount-time -EINVAL after fix
- [Phase 8] stable-kernel-rules.rst: oops/hang/corruption/security/“oh,
  that’s not good”; 100-line cap
- UNVERIFIED: stable@ lore search (403); live e2fsprogs source not in
  tree

The patch is a 6-line, maintainer-reviewed mount check that enforces an
invariant the bitmap checksum code has assumed since 2012. It is in
scope for this 7.3-rc4 tree and meets stable criteria.

**YES**

 fs/ext4/super.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 9b45d27515f9f..cdb7e253015e5 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4431,8 +4431,9 @@ static int ext4_handle_clustersize(struct super_block *sb)
 		sbi->s_cluster_bits = 0;
 	}
 	sbi->s_clusters_per_group = le32_to_cpu(es->s_clusters_per_group);
-	if (sbi->s_clusters_per_group > sb->s_blocksize * 8) {
-		ext4_msg(sb, KERN_ERR, "#clusters per group too big: %lu",
+	if (sbi->s_clusters_per_group > sb->s_blocksize * 8 ||
+	    sbi->s_clusters_per_group & 7) {
+		ext4_msg(sb, KERN_ERR, "invalid #clusters per group: %lu",
 			 sbi->s_clusters_per_group);
 		return -EINVAL;
 	}
@@ -5230,8 +5231,9 @@ static int ext4_block_group_meta_init(struct super_block *sb, int silent)
 		return -EINVAL;
 	}
 	if (sbi->s_inodes_per_group < sbi->s_inodes_per_block ||
-	    sbi->s_inodes_per_group > sb->s_blocksize * 8) {
-		ext4_msg(sb, KERN_ERR, "invalid inodes per group: %lu\n",
+	    sbi->s_inodes_per_group > sb->s_blocksize * 8 ||
+	    sbi->s_inodes_per_group & 7) {
+		ext4_msg(sb, KERN_ERR, "invalid inodes per group: %lu",
 			 sbi->s_inodes_per_group);
 		return -EINVAL;
 	}
-- 
2.53.0

