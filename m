From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 20/37] libext2fs: Verify and calculate extent tree block
	checksums
Date: Wed, 31 Aug 2011 17:37:19 -0700
Message-ID: <20110901003719.1176.60330.stgit@elm3c44.beaverton.ibm.com>
References: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e33.co.us.ibm.com ([32.97.110.151]:43676 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756837Ab1IAAh3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 31 Aug 2011 20:37:29 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e33.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p810TP2U025631
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 18:29:25 -0600
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p810bMdx121818
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 18:37:22 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p7VIbJ8i026187
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 12:37:21 -0600
In-Reply-To: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Verify and calculate extent tree block checksums when processing filesystems.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 lib/ext2fs/csum.c         |   64 +++++++++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/ext2fs.h       |    8 ++++++
 lib/ext2fs/ext3_extents.h |   11 ++++++++
 lib/ext2fs/extent.c       |   16 +++++++++++
 4 files changed, 99 insertions(+), 0 deletions(-)


diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
index f594c90..fdca971 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -29,6 +29,70 @@
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
+__u32 ext2fs_extent_block_csum(ext2_filsys fs, ext2_ino_t inum,
+			       struct ext3_extent_header *eh)
+{
+	int size;
+	__u32 crc = 0;
+
+	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return 0;
+
+	size = EXT3_EXTENT_TAIL_OFFSET(eh) + offsetof(struct ext3_extent_tail,
+						      et_checksum);
+
+	inum = ext2fs_cpu_to_le32(inum);
+	crc = crc32c_le(~0, fs->super->s_uuid, sizeof(fs->super->s_uuid));
+	crc = crc32c_le(crc, (char *)&inum, sizeof(inum));
+	crc = crc32c_le(crc, (char *)eh, size);
+
+	return crc;
+}
+
+int ext2fs_extent_block_csum_verify(ext2_filsys fs, ext2_ino_t inum,
+				    struct ext3_extent_header *eh)
+{
+	struct ext3_extent_tail *t = get_extent_tail(eh);
+
+	/*
+	 * The extent tree structures are accessed in LE order, so we must
+	 * swap the checksum bytes here.
+	 */
+	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
+	    ext2fs_le32_to_cpu(t->et_checksum) !=
+	    ext2fs_extent_block_csum(fs, inum, eh))
+		return 0;
+	return 1;
+}
+
+void ext2fs_extent_block_csum_set(ext2_filsys fs, ext2_ino_t inum,
+				  struct ext3_extent_header *eh)
+{
+	struct ext3_extent_tail *t = get_extent_tail(eh);
+
+	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return;
+
+	/*
+	 * The extent tree structures are accessed in LE order, so we must
+	 * swap the checksum bytes here.
+	 */
+	t->et_checksum = ext2fs_cpu_to_le32(ext2fs_extent_block_csum(fs, inum,
+								     eh));
+}
+
 __u32 ext2fs_bitmap_csum(ext2_filsys fs, dgrp_t group, char *bitmap, int size)
 {
 	__u32 crc = 0;
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 0cc3012..1e3e9f1 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -894,6 +894,14 @@ extern __u32 crc32c_be(__u32 crc, unsigned char const *p, size_t len);
 extern __u32 crc32c_le(__u32 crc, unsigned char const *p, size_t len);
 
 /* csum.c */
+extern __u32 ext2fs_extent_block_csum(ext2_filsys fs, ext2_ino_t inum,
+				      struct ext3_extent_header *eh);
+extern int ext2fs_extent_block_csum_verify(ext2_filsys fs,
+					   ext2_ino_t inum,
+					   struct ext3_extent_header *eh);
+extern void ext2fs_extent_block_csum_set(ext2_filsys fs,
+					 ext2_ino_t inum,
+					 struct ext3_extent_header *eh);
 extern __u32 ext2fs_bitmap_csum(ext2_filsys fs, dgrp_t group, char *bitmap,
 				int size);
 extern int ext2fs_bitmap_csum_verify(ext2_filsys fs, dgrp_t group,
diff --git a/lib/ext2fs/ext3_extents.h b/lib/ext2fs/ext3_extents.h
index 88fabc9..99a4f47 100644
--- a/lib/ext2fs/ext3_extents.h
+++ b/lib/ext2fs/ext3_extents.h
@@ -19,6 +19,17 @@
  */
 
 /*
+ * This is extent tail on-disk structure.
+ * All other extent structures are 12 bytes long.  It turns out that
+ * block_size % 12 >= 4 for all valid block sizes (1k, 2k, 4k).
+ * Therefore, this tail structure can be crammed into the end of the block
+ * without having to rebalance the tree.
+ */
+struct ext3_extent_tail {
+	__u32	et_checksum;	/* crc32c(uuid+inum+extent_block) */
+};
+
+/*
  * this is extent on-disk structure
  * it's used at the bottom of the tree
  */
diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index 33f1a88..d19af48 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -452,6 +452,13 @@ retry:
 			return retval;
 		}
 
+		if (!(handle->fs->flags & EXT2_FLAG_IGNORE_CSUM_ERRORS) &&
+		    !ext2fs_extent_block_csum_verify(handle->fs, handle->ino,
+						     eh)) {
+			handle->level--;
+			return EXT2_ET_EXTENT_HEADER_BAD;
+		}
+
 		newpath->left = newpath->entries =
 			ext2fs_le16_to_cpu(eh->eh_entries);
 		newpath->max_entries = ext2fs_le16_to_cpu(eh->eh_max);
@@ -538,6 +545,7 @@ static errcode_t update_path(ext2_extent_handle_t handle)
 	blk64_t				blk;
 	errcode_t			retval;
 	struct ext3_extent_idx		*ix;
+	struct ext3_extent_header	*eh;
 
 	if (handle->level == 0) {
 		retval = ext2fs_write_inode(handle->fs, handle->ino,
@@ -547,6 +555,11 @@ static errcode_t update_path(ext2_extent_handle_t handle)
 		blk = ext2fs_le32_to_cpu(ix->ei_leaf) +
 			((__u64) ext2fs_le16_to_cpu(ix->ei_leaf_hi) << 32);
 
+		/* then update the checksum */
+		eh = (struct ext3_extent_header *)
+				handle->path[handle->level].buf;
+		ext2fs_extent_block_csum_set(handle->fs, handle->ino, eh);
+
 		retval = io_channel_write_blk64(handle->fs->io,
 				      blk, 1, handle->path[handle->level].buf);
 	}
@@ -955,6 +968,9 @@ static errcode_t extent_node_split(ext2_extent_handle_t handle)
 
 	new_node_start = ext2fs_le32_to_cpu(EXT_FIRST_INDEX(neweh)->ei_block);
 
+	/* then update the checksum */
+	ext2fs_extent_block_csum_set(handle->fs, handle->ino, neweh);
+
 	/* ...and write the new node block out to disk. */
 	retval = io_channel_write_blk64(handle->fs->io, new_node_pblk, 1,
 					block_buf);

