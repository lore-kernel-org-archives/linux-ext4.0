Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513873A759A
	for <linux-ext4@vger.kernel.org>; Tue, 10 Mar 2026 12:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773145695; cv=none; b=kMWzxZFKh65Rbi6V1sg/enFOJp/yInLBbw6tegaHvVHNiNNAgH0M/4GZHVG8kbQTjqX+f05sE0uOtC1xgBTRAUfoXV7Rv3jC4YuQWAY4QTshBadyRjdYOMnDpiK7Xnnyx2Jmr1CdNn2Dgm1Is4bTaUxGuUbR92oxfaX3vRc3FwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773145695; c=relaxed/simple;
	bh=z+s7iNZOmv7Y60pQcgjzg6oVwR9dEAJDGfv+PpLuWM0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dTBNJ4RTYZafsSCcy+heg8od3ZLFvmylPQsPdpCGB0remj/Q5aqFtYBTyPfTdExH7eQyyyvvmgKxRoeiyd0f+qPQw3KnxUNnKjUKkv1GXOgJLSJ903ucTnzszCqU4btflrtpopXRiX3NfRwJGcDfAUdRCv+jj4Ise9FAw4pVbwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=RLPrKHAQ; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="RLPrKHAQ"
Received: from trampoline.thunk.org (pool-173-48-117-133.bstnma.fios.verizon.net [173.48.117.133])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62ACS8WG022651
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Mar 2026 08:28:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1773145689; bh=0tuRckjV7VXF4FxDrS0YxUqr6sqNgghmyE2YFnA7WzM=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=RLPrKHAQ7ewIB0MWDJsbWsBBqUC17lQza2yj5cnhzFbbSTxWnN+yYSu2oBR868Pub
	 IlYg1uz52six2nrceh/JqEnzuHd3eRNrfPTs2xtgG+wFCaqQl8Fvb1yqjp+qrXeE9n
	 zQzlJYJVy6iZsLwxRa9ZF8ZS8wc37DuHs75FEgqBAlJu0UEpQqfHgP0fDhcLKFtxSQ
	 +qL4LYr18D98sogoTnlO9/PB+GITi33VVdZVEvtTwtCUPCzRvqyz35eaEKH9/7YUni
	 9zd2CXqDthWKWzzXjjiQa+N3d0MEr0qg+QFFXVbwLgr7m8tTjNtRYWaFCKsYY7t1Oq
	 TIhH/BYdvMFPw==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 3A5062E00D6; Tue, 10 Mar 2026 08:28:08 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>
Subject: [RFC PATCH] ext4: handle wraparound when searching for blocks for indirect mapped blocks
Date: Tue, 10 Mar 2026 08:28:06 -0400
Message-ID: <20260310122806.1277631-1-tytso@mit.edu>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 4865c768b563 ("ext4: always allocate blocks only from groups
inode can use") restricts what blocks will be allocated for indirect
block based files to block numbers that fit within 32-bit block
numbers.

However, when using a review bot running on the latest Gemini LLM to
check this commit when backporting into an LTS based kernel, it raised
the following concerns:

   If ac->ac_g_ex.fe_group is >= ngroups (for instance, if the goal
   group was populated via stream allocation from s_mb_last_groups),
   then start will be >= ngroups.

   Does this allow allocating blocks beyond the 32-bit limit for
   indirect block mapped files? The commit message mentions that
   ext4_mb_scan_groups_linear() takes care to not select unsupported
   groups. However, its loop uses group = *start, and the very first
   iteration will call ext4_mb_scan_group() with this unsupported
   group because next_linear_group() is only called at the end of the
   iteration.

   Also, in the optimized scanning paths like
   ext4_mb_scan_groups_p2_aligned(), start is passed into
   ext4_mb_scan_groups_xa_range(). If start >= ngroups, will this
   trigger the WARN_ON_ONCE(end > ngroups || start >= end) because end
   is set to ngroups? Furthermore, after wrapping around, end will be
   set to the original start which is > ngroups, triggering the
   warning a second time. Should this code clamp start to < ngroups
   before scanning?

After reviewing the code paths involved and considering the LLM
review, I believe that while it is unlikely, it is possible that how
commit 4865c768b563 added ext4_get_allocation_groups_count() doesn't
completely address all of the possible situtions that might show up
when using indirect-mapped files and allocating blocks on a file
system with more than 2**32 blocks.

So this commit adds some safety checks and wrap around logic to some
functions if the multiblock allocator: ext4_mb_scan_groups_xa_range(),
ext4_mb_scan_groups_best_avail(), ext4_mb_scan_groups_p2_aligned(),
and ext4_mb_scan_groups().

Fixes: 4865c768b563 ("ext4: always allocate blocks only from groups inode can use")
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>
---
 fs/ext4/mballoc.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 20e9fdaf4301..454d5a1b4803 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -915,13 +915,17 @@ static int ext4_mb_scan_groups_xa_range(struct ext4_allocation_context *ac,
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	enum criteria cr = ac->ac_criteria;
 	ext4_group_t ngroups = ext4_get_allocation_groups_count(ac);
-	unsigned long group = start;
+	unsigned long group, end_range;
 	struct ext4_group_info *grp;
 
-	if (WARN_ON_ONCE(end > ngroups || start >= end))
-		return 0;
-
-	xa_for_each_range(xa, group, grp, start, end - 1) {
+	if (start >= ngroups)
+		start = 0;
+	group = start;
+wrap_around:
+	end_range = end;
+	if (end_range > ngroups)
+		end_range = ngroups;
+	xa_for_each_range(xa, group, grp, start, end_range - 1) {
 		int err;
 
 		if (sbi->s_mb_stats)
@@ -933,7 +937,11 @@ static int ext4_mb_scan_groups_xa_range(struct ext4_allocation_context *ac,
 
 		cond_resched();
 	}
-
+	if (start) {
+		end = start;
+		start = 0;
+		goto wrap_around;
+	}
 	return 0;
 }
 
@@ -967,6 +975,8 @@ static int ext4_mb_scan_groups_p2_aligned(struct ext4_allocation_context *ac,
 
 	start = group;
 	end = ext4_get_allocation_groups_count(ac);
+	if (start >= end)
+		return 0;
 wrap_around:
 	for (i = ac->ac_2order; i < MB_NUM_ORDERS(ac->ac_sb); i++) {
 		ret = ext4_mb_scan_groups_largest_free_order_range(ac, i,
@@ -1099,6 +1109,8 @@ static int ext4_mb_scan_groups_best_avail(struct ext4_allocation_context *ac,
 
 	start = group;
 	end = ext4_get_allocation_groups_count(ac);
+	if (start >= end)
+		start = 0;
 wrap_around:
 	for (i = order; i >= min_order; i--) {
 		int frag_order;
@@ -1199,6 +1211,8 @@ static int ext4_mb_scan_groups(struct ext4_allocation_context *ac)
 
 	/* searching for the right group start from the goal value specified */
 	start = ac->ac_g_ex.fe_group;
+	if (start >= ngroups)
+		start = 0;
 	ac->ac_prefetch_grp = start;
 	ac->ac_prefetch_nr = 0;
 
-- 
2.51.0

