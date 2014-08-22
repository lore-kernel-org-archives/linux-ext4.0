From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 6/6] ext4: convert do_split() to use ERR_PTR convention
Date: Fri, 22 Aug 2014 03:29:50 -0400
Message-ID: <1408692590-13346-7-git-send-email-tytso@mit.edu>
References: <1408692590-13346-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44046 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755883AbaHVHaB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Aug 2014 03:30:01 -0400
In-Reply-To: <1408692590-13346-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/namei.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index d4f5832..ddca7b4 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1509,7 +1509,7 @@ static struct ext4_dir_entry_2* dx_pack_dirents(char *base, unsigned blocksize)
  */
 static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 			struct buffer_head **bh,struct dx_frame *frame,
-			struct dx_hash_info *hinfo, int *error)
+			struct dx_hash_info *hinfo)
 {
 	unsigned blocksize = dir->i_sb->s_blocksize;
 	unsigned count, continued;
@@ -1532,8 +1532,7 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 	if (IS_ERR(bh2)) {
 		brelse(*bh);
 		*bh = NULL;
-		*error = PTR_ERR(bh2);
-		return NULL;
+		return (struct ext4_dir_entry_2 *) bh2;
 	}
 
 	BUFFER_TRACE(*bh, "get_write_access");
@@ -1593,8 +1592,7 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 	dxtrace(dx_show_leaf (hinfo, (struct ext4_dir_entry_2 *) data2, blocksize, 1));
 
 	/* Which block gets the new entry? */
-	if (hinfo->hash >= hash2)
-	{
+	if (hinfo->hash >= hash2) {
 		swap(*bh, bh2);
 		de = de2;
 	}
@@ -1614,8 +1612,7 @@ journal_error:
 	brelse(bh2);
 	*bh = NULL;
 	ext4_std_error(dir->i_sb, err);
-	*error = err;
-	return NULL;
+	return ERR_PTR(err);
 }
 
 int ext4_find_dest_de(struct inode *dir, struct inode *inode,
@@ -1838,8 +1835,8 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
 	ext4_handle_dirty_dx_node(handle, dir, frame->bh);
 	ext4_handle_dirty_dirent_node(handle, dir, bh);
 
-	de = do_split(handle,dir, &bh, frame, &hinfo, &retval);
-	if (!de) {
+	de = do_split(handle,dir, &bh, frame, &hinfo);
+	if (IS_ERR(de)) {
 		/*
 		 * Even if the block split failed, we have to properly write
 		 * out all the changes we did so far. Otherwise we can end up
@@ -1847,7 +1844,7 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
 		 */
 		ext4_mark_inode_dirty(handle, dir);
 		dx_release(frames);
-		return retval;
+		return PTR_ERR(de);
 	}
 	dx_release(frames);
 
@@ -2071,9 +2068,11 @@ static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
 			goto cleanup;
 		}
 	}
-	de = do_split(handle, dir, &bh, frame, &hinfo, &err);
-	if (!de)
+	de = do_split(handle, dir, &bh, frame, &hinfo);
+	if (IS_ERR(de)) {
+		err = PTR_ERR(de);
 		goto cleanup;
+	}
 	err = add_dirent_to_buf(handle, dentry, inode, de, bh);
 	goto cleanup;
 
-- 
2.1.0

