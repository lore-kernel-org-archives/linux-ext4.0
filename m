From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: simple block bitmap sanity checking
Date: Mon, 09 Jul 2007 22:52:10 +0530
Message-ID: <46926EC2.7030706@linux.vnet.ibm.com>
References: <20070706184856.GA13812@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:55544 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308AbXGIRWa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Jul 2007 13:22:30 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp05.au.ibm.com (8.13.8/8.13.8) with ESMTP id l69HNXsT3092642
	for <linux-ext4@vger.kernel.org>; Tue, 10 Jul 2007 03:23:38 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.250.237])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l69HPki1130936
	for <linux-ext4@vger.kernel.org>; Tue, 10 Jul 2007 03:25:46 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l69HMDuF013992
	for <linux-ext4@vger.kernel.org>; Tue, 10 Jul 2007 03:22:14 +1000
In-Reply-To: <20070706184856.GA13812@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Andreas Dilger wrote:
> During a discussion at OLS, I came up with a very simple way of validating
> the ext2/3/4 block bitmaps at read time.  Until such a time when we have
> checksums for the bitmaps we can have a simple but quite robust mechanism
> that is useful for ext2/3/4.
> 
> When a new block bitmap is read from disk in read_block_bitmap() there are a
> few bits that should ALWAYS be set.  In particular, the blocks given by
> desc->bg_block_bitmap, desc->bg_inode_bitmap, and the inode table in
> [desc->bg_inode_table, +sbi->s_itb_per_group].  If those bits (shifted to be
> relative to the current group, of course) are not set then the on-disk group
> descriptor is corrupt, or there is some problem reading it from disk, and
> this needs to generate an extN_error() call[*] to make the fs read-only.
> 
> A similar check can be done with the inode bitmap - it should have the
> bits at the end of each bitmap set, for bits higher than s_inodes_per_group.


Something like this ?. If yes i can send a patch with full changelog


diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 44c6254..b9a334c 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -115,17 +115,50 @@ read_block_bitmap(struct super_block *sb, unsigned int block_group)
 {
 	struct ext4_group_desc * desc;
 	struct buffer_head * bh = NULL;
+	ext4_fsblk_t bitmap_blk, grp_rel_blk, grp_first_blk;
 
 	desc = ext4_get_group_desc (sb, block_group, NULL);
 	if (!desc)
 		goto error_out;
-	bh = sb_bread(sb, ext4_block_bitmap(sb, desc));
+	bitmap_blk = ext4_block_bitmap(sb, desc);
+	bh = sb_bread(sb, bitmap_blk);
 	if (!bh)
 		ext4_error (sb, "read_block_bitmap",
 			    "Cannot read block bitmap - "
 			    "block_group = %d, block_bitmap = %llu",
-			    block_group,
-			    ext4_block_bitmap(sb, desc));
+			    block_group, bitmap_blk);
+
+	/* check whether block bitmap block number is set */
+	printk("blk bitmap = %llu first block = %llu block group = %u \n",
+			bitmap_blk, ext4_group_first_block_no(sb, block_group),
+			block_group);
+
+	grp_first_blk = ext4_group_first_block_no(sb, block_group);
+
+	grp_rel_blk = bitmap_blk - grp_first_blk;
+	if (!ext4_test_bit(grp_rel_blk, bh->b_data)) {
+		/* bad block bitmap */
+		brelse(bh);
+		return NULL;
+	}
+
+	/* check whether the inode bitmap block number is set */
+	bitmap_blk = ext4_inode_bitmap(sb, desc);
+	grp_rel_blk = bitmap_blk - grp_first_blk;
+	if (!ext4_test_bit(grp_rel_blk, bh->b_data)) {
+		/* bad block bitmap */
+		brelse(bh);
+		return NULL;
+	}
+	/* check whether the inode table block number is set */
+	bitmap_blk = ext4_inode_table(sb, desc);
+	grp_rel_blk = bitmap_blk - grp_first_blk;
+	if (!ext4_test_bit(grp_rel_blk, bh->b_data)) {
+		/* bad block bitmap */
+		brelse(bh);
+		return NULL;
+	}
+
 error_out:
 	return bh;
 }
