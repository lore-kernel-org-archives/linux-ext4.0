From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH -V4] ext4: Use an rbtree for tracking blocks freed
	during transaction.
Date: Mon, 13 Oct 2008 15:54:06 -0400
Message-ID: <20081013195406.GA9332@mit.edu>
References: <1223914510-25128-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com,
	linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:60009 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751400AbYJMTyW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Oct 2008 15:54:22 -0400
Content-Disposition: inline
In-Reply-To: <1223914510-25128-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 13, 2008 at 09:45:10PM +0530, Aneesh Kumar K.V wrote:
> With this patch we track the block freed during a transaction using
> rb tree. We also make sure contiguous blocks freed are collected
> in one rb node.

One additional fix that I found while looking at the code was that you
shouldn't merge two extents to be freed if they are in different
groups.  This could happen if one extent went to the end of one block
group, and the second extent starts at the beginning of a block group.
In that case, you don't want to merge the two extents given that the
current code depends on an freed extent not spanning groups.

I think this will be a problem with the following patch which treats
data blocks as metadata, because data extents *can* span block groups.
So even though with this fix below we will no longer merge extents
that are in different block groups, if a file has a extent that spans
multipe block groups, the resulting freed extent structure will also
span block groups, which will cause ext4_mb_free_committed_blocks() to
be very unhappy.

So we have two choices; one is that we change ext4_mb_free_metadata()
to break up freed extents into block group chunks, or we change
ext4_mb_free_committed_blocks() to be able to handle extents that span
multiple blocks.  I suspect the latter is the best way to go, but in
case we go the former, then following patch will be needed to the
rbtree patch.  (Also I cleaned up some of the comments documenting the
data structure, which I'd recommend you integrate regardless of how we
solve the problem of freed extents spanning multiple block groups.)

						- Ted

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index acf6a32..1ba9586 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4427,10 +4427,17 @@ static void ext4_mb_poll_new_transaction(struct super_block *sb,
 	ext4_mb_free_committed_blocks(sb);
 }
 
+/*
+ * We can merge two free data extents of the physical blocks
+ * are contiguous, AND the extents were freed by the same transaction, 
+ * AND the blocks are associated with the same group.
+ */
 static int can_merge(struct ext4_free_data *entry1,
 			struct ext4_free_data *entry2)
 {
-	if (entry1->start_blk + entry1->count == entry2->start_blk)
+	if ((entry1->t_tid == entry2->t_tid) &&
+	    (entry1->group == entry2->group) &&
+	    (entry1->start_blk + entry1->count) == entry2->start_blk)
 		return 1;
 	return 0;
 }
diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
index 07dff39..23e08e5 100644
--- a/fs/ext4/mballoc.h
+++ b/fs/ext4/mballoc.h
@@ -106,24 +106,21 @@ static struct kmem_cache *ext4_free_ext_cachep;
 #define EXT4_BB_MAX_BLOCKS	30
 
 struct ext4_free_data {
-	/* this link the free block
-	 * information from group_info
-	 */
+	/* this links the free block information from group_info */
 	struct rb_node node;
 
-	/* group this free block
-	 * extent belong
-	 */
+	/* this links the free block information from ext4_sb_info */
+	struct list_head list;
+
+	/* group which free block extent belongs */
 	ext4_group_t group;
 
 	/* free block extent */
 	ext4_grpblk_t start_blk;
 	ext4_grpblk_t count;
 
-	/* this link the free block
-	 * information from ext4_sb_info
-	 */
-	struct list_head list;
+	/* transaction which freed this extent */
+	tid_t	t_tid;
 };
 
 struct ext4_group_info {
