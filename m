From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V2] ext4: unmap the underlying metadata when allocating
 blocks via fallocate
Date: Fri, 15 Jan 2010 00:00:58 +0530
Message-ID: <87wrzklesd.fsf@linux.vnet.ibm.com>
References: <1262805762-6862-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<1262805762-6862-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<4B4F4DB7.1070501@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, tytso@mit.edu, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:55857 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754770Ab0ANSbH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Jan 2010 13:31:07 -0500
Received: from d23relay05.au.ibm.com (d23relay05.au.ibm.com [202.81.31.247])
	by e23smtp08.au.ibm.com (8.14.3/8.13.1) with ESMTP id o0EIV4Fl012816
	for <linux-ext4@vger.kernel.org>; Fri, 15 Jan 2010 05:31:04 +1100
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay05.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o0EIQSwB1556696
	for <linux-ext4@vger.kernel.org>; Fri, 15 Jan 2010 05:26:28 +1100
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o0EIV3MZ007051
	for <linux-ext4@vger.kernel.org>; Fri, 15 Jan 2010 05:31:04 +1100
In-Reply-To: <4B4F4DB7.1070501@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 14 Jan 2010 11:00:39 -0600, Eric Sandeen <sandeen@redhat.com> wrote:
> Aneesh Kumar K.V wrote:
> > This become important when we are running with nojournal mode. We
> > may end up allocating recently freed metablocks for fallocate. We
> > want to make sure we unmap the old mapping so that when we convert
> > the fallocated uninitialized extent to initialized extent we don't
> > have the old mapping around. Leaving the old mapping can cause
> > file system corruption
> > 
> > Now that we unmap old metadata blocks we need not return blocks
> > allocated from fallocate area as new.
> 
> With this, unmap_underlying_metadata_blocks is no longer used
> and can be removed I guess.
>

Yes. Updated patch below

>From 947ca1e49381bd76b85b44a1d41336a105e421ad Mon Sep 17 00:00:00 2001
From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date: Thu, 7 Jan 2010 00:48:12 +0530
Subject: [PATCH] ext4: unmap the underlying metadata when allocating blocks via fallocate

This become important when we are running with nojournal mode. We
may end up allocating recently freed metablocks for fallocate. We
want to make sure we unmap the old mapping so that when we convert
the fallocated uninitialized extent to initialized extent we don't
have the old mapping around. Leaving the old mapping can cause
file system corruption

Now that we unmap old metadata blocks we need not return blocks
allocated from fallocate area as new.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/ext4.h    |   14 ++++++++++++++
 fs/ext4/extents.c |   26 ++++----------------------
 fs/ext4/inode.c   |   18 +-----------------
 3 files changed, 19 insertions(+), 39 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 874d169..110a31f 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1773,6 +1773,20 @@ static inline void set_bitmap_uptodate(struct buffer_head *bh)
 	set_bit(BH_BITMAP_UPTODATE, &(bh)->b_state);
 }
 
+/*
+ * __unmap_underlying_bh_blocks - just a helper function to unmap
+ * set of blocks described by @bh
+ */
+static inline void __unmap_underlying_bh_blocks(struct inode *inode,
+					     struct buffer_head *bh)
+{
+	struct block_device *bdev = inode->i_sb->s_bdev;
+	int blocks, i;
+
+	blocks = bh->b_size >> inode->i_blkbits;
+	for (i = 0; i < blocks; i++)
+		unmap_underlying_metadata(bdev, bh->b_blocknr + i);
+}
 #endif	/* __KERNEL__ */
 
 #endif	/* _EXT4_H */
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 765a482..8a20a5e 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3038,14 +3038,6 @@ out:
 	return err;
 }
 
-static void unmap_underlying_metadata_blocks(struct block_device *bdev,
-			sector_t block, int count)
-{
-	int i;
-	for (i = 0; i < count; i++)
-                unmap_underlying_metadata(bdev, block + i);
-}
-
 static int
 ext4_ext_handle_uninitialized_extents(handle_t *handle, struct inode *inode,
 			ext4_lblk_t iblock, unsigned int max_blocks,
@@ -3120,21 +3112,9 @@ out:
 		goto out2;
 	} else
 		allocated = ret;
-	set_buffer_new(bh_result);
-	/*
-	 * if we allocated more blocks than requested
-	 * we need to make sure we unmap the extra block
-	 * allocated. The actual needed block will get
-	 * unmapped later when we find the buffer_head marked
-	 * new.
-	 */
-	if (allocated > max_blocks) {
-		unmap_underlying_metadata_blocks(inode->i_sb->s_bdev,
-					newblock + max_blocks,
-					allocated - max_blocks);
-		allocated = max_blocks;
-	}
 
+	if (allocated > max_blocks)
+		allocated = max_blocks;
 	/*
 	 * If we have done fallocate with the offset that is already
 	 * delayed allocated, we would have block reservation
@@ -3570,6 +3550,8 @@ retry:
 			ret2 = ext4_journal_stop(handle);
 			break;
 		}
+		if (buffer_new(&map_bh))
+			__unmap_underlying_bh_blocks(inode, &map_bh);
 		if ((block + ret) >= (EXT4_BLOCK_ALIGN(offset + len,
 						blkbits) >> blkbits))
 			new_size = offset + len;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index cbf56da..f1b66e6 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2111,22 +2111,6 @@ static void mpage_put_bnr_to_bhs(struct mpage_da_data *mpd, sector_t logical,
 	}
 }
 
-
-/*
- * __unmap_underlying_blocks - just a helper function to unmap
- * set of blocks described by @bh
- */
-static inline void __unmap_underlying_blocks(struct inode *inode,
-					     struct buffer_head *bh)
-{
-	struct block_device *bdev = inode->i_sb->s_bdev;
-	int blocks, i;
-
-	blocks = bh->b_size >> inode->i_blkbits;
-	for (i = 0; i < blocks; i++)
-		unmap_underlying_metadata(bdev, bh->b_blocknr + i);
-}
