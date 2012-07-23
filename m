From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC PATCH 2/2] ext4: undo ei->i_da_metadata_calc_len increment
 if we fail to claim space
Date: Mon, 23 Jul 2012 00:18:24 -0400
Message-ID: <20120723041824.GB17588@thunk.org>
References: <4F79C24C.7070907@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Brian Foster <bfoster@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40608 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931Ab2GWES1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Jul 2012 00:18:27 -0400
Content-Disposition: inline
In-Reply-To: <4F79C24C.7070907@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 02, 2012 at 11:14:20AM -0400, Brian Foster wrote:
> From: Brian Foster <bfoster@redhat.com>
> 
> If we call ext4_calc_metadata_amount() and then fail to claim
> the space, a subsequent successful request to a block covered
> by the same ext2 indirect block will set md_needed to 0, fail
> to update the associated counters and result in a delayed md
> block allocation without a reservation. Decrement
> i_da_metadata_calc_len on failure to ensure the next
> reservation sets md_needed correctly.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Hi Brian,

This patch was not quite right.  i_data_metadata_calc_len is not the
only side effect of ext4_calc_metadata().  We need to undo the side
effects not only when exit with an error, but also if we yield and
then retry the claim.  Also, in the extent case we don't always modify
i_data_metadata_calc_len, so just decrementing isn't necessarily going
to do the right thing.

So this is the patch which I am testing....

						- Ted

commit 19ec0f1fe139a642f688177ffd2f91a1c09f6bc0
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Mon Jul 23 00:00:20 2012 -0400

    ext4: undo ext4_calc_metadata_amount if we fail to claim space
    
    The function ext4_calc_metadata_amount() has side effects, although
    it's not obvious from its function name.  So if we fail to claim
    space, regardless of whether we retry to claim the space again, or
    return an error, we need to undo these side effects.
    
    Otherwise we can end up incorrectly calculating the number of metadata
    blocks needed for the operation, which was responsible for an xfstests
    failure for test #271 when using an ext2 file system with delalloc
    enabled.
    
    Reported-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
    Cc: stable@vger.kernel.org

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 25f809d..89b59cb 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1182,6 +1182,17 @@ static int ext4_da_reserve_space(struct inode *inode, ext4_lblk_t lblock)
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	unsigned int md_needed;
 	int ret;
+	ext4_lblk_t save_last_lblock;
+	int save_len;
+
+	/*
+	 * We will charge metadata quota at writeout time; this saves
+	 * us from metadata over-estimation, though we may go over by
+	 * a small amount in the end.  Here we just reserve for data.
+	 */
+	ret = dquot_reserve_block(inode, EXT4_C2B(sbi, 1));
+	if (ret)
+		return ret;
 
 	/*
 	 * recalculate the amount of metadata blocks to reserve
@@ -1190,32 +1201,31 @@ static int ext4_da_reserve_space(struct inode *inode, ext4_lblk_t lblock)
 	 */
 repeat:
 	spin_lock(&ei->i_block_reservation_lock);
+	/*
+	 * ext4_calc_metadata_amount() has side effects, which we have
+	 * to be prepared undo if we fail to claim space.
+	 */
+	save_len = ei->i_da_metadata_calc_len;
+	save_last_lblock = ei->i_da_metadata_calc_last_lblock;
 	md_needed = EXT4_NUM_B2C(sbi,
 				 ext4_calc_metadata_amount(inode, lblock));
 	trace_ext4_da_reserve_space(inode, md_needed);
-	spin_unlock(&ei->i_block_reservation_lock);
 
 	/*
-	 * We will charge metadata quota at writeout time; this saves
-	 * us from metadata over-estimation, though we may go over by
-	 * a small amount in the end.  Here we just reserve for data.
-	 */
-	ret = dquot_reserve_block(inode, EXT4_C2B(sbi, 1));
-	if (ret)
-		return ret;
-	/*
 	 * We do still charge estimated metadata to the sb though;
 	 * we cannot afford to run out of free blocks.
 	 */
 	if (ext4_claim_free_clusters(sbi, md_needed + 1, 0)) {
-		dquot_release_reservation_block(inode, EXT4_C2B(sbi, 1));
+		ei->i_da_metadata_calc_len = save_len;
+		ei->i_da_metadata_calc_last_lblock = save_last_lblock;
+		spin_unlock(&ei->i_block_reservation_lock);
 		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
 			yield();
 			goto repeat;
 		}
+		dquot_release_reservation_block(inode, EXT4_C2B(sbi, 1));
 		return -ENOSPC;
 	}
-	spin_lock(&ei->i_block_reservation_lock);
 	ei->i_reserved_data_blocks++;
 	ei->i_reserved_meta_blocks += md_needed;
 	spin_unlock(&ei->i_block_reservation_lock);
