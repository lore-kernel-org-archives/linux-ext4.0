From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: [ext3,ext4] old bug in htree_dirblock_to_tree()
Date: Mon, 17 Jun 2013 16:23:38 +0100
Message-ID: <20130617152338.GS4165@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

	Both ext3 and ext4 htree_dirblock_to_tree() is just filling
the in-core rbtree for use by call_filldir().  All updates of
->f_pos are done by the latter; bumping it here (on error) is obviously
wrong - we might very well have it nowhere near the block we'd found
an error in.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 7523c61f..998ea11 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -576,11 +576,8 @@ static int htree_dirblock_to_tree(struct file *dir_file,
 		if (!ext3_check_dir_entry("htree_dirblock_to_tree", dir, de, bh,
 					(block<<EXT3_BLOCK_SIZE_BITS(dir->i_sb))
 						+((char *)de - bh->b_data))) {
-			/* On error, skip the f_pos to the next block. */
-			dir_file->f_pos = (dir_file->f_pos |
-					(dir->i_sb->s_blocksize - 1)) + 1;
-			brelse (bh);
-			return count;
+			/* silently ignore the rest of the block */
+			break;
 		}
 		ext3fs_dirhash(de->name, de->name_len, hinfo);
 		if ((hinfo->hash < start_hash) ||
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 6653fc3..ab2f6dc 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -918,11 +918,8 @@ static int htree_dirblock_to_tree(struct file *dir_file,
 				bh->b_data, bh->b_size,
 				(block<<EXT4_BLOCK_SIZE_BITS(dir->i_sb))
 					 + ((char *)de - bh->b_data))) {
-			/* On error, skip the f_pos to the next block. */
-			dir_file->f_pos = (dir_file->f_pos |
-					(dir->i_sb->s_blocksize - 1)) + 1;
-			brelse(bh);
-			return count;
+			/* silently ignore the rest of the block */
+			break;
 		}
 		ext4fs_dirhash(de->name, de->name_len, hinfo);
 		if ((hinfo->hash < start_hash) ||
