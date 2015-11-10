From: Jan Kara <jack@suse.com>
Subject: [PATCH 2/9] ext4: Move unlocked dio protection from ext4_alloc_file_blocks()
Date: Tue, 10 Nov 2015 20:50:52 +0100
Message-ID: <1447185059-16166-3-git-send-email-jack@suse.com>
References: <1447185059-16166-1-git-send-email-jack@suse.com>
Cc: linux-ext4@vger.kernel.org,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	dan.j.williams@intel.com, brian.boylston@hpe.com,
	Jan Kara <jack@suse.com>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52867 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701AbbKJTvQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Nov 2015 14:51:16 -0500
In-Reply-To: <1447185059-16166-1-git-send-email-jack@suse.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently ext4_alloc_file_blocks() was handling protection against
unlocked DIO. However we now need to sometimes call it under i_mmap_sem
and sometimes not and DIO protection ranks above it (although strictly
speaking this cannot currently create any deadlocks). Also
ext4_zero_range() was actually getting & releasing unlocked DIO
protection twice in some cases. Luckily it didn't introduce any real bug
but it was a land mine waiting to be stepped on.  So move DIO protection
out from ext4_alloc_file_blocks() into the two callsites.

Signed-off-by: Jan Kara <jack@suse.com>
---
 fs/ext4/extents.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 5be9ca5a8a7a..65b5ada2833f 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4685,10 +4685,6 @@ static int ext4_alloc_file_blocks(struct file *file, ext4_lblk_t offset,
 	if (len <= EXT_UNWRITTEN_MAX_LEN)
 		flags |= EXT4_GET_BLOCKS_NO_NORMALIZE;
 
-	/* Wait all existing dio workers, newcomers will block on i_mutex */
-	ext4_inode_block_unlocked_dio(inode);
-	inode_dio_wait(inode);
-
 	/*
 	 * credits to insert 1 extent into extent tree
 	 */
@@ -4752,8 +4748,6 @@ retry:
 		goto retry;
 	}
 
-	ext4_inode_resume_unlocked_dio(inode);
-
 	return ret > 0 ? ret2 : ret;
 }
 
@@ -4827,6 +4821,10 @@ static long ext4_zero_range(struct file *file, loff_t offset,
 	if (mode & FALLOC_FL_KEEP_SIZE)
 		flags |= EXT4_GET_BLOCKS_KEEP_SIZE;
 
+	/* Wait all existing dio workers, newcomers will block on i_mutex */
+	ext4_inode_block_unlocked_dio(inode);
+	inode_dio_wait(inode);
+
 	/* Preallocate the range including the unaligned edges */
 	if (partial_begin || partial_end) {
 		ret = ext4_alloc_file_blocks(file,
@@ -4835,7 +4833,7 @@ static long ext4_zero_range(struct file *file, loff_t offset,
 				 round_down(offset, 1 << blkbits)) >> blkbits,
 				new_size, flags, mode);
 		if (ret)
-			goto out_mutex;
+			goto out_dio;
 
 	}
 
@@ -4844,10 +4842,6 @@ static long ext4_zero_range(struct file *file, loff_t offset,
 		flags |= (EXT4_GET_BLOCKS_CONVERT_UNWRITTEN |
 			  EXT4_EX_NOCACHE);
 
-		/* Wait all existing dio workers, newcomers will block on i_mutex */
-		ext4_inode_block_unlocked_dio(inode);
-		inode_dio_wait(inode);
