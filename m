From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 5/4] ext4: check EA value offset when loading
Date: Thu, 11 Sep 2014 13:35:26 -0700
Message-ID: <20140911203526.GX10351@birch.djwong.org>
References: <20140911002818.10109.51772.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47043 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbaIKUfd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Sep 2014 16:35:33 -0400
Content-Disposition: inline
In-Reply-To: <20140911002818.10109.51772.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When loading extended attributes, check each entry's value offset to
make sure it doesn't collide with the entries.

Without this check it is easy to crash the kernel by mounting a
malicious FS containing a file with an EA wherein e_value_offs = 0 and
e_value_size > 0 and then deleting the EA, which corrupts the name
list.

(See the f_ea_value_crash test's FS image in e2fsprogs for an example.)

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ext4/xattr.c |   34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index e738733..c11738e 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -189,15 +189,29 @@ ext4_listxattr(struct dentry *dentry, char *buffer, size_t size)
 	return ext4_xattr_list(dentry, buffer, size);
 }
 
-static int
-ext4_xattr_check_names(struct ext4_xattr_entry *entry, void *end)
+int
+ext4_xattr_check_names(struct ext4_xattr_entry *entry, void *end,
+		       void *value_start)
 {
-	while (!IS_LAST_ENTRY(entry)) {
-		struct ext4_xattr_entry *next = EXT4_XATTR_NEXT(entry);
+	struct ext4_xattr_entry *e = entry;
+
+	while (!IS_LAST_ENTRY(e)) {
+		struct ext4_xattr_entry *next = EXT4_XATTR_NEXT(e);
 		if ((void *)next >= end)
 			return -EIO;
-		entry = next;
+		e = next;
 	}
+
+	while (!IS_LAST_ENTRY(entry)) {
+		if (entry->e_value_size != 0 &&
+		    (value_start + le16_to_cpu(entry->e_value_offs) <
+		     (void *)e + sizeof(__u32) ||
+		     value_start + le16_to_cpu(entry->e_value_offs) +
+		    le32_to_cpu(entry->e_value_size) > end))
+			return -EIO;
+		entry = EXT4_XATTR_NEXT(entry);
+	}
+
 	return 0;
 }
 
@@ -214,7 +228,8 @@ ext4_xattr_check_block(struct inode *inode, struct buffer_head *bh)
 		return -EIO;
 	if (!ext4_xattr_block_csum_verify(inode, bh->b_blocknr, BHDR(bh)))
 		return -EIO;
-	error = ext4_xattr_check_names(BFIRST(bh), bh->b_data + bh->b_size);
+	error = ext4_xattr_check_names(BFIRST(bh), bh->b_data + bh->b_size,
+				       bh->b_data);
 	if (!error)
 		set_buffer_verified(bh);
 	return error;
@@ -331,7 +346,7 @@ ext4_xattr_ibody_get(struct inode *inode, int name_index, const char *name,
 	header = IHDR(inode, raw_inode);
 	entry = IFIRST(header);
 	end = (void *)raw_inode + EXT4_SB(inode->i_sb)->s_inode_size;
-	error = ext4_xattr_check_names(entry, end);
+	error = ext4_xattr_check_names(entry, end, entry);
 	if (error)
 		goto cleanup;
 	error = ext4_xattr_find_entry(&entry, name_index, name,
@@ -463,7 +478,7 @@ ext4_xattr_ibody_list(struct dentry *dentry, char *buffer, size_t buffer_size)
 	raw_inode = ext4_raw_inode(&iloc);
 	header = IHDR(inode, raw_inode);
 	end = (void *)raw_inode + EXT4_SB(inode->i_sb)->s_inode_size;
-	error = ext4_xattr_check_names(IFIRST(header), end);
+	error = ext4_xattr_check_names(IFIRST(header), end, IFIRST(header));
 	if (error)
 		goto cleanup;
 	error = ext4_xattr_list_entries(dentry, IFIRST(header),
@@ -986,7 +1001,8 @@ int ext4_xattr_ibody_find(struct inode *inode, struct ext4_xattr_info *i,
 	is->s.here = is->s.first;
 	is->s.end = (void *)raw_inode + EXT4_SB(inode->i_sb)->s_inode_size;
 	if (ext4_test_inode_state(inode, EXT4_STATE_XATTR)) {
-		error = ext4_xattr_check_names(IFIRST(header), is->s.end);
+		error = ext4_xattr_check_names(IFIRST(header), is->s.end,
+					       IFIRST(header));
 		if (error)
 			return error;
 		/* Find the named attribute. */
