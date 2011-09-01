From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 29/37] libext2fs: Verify and calculate extended attribute
	block checksums
Date: Wed, 31 Aug 2011 17:38:17 -0700
Message-ID: <20110901003817.1176.13809.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e37.co.us.ibm.com ([32.97.110.158]:47086 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756849Ab1IAAi0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 31 Aug 2011 20:38:26 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e37.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p810Z7P8028930
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 18:35:07 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p810cKF6147338
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 18:38:20 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p7VIbpIc010038
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 12:37:53 -0600
In-Reply-To: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Calculate and verify the checksum for separate (i.e. not in the inode) extended
attribute blocks; the checksum lives in the header.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 lib/ext2fs/csum.c          |   54 ++++++++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/ext2_err.et.in  |    3 ++
 lib/ext2fs/ext2_ext_attr.h |    3 ++
 lib/ext2fs/ext2fs.h        |    6 +++++
 lib/ext2fs/ext_attr.c      |   11 ++++++++-
 lib/ext2fs/swapfs.c        |    3 ++
 6 files changed, 77 insertions(+), 3 deletions(-)


diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
index a606b7c..4fe4b3d 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -29,6 +29,60 @@
 #define STATIC static
 #endif
 
+__u32 ext2fs_ext_attr_block_csum(ext2_filsys fs, blk64_t block,
+				 struct ext2_ext_attr_header *hdr)
+{
+	char *buf = (char *)hdr;
+	int offset = offsetof(struct ext2_ext_attr_header, h_checksum);
+	__u32 crc = 0;
+
+	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return 0;
+
+#ifdef WORDS_BIGENDIAN
+	errcode_t retval;
+
+	retval = ext2fs_get_mem(fs->blocksize, &buf);
+	if (retval)
+		return retval;
+	ext2fs_swap_ext_attr(buf, (char *)hdr, fs->blocksize, 1);
+#endif
+
+	block = ext2fs_cpu_to_le64(block);
+	crc = crc32c_le(~0, fs->super->s_uuid, sizeof(fs->super->s_uuid));
+	crc = crc32c_le(crc, (char *)&block, sizeof(block));
+	crc = crc32c_le(crc, buf, offset);
+	offset += sizeof(hdr->h_checksum); /* skip checksum */
+	crc = crc32c_le(crc, buf + offset, fs->blocksize - offset);
+
+#ifdef WORDS_BIGENDIAN
+	ext2fs_free_mem(&buf);
+#endif
+
+	return crc;
+}
+
+int ext2fs_ext_attr_block_csum_verify(ext2_filsys fs, blk64_t block,
+				      struct ext2_ext_attr_header *hdr)
+{
+	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
+	    (hdr->h_checksum != ext2fs_ext_attr_block_csum(fs, block, hdr)))
+		return 0;
+	return 1;
+}
+
+void ext2fs_ext_attr_block_csum_set(ext2_filsys fs, blk64_t block,
+				    struct ext2_ext_attr_header *hdr)
+{
+	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return;
+
+	hdr->h_checksum = ext2fs_ext_attr_block_csum(fs, block, hdr);
+}
+
 static struct ext2_dir_entry_tail *get_dirent_tail(ext2_filsys fs,
 						struct ext2_dir_entry *dirent)
 {
diff --git a/lib/ext2fs/ext2_err.et.in b/lib/ext2fs/ext2_err.et.in
index 31c8fe1..6e2c22c 100644
--- a/lib/ext2fs/ext2_err.et.in
+++ b/lib/ext2fs/ext2_err.et.in
@@ -431,4 +431,7 @@ ec	EXT2_ET_INODE_CORRUPT,
 ec	EXT2_ET_INODE_CSUM_NONZERO,
 	"Inode checksum should not be set"
 
+ec	EXT2_ET_EXT_ATTR_BLOCK_CORRUPT,
+	"Extended attribute block fails checksum"
+
 	end
diff --git a/lib/ext2fs/ext2_ext_attr.h b/lib/ext2fs/ext2_ext_attr.h
index ed548d1..ee45175 100644
--- a/lib/ext2fs/ext2_ext_attr.h
+++ b/lib/ext2fs/ext2_ext_attr.h
@@ -20,7 +20,8 @@ struct ext2_ext_attr_header {
 	__u32	h_refcount;	/* reference count */
 	__u32	h_blocks;	/* number of disk blocks used */
 	__u32	h_hash;		/* hash value of all attributes */
-	__u32	h_reserved[4];	/* zero right now */
+	__u32	h_checksum;	/* crc32c(uuid+inode+xattrs) */
+	__u32	h_reserved[3];	/* zero right now */
 };
 
 struct ext2_ext_attr_entry {
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 706357a..0820e43 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -894,6 +894,12 @@ extern __u32 crc32c_be(__u32 crc, unsigned char const *p, size_t len);
 extern __u32 crc32c_le(__u32 crc, unsigned char const *p, size_t len);
 
 /* csum.c */
+extern __u32 ext2fs_ext_attr_block_csum(ext2_filsys fs, blk64_t block,
+					struct ext2_ext_attr_header *hdr);
+extern int ext2fs_ext_attr_block_csum_verify(ext2_filsys fs, blk64_t block,
+					     struct ext2_ext_attr_header *hdr);
+extern void ext2fs_ext_attr_block_csum_set(ext2_filsys fs, blk64_t block,
+					   struct ext2_ext_attr_header *hdr);
 extern int ext2fs_dirent_has_tail(ext2_filsys fs,
 				  struct ext2_dir_entry *dirent);
 extern int ext2fs_dir_block_csum_verify(ext2_filsys fs, ext2_ino_t inum,
diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index 52664eb..2240e3e 100644
--- a/lib/ext2fs/ext_attr.c
+++ b/lib/ext2fs/ext_attr.c
@@ -70,6 +70,11 @@ errcode_t ext2fs_read_ext_attr2(ext2_filsys fs, blk64_t block, void *buf)
 #ifdef WORDS_BIGENDIAN
 	ext2fs_swap_ext_attr(buf, buf, fs->blocksize, 1);
 #endif
+
+	if (!(fs->flags & EXT2_FLAG_IGNORE_CSUM_ERRORS) &&
+	    !ext2fs_ext_attr_block_csum_verify(fs, block, buf))
+		return EXT2_ET_EXT_ATTR_BLOCK_CORRUPT;
+
 	return 0;
 }
 
@@ -84,6 +89,9 @@ errcode_t ext2fs_write_ext_attr2(ext2_filsys fs, blk64_t block, void *inbuf)
 	char		*write_buf;
 	char		*buf = NULL;
 
+	ext2fs_ext_attr_block_csum_set(fs, block,
+			(struct ext2_ext_attr_header *)inbuf);
+
 #ifdef WORDS_BIGENDIAN
 	retval = ext2fs_get_mem(fs->blocksize, &buf);
 	if (retval)
@@ -151,5 +159,6 @@ errcode_t ext2fs_adjust_ea_refcount(ext2_filsys fs, blk_t blk,
 					char *block_buf, int adjust,
 					__u32 *newcount)
 {
-	return ext2fs_adjust_ea_refcount(fs, blk, block_buf, adjust, newcount);
+	return ext2fs_adjust_ea_refcount2(fs, blk, block_buf, adjust,
+					  newcount);
 }
diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
index 570ab7d..a13f46a 100644
--- a/lib/ext2fs/swapfs.c
+++ b/lib/ext2fs/swapfs.c
@@ -144,7 +144,8 @@ void ext2fs_swap_ext_attr_header(struct ext2_ext_attr_header *to_header,
 	to_header->h_blocks   = ext2fs_swab32(from_header->h_blocks);
 	to_header->h_refcount = ext2fs_swab32(from_header->h_refcount);
 	to_header->h_hash     = ext2fs_swab32(from_header->h_hash);
-	for (n = 0; n < 4; n++)
+	to_header->h_checksum = ext2fs_swab32(from_header->h_checksum);
+	for (n = 0; n < 3; n++)
 		to_header->h_reserved[n] =
 			ext2fs_swab32(from_header->h_reserved[n]);
 }

