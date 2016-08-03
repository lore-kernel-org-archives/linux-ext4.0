From: Jan Kara <jack@suse.cz>
Subject: [PATCH 01/11] ext4: Fix xattr shifting when expanding inodes
Date: Wed,  3 Aug 2016 12:39:45 +0200
Message-ID: <1470220795-17045-2-git-send-email-jack@suse.cz>
References: <1470220795-17045-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
	Jan Kara <jack@suse.cz>, stable@vger.kernel.org#4.4.x-
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52213 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757566AbcHCKkZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Aug 2016 06:40:25 -0400
In-Reply-To: <1470220795-17045-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The code in ext4_expand_extra_isize_ea() treated new_extra_isize
argument sometimes as the desired target i_extra_isize and sometimes as
the amount by which we need to grow current i_extra_isize. These happen
to coincide when i_extra_isize is 0 which used to be the common case and
so nobody noticed this until recently when we added i_projid to the
inode and so i_extra_isize now needs to grow from 28 to 32 bytes.

The result of these bugs was that we sometimes unnecessarily decided to
move xattrs out of inode even if there was enough space and we often
ended up corrupting in-inode xattrs because arguments to
ext4_xattr_shift_entries() were just wrong. This could demonstrate
itself as BUG_ON in ext4_xattr_shift_entries() triggering.

Fix the problem by introducing new isize_diff variable and use it where
appropriate.

CC: <stable@vger.kernel.org> # 4.4.x-
Reported-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/xattr.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 39e9cfb1b371..cb1d7b4482de 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1353,11 +1353,13 @@ int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
 	size_t min_offs, free;
 	int total_ino;
 	void *base, *start, *end;
-	int extra_isize = 0, error = 0, tried_min_extra_isize = 0;
+	int error = 0, tried_min_extra_isize = 0;
 	int s_min_extra_isize = le16_to_cpu(EXT4_SB(inode->i_sb)->s_es->s_min_extra_isize);
+	int isize_diff;	/* How much do we need to grow i_extra_isize */
 
 	down_write(&EXT4_I(inode)->xattr_sem);
 retry:
+	isize_diff = new_extra_isize - EXT4_I(inode)->i_extra_isize;
 	if (EXT4_I(inode)->i_extra_isize >= new_extra_isize) {
 		up_write(&EXT4_I(inode)->xattr_sem);
 		return 0;
@@ -1382,7 +1384,7 @@ retry:
 		goto cleanup;
 
 	free = ext4_xattr_free_space(last, &min_offs, base, &total_ino);
-	if (free >= new_extra_isize) {
+	if (free >= isize_diff) {
 		entry = IFIRST(header);
 		ext4_xattr_shift_entries(entry,	EXT4_I(inode)->i_extra_isize
 				- new_extra_isize, (void *)raw_inode +
@@ -1414,7 +1416,7 @@ retry:
 		end = bh->b_data + bh->b_size;
 		min_offs = end - base;
 		free = ext4_xattr_free_space(first, &min_offs, base, NULL);
-		if (free < new_extra_isize) {
+		if (free < isize_diff) {
 			if (!tried_min_extra_isize && s_min_extra_isize) {
 				tried_min_extra_isize++;
 				new_extra_isize = s_min_extra_isize;
@@ -1428,7 +1430,7 @@ retry:
 		free = inode->i_sb->s_blocksize;
 	}
 
-	while (new_extra_isize > 0) {
+	while (isize_diff > 0) {
 		size_t offs, size, entry_size;
 		struct ext4_xattr_entry *small_entry = NULL;
 		struct ext4_xattr_info i = {
@@ -1459,7 +1461,7 @@ retry:
 			EXT4_XATTR_SIZE(le32_to_cpu(last->e_value_size)) +
 					EXT4_XATTR_LEN(last->e_name_len);
 			if (total_size <= free && total_size < min_total_size) {
-				if (total_size < new_extra_isize) {
+				if (total_size < isize_diff) {
 					small_entry = last;
 				} else {
 					entry = last;
@@ -1516,20 +1518,19 @@ retry:
 			goto cleanup;
 
 		entry = IFIRST(header);
-		if (entry_size + EXT4_XATTR_SIZE(size) >= new_extra_isize)
-			shift_bytes = new_extra_isize;
+		if (entry_size + EXT4_XATTR_SIZE(size) >= isize_diff)
+			shift_bytes = isize_diff;
 		else
 			shift_bytes = entry_size + size;
 		/* Adjust the offsets and shift the remaining entries ahead */
-		ext4_xattr_shift_entries(entry, EXT4_I(inode)->i_extra_isize -
-			shift_bytes, (void *)raw_inode +
-			EXT4_GOOD_OLD_INODE_SIZE + extra_isize + shift_bytes,
+		ext4_xattr_shift_entries(entry, -shift_bytes,
+			(void *)raw_inode + EXT4_GOOD_OLD_INODE_SIZE +
+			EXT4_I(inode)->i_extra_isize + shift_bytes,
 			(void *)header, total_ino - entry_size,
 			inode->i_sb->s_blocksize);
 
-		extra_isize += shift_bytes;
-		new_extra_isize -= shift_bytes;
-		EXT4_I(inode)->i_extra_isize = extra_isize;
+		isize_diff -= shift_bytes;
+		EXT4_I(inode)->i_extra_isize += shift_bytes;
 
 		i.name = b_entry_name;
 		i.value = buffer;
-- 
2.6.6

