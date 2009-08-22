From: Andreas Schlick <schlick@lavabit.com>
Subject: [PATCH 1/1] dir shrink (was Re: ext3/ext4 directories don't shrink after deleting lots of files)
Date: Sat, 22 Aug 2009 16:20:49 +0200
Message-ID: <200908221620.50103.schlick@lavabit.com>
References: <1242338523.6933.664.camel@timo-desktop> <605A8D56-81CD-4775-8FCD-58CDB12CBA36@iki.fi> <20090517213335.GB32019@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from karen.lavabit.com ([72.249.41.33]:57731 "EHLO karen.lavabit.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932520AbZHVO0n (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 22 Aug 2009 10:26:43 -0400
In-Reply-To: <20090517213335.GB32019@mit.edu>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

> Anyway, if there's someone interested in trying to implement this,
> give me a holler; I'd be happy to give more details as necessary.

I'd like to try it. It looks like a nice starting project. 
Following your outline the first version of the patch tries to remove an empty 
block at the end of a non-htree directory. I'd appreciate it if you checked it 
and gave me suggestions for improving it. 
At the moment I am looking at the dir_index code, so I can extend it to htree 
directories. Please let me know if you want me to port it to ext3, although 
personally I think it is better to do so at later point.

Greetings Andreas


[PATCH] ext4: Add a function to shrink directories by removing last empty block.

Current limitations: It only works on directories that don't use htree and will
only remove the last block (if it is not used).

Signed-off-by: Andreas Schlick <schlick@lavabit.com>
---
 fs/ext4/namei.c |   70 +++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 65 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 1855060..04ac43d 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -79,6 +79,13 @@ static struct buffer_head *ext4_append(handle_t *handle,
 #define dxtrace(command)
 #endif
 
+// ext4_dir_cleanup holds information for ext4_shrink_directory(..).
+// At the moment it is only a pointer to the directory's inode but this
+// will change in later versions of the patch.
+struct ext4_dir_cleanup {
+	struct inode *dir;
+};
+
 struct fake_dirent
 {
 	__le32 inode;
@@ -1684,7 +1691,8 @@ cleanup:
 static int ext4_delete_entry(handle_t *handle,
 			     struct inode *dir,
 			     struct ext4_dir_entry_2 *de_del,
-			     struct buffer_head *bh)
+			     struct buffer_head *bh,
+			     struct ext4_dir_cleanup *dc)
 {
 	struct ext4_dir_entry_2 *de, *pde;
 	unsigned int blocksize = dir->i_sb->s_blocksize;
@@ -1711,6 +1719,9 @@ static int ext4_delete_entry(handle_t *handle,
 			dir->i_version++;
 			BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
 			ext4_handle_dirty_metadata(handle, dir, bh);
+			if (dc) {
+				dc->dir = dir;
+			}
 			return 0;
 		}
 		i += ext4_rec_len_from_disk(de->rec_len, blocksize);
@@ -1989,6 +2000,49 @@ static int empty_dir(struct inode *inode)
 	return 1;
 }
 
+/*
+ * This function tries to shrink the size of a directory.
+ *
+ * The current limitations are that it checks only the last block
+ * and only works on non-indexed directories.
+ */
+static void ext4_shrink_directory(struct ext4_dir_cleanup *dc) {
+	struct inode *dir = dc->dir;
+	struct buffer_head *bh;
+	struct ext4_dir_entry_2 * de;
+	char * dlimit;
+	ext4_lblk_t lblock;
+	int err=0;
+
+	lblock = dir->i_size >> EXT4_BLOCK_SIZE_BITS(dir->i_sb);
+
+	// We don't handle indexed dirs at the moment and need at least two blocks
+	if (is_dx(dir) || lblock <= 1) {
+		return;
+	}
+
+	bh = ext4_bread(NULL, dir, (lblock-1), 0, &err);
+
+	if (!bh) {
+		return;
+	}
+
+	de = (struct ext4_dir_entry_2 *) bh->b_data;
+	dlimit = bh->b_data + dir->i_sb->s_blocksize;
+	while ((char *) de < dlimit) {
+		if (de->inode) {
+			brelse(bh);
+			return;
+		}
+		de = ext4_next_entry(de, EXT4_BLOCK_SIZE(dir->i_sb));
+	}
+
+	brelse(bh);
+
+	dir->i_size -= EXT4_BLOCK_SIZE(dir->i_sb);
+	ext4_truncate(dir);
+}
+
 /* ext4_orphan_add() links an unlinked or truncated inode into a list of
  * such inodes, starting at the superblock, in case we crash before the
  * file is closed/deleted, or in case the inode truncate spans multiple
@@ -2145,6 +2199,7 @@ static int ext4_rmdir(struct inode *dir, struct dentry *dentry)
 	struct inode *inode;
 	struct buffer_head *bh;
 	struct ext4_dir_entry_2 *de;
+	struct ext4_dir_cleanup dc;
 	handle_t *handle;
 
 	/* Initialize quotas before so that eventual writes go in
@@ -2172,7 +2227,7 @@ static int ext4_rmdir(struct inode *dir, struct dentry *dentry)
 	if (!empty_dir(inode))
 		goto end_rmdir;
 
-	retval = ext4_delete_entry(handle, dir, de, bh);
+	retval = ext4_delete_entry(handle, dir, de, bh, &dc);
 	if (retval)
 		goto end_rmdir;
 	if (!EXT4_DIR_LINK_EMPTY(inode))
@@ -2195,6 +2250,7 @@ static int ext4_rmdir(struct inode *dir, struct dentry *dentry)
 end_rmdir:
 	ext4_journal_stop(handle);
 	brelse(bh);
+	ext4_shrink_directory(&dc);
 	return retval;
 }
 
@@ -2204,6 +2260,7 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
 	struct inode *inode;
 	struct buffer_head *bh;
 	struct ext4_dir_entry_2 *de;
+	struct ext4_dir_cleanup dc;
 	handle_t *handle;
 
 	/* Initialize quotas before so that eventual writes go
@@ -2233,7 +2290,7 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
 			     inode->i_ino, inode->i_nlink);
 		inode->i_nlink = 1;
 	}
-	retval = ext4_delete_entry(handle, dir, de, bh);
+	retval = ext4_delete_entry(handle, dir, de, bh, &dc);
 	if (retval)
 		goto end_unlink;
 	dir->i_ctime = dir->i_mtime = ext4_current_time(dir);
@@ -2249,6 +2306,7 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
 end_unlink:
 	ext4_journal_stop(handle);
 	brelse(bh);
+	ext4_shrink_directory(&dc);
 	return retval;
 }
 
@@ -2369,6 +2427,7 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct inode *old_inode, *new_inode;
 	struct buffer_head *old_bh, *new_bh, *dir_bh;
 	struct ext4_dir_entry_2 *old_de, *new_de;
+	struct ext4_dir_cleanup dc;
 	int retval, force_da_alloc = 0;
 
 	old_bh = new_bh = dir_bh = NULL;
@@ -2459,7 +2518,7 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	    old_de->name_len != old_dentry->d_name.len ||
 	    strncmp(old_de->name, old_dentry->d_name.name, old_de->name_len) ||
 	    (retval = ext4_delete_entry(handle, old_dir,
-					old_de, old_bh)) == -ENOENT) {
+					old_de, old_bh, &dc)) == -ENOENT) {
 		/* old_de could have moved from under us during htree split, so
 		 * make sure that we are deleting the right entry.  We might
 		 * also be pointing to a stale entry in the unused part of
@@ -2470,7 +2529,7 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 		old_bh2 = ext4_find_entry(old_dir, &old_dentry->d_name, &old_de2);
 		if (old_bh2) {
 			retval = ext4_delete_entry(handle, old_dir,
-						   old_de2, old_bh2);
+						   old_de2, old_bh2, &dc);
 			brelse(old_bh2);
 		}
 	}
@@ -2519,6 +2578,7 @@ end_rename:
 	brelse(old_bh);
 	brelse(new_bh);
 	ext4_journal_stop(handle);
+	ext4_shrink_directory(&dc);
 	if (retval == 0 && force_da_alloc)
 		ext4_alloc_da_blocks(old_inode);
 	return retval;
-- 
1.6.4


