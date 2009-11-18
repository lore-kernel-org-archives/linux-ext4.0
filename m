From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [PATCH 3/3]ext4: move_extent_per_page() cleanup
Date: Wed, 18 Nov 2009 16:26:15 +0900
Message-ID: <4B03A197.5030605@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Akira Fujita <a-fujita@rs.jp.nec.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:33809 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbZKRHb2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 Nov 2009 02:31:28 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4: move_extent_per_page() cleanup

From: Akira Fujita <a-fujita@rs.jp.nec.com>

This is a cleanup patch.
Integrate duplicate lines (acquire/release semaphore
and invalidate extent cache in move_extent_per_page())
into mext_replace_branches(),
so this change leads to the code size reduction.

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
---
 move_extent.c |   30 +++++++++---------------------
 1 file changed, 9 insertions(+), 21 deletions(-)
diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 39b5d80..c002449 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -660,6 +660,9 @@ mext_replace_branches(handle_t *handle, struct inode *orig_inode,
 	int replaced_count = 0;
 	int dext_alen;

+	/* Protect extent trees against block allocations via delalloc */
+	double_down_write_data_sem(orig_inode, donor_inode);
+
 	/* Get the original extent for the block "orig_off" */
 	*err = get_ext_path(orig_inode, orig_off, &orig_path);
 	if (*err)
@@ -755,6 +758,11 @@ out:
 		kfree(donor_path);
 	}

+	ext4_ext_invalidate_cache(orig_inode);
+	ext4_ext_invalidate_cache(donor_inode);
+
+	double_up_write_data_sem(orig_inode, donor_inode);
+
 	return replaced_count;
 }

@@ -820,19 +828,9 @@ move_extent_per_page(struct file *o_filp, struct inode *donor_inode,
 	 * Just swap data blocks between orig and donor.
 	 */
 	if (uninit) {
-		/*
-		 * Protect extent trees against block allocations
-		 * via delalloc
-		 */
-		double_down_write_data_sem(orig_inode, donor_inode);
 		replaced_count = mext_replace_branches(handle, orig_inode,
 						donor_inode, orig_blk_offset,
 						block_len_in_page, err);
-
-		/* Clear the inode cache not to refer to the old data */
-		ext4_ext_invalidate_cache(orig_inode);
-		ext4_ext_invalidate_cache(donor_inode);
-		double_up_write_data_sem(orig_inode, donor_inode);
 		goto out2;
 	}

@@ -880,8 +878,6 @@ move_extent_per_page(struct file *o_filp, struct inode *donor_inode,
 	/* Release old bh and drop refs */
 	try_to_release_page(page, 0);

-	/* Protect extent trees against block allocations via delalloc */
-	double_down_write_data_sem(orig_inode, donor_inode);
 	replaced_count = mext_replace_branches(handle, orig_inode, donor_inode,
 					orig_blk_offset, block_len_in_page,
 					&err2);
@@ -890,18 +886,10 @@ move_extent_per_page(struct file *o_filp, struct inode *donor_inode,
 			block_len_in_page = replaced_count;
 			replaced_size =
 				block_len_in_page << orig_inode->i_blkbits;
-		} else {
-			double_up_write_data_sem(orig_inode, donor_inode);
+		} else
 			goto out;
-		}
 	}

-	/* Clear the inode cache not to refer to the old data */
-	ext4_ext_invalidate_cache(orig_inode);
-	ext4_ext_invalidate_cache(donor_inode);
-
-	double_up_write_data_sem(orig_inode, donor_inode);
