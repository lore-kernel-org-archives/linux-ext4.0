From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] don't use ext4_allocation_contexts for tracing
Date: Fri, 20 Aug 2010 14:51:43 -0500
Message-ID: <4C6EDCCF.1000104@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63926 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369Ab0HTTvu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Aug 2010 15:51:50 -0400
Received: from int-mx08.intmail.prod.int.phx2.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o7KJpos2008246
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Fri, 20 Aug 2010 15:51:50 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o7KJphd8023601
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 20 Aug 2010 15:51:48 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Many tracepoints were populating an ext4_allocation_context
to pass in, but this requires a slab allocation even when
tracepoints are off.  In fact, 4 of 5 of these allocations
were only for tracing.  In addition, we were only using a
small fraction of the 144 bytes of this structure for this
purpose.

We can do away with all these alloc/frees of the ac and
simply pass in the bits we care about, instead.

I tested this by turning on tracing and running through
xfstests on x86_64.  I did not actually do anything with
the trace output, however.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Note: This will apply after my other patch,
"[PATCH] fix oops in ext4_mb_release_group_pa tracing"

I could roll them together if desired.

 fs/ext4/mballoc.c           |   81 ++++++--------------------------------------
 include/trace/events/ext4.h |   49 ++++++++++++++++----------
 2 files changed, 43 insertions(+), 87 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 4b4ad4b..f34caf6 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3535,8 +3535,7 @@ static int ext4_mb_new_preallocation(struct ext4_allocation_context *ac)
  */
 static noinline_for_stack int
 ext4_mb_release_inode_pa(struct ext4_buddy *e4b, struct buffer_head *bitmap_bh,
-			struct ext4_prealloc_space *pa,
-			struct ext4_allocation_context *ac)
+			struct ext4_prealloc_space *pa)
 {
 	struct super_block *sb = e4b->bd_sb;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
@@ -3554,11 +3553,6 @@ ext4_mb_release_inode_pa(struct ext4_buddy *e4b, struct buffer_head *bitmap_bh,
 	BUG_ON(group != e4b->bd_group && pa->pa_len != 0);
 	end = bit + pa->pa_len;
 
-	if (ac) {
-		ac->ac_sb = sb;
-		ac->ac_inode = pa->pa_inode;
-	}
-
 	while (bit < end) {
 		bit = mb_find_next_zero_bit(bitmap_bh->b_data, end, bit);
 		if (bit >= end)
@@ -3569,16 +3563,9 @@ ext4_mb_release_inode_pa(struct ext4_buddy *e4b, struct buffer_head *bitmap_bh,
 			 (unsigned) next - bit, (unsigned) group);
 		free += next - bit;
 
-		if (ac) {
-			ac->ac_b_ex.fe_group = group;
-			ac->ac_b_ex.fe_start = bit;
-			ac->ac_b_ex.fe_len = next - bit;
-			ac->ac_b_ex.fe_logical = 0;
-			trace_ext4_mballoc_discard(ac);
-		}
-
-		trace_ext4_mb_release_inode_pa(sb, ac, pa, grp_blk_start + bit,
-					       next - bit);
+		trace_ext4_mballoc_discard(sb, NULL, group, bit, next - bit, 0);
+		trace_ext4_mb_release_inode_pa(sb, pa->pa_inode, pa,
+					       grp_blk_start + bit, next - bit);
 		mb_free_blocks(pa->pa_inode, e4b, bit, next - bit);
 		bit = next + 1;
 	}
@@ -3601,29 +3588,19 @@ ext4_mb_release_inode_pa(struct ext4_buddy *e4b, struct buffer_head *bitmap_bh,
 
 static noinline_for_stack int
 ext4_mb_release_group_pa(struct ext4_buddy *e4b,
-				struct ext4_prealloc_space *pa,
-				struct ext4_allocation_context *ac)
+				struct ext4_prealloc_space *pa)
 {
 	struct super_block *sb = e4b->bd_sb;
 	ext4_group_t group;
 	ext4_grpblk_t bit;
 
-	trace_ext4_mb_release_group_pa(sb, ac, pa);
+	trace_ext4_mb_release_group_pa(sb, pa);
 	BUG_ON(pa->pa_deleted == 0);
 	ext4_get_group_no_and_offset(sb, pa->pa_pstart, &group, &bit);
 	BUG_ON(group != e4b->bd_group && pa->pa_len != 0);
 	mb_free_blocks(pa->pa_inode, e4b, bit, pa->pa_len);
 	atomic_add(pa->pa_len, &EXT4_SB(sb)->s_mb_discarded);
-
-	if (ac) {
-		ac->ac_sb = sb;
-		ac->ac_inode = NULL;
-		ac->ac_b_ex.fe_group = group;
-		ac->ac_b_ex.fe_start = bit;
-		ac->ac_b_ex.fe_len = pa->pa_len;
-		ac->ac_b_ex.fe_logical = 0;
-		trace_ext4_mballoc_discard(ac);
-	}
+	trace_ext4_mballoc_discard(sb, NULL, group, bit, pa->pa_len, 0);
 
 	return 0;
 }
@@ -3644,7 +3621,6 @@ ext4_mb_discard_group_preallocations(struct super_block *sb,
 	struct ext4_group_info *grp = ext4_get_group_info(sb, group);
 	struct buffer_head *bitmap_bh = NULL;
 	struct ext4_prealloc_space *pa, *tmp;
-	struct ext4_allocation_context *ac;
 	struct list_head list;
 	struct ext4_buddy e4b;
 	int err;
@@ -3673,9 +3649,6 @@ ext4_mb_discard_group_preallocations(struct super_block *sb,
 		needed = EXT4_BLOCKS_PER_GROUP(sb) + 1;
 
 	INIT_LIST_HEAD(&list);
-	ac = kmem_cache_alloc(ext4_ac_cachep, GFP_NOFS);
-	if (ac)
-		ac->ac_sb = sb;
 repeat:
 	ext4_lock_group(sb, group);
 	list_for_each_entry_safe(pa, tmp,
@@ -3730,9 +3703,9 @@ repeat:
 		spin_unlock(pa->pa_obj_lock);
 
 		if (pa->pa_type == MB_GROUP_PA)
-			ext4_mb_release_group_pa(&e4b, pa, ac);
+			ext4_mb_release_group_pa(&e4b, pa);
 		else
-			ext4_mb_release_inode_pa(&e4b, bitmap_bh, pa, ac);
+			ext4_mb_release_inode_pa(&e4b, bitmap_bh, pa);
 
 		list_del(&pa->u.pa_tmp_list);
 		call_rcu(&(pa)->u.pa_rcu, ext4_mb_pa_callback);
@@ -3740,8 +3713,6 @@ repeat:
 
 out:
 	ext4_unlock_group(sb, group);
-	if (ac)
-		kmem_cache_free(ext4_ac_cachep, ac);
 	ext4_mb_unload_buddy(&e4b);
 	put_bh(bitmap_bh);
 	return free;
@@ -3762,7 +3733,6 @@ void ext4_discard_preallocations(struct inode *inode)
 	struct super_block *sb = inode->i_sb;
 	struct buffer_head *bitmap_bh = NULL;
 	struct ext4_prealloc_space *pa, *tmp;
-	struct ext4_allocation_context *ac;
 	ext4_group_t group = 0;
 	struct list_head list;
 	struct ext4_buddy e4b;
@@ -3778,11 +3748,6 @@ void ext4_discard_preallocations(struct inode *inode)
 
 	INIT_LIST_HEAD(&list);
 
-	ac = kmem_cache_alloc(ext4_ac_cachep, GFP_NOFS);
-	if (ac) {
-		ac->ac_sb = sb;
-		ac->ac_inode = inode;
-	}
 repeat:
 	/* first, collect all pa's in the inode */
 	spin_lock(&ei->i_prealloc_lock);
@@ -3852,7 +3817,7 @@ repeat:
 
 		ext4_lock_group(sb, group);
 		list_del(&pa->pa_group_list);
-		ext4_mb_release_inode_pa(&e4b, bitmap_bh, pa, ac);
+		ext4_mb_release_inode_pa(&e4b, bitmap_bh, pa);
 		ext4_unlock_group(sb, group);
 
 		ext4_mb_unload_buddy(&e4b);
@@ -3861,8 +3826,6 @@ repeat:
 		list_del(&pa->u.pa_tmp_list);
 		call_rcu(&(pa)->u.pa_rcu, ext4_mb_pa_callback);
 	}
-	if (ac)
-		kmem_cache_free(ext4_ac_cachep, ac);
 }
 
 /*
@@ -4060,14 +4023,10 @@ ext4_mb_discard_lg_preallocations(struct super_block *sb,
 	struct ext4_buddy e4b;
 	struct list_head discard_list;
 	struct ext4_prealloc_space *pa, *tmp;
-	struct ext4_allocation_context *ac;
 
 	mb_debug(1, "discard locality group preallocation\n");
 
 	INIT_LIST_HEAD(&discard_list);
-	ac = kmem_cache_alloc(ext4_ac_cachep, GFP_NOFS);
-	if (ac)
-		ac->ac_sb = sb;
 
 	spin_lock(&lg->lg_prealloc_lock);
 	list_for_each_entry_rcu(pa, &lg->lg_prealloc_list[order],
@@ -4119,15 +4078,13 @@ ext4_mb_discard_lg_preallocations(struct super_block *sb,
 		}
 		ext4_lock_group(sb, group);
 		list_del(&pa->pa_group_list);
-		ext4_mb_release_group_pa(&e4b, pa, ac);
+		ext4_mb_release_group_pa(&e4b, pa);
 		ext4_unlock_group(sb, group);
 
 		ext4_mb_unload_buddy(&e4b);
 		list_del(&pa->u.pa_tmp_list);
 		call_rcu(&(pa)->u.pa_rcu, ext4_mb_pa_callback);
 	}
-	if (ac)
-		kmem_cache_free(ext4_ac_cachep, ac);
 }
 
 /*
@@ -4491,7 +4448,6 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 {
 	struct buffer_head *bitmap_bh = NULL;
 	struct super_block *sb = inode->i_sb;
-	struct ext4_allocation_context *ac = NULL;
 	struct ext4_group_desc *gdp;
 	unsigned long freed = 0;
 	unsigned int overflow;
@@ -4546,12 +4502,6 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 	if (!ext4_should_writeback_data(inode))
 		flags |= EXT4_FREE_BLOCKS_METADATA;
 
-	ac = kmem_cache_alloc(ext4_ac_cachep, GFP_NOFS);
-	if (ac) {
-		ac->ac_inode = inode;
-		ac->ac_sb = sb;
-	}
-
 do_more:
 	overflow = 0;
 	ext4_get_group_no_and_offset(sb, block, &block_group, &bit);
@@ -4609,12 +4559,7 @@ do_more:
 			BUG_ON(!mb_test_bit(bit + i, bitmap_bh->b_data));
 	}
 #endif
-	if (ac) {
-		ac->ac_b_ex.fe_group = block_group;
-		ac->ac_b_ex.fe_start = bit;
-		ac->ac_b_ex.fe_len = count;
-		trace_ext4_mballoc_free(ac);
-	}
+	trace_ext4_mballoc_free(sb, inode, block_group, bit, count, 0);
 
 	err = ext4_mb_load_buddy(sb, block_group, &e4b);
 	if (err)
@@ -4685,7 +4630,5 @@ error_return:
 		dquot_free_block(inode, freed);
 	brelse(bitmap_bh);
 	ext4_std_error(sb, err);
-	if (ac)
-		kmem_cache_free(ext4_ac_cachep, ac);
 	return;
 }
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index e352c77..d500fc4 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -396,11 +396,11 @@ DEFINE_EVENT(ext4__mb_new_pa, ext4_mb_new_group_pa,
 
 TRACE_EVENT(ext4_mb_release_inode_pa,
 	TP_PROTO(struct super_block *sb,
-		 struct ext4_allocation_context *ac,
+		 struct inode *inode,
 		 struct ext4_prealloc_space *pa,
 		 unsigned long long block, unsigned int count),
 
-	TP_ARGS(sb, ac, pa, block, count),
+	TP_ARGS(sb, inode, pa, block, count),
 
 	TP_STRUCT__entry(
 		__field(	dev_t,	dev			)
@@ -412,8 +412,7 @@ TRACE_EVENT(ext4_mb_release_inode_pa,
 
 	TP_fast_assign(
 		__entry->dev		= sb->s_dev;
-		__entry->ino		= (ac && ac->ac_inode) ? 
-						ac->ac_inode->i_ino : 0;
+		__entry->ino		= inode->i_ino;
 		__entry->block		= block;
 		__entry->count		= count;
 	),
@@ -425,10 +424,9 @@ TRACE_EVENT(ext4_mb_release_inode_pa,
 
 TRACE_EVENT(ext4_mb_release_group_pa,
 	TP_PROTO(struct super_block *sb,
-		 struct ext4_allocation_context *ac,
 		 struct ext4_prealloc_space *pa),
 
-	TP_ARGS(sb, ac, pa),
+	TP_ARGS(sb, pa),
 
 	TP_STRUCT__entry(
 		__field(	dev_t,	dev			)
@@ -779,9 +777,14 @@ TRACE_EVENT(ext4_mballoc_prealloc,
 );
 
 DECLARE_EVENT_CLASS(ext4__mballoc,
-	TP_PROTO(struct ext4_allocation_context *ac),
+	TP_PROTO(struct super_block *sb,
+		 struct inode *inode,
+		 ext4_group_t group,
+		 ext4_grpblk_t start,
+		 ext4_grpblk_t len,
+		 ext4_lblk_t logical),
 
-	TP_ARGS(ac),
+	TP_ARGS(sb, inode, group, start, len, logical),
 
 	TP_STRUCT__entry(
 		__field(	dev_t,	dev			)
@@ -793,12 +796,12 @@ DECLARE_EVENT_CLASS(ext4__mballoc,
 	),
 
 	TP_fast_assign(
-		__entry->dev		= ac->ac_inode->i_sb->s_dev;
-		__entry->ino		= ac->ac_inode->i_ino;
-		__entry->result_logical	= ac->ac_b_ex.fe_logical;
-		__entry->result_start	= ac->ac_b_ex.fe_start;
-		__entry->result_group	= ac->ac_b_ex.fe_group;
-		__entry->result_len	= ac->ac_b_ex.fe_len;
+		__entry->dev		= sb->s_dev;
+		__entry->ino		= inode ? inode->i_ino : 0;
+		__entry->result_logical	= logical;
+		__entry->result_start	= start;
+		__entry->result_group	= group;
+		__entry->result_len	= len;
 	),
 
 	TP_printk("dev %s inode %lu extent %u/%d/%u@%u ",
@@ -809,16 +812,26 @@ DECLARE_EVENT_CLASS(ext4__mballoc,
 
 DEFINE_EVENT(ext4__mballoc, ext4_mballoc_discard,
 
-	TP_PROTO(struct ext4_allocation_context *ac),
+	TP_PROTO(struct super_block *sb,
+		 struct inode *inode,
+		 ext4_group_t group,
+		 ext4_grpblk_t start,
+		 ext4_grpblk_t len,
+		 ext4_lblk_t logical),
 
-	TP_ARGS(ac)
+	TP_ARGS(sb, inode, group, start, len, logical)
 );
 
 DEFINE_EVENT(ext4__mballoc, ext4_mballoc_free,
 
-	TP_PROTO(struct ext4_allocation_context *ac),
+	TP_PROTO(struct super_block *sb,
+		 struct inode *inode,
+		 ext4_group_t group,
+		 ext4_grpblk_t start,
+		 ext4_grpblk_t len,
+		 ext4_lblk_t logical),
 
-	TP_ARGS(ac)
+	TP_ARGS(sb, inode, group, start, len, logical)
 );
 
 TRACE_EVENT(ext4_forget,

