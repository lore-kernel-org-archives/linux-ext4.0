From: Jan Kara <jack@suse.cz>
Subject: [PATCH 11/11] ext4: Factor out loop for freeing inode xattr space
Date: Wed,  3 Aug 2016 12:39:55 +0200
Message-ID: <1470220795-17045-12-git-send-email-jack@suse.cz>
References: <1470220795-17045-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
	Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52261 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757668AbcHCKlY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Aug 2016 06:41:24 -0400
In-Reply-To: <1470220795-17045-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Move loop to make enough space in the inode from
ext4_expand_extra_isize_ea() into a separate function to make that
function smaller and better readable and also to avoid delaration of
variables inside a loop block.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/xattr.c | 121 ++++++++++++++++++++++++++++++++------------------------
 1 file changed, 69 insertions(+), 52 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 2ef687620205..c15d63389957 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1417,6 +1417,63 @@ out:
 	return error;
 }
 
+static int ext4_xattr_make_inode_space(handle_t *handle, struct inode *inode,
+				       struct ext4_inode *raw_inode,
+				       int isize_diff, size_t ifree,
+				       size_t bfree, int *total_ino)
+{
+	struct ext4_xattr_ibody_header *header = IHDR(inode, raw_inode);
+	struct ext4_xattr_entry *small_entry;
+	struct ext4_xattr_entry *entry;
+	struct ext4_xattr_entry *last;
+	unsigned int entry_size;	/* EA entry size */
+	unsigned int total_size;	/* EA entry size + value size */
+	unsigned int min_total_size;
+	int error;
+
+	while (isize_diff > ifree) {
+		entry = NULL;
+		small_entry = NULL;
+		min_total_size = ~0U;
+		last = IFIRST(header);
+		/* Find the entry best suited to be pushed into EA block */
+		for (; !IS_LAST_ENTRY(last); last = EXT4_XATTR_NEXT(last)) {
+			total_size =
+			EXT4_XATTR_SIZE(le32_to_cpu(last->e_value_size)) +
+					EXT4_XATTR_LEN(last->e_name_len);
+			if (total_size <= bfree &&
+			    total_size < min_total_size) {
+				if (total_size + ifree < isize_diff) {
+					small_entry = last;
+				} else {
+					entry = last;
+					min_total_size = total_size;
+				}
+			}
+		}
+
+		if (entry == NULL) {
+			if (small_entry == NULL)
+				return -ENOSPC;
+			entry = small_entry;
+		}
+
+		entry_size = EXT4_XATTR_LEN(entry->e_name_len);
+		total_size = entry_size +
+			EXT4_XATTR_SIZE(le32_to_cpu(entry->e_value_size));
+		error = ext4_xattr_move_to_block(handle, inode, raw_inode,
+						 entry);
+		if (error)
+			return error;
+
+		*total_ino -= entry_size;
+		ifree += total_size;
+		bfree -= total_size;
+	}
+
+	return 0;
+}
+
 /*
  * Expand an inode by new_extra_isize bytes when EAs are present.
  * Returns 0 on success or negative error number on failure.
@@ -1491,66 +1548,26 @@ retry:
 				brelse(bh);
 				goto retry;
 			}
-			error = -1;
+			error = -ENOSPC;
 			goto cleanup;
 		}
 	} else {
 		bfree = inode->i_sb->s_blocksize;
 	}
 
-	while (isize_diff > ifree) {
-		struct ext4_xattr_entry *small_entry = NULL, *entry = NULL;
-		struct ext4_xattr_entry *last;
-		unsigned int entry_size;	/* EA entry size */
-		unsigned int total_size;	/* EA entry size + value size */
-		unsigned int min_total_size = ~0U;
-
-		last = IFIRST(header);
-		/* Find the entry best suited to be pushed into EA block */
-		for (; !IS_LAST_ENTRY(last); last = EXT4_XATTR_NEXT(last)) {
-			total_size =
-			EXT4_XATTR_SIZE(le32_to_cpu(last->e_value_size)) +
-					EXT4_XATTR_LEN(last->e_name_len);
-			if (total_size <= bfree &&
-			    total_size < min_total_size) {
-				if (total_size + ifree < isize_diff) {
-					small_entry = last;
-				} else {
-					entry = last;
-					min_total_size = total_size;
-				}
-			}
-		}
-
-		if (entry == NULL) {
-			if (small_entry) {
-				entry = small_entry;
-			} else {
-				if (!tried_min_extra_isize &&
-				    s_min_extra_isize) {
-					tried_min_extra_isize++;
-					new_extra_isize = s_min_extra_isize;
-					brelse(bh);
-					goto retry;
-				}
-				error = -1;
-				goto cleanup;
-			}
+	error = ext4_xattr_make_inode_space(handle, inode, raw_inode,
+					    isize_diff, ifree, bfree,
+					    &total_ino);
+	if (error) {
+		if (error == -ENOSPC && !tried_min_extra_isize &&
+		    s_min_extra_isize) {
+			tried_min_extra_isize++;
+			new_extra_isize = s_min_extra_isize;
+			brelse(bh);
+			goto retry;
 		}
-
-		entry_size = EXT4_XATTR_LEN(entry->e_name_len);
-		total_size = entry_size +
-			EXT4_XATTR_SIZE(le32_to_cpu(entry->e_value_size));
-		error = ext4_xattr_move_to_block(handle, inode, raw_inode,
-						 entry);
-		if (error)
-			goto cleanup;
-
-		total_ino -= entry_size;
-		ifree += total_size;
-		bfree -= total_size;
+		goto cleanup;
 	}
