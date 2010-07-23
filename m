From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [BUG] ext4 trace events cause NULL pointer dereferences
Date: Thu, 22 Jul 2010 21:13:15 -0400
Message-ID: <20100723011315.GC16373@thunk.org>
References: <4C401CE3.7010004@cn.fujitsu.com>
 <20100721222508.8704.A69D9226@jp.fujitsu.com>
 <20100722054957.GA11670@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Li Zefan <lizf@cn.fujitsu.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:40040 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757291Ab0GWBNZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Jul 2010 21:13:25 -0400
Content-Disposition: inline
In-Reply-To: <20100722054957.GA11670@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 22, 2010 at 01:49:57AM -0400, Christoph Hellwig wrote:
> 
> I think ext4 is simply using an incorrectly typed tracepoint here.
> If you want it to be useful in any way it needs a sb paramter and
> an optional inode paramter, not the allocation context.

I agree; this is the patch that I had whipped up to fix the problem.
(See below)

> Also the whole ext4_mb_release_group_pa function seems to be a bit
> misdesigned.  The code using ac is a totally separate block at the
> end of the function and does work that's unrelated to the rest
> of the function.  Just making it a separate helper can calling it
> only from those places that have the allocation context would make
> the code more clear.

I need to look more closely at this.  If I had time there would be a
lot of things that I'd be refactoring and cleaning up in mballoc.c....

       	      	       	  	      	  	   - Ted


>From 52f9a0d80ccdb1b23e364221167bb55b2886cc18 Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Thu, 22 Jul 2010 21:09:44 -0400
Subject: [PATCH] ext4: fix potential NULL dereference while tracing

The allocation_context pointer can be NULL.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/mballoc.c           |    4 ++--
 include/trace/events/ext4.h |   20 ++++++++++++--------
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 3dfad95..8b3b934 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3575,7 +3575,7 @@ ext4_mb_release_inode_pa(struct ext4_buddy *e4b, struct buffer_head *bitmap_bh,
 			trace_ext4_mballoc_discard(ac);
 		}
 
-		trace_ext4_mb_release_inode_pa(ac, pa, grp_blk_start + bit,
+		trace_ext4_mb_release_inode_pa(sb, ac, pa, grp_blk_start + bit,
 					       next - bit);
 		mb_free_blocks(pa->pa_inode, e4b, bit, next - bit);
 		bit = next + 1;
@@ -3606,7 +3606,7 @@ ext4_mb_release_group_pa(struct ext4_buddy *e4b,
 	ext4_group_t group;
 	ext4_grpblk_t bit;
 
-	trace_ext4_mb_release_group_pa(ac, pa);
+	trace_ext4_mb_release_group_pa(sb, ac, pa);
 	BUG_ON(pa->pa_deleted == 0);
 	ext4_get_group_no_and_offset(sb, pa->pa_pstart, &group, &bit);
 	BUG_ON(group != e4b->bd_group && pa->pa_len != 0);
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index f3865c7..01e9e00 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -395,11 +395,12 @@ DEFINE_EVENT(ext4__mb_new_pa, ext4_mb_new_group_pa,
 );
 
 TRACE_EVENT(ext4_mb_release_inode_pa,
-	TP_PROTO(struct ext4_allocation_context *ac,
+	TP_PROTO(struct super_block *sb,
+		 struct ext4_allocation_context *ac,
 		 struct ext4_prealloc_space *pa,
 		 unsigned long long block, unsigned int count),
 
-	TP_ARGS(ac, pa, block, count),
+	TP_ARGS(sb, ac, pa, block, count),
 
 	TP_STRUCT__entry(
 		__field(	dev_t,	dev			)
@@ -410,8 +411,9 @@ TRACE_EVENT(ext4_mb_release_inode_pa,
 	),
 
 	TP_fast_assign(
-		__entry->dev		= ac->ac_sb->s_dev;
-		__entry->ino		= ac->ac_inode->i_ino;
+		__entry->dev		= sb->s_dev;
+		__entry->ino		= (ac && ac->ac_inode) ? 
+						ac->ac_inode->i_ino : 0;
 		__entry->block		= block;
 		__entry->count		= count;
 	),
@@ -422,10 +424,11 @@ TRACE_EVENT(ext4_mb_release_inode_pa,
 );
 
 TRACE_EVENT(ext4_mb_release_group_pa,
-	TP_PROTO(struct ext4_allocation_context *ac,
+	TP_PROTO(struct super_block *sb,
+		 struct ext4_allocation_context *ac,
 		 struct ext4_prealloc_space *pa),
 
-	TP_ARGS(ac, pa),
+	TP_ARGS(sb, ac, pa),
 
 	TP_STRUCT__entry(
 		__field(	dev_t,	dev			)
@@ -436,8 +439,9 @@ TRACE_EVENT(ext4_mb_release_group_pa,
 	),
 
 	TP_fast_assign(
-		__entry->dev		= ac->ac_sb->s_dev;
-		__entry->ino		= ac->ac_inode->i_ino;
+		__entry->dev		= sb->s_dev;
+		__entry->ino		= (ac && ac->ac_inode) ?
+						ac->ac_inode->i_ino : 0;
 		__entry->pa_pstart	= pa->pa_pstart;
 		__entry->pa_len		= pa->pa_len;
 	),
-- 
1.7.0.4

