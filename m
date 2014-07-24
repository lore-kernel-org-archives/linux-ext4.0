From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] ext4: check inline directory before converting
Date: Thu, 24 Jul 2014 14:22:22 -0700
Message-ID: <20140724212222.GG8628@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>, darrick.wong@oracle.com,
	Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19687 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759771AbaGXVWa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jul 2014 17:22:30 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Before converting an inline directory to a regular directory, check
the directory entries to make sure they're not obviously broken.
This helps us to avoid a BUG_ON if one of the dirents is trashed.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ext4/inline.c |   37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 645205d..c79d8e7 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1157,6 +1157,31 @@ out:
 	return err;
 }
 
+static int ext4_check_all_de(struct inode *dir, struct buffer_head *bh,
+			     void *buf, int buf_size)
+{
+	struct ext4_dir_entry_2 *de;
+	int nlen, rlen;
+	unsigned int offset = 0;
+	char *top;
+
+	de = (struct ext4_dir_entry_2 *)buf;
+	top = buf + buf_size;
+	while ((char *) de < top) {
+		if (ext4_check_dir_entry(dir, NULL, de, bh,
+					 buf, buf_size, offset))
+			return -EIO;
+		nlen = EXT4_DIR_REC_LEN(de->name_len);
+		rlen = ext4_rec_len_from_disk(de->rec_len, buf_size);
+		de = (struct ext4_dir_entry_2 *)((char *)de + rlen);
+		offset += rlen;
+	}
+	if ((char *) de > top)
+		return -EIO;
+
+	return 0;
+}
+
 static int ext4_convert_inline_data_nolock(handle_t *handle,
 					   struct inode *inode,
 					   struct ext4_iloc *iloc)
@@ -1178,6 +1203,18 @@ static int ext4_convert_inline_data_nolock(handle_t *handle,
 	if (error < 0)
 		goto out;
 
+	/*
+	 * Make sure the inline directory entries pass checks before we try to
+	 * convert them, so that we avoid touching stuff that needs fsck.
+	 */
+	if (S_ISDIR(inode->i_mode)) {
+		error = ext4_check_all_de(inode, iloc->bh,
+					buf + EXT4_INLINE_DOTDOT_SIZE,
+					inline_size - EXT4_INLINE_DOTDOT_SIZE);
+		if (error)
+			goto out;
+	}
+
 	error = ext4_destroy_inline_data_nolock(handle, inode);
 	if (error)
 		goto out;
