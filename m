From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH, RFC 2/2] ext3: Add sanity check to make_indexed_dir
Date: Fri, 16 Jan 2009 12:00:01 -0500
Message-ID: <1232125201-14075-2-git-send-email-tytso@mit.edu>
References: <1232125201-14075-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, stable@kernel.org
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:45260 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935508AbZAPRAE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Jan 2009 12:00:04 -0500
In-Reply-To: <1232125201-14075-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Make sure the rec_len field in the '..' entry is sane, lest we overrun
the directory block and cause a kernel oops on a purposefully
corrupted filesystem.

This fixes a bug related to a bug originally reported by Sami Liedes
for ext4 at:

http://bugzilla.kernel.org/show_bug.cgi?id=12430

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@kernel.org
---
 fs/ext3/namei.c |   20 ++++++++++++++------
 1 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 69a3d19..4db4ffa 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -1358,7 +1358,7 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
 	struct fake_dirent *fde;
 
 	blocksize =  dir->i_sb->s_blocksize;
-	dxtrace(printk("Creating index\n"));
+	dxtrace(printk(KERN_DEBUG "Creating index: inode %lu\n", dir->i_ino));
 	retval = ext3_journal_get_write_access(handle, bh);
 	if (retval) {
 		ext3_std_error(dir->i_sb, retval);
@@ -1367,6 +1367,19 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
 	}
 	root = (struct dx_root *) bh->b_data;
 
+	/* The 0th block becomes the root, move the dirents out */
+	fde = &root->dotdot;
+	de = (struct ext3_dir_entry_2 *)((char *)fde +
+			ext3_rec_len_from_disk(fde->rec_len));
+	if ((char *) de >= (((char *) root) + blocksize)) {
+		ext3_error(dir->i_sb, __func__,
+			   "invalid rec_len for '..' in inode %lu",
+			   dir->i_ino);
+		brelse(bh);
+		return -EIO;
+	}
+	len = ((char *) root) + blocksize - (char *) de;
+
 	bh2 = ext3_append (handle, dir, &block, &retval);
 	if (!(bh2)) {
 		brelse(bh);
@@ -1375,11 +1388,6 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
 	EXT3_I(dir)->i_flags |= EXT3_INDEX_FL;
 	data1 = bh2->b_data;
 
-	/* The 0th block becomes the root, move the dirents out */
-	fde = &root->dotdot;
-	de = (struct ext3_dir_entry_2 *)((char *)fde +
-			ext3_rec_len_from_disk(fde->rec_len));
-	len = ((char *) root) + blocksize - (char *) de;
 	memcpy (data1, de, len);
 	de = (struct ext3_dir_entry_2 *) data1;
 	top = data1 + len;
-- 
1.6.0.4.8.g36f27.dirty

