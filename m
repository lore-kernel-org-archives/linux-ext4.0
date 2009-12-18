From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Ensure zeroout blocks have no dirty metadata
Date: Fri, 18 Dec 2009 17:40:08 +0530
Message-ID: <20091218121008.GE9437@skywalker.linux.vnet.ibm.com>
References: <6601abe90912100928v747671dat489aeee5dabf2c03@mail.gmail.com>
 <20091218114946.GD9437@skywalker.linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:45669 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbZLRMKN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Dec 2009 07:10:13 -0500
Received: from d23relay04.au.ibm.com (d23relay04.au.ibm.com [202.81.31.246])
	by e23smtp03.au.ibm.com (8.14.3/8.13.1) with ESMTP id nBIC7Oq3013755
	for <linux-ext4@vger.kernel.org>; Fri, 18 Dec 2009 23:07:24 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay04.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id nBIC6F1f1745148
	for <linux-ext4@vger.kernel.org>; Fri, 18 Dec 2009 23:06:16 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id nBICABio009462
	for <linux-ext4@vger.kernel.org>; Fri, 18 Dec 2009 23:10:11 +1100
Content-Disposition: inline
In-Reply-To: <20091218114946.GD9437@skywalker.linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 18, 2009 at 05:19:46PM +0530, Aneesh Kumar K.V wrote:
> On Thu, Dec 10, 2009 at 09:28:28AM -0800, Curt Wohlgemuth wrote:
> > This fixes a bug in which new blocks returned from an extent created with
> > ext4_ext_zeroout() can have dirty metadata still associated with them.
> > 
> > 	Signed-off-by: Curt Wohlgemuth <curtw@google.com>

A better option would be to do the unmap during fallocate.

commit 87b3121fd9d1223acb08326fc0c9711b0bc3cfeb
Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date:   Fri Dec 18 17:38:15 2009 +0530

    ext4: unmap the underlying metadata when allocating blocks via fallocate
    
    This become important when we are running with nojournal mode. We
    may end up allocating recently freed metablocks for fallocate. We
    want to make sure we unmap the old mapping so that when we convert
    the fallocated uninitialized extent to initialized extent we don't
    have the old mapping around. Leaving the old mapping can cause
    file system corruption
    
    Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index ab31e65..7c0fcae 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1768,6 +1768,20 @@ static inline void set_bitmap_uptodate(struct buffer_head *bh)
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
index 3a7928f..4e646a5 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3508,6 +3508,8 @@ retry:
 			ret2 = ext4_journal_stop(handle);
 			break;
 		}
+		if (buffer_new(&map_bh))
+			__unmap_underlying_bh_blocks(inode, &map_bh);
 		if ((block + ret) >= (EXT4_BLOCK_ALIGN(offset + len,
 						blkbits) >> blkbits))
 			new_size = offset + len;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5352db1..7b44737 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2073,22 +2073,6 @@ static void mpage_put_bnr_to_bhs(struct mpage_da_data *mpd, sector_t logical,
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
