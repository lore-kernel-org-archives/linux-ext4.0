From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH, RFC V2] ext4: limit block allocations for indirect-block
 files to < 2^32
Date: Fri, 04 Sep 2009 22:21:51 -0500
Message-ID: <4AA1D94F.8060703@redhat.com>
References: <4AA1920C.9040406@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([209.173.210.139]:14039 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934608AbZIEDVu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 4 Sep 2009 23:21:50 -0400
Received: from Liberator.local (unknown [10.0.0.176])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id D24CBA9C9A1
	for <linux-ext4@vger.kernel.org>; Fri,  4 Sep 2009 22:21:51 -0500 (CDT)
In-Reply-To: <4AA1920C.9040406@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Today, the ext4 allocator will happily allocate blocks past
232 for indirect-block files, which results in the block
numbers getting truncated, and corruption ensues.

This patch limits such allocations to < 232, and adds
WARN_ONs (maybe should be BUG_ONs) if we do get blocks
larger than that.

This should address RH Bug 519471, ext4 bitmap allocator 
must limit blocks to < 232

* ext4_find_goal() is modified to choose a goal < UINT_MAX,
  so that our starting point is in an acceptable range.

* ext4_xattr_block_set() is modified such that the goal block
  is < UINT_MAX, as above.

* ext4_mb_regular_allocator() is modified so that the group
  search does not continue into groups which are too high

* ext4_mb_use_preallocated() has a check that we don't use
  preallocated space which is too far out

* ext4_alloc_blocks() and ext4_xattr_block_set() add some WARN_ONs

No attempt has been made to limit inode locations to < 232,
so we may wind up with blocks far from their inodes.  Doing
this much already will lead to some odd ENOSPC issues when the
"lower 32" gets full, and further restricting inodes could
make that even weirder.

For high inodes, choosing a goal of the original, % UINT_MAX,
may be a bit odd, but then we're in an odd situation anyway,
and I don't know of a better heuristic.

Perhaps an ext4-specific #define would be better than UINT_MAX?

The allocator being what it is, I may have missed some spots,
so I'd welcome review.

Thanks,
-Eric

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: got modulo-happy in ext4_mb_regular_allocator, just limit
ngroups to no more than UINT_MAX.

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f9c642b..cda3f8d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -551,15 +551,21 @@ static ext4_fsblk_t ext4_find_near(struct inode *inode, Indirect *ind)
  *
  *	Normally this function find the preferred place for block allocation,
  *	returns it.
+ *	Because this is only used for non-extent files, we limit the block nr
+ *	to 32 bits.
  */
 static ext4_fsblk_t ext4_find_goal(struct inode *inode, ext4_lblk_t block,
 				   Indirect *partial)
 {
+	ext4_fsblk_t goal;
+
 	/*
 	 * XXX need to get goal block from mballoc's data structures
 	 */
 
-	return ext4_find_near(inode, partial);
+	goal = ext4_find_near(inode, partial);
+	goal = goal % UINT_MAX;
+	return goal;
 }
 
 /**
@@ -640,6 +646,8 @@ static int ext4_alloc_blocks(handle_t *handle, struct inode *inode,
 		if (*err)
 			goto failed_out;
 
+		WARN_ON(current_block + count > UINT_MAX);
+
 		target -= count;
 		/* allocate blocks for indirect blocks */
 		while (index < indirect_blks && count) {
@@ -674,6 +682,7 @@ static int ext4_alloc_blocks(handle_t *handle, struct inode *inode,
 		ar.flags = EXT4_MB_HINT_DATA;
 
 	current_block = ext4_mb_new_blocks(handle, &ar, err);
+	WARN_ON(current_block + ar.len > UINT_MAX);
 
 	if (*err && (target == blks)) {
 		/*
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index cd25846..10384c3 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1943,6 +1943,11 @@ ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 	sb = ac->ac_sb;
 	sbi = EXT4_SB(sb);
 	ngroups = ext4_get_groups_count(sb);
+	/* non-extent files are limited to low blocks/groups */
+	if (!(EXT4_I(ac->ac_inode)->i_flags & EXT4_EXTENTS_FL))
+		ngroups = min_t(unsigned long, ngroups,
+				(UINT_MAX / EXT4_BLOCKS_PER_GROUP(sb)));
+
 	BUG_ON(ac->ac_status == AC_STATUS_FOUND);
 
 	/* first, try the goal */
@@ -3382,6 +3387,10 @@ ext4_mb_use_preallocated(struct ext4_allocation_context *ac)
 			ac->ac_o_ex.fe_logical >= pa->pa_lstart + pa->pa_len)
 			continue;
 
+		if (!(EXT4_I(ac->ac_inode)->i_flags & EXT4_EXTENTS_FL) &&
+			pa->pa_pstart + pa->pa_len > UINT_MAX)
+			continue;
+
 		/* found preallocated blocks, use them */
 		spin_lock(&pa->pa_lock);
 		if (pa->pa_deleted == 0 && pa->pa_free) {
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 62b31c2..9ed0f12 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -810,12 +810,22 @@ inserted:
 			get_bh(new_bh);
 		} else {
 			/* We need to allocate a new block */
-			ext4_fsblk_t goal = ext4_group_first_block_no(sb,
+			ext4_fsblk_t goal, block;
+
+			goal = ext4_group_first_block_no(sb,
 						EXT4_I(inode)->i_block_group);
-			ext4_fsblk_t block = ext4_new_meta_blocks(handle, inode,
+
+			if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
+				goal = goal % UINT_MAX;
+
+			block = ext4_new_meta_blocks(handle, inode,
 						  goal, NULL, &error);
 			if (error)
 				goto cleanup;
+
+			if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
+				WARN_ON(block > UINT_MAX);
+
 			ea_idebug(inode, "creating block %d", block);
 
 			new_bh = sb_getblk(sb, block);

