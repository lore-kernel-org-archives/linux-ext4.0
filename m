From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 56/54] libext2fs: zero hash in ibody extended attributes
Date: Thu, 19 Mar 2015 14:45:51 -0700
Message-ID: <20150319214551.GK11031@birch.djwong.org>
References: <20150127073533.13308.44994.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39736 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbbCSVp4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Mar 2015 17:45:56 -0400
Content-Disposition: inline
In-Reply-To: <20150127073533.13308.44994.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The kernel never updates the extended attribute hash value for
attributes stored in the inode.  However, fsck has always checked this
value (if it's nonzero) and will complain if the hash doesn't match
the xattr.  Therefore, always zero the hash value when writing to
in-ibody xattrs to avoid creating "corrupt" attribute errors
downstream.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/ext_attr.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index df512d8..f8fe691 100644
--- a/lib/ext2fs/ext_attr.c
+++ b/lib/ext2fs/ext_attr.c
@@ -434,7 +434,8 @@ static errcode_t write_xattrs_to_buffer(struct ext2_xattr_handle *handle,
 					struct ext2_xattr **pos,
 					void *entries_start,
 					unsigned int storage_size,
-					unsigned int value_offset_correction)
+					unsigned int value_offset_correction,
+					int write_hash)
 {
 	struct ext2_xattr *x = *pos;
 	struct ext2_ext_attr_entry *e = entries_start;
@@ -481,7 +482,10 @@ static errcode_t write_xattrs_to_buffer(struct ext2_xattr_handle *handle,
 		memcpy((void *)e + sizeof(*e), shortname, e->e_name_len);
 		memcpy(end, x->value, e->e_value_size);
 
-		e->e_hash = ext2fs_ext_attr_hash_entry(e, end);
+		if (write_hash)
+			e->e_hash = ext2fs_ext_attr_hash_entry(e, end);
+		else
+			e->e_hash = 0;
 
 		e = EXT2_EXT_ATTR_NEXT(e);
 		*(__u32 *)e = 0;
@@ -553,7 +557,7 @@ errcode_t ext2fs_xattrs_write(struct ext2_xattr_handle *handle)
 	start = ((char *) inode) + EXT2_GOOD_OLD_INODE_SIZE +
 		inode->i_extra_isize + sizeof(__u32);
 
-	err = write_xattrs_to_buffer(handle, &x, start, storage_size, 0);
+	err = write_xattrs_to_buffer(handle, &x, start, storage_size, 0, 0);
 	if (err)
 		goto out;
 
@@ -572,7 +576,7 @@ write_ea_block:
 	start = block_buf + sizeof(struct ext2_ext_attr_header);
 
 	err = write_xattrs_to_buffer(handle, &x, start, storage_size,
-				     (void *)start - block_buf);
+				     (void *)start - block_buf, 1);
 	if (err)
 		goto out2;
 
