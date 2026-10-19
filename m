Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7255B53FA22;
	Mon, 19 Oct 2026 14:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418812; cv=none; b=mC7AnyoctEFcdsh7NO2GYqhLuXjVzsZ2VQeaaGr92n4reHMFarA82/eSrMCO9Bmy4B56sGjXJdNxW7YCCzaQHcJE1bHQlzbIlAz2bmHfIXc40bUZBMIvyFDWPw1UEiTI2DZENGXcK8VlDYlz7zCfFX4uKWzA2fCnWkvOuw967Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418812; c=relaxed/simple;
	bh=9rG/+Iw+mKzxYFLTqkl6csqsPkCNFKmRx0FknDhw6QA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JKorlWdWGpLaUAljSanlTv1BI7RLBVE80rysBj8luulE+mqiFDK+amPHw56a+Iq5MESjGV36CnYxUop7p50Mv0gT5AOCfT+/GJYJlzlKclEli+LN9zHEBWtWmBm1QekGxesmcFLV1Q7ZCuLm1121RsRQzO/KWqXSkuHUCF6vqzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gvP5p6fJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gvP5p6fJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66D981F000C4;
	Mon, 19 Oct 2026 14:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418808;
	bh=RzQ3SkwKQZ9klrbhlD1x6zyQ5NhMYF1dZvBVDXNr5yQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gvP5p6fJhaEhhjEKpSg2YPvM/9lvSuF8tTaukzN34pI6EEZoZ2G/x26nKIkxkrGw/
	 CBZ5MOrefrFxXGQ3sSZscW8W2btzJM3Yz9bFv8z/bxo2/e8bnpMa5YMwPI3v5Ag5TE
	 zUXu6Fgccp4EVpCmHRfvIuBqxBMUVGyPhfSaqxLFVA5k416dB8KtQjjxLF7Agcw0Gh
	 A13q1DjaOx+RKqscOUdiT5o7ikyGfGZsU2TMaQY6Ul2t7EexnnRFVFGTHbNTaXf+tM
	 aD3LBtdhRnwp0VaF8RrTMl9asA0hKIDmP8nq7g8gelYctFBJg7S3upWTrPBrkFoNnV
	 Hh0YelvCgB0lg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Baokun Li <libaokun@linux.alibaba.com>,
	Sashiko <sashiko-bot@kernel.org>,
	Andreas Dilger <adilger@dilger.ca>,
	Theodore Ts'o <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ext4: reduce max cluster size to match documented 256MB limit
Date: Mon, 19 Oct 2026 09:53:22 -0400
Message-ID: <20261019135441.1420968-511-sashal@kernel.org>
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

[ Upstream commit afa3caf2fbc417f755f36e271c4b3c2d45ccda9d ]

The mke2fs man page documents:

  Valid cluster-size values are from 2048 to 256M bytes per cluster.

but EXT4_MAX_CLUSTER_LOG_SIZE was set to 30 (1GB), allowing crafted
filesystem images to specify cluster sizes up to 1GB.

On 32-bit systems with bigalloc enabled, the consistency check in
ext4_handle_clustersize():

  s_blocks_per_group == s_clusters_per_group * (clustersize / blocksize)

can overflow when the cluster ratio is large enough. Since
s_blocks_per_group is not range-checked in the bigalloc path, the
wrapped product can pass the consistency check, leading to inconsistent
group geometry and potential out-of-bounds block allocation.

Reduce EXT4_MAX_CLUSTER_LOG_SIZE to 28 to match the documented 256MB
limit. With this cap, the maximum product is:

  (blocksize * 8) * (256M / blocksize) = 2^31

which fits safely in a 32-bit unsigned long for all block sizes.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260608061112.392391-1-libaokun%40linux.alibaba.com
Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Link: https://patch.msgid.link/20260608111150.827117-3-libaokun@linux.alibaba.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Local tree is **v7.3-rc4** (kernel 7.3.0-rc4, detached HEAD). The change
is a one-line cap on ext4 bigalloc cluster size to stop a 32-bit
overflow on crafted images.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[ext4]** **[reduce]** reduce `EXT4_MAX_CLUSTER_LOG_SIZE` from
30 (1GB) to 28 (256MB) to match the documented mke2fs limit and stop a
32-bit overflow.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- **Reported-by:** Sashiko `<sashiko-bot@kernel.org>` (automated kernel
  review, not syzbot)
- **Closes:** https://sashiko.dev/#/patchset/20260608061112.392391-1-
  libaokun%40linux.alibaba.com (v1 series)
- **Reviewed-by:** Andreas Dilger `<adilger@dilger.ca>` (ext4 co-
  maintainer)
- **Link:** https://patch.msgid.link/20260608111150.827117-3-
  libaokun@linux.alibaba.com
- **Signed-off-by:** Baokun Li `<libaokun@linux.alibaba.com>` (author)
- **Signed-off-by:** Theodore Ts'o `<tytso@mit.edu>` (ext4 maintainer;
  applied the series)
- **Fixes:** none (expected for this review pipeline)
- **Cc: stable:** none (expected)
- Ignore pipeline markers: none present in the supplied message beyond
  the usual evaluation context

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** `EXT4_MAX_CLUSTER_LOG_SIZE` was 30, so crafted bigalloc
  images can claim cluster sizes up to 1GB. mke2fs only documents
  2048–256MB.
- **Symptom/failure mode:** On 32-bit, `s_clusters_per_group *
  (clustersize / blocksize)` in `ext4_handle_clustersize()` wraps.
  `s_blocks_per_group` is not range-checked on the bigalloc path, so the
  wrapped product can pass the consistency check. That yields
  inconsistent group geometry and possible out-of-bounds block
  allocation.
- **Version info:** none beyond “32-bit systems with bigalloc”.
- **Root cause (author):** cluster-size cap is too high; product can
  exceed 32-bit `unsigned long`.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: Not a disguised cleanup. The message names overflow, crafted
images, and OOB allocation. It is an explicit mount-time sanity fix.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**

Record:
- **File:** `fs/ext4/ext4.h` — 1 line changed (`30` → `28`)
- **Functions:** none; only `#define EXT4_MAX_CLUSTER_LOG_SIZE`
- **Scope:** single-file, one-constant surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record:
- **Before:** `__ext4_fill_super()` rejects `s_log_cluster_size` only if
  it is greater than `30 - 10 = 20`, so `clustersize = BLOCK_SIZE << log
  = 1024 << 20 = 1GB` is accepted.
- **After:** max log is `28 - 10 = 18`, so max cluster size is `1024 <<
  18 = 256MB`.
- **Path:** mount-time superblock validation in `__ext4_fill_super()`,
  before `ext4_handle_clustersize()`.

Verified use site:

```5196:5202:fs/ext4/super.c
        if (le32_to_cpu(es->s_log_cluster_size) >
            (EXT4_MAX_CLUSTER_LOG_SIZE - EXT4_MIN_BLOCK_LOG_SIZE)) {
                ext4_msg(sb, KERN_ERR,
                         "Invalid log cluster size: %u",
                         le32_to_cpu(es->s_log_cluster_size));
                goto out;
        }
```

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record:
- **Category:** integer overflow in mount-time geometry check, leading
  to inconsistent geometry / possible OOB block allocation (memory-
  safety / filesystem-image robustness).
- **Mechanism:** `s_blocks_per_group` and `s_clusters_per_group` are
  `unsigned long` (`fs/ext4/ext4.h`). The check is:

```4500:4506:fs/ext4/super.c
        if (sbi->s_blocks_per_group !=
            (sbi->s_clusters_per_group * (clustersize /
sb->s_blocksize))) {
                ext4_msg(sb, KERN_ERR,
                         "blocks per group (%lu) and clusters per group
(%lu) inconsistent",
                         sbi->s_blocks_per_group,
sbi->s_clusters_per_group);
                return -EINVAL;
        }
```

`s_clusters_per_group` is capped at `blocksize * 8`. Max product is
`(blocksize * 8) * (clustersize / blocksize) = 8 * clustersize`.
- With 1GB clusters: `8 * 2^30 = 2^33` → wraps on 32-bit `unsigned
  long`.
- With 256MB clusters: `8 * 2^28 = 2^31` → fits in 32-bit `unsigned
  long`.

The `s_blocks_per_group > sb->s_blocksize * 8` range check is only on
the **non-bigalloc** branch (verified in `ext4_handle_clustersize()`).

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- **Quality:** obviously correct. Tightens an existing mount-time bound
  to the documented mkfs limit; the overflow math is checkable by
  inspection.
- **Regression risk:** very low. mke2fs documents max 256MB; Andreas
  Dilger noted real-world >1GB clusters are implausible. A 512MB (log
  29) filesystem would also be rejected; Jan Kara said 28 or 29 were
  both acceptable. **29 is not overflow-safe:** `8 * 512MB = 2^32` wraps
  to 0 on 32-bit `unsigned long`. 28 is the right cap. Ted applied 28.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- Current line (already 28 in this checkout): `afa3caf2fbc41` Baokun Li,
  2026-06-08 — the candidate itself.
- Previous value 30 introduced by **`9e47a4c9fc580`** (“ext4: sanity
  check the block and cluster size at mount time”, Ted Ts'o,
  2016-11-18), first in **v4.10-rc1**. Duplicate in-tree copy:
  `8cdf3372fe836`.
- That original commit was **Cc: stable** and cited security refs
  (SecurityFocus 539661, RH BZ 1332506). The 1GB cap has been in place
  since then.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: No `Fixes:` tag. The overflow is in the interaction of the 2016
cap (`9e47a4c9fc580`, in this tree) and the bigalloc consistency
multiply (bigalloc from `281b59959707d`, **v3.2-rc1**). Both ancestors
of HEAD.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record:
- This is **v2 2/3** of “ext4: tighten mount-time superblock geometry
  validation”.
- Sibling **1/3:** `d42dc7726a003` — 8-alignment of clusters/inodes per
  group (bitmap csum).
- Sibling **3/3:** `a34de48f329b2` — inodes-per-group multiple of
  inodes-per-block.
- Cover letter (Ted applied 2026-07-23): patches 2 and 3 were added in
  v2 for additional Sashiko issues and are **independent of patch 1**.
- This commit is standalone: only the `#define` in `ext4.h`. No
  prerequisite from 1/3 or 3/3.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Baokun Li is a regular, high-volume ext4 contributor (many
recent ext4 commits in this tree). Series was reviewed by
Dilger/Kara/Zhang Yi and applied by Ted Ts'o.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: None required. `EXT4_MAX_CLUSTER_LOG_SIZE` and the
`s_log_cluster_size` check exist here. The define is the only consumer
besides `ext4.h` itself (`git grep` shows only `fs/ext4/ext4.h` and
`fs/ext4/super.c`). Applies standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- **b4 dig -c afa3caf2fbc41:** matched `[PATCH v2 2/3]` at https://patch
  .msgid.link/20260608111150.827117-3-libaokun@linux.alibaba.com
- **b4 dig -a:** series is **v2** “ext4: tighten mount-time superblock
  geometry validation” (2026-06-08). v1 was only patch 1; patches 2–3
  are new in v2.
- **Jan Kara** (2026-06-09): no NAK; defer 28 vs 29 to Ted; both fine if
  consistent.
- **Andreas Dilger** (2026-06-08): Reviewed-by; “pretty safe”; doubts
  anyone uses >1GiB clusters.
- **Ted Ts'o** (2026-07-23): “Applied, thanks!” with this SHA.
- No NAKs. No reviewer `Cc: stable` in the thread (absence expected).

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record (**b4 dig -w**): linux-ext4, tytso, adilger, jack@suse.cz,
yi.zhang@huawei.com, ojaswin@linux.ibm.com, ritesh.list@gmail.com,
Sashiko. Maintainers and regular reviewers were on the To/Cc list.
Dilger R-b; Ted applied.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: Sashiko is an LF/Google automated review bot, not a user crash
or syzbot repro. The Closes URL is the v1 patchset page (SPA; fetch
returned the Sashiko landing page, not the finding text). Cover letter:
patches 2 and 3 fix additional Sashiko-reported issues. Severity from
the patch itself: crafted-image overflow → inconsistent geometry / OOB
allocation.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Three independent mount-time checks. This one does not need 1/3
or 3/3 to be correct. Siblings are also real bugfixes but out of scope
for this verdict.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: lore.kernel.org/stable returned 403. Openwall/web search found
no stable-list rejection of this patch. UNVERIFIED whether anyone
already requested it on stable@.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**

Record: No function body changed. Consumer: `__ext4_fill_super()`
cluster-log check; downstream user of the accepted size:
`ext4_handle_clustersize()`.

**Step 5.2: TRACE CALLERS**

Record:
- `ext4_handle_clustersize()` is static; only caller is
  `__ext4_fill_super()` at mount (`fs/ext4/super.c:5451`).
- `ext4_fill_super()` is the VFS mount entry (`:5835`).
- Context: filesystem mount, not IRQ/hot path.

**Step 5.3: TRACE CALLEES**

Record: The define is only compared in the mount validator. No new
calls.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: Userspace mount of an ext4 image (`mount`, loop, USB, VM disk) →
`ext4_fill_super` → `__ext4_fill_super` → log-cluster check →
`ext4_handle_clustersize()`. Reachable from any ext4 mount of a bigalloc
image. Triggering the overflow needs a crafted superblock (untrusted
image), typically CAP_SYS_ADMIN to mount, still the usual malicious-
filesystem class.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: Same series adds two other geometry checks. Same class of
crafted-image bugs. No other `EXT4_MAX_CLUSTER_LOG_SIZE` sites.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record:
- Tree: **v7.3-rc4-27-gf0100363d8c37**, `VERSION=7 PATCHLEVEL=3
  SUBLEVEL=0 EXTRAVERSION=-rc4`.
- `git merge-base --is-ancestor afa3caf2fbc41 HEAD` → commit **is** in
  HEAD (landed via ext4-for-linus 7.3-rc1). Current `#define` is already
  28.
- That does **not** mean “already selected for stable”; it is the
  mainline landing. The **bug mechanism** (32-bit multiply of
  `s_clusters_per_group` by cluster ratio, uncapped `s_blocks_per_group`
  on bigalloc) is still in `ext4_handle_clustersize()` here; only the
  cap is 28.
- Bug class has existed since the 2016 cap (`9e47a4c9fc580` is an
  ancestor). Code is not missing.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: Expected apply: **clean**. One-line `#define` change in
`fs/ext4/ext4.h`. Macro and check have been stable since 2016 / the 2022
`ext4_handle_clustersize()` factor-out (`4a8557b094671`).

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: This is the fix. No earlier alternate cap. No follow-up revert
or tightening of this define after `afa3caf2fbc41` in `fs/ext4/ext4.h`.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: **ext4** (`fs/ext4/`). **IMPORTANT** — default Linux filesystem;
crafted-image bugs affect anyone who mounts untrusted ext4 (install
media, USB, VMs, backups).

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: Actively developed (ext4_for_linus pulls this cycle). The
overflow is in long-standing mount validation, not new BS>PS work.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: **Filesystem-specific (ext4)**, extra conditions: **bigalloc +
32-bit `unsigned long` + cluster size > 256MB**. 64-bit does not wrap at
1GB, but the looser cap still allows undocumented cluster sizes. 32-bit
still matters (embedded, some Android/i686).

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record: Mount of a crafted bigalloc image with large
`s_log_cluster_size`. Not every boot. Not an unprivileged syscall by
itself (mount is privileged), but standard untrusted-image attack. Not a
timing race.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record: Integer overflow bypass of geometry check → inconsistent groups
→ **potential out-of-bounds block allocation**. Severity **HIGH**
(memory corruption / OOB on crafted mount). Not a guaranteed panic on
every mount, but it is a real robustness/security class that stable
routinely takes.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- **Benefit:** high for 32-bit ext4 mounts of untrusted images; aligns
  kernel with documented mkfs limit.
- **Risk:** very low (one constant; Dilger R-b; Ted applied). Only
  theoretical regression is rejecting 512MB/1GB cluster filesystems that
  mke2fs would not create.
- **Ratio:** strongly favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real 32-bit overflow in mount-time geometry check; wrapped product can
  pass; OOB allocation is the stated consequence.
- One-line, obviously correct cap matching mke2fs (256MB).
- 28 is the max value that keeps `8 * clustersize` ≤ 2^31 on 32-bit.
- Reviewed by Andreas Dilger; applied by Ted Ts'o; Jan Kara did not
  object.
- Independent of the rest of the series.
- Affected code present since v4.10; applies cleanly.
- Same class as the original 2016 cluster-size sanity check (that one
  was Cc: stable).

AGAINST:
- Trigger needs crafted bigalloc + typically 32-bit.
- No `Fixes:` / `Cc: stable` (not a negative per rules).
- Sashiko is a bot, not a production crash with a reproducer.
- Jan Kara floated 29; that value still overflows (verified); committed
  value is 28.

UNRESOLVED:
- Stable@ discussion (lore/stable 403).
- Full Sashiko finding text (SPA page).

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — one-constant change;
   maintainer-applied; Dilger R-b.
2. Fixes a real bug that affects users? **PASS** — overflow on crafted
   bigalloc mount.
3. Important issue (crash, security, corruption, deadlock)? **PASS** —
   HIGH: overflow → bad geometry / possible OOB allocation.
4. Small and contained? **PASS** — 1 line, 1 file.
5. No new features or APIs? **PASS** — tightens an existing limit.
6. Can apply to the local tree? **PASS** — define and check exist; patch
   is a single substitution.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: Not an ID/quirk/DT/build/docs exception. It is a normal small
correctness/security-style mount check.

**Step 9.4: MAKE YOUR DECISION**

This tree has the ext4 mount path, the overflow-prone multiply, and the
too-large historical cap. The fix is a one-line tightening to the
documented 256MB limit so the 32-bit product cannot wrap. Independent,
reviewed, and low regression risk. It should be backported here.

------------------------------------------------
What the commit solves and why it matters
------------------------------------------------
Crafted ext4 bigalloc images can set cluster size up to 1GB. On 32-bit,
the groups-per-cluster consistency multiply wraps, so a bogus
`s_blocks_per_group` can look consistent. That can produce wrong group
geometry and out-of-bounds block allocation when the image is mounted.
Capping at 256MB matches mke2fs and keeps the product at 2^31.

------------------------------------------------
Stable rules / risk vs benefit
------------------------------------------------
Meets all six criteria: real overflow, small, no API, applies cleanly.
Benefit is blocking a crafted-image OOB path; risk is rejecting
undocumented huge clusters that tools do not create.

------------------------------------------------
Concerns
------------------------------------------------
No extra series deps. No backport rework expected. 32-bit-centric, but
still a valid stable-class filesystem-image bug.

Verification:
- [Phase 1] Parsed tags: Reported-by Sashiko; Reviewed-by Andreas
  Dilger; SOB Baokun Li + Ted Ts'o; Link msgid 20260608111150.827117-3;
  no Fixes/Cc:stable
- [Phase 1] Cover letter (openwall/spinics): v2 2/3 independent of 1/3;
  overflow on 32-bit bigalloc
- [Phase 2] Diff: 1 line in fs/ext4/ext4.h, 30→28
- [Phase 2] Read ext4_handle_clustersize(): s_blocks_per_group range
  check only on non-bigalloc; multiply at lines 4500–4501
- [Phase 2] Types: s_blocks_per_group / s_clusters_per_group are
  unsigned long (ext4.h:1595–1596)
- [Phase 2] Math: max product 8*clustersize; 1GB → 2^33 wrap; 256MB →
  2^31; 512MB → 2^32 wrap (29 unsafe)
- [Phase 2] Consumer: __ext4_fill_super log-cluster check at
  super.c:5196–5202
- [Phase 3] git blame: current 28 from afa3caf2fbc41; 30 from
  9e47a4c9fc580 (2016-11-18, v4.10-rc1, Cc:stable)
- [Phase 3] git merge-base --is-ancestor 9e47a4c9fc580 HEAD: yes
- [Phase 3] git merge-base --is-ancestor afa3caf2fbc41 HEAD: yes
  (mainline landing, not used as circular “already selected”)
- [Phase 3] Series siblings d42dc7726a003 and a34de48f329b2 are
  independent; this patch only touches the define
- [Phase 3] git grep EXT4_MAX_CLUSTER_LOG_SIZE: only ext4.h and super.c
- [Phase 4] b4 dig -c: lore msgid 20260608111150.827117-3
- [Phase 4] b4 dig -a: v2 series 2026-06-08; v1 was patch 1 only
- [Phase 4] b4 dig -w: tytso, dilger, jack, linux-ext4 on original To/Cc
- [Phase 4] Jan Kara: 28 vs 29 up to Ted, no NAK
- [Phase 4] Andreas Dilger: Reviewed-by; safe, nobody using >1GiB
  clusters
- [Phase 4] Ted: Applied 2026-07-23 as afa3caf2fbc41
- [Phase 4] lore.kernel.org/stable: 403, UNVERIFIED
- [Phase 4] sashiko.dev hash URL: landing page only, UNVERIFIED full
  finding text
- [Phase 5] Only caller of ext4_handle_clustersize: __ext4_fill_super
  (mount)
- [Phase 6] git describe HEAD: v7.3-rc4-27-gf0100363d8c37; make
  kernelversion 7.3.0-rc4
- [Phase 6] Buggy cap/check present in this lineage since v4.10; apply
  is a one-line define swap
- [Phase 8] Failure mode: 32-bit overflow → inconsistent geometry /
  possible OOB alloc, severity HIGH
- UNVERIFIED: stable@ thread; full Sashiko report body

**YES**

 fs/ext4/ext4.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index da6428312c36b..a9178d63a7d1b 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -334,7 +334,7 @@ struct ext4_io_submit {
 #define	EXT4_MAX_BLOCK_SIZE		65536
 #define EXT4_MIN_BLOCK_LOG_SIZE		10
 #define EXT4_MAX_BLOCK_LOG_SIZE		16
-#define EXT4_MAX_CLUSTER_LOG_SIZE	30
+#define EXT4_MAX_CLUSTER_LOG_SIZE	28
 #ifdef __KERNEL__
 # define EXT4_BLOCK_SIZE(s)		((s)->s_blocksize)
 #else
-- 
2.53.0

