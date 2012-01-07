From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 19/51] libext2fs: Verify and calculate extent tree block
	checksums
Date: Sat, 07 Jan 2012 00:34:58 -0800
Message-ID: <20120107083458.25788.65429.stgit@elm3c44.beaverton.ibm.com>
References: <20120107083256.25788.41238.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:34089 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455Ab2AGIf6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 7 Jan 2012 03:35:58 -0500
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Sat, 7 Jan 2012 01:35:58 -0700
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q078Z1OQ112186
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jan 2012 01:35:01 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q078YxFP019963
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jan 2012 01:35:00 -0700
In-Reply-To: <20120107083256.25788.41238.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Verify and calculate extent tree block checksums when processing filesystems.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 lib/ext2fs/csum.c         |   79 +++++++++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/ext2_err.et.in |    3 ++
 lib/ext2fs/ext2fs.h       |    6 +++
 lib/ext2fs/extent.c       |   21 ++++++++++++
 4 files changed, 109 insertions(+), 0 deletions(-)


diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
index 5c5b7fb..8a0543c 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -30,6 +30,85 @@
 #define STATIC static
 #endif
 
+#define EXT3_EXTENT_TAIL_OFFSET(hdr)	(sizeof(struct ext3_extent_header) + \
+	(sizeof(struct ext3_extent) * ext2fs_le16_to_cpu((hdr)->eh_max)))
+
+static struct ext3_extent_tail *get_extent_tail(struct ext3_extent_header *h)
+{
+	return (struct ext3_extent_tail *)(((void *)h) +
+					   EXT3_EXTENT_TAIL_OFFSET(h));
+}
+
+static errcode_t ext2fs_extent_block_csum(ext2_filsys fs, ext2_ino_t inum,
+					  struct ext3_extent_header *eh,
+					  __u32 *crc)
+{
+	int size;
+	__u32 gen;
+	errcode_t retval;
+	struct ext2_inode inode;
+
+	size = EXT3_EXTENT_TAIL_OFFSET(eh) + offsetof(struct ext3_extent_tail,
+						      et_checksum);
+
+	retval = ext2fs_read_inode(fs, inum, &inode);
+	if (retval)
+		return retval;
+	inum = ext2fs_cpu_to_le32(inum);
+	gen = ext2fs_cpu_to_le32(inode.i_generation);
+	*crc = ext2fs_crc32c_le(fs->csum_seed, (unsigned char *)&inum,
+				sizeof(inum));
+	*crc = ext2fs_crc32c_le(*crc, (unsigned char *)&gen, sizeof(gen));
+	*crc = ext2fs_crc32c_le(*crc, (unsigned char *)eh, size);
+
+	return 0;
+}
+
+int ext2fs_extent_block_csum_verify(ext2_filsys fs, ext2_ino_t inum,
+				    struct ext3_extent_header *eh)
+{
+	errcode_t retval;
+	__u32 provided, calculated;
+	struct ext3_extent_tail *t = get_extent_tail(eh);
+
+	/*
+	 * The extent tree structures are accessed in LE order, so we must
+	 * swap the checksum bytes here.
+	 */
+	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return 1;
+
+	provided = ext2fs_le32_to_cpu(t->et_checksum);
+	retval = ext2fs_extent_block_csum(fs, inum, eh, &calculated);
+	if (retval)
+		return 0;
+
+	return provided == calculated;
+}
+
+errcode_t ext2fs_extent_block_csum_set(ext2_filsys fs, ext2_ino_t inum,
+				       struct ext3_extent_header *eh)
+{
+	errcode_t retval;
+	__u32 crc;
+	struct ext3_extent_tail *t = get_extent_tail(eh);
+
+	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return 0;
+
+	/*
+	 * The extent tree structures are accessed in LE order, so we must
+	 * swap the checksum bytes here.
+	 */
+	retval = ext2fs_extent_block_csum(fs, inum, eh, &crc);
+	if (retval)
+		return retval;
+	t->et_checksum = ext2fs_cpu_to_le32(crc);
+	return retval;
+}
+
 int ext2fs_inode_bitmap_csum_verify(ext2_filsys fs, dgrp_t group,
 				    char *bitmap, int size)
 {
diff --git a/lib/ext2fs/ext2_err.et.in b/lib/ext2fs/ext2_err.et.in
index 3f5d08f..9019026 100644
--- a/lib/ext2fs/ext2_err.et.in
+++ b/lib/ext2fs/ext2_err.et.in
@@ -449,4 +449,7 @@ ec	EXT2_ET_INODE_CSUM_INVALID,
 ec	EXT2_ET_INODE_BITMAP_CSUM_INVALID,
 	"Inode bitmap checksum does not match bitmap"
 
+ec	EXT2_ET_EXTENT_CSUM_INVALID,
+	"Extent block checksum does not match extent block"
+
 	end
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 921ecb2..5fa809a 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -943,6 +943,12 @@ extern __u32 ext2fs_crc32c_be(__u32 crc, unsigned char const *p, size_t len);
 extern __u32 ext2fs_crc32c_le(__u32 crc, unsigned char const *p, size_t len);
 
 /* csum.c */
+extern errcode_t ext2fs_extent_block_csum_set(ext2_filsys fs,
+					      ext2_ino_t inum,
+					      struct ext3_extent_header *eh);
+extern int ext2fs_extent_block_csum_verify(ext2_filsys fs,
+					   ext2_ino_t inum,
+					   struct ext3_extent_header *eh);
 extern errcode_t ext2fs_block_bitmap_csum_set(ext2_filsys fs, dgrp_t group,
 					      char *bitmap, int size);
 extern int ext2fs_block_bitmap_csum_verify(ext2_filsys fs, dgrp_t group,
diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index eb096d6..7d456ef 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -455,6 +455,13 @@ retry:
 			return retval;
 		}
 
+		if (!(handle->fs->flags & EXT2_FLAG_IGNORE_CSUM_ERRORS) &&
+		    !ext2fs_extent_block_csum_verify(handle->fs, handle->ino,
+						     eh)) {
+			handle->level--;
+			return EXT2_ET_EXTENT_CSUM_INVALID;
+		}
+
 		newpath->left = newpath->entries =
 			ext2fs_le16_to_cpu(eh->eh_entries);
 		newpath->max_entries = ext2fs_le16_to_cpu(eh->eh_max);
@@ -541,6 +548,7 @@ static errcode_t update_path(ext2_extent_handle_t handle)
 	blk64_t				blk;
 	errcode_t			retval;
 	struct ext3_extent_idx		*ix;
+	struct ext3_extent_header	*eh;
 
 	if (handle->level == 0) {
 		retval = ext2fs_write_inode(handle->fs, handle->ino,
@@ -550,6 +558,14 @@ static errcode_t update_path(ext2_extent_handle_t handle)
 		blk = ext2fs_le32_to_cpu(ix->ei_leaf) +
 			((__u64) ext2fs_le16_to_cpu(ix->ei_leaf_hi) << 32);
 
+		/* then update the checksum */
+		eh = (struct ext3_extent_header *)
+				handle->path[handle->level].buf;
+		retval = ext2fs_extent_block_csum_set(handle->fs, handle->ino,
+						      eh);
+		if (retval)
+			return retval;
+
 		retval = io_channel_write_blk64(handle->fs->io,
 				      blk, 1, handle->path[handle->level].buf);
 	}
@@ -958,6 +974,11 @@ static errcode_t extent_node_split(ext2_extent_handle_t handle)
 
 	new_node_start = ext2fs_le32_to_cpu(EXT_FIRST_INDEX(neweh)->ei_block);
 
+	/* then update the checksum */
+	retval = ext2fs_extent_block_csum_set(handle->fs, handle->ino, neweh);
+	if (retval)
+		goto done;
+
 	/* ...and write the new node block out to disk. */
 	retval = io_channel_write_blk64(handle->fs->io, new_node_pblk, 1,
 					block_buf);

