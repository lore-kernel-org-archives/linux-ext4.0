From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: simple block bitmap sanity checking
Date: Mon, 9 Jul 2007 12:58:54 -0600
Message-ID: <20070709185854.GW5633@schatzie.adilger.int>
References: <20070706184856.GA13812@schatzie.adilger.int> <46926EC2.7030706@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 74-0-229-162.T1.lbdsl.net ([74.0.229.162]:34767 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755312AbXGIS66 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Jul 2007 14:58:58 -0400
Content-Disposition: inline
In-Reply-To: <46926EC2.7030706@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jul 09, 2007  22:52 +0530, Aneesh Kumar K.V wrote:
> Something like this ?. If yes i can send a patch with full changelog
> 
> 
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index 44c6254..b9a334c 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -115,17 +115,50 @@ read_block_bitmap(struct super_block *sb, unsigned 
> int block_group)
> {
> 	struct ext4_group_desc * desc;
> 	struct buffer_head * bh = NULL;
> +	ext4_fsblk_t bitmap_blk, grp_rel_blk, grp_first_blk;
> 
> 	desc = ext4_get_group_desc (sb, block_group, NULL);
> 	if (!desc)
> 		goto error_out;
> -	bh = sb_bread(sb, ext4_block_bitmap(sb, desc));
> +	bitmap_blk = ext4_block_bitmap(sb, desc);
> +	bh = sb_bread(sb, bitmap_blk);
> 	if (!bh)
> 		ext4_error (sb, "read_block_bitmap",

I prefer ext4_error(sb, __FUNCTION__, ...) since then we don't need to
update the error message when the function name changes, so while we are
here you may as well change it...

> 			    "Cannot read block bitmap - "
> 			    "block_group = %d, block_bitmap = %llu",
> -			    block_group,
> -			    ext4_block_bitmap(sb, desc));
> +			    block_group, bitmap_blk);
> +
> +	/* check whether block bitmap block number is set */
> +	printk("blk bitmap = %llu first block = %llu block group = %u \n",
> +			bitmap_blk, ext4_group_first_block_no(sb, block_group),
> +			block_group);
> +	grp_first_blk = ext4_group_first_block_no(sb, block_group);
> +

This should be wrapped as ext4_debug(), and you may as well calculate
grp_first_blk and use that for the printed message.

> +	grp_rel_blk = bitmap_blk - grp_first_blk;
> +	if (!ext4_test_bit(grp_rel_blk, bh->b_data)) {
> +		/* bad block bitmap */
> +		brelse(bh);
> +		return NULL;
> +	}
> +
> +	/* check whether the inode bitmap block number is set */
> +	bitmap_blk = ext4_inode_bitmap(sb, desc);
> +	grp_rel_blk = bitmap_blk - grp_first_blk;
> +	if (!ext4_test_bit(grp_rel_blk, bh->b_data)) {
> +		/* bad block bitmap */
> +		brelse(bh);
> +		return NULL;
> +	}
> +	/* check whether the inode table block number is set */
> +	bitmap_blk = ext4_inode_table(sb, desc);
> +	grp_rel_blk = bitmap_blk - grp_first_blk;
> +	if (!ext4_test_bit(grp_rel_blk, bh->b_data)) {
> +		/* bad block bitmap */
> +		brelse(bh);
> +		return NULL;
> +	}

Each of these error returns should have an ext4_error() message so that the
filesystem is marked read-only if this happens.  It might make sense to
just have the error message referenced by a char *, goto err_brelse and then
a single call and brelse(bh) at the end of the function.  I've rewritten
the code below, but note this is a hand-edit and not a patch...  Also note
that we can do the same for inode bitmaps, checking the bits between
[sbi->s_inodes_per_group, sb->s_blocksize * 8 - 1] are set.

We likely also need to skip these checks for uninit groups, so the context
of this patch should change to go into the ext4 patch queue (the checks go
into the "else" clause).


--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -115,19 +115,54 @@ read_block_bitmap(struct super_block *sb, unsigned int block_group)
 {
	struct ext4_group_desc * desc;
	struct buffer_head * bh = NULL;
+	ext4_fsblk_t bitmap_blk, grp_first_blk;
+	int i;
+	const char *msg;

	desc = ext4_get_group_desc (sb, block_group, NULL);
	if (!desc)
		goto error_out;
-	bh = sb_bread(sb, ext4_block_bitmap(sb, desc));
-	if (!bh)
-		ext4_error (sb, "read_block_bitmap",
-			    "Cannot read block bitmap - "
-			    "block_group = %d, block_bitmap = %llu",
-			    block_group,
-			    ext4_block_bitmap(sb, desc));
+	bitmap_blk = ext4_block_bitmap(sb, desc);
+	bh = sb_bread(sb, bitmap_blk);
+	if (!bh) {
+		msg = "Cannot read block bitmap"
+		goto error_out;
+	}
+
+	grp_first_blk = ext4_group_first_block_no(sb, block_group);
+
+	ext4_debug("blk bitmap = %llu first block = %llu block group = %u\n",
+		   bitmap_blk, grp_first_blk, block_group);
+
+	/* check whether block bitmap block number is set */
+	if (!ext4_test_bit(bitmap_blk - grp_first_blk, bh->b_data)) {
+		msg = "Block bitmap block not marked in use";
+		goto error_brelse;
+	}
+
+	/* check whether the inode bitmap block number is set */
+	bitmap_blk = ext4_inode_bitmap(sb, desc);
+	if (!ext4_test_bit(bitmap_blk - grp_first_blk, bh->b_data)) {
+		msg = "Inode bitmap block not marked in use";
+		goto error_brelse;
+	}
+
+	/* check whether the inode table blocks are set */
+	bitmap_blk = ext4_inode_table(sb, desc);
+	for (i = 0; i < EXT4_SB(sb)->s_itb_per_group; i++, bitmap_blk++)
+		if (!ext4_test_bit(bitmap_blk - grp_first_blk, bh->b_data)){
+			msg = "Inode table block not marked in use";
+			goto error_brelse;
+		}
+	}
+	return bh;
+
+error_brelse:
+	brelse(bh);
 error_out:
-	return bh;
+	ext4_error(sb, __FUNCTION__, "%s - block_group %u, block %llu\n"
+		   block_group, bitmap_blk);
+	return NULL;
 }


Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
