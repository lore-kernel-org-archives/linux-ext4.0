From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 1/1] ext4: Fix ext4_mb_normalize_request
Date: Fri, 13 Jun 2014 15:55:36 +0200
Message-ID: <1402667736-7843-2-git-send-email-lczerner@redhat.com>
References: <1402667736-7843-1-git-send-email-lczerner@redhat.com>
Cc: Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9679 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321AbaFMNzt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Jun 2014 09:55:49 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s5DDtnoA013654
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Fri, 13 Jun 2014 09:55:49 -0400
In-Reply-To: <1402667736-7843-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently there are couple of problems with ext4_mb_normalize_request().

- We're trying to normalize unwritten extents allocation which is
  entirely unnecessary, because user exactly knows what how much space
  he is going to need - no need for file system to do preallocations.

- ext4_mb_normalize_request() unnecessarily divides bigger allocation
  requests to small ones (8MB). I believe that this is a bug rather than
  design.

- For smaller allocations (or smaller files) we do not even respect the
  fe_logical. Although we do respect it for bigger files.

- Overall the logic within ext4_mb_normalize_request() is weird and
  no-one really understand why it is the way it is.

Fix all of this by:

- Disabling preallocation for unwritten extent allocation. However
  because the maximum size of the unwritten extent is one block smaller
  than written, in order to avoid unnecessary fragmentation we limit the
  request to EXT_INIT_MAX_LEN / 2

- Get rid of the "if table" in ext4_mb_normalize_request() and replace
  it with simply aligning the assumed end of the file up to power of
  two. But we still limit the allocation size to EXT4_BLOCKS_PER_GROUP.
  Also do this on file system block units to take into account different
  block sized file systems.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/extents.c | 29 +++++++++++++++------
 fs/ext4/mballoc.c | 78 +++++++++++++++----------------------------------------
 2 files changed, 42 insertions(+), 65 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 4da228a..0af9aaf 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4412,12 +4412,28 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	 * EXT_INIT_MAX_LEN and for an unwritten extent this limit is
 	 * EXT_UNWRITTEN_MAX_LEN.
 	 */
+	ar.flags = 0;
 	if (map->m_len > EXT_INIT_MAX_LEN &&
-	    !(flags & EXT4_GET_BLOCKS_UNWRIT_EXT))
+	    !(flags & EXT4_GET_BLOCKS_UNWRIT_EXT)) {
 		map->m_len = EXT_INIT_MAX_LEN;
-	else if (map->m_len > EXT_UNWRITTEN_MAX_LEN &&
-		 (flags & EXT4_GET_BLOCKS_UNWRIT_EXT))
-		map->m_len = EXT_UNWRITTEN_MAX_LEN;
+		/*
+		 * We're going to allocate as much as we can
+		 * so there is no reason to do preallocation
+		 */
+		ar.flags |= EXT4_MB_HINT_NOPREALLOC;
+	} else if (map->m_len >= EXT_UNWRITTEN_MAX_LEN &&
+		 (flags & EXT4_GET_BLOCKS_UNWRIT_EXT)) {
+		/*
+		 * We want to avoid unnecessary fragmentation. Setting this
+		 * to EXT_UNWRITTEN_MAX_LEN would leave 1 block in the block
+		 * group.
+		 */
+		map->m_len = EXT_INIT_MAX_LEN / 2;
+	}
+
+	/* Disable preallocation for unwritten extents. */
+	if (flags & EXT4_GET_BLOCKS_UNWRIT_EXT)
+		ar.flags |= EXT4_MB_HINT_NOPREALLOC;
 
 	/* Check if we can really insert (m_lblk)::(m_lblk + m_len) extent */
 	newex.ee_len = cpu_to_le16(map->m_len);
@@ -4444,10 +4460,7 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	ar.goal -= offset;
 	ar.logical -= offset;
 	if (S_ISREG(inode->i_mode))
-		ar.flags = EXT4_MB_HINT_DATA;
-	else
-		/* disable in-core preallocation for non-regular files */
-		ar.flags = 0;
+		ar.flags |= EXT4_MB_HINT_DATA;
 	if (flags & EXT4_GET_BLOCKS_NO_NORMALIZE)
 		ar.flags |= EXT4_MB_HINT_NOPREALLOC;
 	newblock = ext4_mb_new_blocks(handle, &ar, &err);
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 59e3162..cc55150 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2993,10 +2993,9 @@ ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 				struct ext4_allocation_request *ar)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_sb);
-	int bsbits, max;
-	ext4_lblk_t end;
-	loff_t size, start_off;
-	loff_t orig_size __maybe_unused;
+	int bsbits;
+	loff_t end;
+	loff_t size;
 	ext4_lblk_t start;
 	struct ext4_inode_info *ei = EXT4_I(ac->ac_inode);
 	struct ext4_prealloc_space *pa;
@@ -3022,64 +3021,29 @@ ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 
 	bsbits = ac->ac_sb->s_blocksize_bits;
 
-	/* first, let's learn actual file size
-	 * given current request is allocated */
-	size = ac->ac_o_ex.fe_logical + EXT4_C2B(sbi, ac->ac_o_ex.fe_len);
-	size = size << bsbits;
-	if (size < i_size_read(ac->ac_inode))
-		size = i_size_read(ac->ac_inode);
-	orig_size = size;
-
-	/* max size of free chunks */
-	max = 2 << bsbits;
-
-#define NRL_CHECK_SIZE(req, size, max, chunk_size)	\
-		(req <= (size) || max <= (chunk_size))
-
-	/* first, try to predict filesize */
-	/* XXX: should this table be tunable? */
-	start_off = 0;
-	if (size <= 16 * 1024) {
-		size = 16 * 1024;
-	} else if (size <= 32 * 1024) {
-		size = 32 * 1024;
-	} else if (size <= 64 * 1024) {
-		size = 64 * 1024;
-	} else if (size <= 128 * 1024) {
-		size = 128 * 1024;
-	} else if (size <= 256 * 1024) {
-		size = 256 * 1024;
-	} else if (size <= 512 * 1024) {
-		size = 512 * 1024;
-	} else if (size <= 1024 * 1024) {
-		size = 1024 * 1024;
-	} else if (NRL_CHECK_SIZE(size, 4 * 1024 * 1024, max, 2 * 1024)) {
-		start_off = ((loff_t)ac->ac_o_ex.fe_logical >>
-						(21 - bsbits)) << 21;
-		size = 2 * 1024 * 1024;
-	} else if (NRL_CHECK_SIZE(size, 8 * 1024 * 1024, max, 4 * 1024)) {
-		start_off = ((loff_t)ac->ac_o_ex.fe_logical >>
-							(22 - bsbits)) << 22;
-		size = 4 * 1024 * 1024;
-	} else if (NRL_CHECK_SIZE(ac->ac_o_ex.fe_len,
-					(8<<20)>>bsbits, max, 8 * 1024)) {
-		start_off = ((loff_t)ac->ac_o_ex.fe_logical >>
-							(23 - bsbits)) << 23;
-		size = 8 * 1024 * 1024;
-	} else {
-		start_off = (loff_t)ac->ac_o_ex.fe_logical << bsbits;
-		size	  = ac->ac_o_ex.fe_len << bsbits;
-	}
-	size = size >> bsbits;
-	start = start_off >> bsbits;
+	end = ac->ac_o_ex.fe_logical + EXT4_C2B(sbi, ac->ac_o_ex.fe_len);
+	if ((end << bsbits) < i_size_read(ac->ac_inode))
+		end = i_size_read(ac->ac_inode) >> bsbits;
+
+	/* Guess the file size -- round up to nearest power of two */
+	end = roundup_pow_of_two(end + 1);
+	start = ac->ac_o_ex.fe_logical;
+
+	/* Get the actual allocation size */
+	size = end - start;
+
+	/* We can not allocate more blocks than can be found in the group */
+	if (size > EXT4_BLOCKS_PER_GROUP(ac->ac_sb))
+		size = EXT4_BLOCKS_PER_GROUP(ac->ac_sb);
 
 	/* don't cover already allocated blocks in selected range */
 	if (ar->pleft && start <= ar->lleft) {
 		size -= ar->lleft + 1 - start;
 		start = ar->lleft + 1;
 	}
-	if (ar->pright && start + size - 1 >= ar->lright)
-		size -= start + size - ar->lright;
+	end = start + size;
+	if (ar->pright && end - 1 >= ar->lright)
+		size -= (end - ar->lright);
 
 	end = start + size;
 
@@ -3173,7 +3137,7 @@ ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 	}
 
 	mb_debug(1, "goal: %u(was %u) blocks at %u\n", (unsigned) size,
-		(unsigned) orig_size, (unsigned) start);
+		(unsigned) ac->ac_o_ex.fe_logical, (unsigned) start);
 }
 
 static void ext4_mb_collect_stats(struct ext4_allocation_context *ac)
-- 
1.8.3.1

