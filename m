From: Tomas Racek <tracek@redhat.com>
Subject: Re: [PATCH] ext4: Automatic setting of {INODE,BLOCK}_UNINIT flags
Date: Thu, 20 Dec 2012 04:48:28 -0500 (EST)
Message-ID: <949616759.6186198.1355996908940.JavaMail.root@redhat.com>
References: <20121108174859.GE19977@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, lczerner@redhat.com
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:52289 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab2LTJsb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Dec 2012 04:48:31 -0500
In-Reply-To: <20121108174859.GE19977@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

----- Original Message -----
> On Thu, Oct 25, 2012 at 09:25:43AM +0200, Tomas Racek wrote:
> > When last inode from bg is freed, set the INODE_UNINIT flag,
> > similarly
> > when last block is freed, set BLOCK_UNINIT flag. This can speed up
> > subsequent fsck run.
> > 
> > Signed-off-by: Tomas Racek <tracek@redhat.com>
> 
> Could you make the following enhancements to your patch?
> 
> 1)  Only do this if ext4_has_group_desc_csum(sb) is true
> 
> 2)  Check to make sure the inode bitmap has only one bit set (the
> inode
>     to be freed).  Basically, I don't want to set the
>     BLOCK/INODE_UNINIT
>     based just on the block group descriptor count, in case it got
>     corrupted
>      --- what, me paranoid?
> 
>     If there is other inodes set, then we need to call ext4_error()
>     since we know the file system has gotten corrupted.
> 
> 3)  If we can set BLOCK/INODE_UNINIT, we can skip modifying the
> bitmap
>     block (since we won't consult the bitmap block if uninit is set).
>     So that means we can skip calling get_write_access(), modifying
>     the bitmap, updating the checksum, and then calling
>     handle_dirty_metadata.  In fact, we can call ext4_forget(), so we
>     can drop it from the buffer cache, and if it had been modified
>     during
>     the current transaction --- as part of an rm -rf, for example ---
>     we don't need to include the bitmap block in the transaction.
> 
> (2) makes this patch much safer, and (3) should more than make up for
> the overhead of scanning the the bitmap.
> 

Hi Ted,

sorry for late response, I've tried to add features you suggested to my patch (see below). Skipping modification of the bitmap however requires zeroing the bitmap when uninit flag is discarded, i.e. in new_inode. This adds some complexity and could slow things down. What's your opinion about it? I wrote the patches some time ago, one for inode_uninit follows as an example. If it's the right approach I'll rewrite them to be applicable to the current head and send them.

Thank you for your time and suggestions!

Tom


Subject: [PATCH v2 1/2] Set INODE_UNINIT flag when last inode is freed from BG

This can speed up subsequent fsck run.

Changes in v2: Suggestions by Ted Ts'o
	- only set this when ext4_has_group_desc_csum is true
	- check if there are no other set bits in the bitmap
	- skip modifying bitmap, checksum calculations and journal
	  operations

The last suggestion requires zeroing bitmap when UNINIT flag is
discarded (e.g. new inode allocation from bg with INODE_UNINIT)

Signed-off-by: Tomas Racek <tracek@redhat.com>
---
 fs/ext4/ialloc.c | 100 ++++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 73 insertions(+), 27 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 3a100e7..04d50a8 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -221,6 +221,7 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
 	struct ext4_super_block *es;
 	struct ext4_sb_info *sbi;
 	int fatal = 0, err, count, cleared;
+	int uninit = 0;
 
 	if (!sb) {
 		printk(KERN_ERR "EXT4-fs: %s:%d: inode on "
@@ -266,36 +267,65 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
 	block_group = (ino - 1) / EXT4_INODES_PER_GROUP(sb);
 	bit = (ino - 1) % EXT4_INODES_PER_GROUP(sb);
 	bitmap_bh = ext4_read_inode_bitmap(sb, block_group);
-	if (!bitmap_bh)
-		goto error_return;
 
-	BUFFER_TRACE(bitmap_bh, "get_write_access");
-	fatal = ext4_journal_get_write_access(handle, bitmap_bh);
-	if (fatal)
+	if (!bitmap_bh)
 		goto error_return;
 
-	fatal = -ESRCH;
 	gdp = ext4_get_group_desc(sb, block_group, &bh2);
 	if (gdp) {
 		BUFFER_TRACE(bh2, "get_write_access");
 		fatal = ext4_journal_get_write_access(handle, bh2);
 	}
+
+	if(fatal)
+		goto error_return;
+
 	ext4_lock_group(sb, block_group);
-	cleared = ext4_test_and_clear_bit(bit, bitmap_bh->b_data);
-	if (fatal || !cleared) {
+	count = ext4_free_inodes_count(sb, gdp) + 1;
+
+	if(ext4_has_group_desc_csum(sb) && count == EXT4_INODES_PER_GROUP(sb)) {
+		unsigned long first_bit = ext4_find_next_bit(bitmap_bh->b_data,\
+						 EXT4_INODES_PER_GROUP(sb), 0);
+		unsigned long next_bit = ext4_find_next_bit(bitmap_bh->b_data,\
+						EXT4_INODES_PER_GROUP(sb), bit + 1);
+		if(first_bit != bit || next_bit < EXT4_INODES_PER_GROUP(sb)) {
+			ext4_unlock_group(sb, block_group);
+			ext4_error(sb, "Inode bitmap corruption in block_group %u",\
+					block_group);
+			goto error_return;
+		}
+
+		gdp->bg_flags |= cpu_to_le16(EXT4_BG_INODE_UNINIT);
+		uninit = 1;
+	}
+	else {
 		ext4_unlock_group(sb, block_group);
-		goto out;
+
+		BUFFER_TRACE(bitmap_bh, "get_write_access");
+		fatal = ext4_journal_get_write_access(handle, bitmap_bh);
+
+		if(fatal)
+			goto error_return;
+
+		ext4_lock_group(sb, block_group);
+		count = ext4_free_inodes_count(sb, gdp) + 1;
+
+		cleared = ext4_test_and_clear_bit(bit, bitmap_bh->b_data);
+		if(!cleared) {
+			ext4_unlock_group(sb, block_group);
+			goto out;
+		}
+		ext4_inode_bitmap_csum_set(sb, block_group, gdp, bitmap_bh,
+				   EXT4_INODES_PER_GROUP(sb) / 8);
 	}
 
-	count = ext4_free_inodes_count(sb, gdp) + 1;
 	ext4_free_inodes_set(sb, gdp, count);
+
 	if (is_directory) {
 		count = ext4_used_dirs_count(sb, gdp) - 1;
 		ext4_used_dirs_set(sb, gdp, count);
 		percpu_counter_dec(&sbi->s_dirs_counter);
 	}
-	ext4_inode_bitmap_csum_set(sb, block_group, gdp, bitmap_bh,
-				   EXT4_INODES_PER_GROUP(sb) / 8);
 	ext4_group_desc_csum_set(sb, block_group, gdp);
 	ext4_unlock_group(sb, block_group);
 
@@ -310,13 +340,20 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
 	BUFFER_TRACE(bh2, "call ext4_handle_dirty_metadata");
 	fatal = ext4_handle_dirty_metadata(handle, NULL, bh2);
 out:
-	if (cleared) {
-		BUFFER_TRACE(bitmap_bh, "call ext4_handle_dirty_metadata");
-		err = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
-		if (!fatal)
-			fatal = err;
-	} else
-		ext4_error(sb, "bit already cleared for inode %lu", ino);
+	if(!uninit) {
+		if (cleared) {
+			BUFFER_TRACE(bitmap_bh, "call ext4_handle_dirty_metadata");
+			err = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
+			if (!fatal)
+				fatal = err;
+		} else
+			ext4_error(sb, "bit already cleared for inode %lu", ino);
+	} else {
+		ext4_fsblk_t bitmap_blk = ext4_inode_bitmap(sb, gdp);
+		fatal = ext4_forget(handle, 0, inode, bitmap_bh, bitmap_blk);
+		ext4_std_error(sb, fatal);
+		return;
+	}
 
 error_return:
 	brelse(bitmap_bh);
@@ -650,6 +687,7 @@ struct inode *ext4_new_inode(handle_t *handle, struct inode *dir, umode_t mode,
 	struct inode *ret;
 	ext4_group_t i;
 	ext4_group_t flex_group;
+	int free = -1;
 
 	/* Cannot create files in a deleted directory */
 	if (!dir || !dir->i_nlink)
@@ -730,7 +768,20 @@ repeat_in_this_group:
 		if (err)
 			goto fail;
 		ext4_lock_group(sb, group);
-		ret2 = ext4_test_and_set_bit(ino, inode_bitmap_bh->b_data);
+		if(ext4_has_group_desc_csum(sb) &&
+		   gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT)) {
+
+			gdp->bg_flags &= cpu_to_le16(~EXT4_BG_INODE_UNINIT);
+			ext4_group_desc_csum_set(sb, group, gdp);
+			memset(inode_bitmap_bh->b_data, 0, sb->s_blocksize);
+			ext4_mark_bitmap_end(EXT4_INODES_PER_GROUP(sb),\
+				sb->s_blocksize * 8, inode_bitmap_bh->b_data);
+			ext4_set_bit(ino, inode_bitmap_bh->b_data);
+			free = 0;
+			ret2 = 0;
+		}
+		else
+			ret2 = ext4_test_and_set_bit(ino, inode_bitmap_bh->b_data);
 		ext4_unlock_group(sb, group);
 		ino++;		/* the inode bitmap is zero-based */
 		if (!ret2)
@@ -787,17 +838,12 @@ got:
 
 	/* Update the relevant bg descriptor fields */
 	if (ext4_has_group_desc_csum(sb)) {
-		int free;
 		struct ext4_group_info *grp = ext4_get_group_info(sb, group);
 
 		down_read(&grp->alloc_sem); /* protect vs itable lazyinit */
 		ext4_lock_group(sb, group); /* while we modify the bg desc */
-		free = EXT4_INODES_PER_GROUP(sb) -
-			ext4_itable_unused_count(sb, gdp);
-		if (gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT)) {
-			gdp->bg_flags &= cpu_to_le16(~EXT4_BG_INODE_UNINIT);
-			free = 0;
-		}
+		if(free != 0)
+			free = EXT4_INODES_PER_GROUP(sb) - ext4_itable_unused_count(sb, gdp);
 		/*
 		 * Check the relative inode number against the last used
 		 * relative inode number in this group. if it is greater
-- 
1.7.11.7
