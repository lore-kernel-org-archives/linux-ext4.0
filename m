From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH FOR-STABLE-2.6.27 22/24] ext4: Add sanity check to make_indexed_dir
Date: Tue, 17 Feb 2009 10:58:42 -0500
Message-ID: <1234886324-15105-23-git-send-email-tytso@mit.edu>
References: <1234886324-15105-1-git-send-email-tytso@mit.edu>
 <1234886324-15105-2-git-send-email-tytso@mit.edu>
 <1234886324-15105-3-git-send-email-tytso@mit.edu>
 <1234886324-15105-4-git-send-email-tytso@mit.edu>
 <1234886324-15105-5-git-send-email-tytso@mit.edu>
 <1234886324-15105-6-git-send-email-tytso@mit.edu>
 <1234886324-15105-7-git-send-email-tytso@mit.edu>
 <1234886324-15105-8-git-send-email-tytso@mit.edu>
 <1234886324-15105-9-git-send-email-tytso@mit.edu>
 <1234886324-15105-10-git-send-email-tytso@mit.edu>
 <1234886324-15105-11-git-send-email-tytso@mit.edu>
 <1234886324-15105-12-git-send-email-tytso@mit.edu>
 <1234886324-15105-13-git-send-email-tytso@mit.edu>
 <1234886324-15105-14-git-send-email-tytso@mit.edu>
 <1234886324-15105-15-git-send-email-tytso@mit.edu>
 <1234886324-15105-16-git-send-email-tytso@mit.edu>
 <1234886324-15105-17-git-send-email-tytso@mit.edu>
 <1234886324-15105-18-git-send-email-tytso@mit.edu>
 <1234886324-15105-19-git-send-email-tytso@mit.edu>
 <1234886324-15105-20-git-send-email-tytso@mit.edu>
 <1234886324-15105-21-git-send-email-tytso@mit.edu>
 <1234886324-15105-22-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:56262 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669AbZBQQPU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Feb 2009 11:15:20 -0500
In-Reply-To: <1234886324-15105-22-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Make sure the rec_len field in the '..' entry is sane, lest we overrun
the directory block and cause a kernel oops on a purposefully
corrupted filesystem.

Thanks to Sami Liedes for reporting this bug.

http://bugzilla.kernel.org/show_bug.cgi?id=12430

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@kernel.org
(cherry picked from commit e6b8bc09ba2075cd91fbffefcd2778b1a00bd76f)
---
 fs/ext4/namei.c |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 8f0881b..4f3628f 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1382,7 +1382,7 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
 	struct fake_dirent *fde;
 
 	blocksize =  dir->i_sb->s_blocksize;
-	dxtrace(printk("Creating index\n"));
+	dxtrace(printk(KERN_DEBUG "Creating index: inode %lu\n", dir->i_ino));
 	retval = ext4_journal_get_write_access(handle, bh);
 	if (retval) {
 		ext4_std_error(dir->i_sb, retval);
@@ -1391,6 +1391,20 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
 	}
 	root = (struct dx_root *) bh->b_data;
 
+	/* The 0th block becomes the root, move the dirents out */
+	fde = &root->dotdot;
+	de = (struct ext4_dir_entry_2 *)((char *)fde +
+		ext4_rec_len_from_disk(fde->rec_len));
+	if ((char *) de >= (((char *) root) + blocksize)) {
+		ext4_error(dir->i_sb, __func__,
+			   "invalid rec_len for '..' in inode %lu",
+			   dir->i_ino);
+		brelse(bh);
+		return -EIO;
+	}
+	len = ((char *) root) + blocksize - (char *) de;
+
+	/* Allocate new block for the 0th block's dirents */
 	bh2 = ext4_append (handle, dir, &block, &retval);
 	if (!(bh2)) {
 		brelse(bh);
@@ -1399,11 +1413,6 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
 	EXT4_I(dir)->i_flags |= EXT4_INDEX_FL;
 	data1 = bh2->b_data;
 
-	/* The 0th block becomes the root, move the dirents out */
-	fde = &root->dotdot;
-	de = (struct ext4_dir_entry_2 *)((char *)fde +
-		ext4_rec_len_from_disk(fde->rec_len));
-	len = ((char *) root) + blocksize - (char *) de;
 	memcpy (data1, de, len);
 	de = (struct ext4_dir_entry_2 *) data1;
 	top = data1 + len;
-- 
1.5.6.3

