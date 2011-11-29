From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 04/50] libext2fs: Add inode checksum support
Date: Mon, 28 Nov 2011 16:28:23 -0800
Message-ID: <20111129002823.17953.8482.stgit@elm3c44.beaverton.ibm.com>
References: <20111129002755.17953.19556.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e1.ny.us.ibm.com ([32.97.182.141]:50028 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291Ab1K2AbW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Nov 2011 19:31:22 -0500
Received: from /spool/local
	by e1.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Mon, 28 Nov 2011 19:31:20 -0500
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pAT0SRtm313630
	for <linux-ext4@vger.kernel.org>; Mon, 28 Nov 2011 19:28:27 -0500
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pAT0SOo7029287
	for <linux-ext4@vger.kernel.org>; Mon, 28 Nov 2011 17:28:26 -0700
In-Reply-To: <20111129002755.17953.19556.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds the ability for the libext2fs functions to read and write the
inode checksum.  It also fixes a few fields that were omitted from the byte
swapping routines.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 lib/ext2fs/csum.c         |   83 +++++++++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/ext2_err.et.in |    3 ++
 lib/ext2fs/ext2_fs.h      |    5 +++
 lib/ext2fs/ext2fs.h       |    4 ++
 lib/ext2fs/inode.c        |   49 ++++++++++++++++++++++-----
 5 files changed, 135 insertions(+), 9 deletions(-)


diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
index 596923e..1f7c641 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -30,6 +30,89 @@
 #define STATIC static
 #endif
 
+static errcode_t ext2fs_inode_csum(ext2_filsys fs, ext2_ino_t inum,
+			       struct ext2_inode_large *inode,
+			       __u32 *crc, int has_hi)
+{
+	__u32 ncrc;
+	struct ext2_inode_large *desc = inode;
+	size_t size = fs->super->s_inode_size;
+	__u16 old_lo;
+	__u16 old_hi = 0;
+	errcode_t retval = 0;
+
+	old_lo = inode->i_checksum_lo;
+	inode->i_checksum_lo = 0;
+	if (has_hi) {
+		old_hi = inode->i_checksum_hi;
+		inode->i_checksum_hi = 0;
+	}
+
+	inum = ext2fs_cpu_to_le32(inum);
+	ncrc = ext2fs_crc32c_le(~0, fs->super->s_uuid,
+				sizeof(fs->super->s_uuid));
+	ncrc = ext2fs_crc32c_le(ncrc, (unsigned char *)&inum, sizeof(inum));
+	ncrc = ext2fs_crc32c_le(ncrc, (unsigned char *)desc, size);
+	*crc = ncrc;
+
+	inode->i_checksum_lo = old_lo;
+	if (has_hi)
+		inode->i_checksum_hi = old_hi;
+	return retval;
+}
+
+int ext2fs_inode_csum_verify(ext2_filsys fs, ext2_ino_t inum,
+			     struct ext2_inode_large *inode)
+{
+	errcode_t retval;
+	__u32 provided, calculated;
+	int has_hi;
+
+	if (fs->super->s_creator_os != EXT2_OS_LINUX ||
+	    !EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return 1;
+
+	has_hi = (EXT2_INODE_SIZE(fs->super) > EXT2_GOOD_OLD_INODE_SIZE &&
+		  inode->i_extra_isize >= EXT4_INODE_CSUM_HI_EXTRA_LOCATION);
+
+	provided = ext2fs_le16_to_cpu(inode->i_checksum_lo);
+	retval = ext2fs_inode_csum(fs, inum, inode, &calculated, has_hi);
+	if (retval)
+		return 0;
+	if (has_hi) {
+		__u32 hi = ext2fs_le16_to_cpu(inode->i_checksum_hi);
+		provided |= hi << 16;
+	} else
+		calculated &= 0xFFFF;
+
+	return provided == calculated;
+}
+
+errcode_t ext2fs_inode_csum_set(ext2_filsys fs, ext2_ino_t inum,
+			   struct ext2_inode_large *inode)
+{
+	errcode_t retval;
+	__u32 crc;
+	int has_hi;
+
+	if (fs->super->s_creator_os != EXT2_OS_LINUX ||
+	    !EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return 0;
+
+	has_hi = (EXT2_INODE_SIZE(fs->super) > EXT2_GOOD_OLD_INODE_SIZE &&
+		  inode->i_extra_isize >= EXT4_INODE_CSUM_HI_EXTRA_LOCATION);
+
+	retval = ext2fs_inode_csum(fs, inum, inode, &crc, has_hi);
+	if (retval)
+		return retval;
+	inode->i_checksum_lo = ext2fs_cpu_to_le16(crc & 0xFFFF);
+	if (has_hi)
+		inode->i_checksum_hi = ext2fs_cpu_to_le16(crc >> 16);
+	return 0;
+}
+
 STATIC __u16 ext2fs_group_desc_csum(ext2_filsys fs, dgrp_t group)
 {
 	__u16 crc = 0;
diff --git a/lib/ext2fs/ext2_err.et.in b/lib/ext2fs/ext2_err.et.in
index ccf1894..d4a5b10 100644
--- a/lib/ext2fs/ext2_err.et.in
+++ b/lib/ext2fs/ext2_err.et.in
@@ -443,4 +443,7 @@ ec	EXT2_ET_MMP_CHANGE_ABORT,
 ec	EXT2_ET_MMP_OPEN_DIRECT,
 	"MMP: open with O_DIRECT failed"
 
+ec	EXT2_ET_INODE_CSUM_INVALID,
+	"Inode checksum does not match inode"
+
 	end
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 0f8cde8..6fd82f1 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -452,6 +452,10 @@ struct ext2_inode_large {
 	__u32	i_version_hi;	/* high 32 bits for 64-bit version */
 };
 
+#define EXT4_INODE_CSUM_HI_EXTRA_LOCATION	\
+	(offsetof(struct ext2_inode_large, i_checksum_hi) + sizeof(__u16) - \
+	 EXT2_GOOD_OLD_INODE_SIZE)
+
 #define i_dir_acl	i_size_high
 
 #if defined(__KERNEL__) || defined(__linux__)
@@ -462,6 +466,7 @@ struct ext2_inode_large {
 #define i_gid_low	i_gid
 #define i_uid_high	osd2.linux2.l_i_uid_high
 #define i_gid_high	osd2.linux2.l_i_gid_high
+#define i_checksum_lo	osd2.linux2.l_i_checksum_lo
 #else
 #if defined(__GNU__)
 
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 4ff7f4f..52d4a61 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -938,6 +938,10 @@ extern __u32 ext2fs_crc32c_be(__u32 crc, unsigned char const *p, size_t len);
 extern __u32 ext2fs_crc32c_le(__u32 crc, unsigned char const *p, size_t len);
 
 /* csum.c */
+extern errcode_t ext2fs_inode_csum_set(ext2_filsys fs, ext2_ino_t inum,
+				       struct ext2_inode_large *inode);
+extern int ext2fs_inode_csum_verify(ext2_filsys fs, ext2_ino_t inum,
+				    struct ext2_inode_large *inode);
 extern void ext2fs_group_desc_csum_set(ext2_filsys fs, dgrp_t group);
 extern int ext2fs_group_desc_csum_verify(ext2_filsys fs, dgrp_t group);
 extern errcode_t ext2fs_set_gdt_csum(ext2_filsys fs);
diff --git a/lib/ext2fs/inode.c b/lib/ext2fs/inode.c
index 7b0db60..f465e27 100644
--- a/lib/ext2fs/inode.c
+++ b/lib/ext2fs/inode.c
@@ -417,7 +417,7 @@ errcode_t ext2fs_get_next_inode_full(ext2_inode_scan scan, ext2_ino_t *ino,
 	errcode_t	retval;
 	int		extra_bytes = 0;
 	const int	length = EXT2_INODE_SIZE(scan->fs->super);
-	struct ext2_inode	*iptr = inode;
+	struct ext2_inode_large	*iptr = (struct ext2_inode_large *)inode;
 
 	EXT2_CHECK_MAGIC(scan, EXT2_ET_MAGIC_INODE_SCAN);
 
@@ -493,6 +493,12 @@ errcode_t ext2fs_get_next_inode_full(ext2_inode_scan scan, ext2_ino_t *ino,
 		scan->ptr += scan->inode_size - extra_bytes;
 		scan->bytes_left -= scan->inode_size - extra_bytes;
 
+		/* Verify the inode checksum. */
+		if (!(scan->fs->flags & EXT2_FLAG_IGNORE_CSUM_ERRORS) &&
+		    !ext2fs_inode_csum_verify(scan->fs, scan->current_inode + 1,
+				(struct ext2_inode_large *)scan->temp_buffer))
+			retval = EXT2_ET_INODE_CSUM_INVALID;
+
 #ifdef WORDS_BIGENDIAN
 		memset(iptr, 0, length);
 		ext2fs_swap_inode_full(scan->fs,
@@ -506,6 +512,12 @@ errcode_t ext2fs_get_next_inode_full(ext2_inode_scan scan, ext2_ino_t *ino,
 			retval = EXT2_ET_BAD_BLOCK_IN_INODE_TABLE;
 		scan->scan_flags &= ~EXT2_SF_BAD_EXTRA_BYTES;
 	} else {
+		/* Verify the inode checksum. */
+		if (!(scan->fs->flags & EXT2_FLAG_IGNORE_CSUM_ERRORS) &&
+		    !ext2fs_inode_csum_verify(scan->fs, scan->current_inode + 1,
+				(struct ext2_inode_large *)scan->ptr))
+			retval = EXT2_ET_INODE_CSUM_INVALID;
+
 #ifdef WORDS_BIGENDIAN
 		memset(iptr, 0, length);
 		ext2fs_swap_inode_full(scan->fs,
@@ -524,7 +536,7 @@ errcode_t ext2fs_get_next_inode_full(ext2_inode_scan scan, ext2_ino_t *ino,
 	scan->inodes_left--;
 	scan->current_inode++;
 	*ino = scan->current_inode;
-	if (inode != iptr) {
+	if (iptr != (struct ext2_inode_large *)inode) {
 		memcpy(inode, iptr, bufsize);
 		ext2fs_free_mem(&iptr);
 	}
@@ -547,11 +559,11 @@ errcode_t ext2fs_read_inode_full(ext2_filsys fs, ext2_ino_t ino,
 	blk64_t		block_nr;
 	unsigned long 	group, block, offset;
 	char 		*ptr;
-	errcode_t	retval;
+	errcode_t	retval = 0;
 	int		clen, i, inodes_per_block;
 	io_channel	io;
 	int		length = EXT2_INODE_SIZE(fs->super);
-	struct ext2_inode	*iptr = inode;
+	struct ext2_inode_large	*iptr = (struct ext2_inode_large *)inode;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
@@ -628,24 +640,34 @@ errcode_t ext2fs_read_inode_full(ext2_filsys fs, ext2_ino_t ino,
 	}
 	length = EXT2_INODE_SIZE(fs->super);
 
+	/* Verify the inode checksum. */
+	if (!(fs->flags & EXT2_FLAG_IGNORE_CSUM_ERRORS) &&
+	    !ext2fs_inode_csum_verify(fs, ino, iptr))
+		retval = EXT2_ET_INODE_CSUM_INVALID;
+
 #ifdef WORDS_BIGENDIAN
 	ext2fs_swap_inode_full(fs, (struct ext2_inode_large *) iptr,
 			       (struct ext2_inode_large *) iptr,
 			       0, length);
 #endif
 
+	/* Don't fill the cache with corrupt inodes */
+	if (retval == EXT2_ET_INODE_CSUM_INVALID)
+		goto err;
+
 	/* Update the inode cache */
 	fs->icache->cache_last = (fs->icache->cache_last + 1) %
 		fs->icache->cache_size;
 	fs->icache->cache[fs->icache->cache_last].ino = ino;
 	memcpy(fs->icache->cache[fs->icache->cache_last].inode, iptr, length);
 
-	if (iptr != inode) {
+err:
+	if (iptr != (struct ext2_inode_large *)inode) {
 		memcpy(inode, iptr, bufsize);
 		ext2fs_free_mem(&iptr);
 	}
 
-	return 0;
+	return retval;
 }
 
 errcode_t ext2fs_read_inode(ext2_filsys fs, ext2_ino_t ino,
@@ -682,12 +704,17 @@ errcode_t ext2fs_write_inode_full(ext2_filsys fs, ext2_ino_t ino,
 	retval = ext2fs_get_mem(length, &w_inode);
 	if (retval)
 		return retval;
-	if (bufsize < length)
+
+	if (bufsize < length) {
+		int old_flags = fs->flags;
+		fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
 		retval = ext2fs_read_inode_full(fs, ino,
 						(struct ext2_inode *)w_inode,
 						length);
-	if (retval)
-		goto errout;
+		fs->flags = old_flags;
+		if (retval)
+			goto errout;
+	}
 
 	/* Check to see if the inode cache needs to be updated */
 	if (fs->icache) {
@@ -714,6 +741,10 @@ errcode_t ext2fs_write_inode_full(ext2_filsys fs, ext2_ino_t ino,
 	ext2fs_swap_inode_full(fs, w_inode, w_inode, 1, length);
 #endif
 
+	retval = ext2fs_inode_csum_set(fs, ino, w_inode);
+	if (retval)
+		goto errout;
+
 	group = (ino - 1) / EXT2_INODES_PER_GROUP(fs->super);
 	offset = ((ino - 1) % EXT2_INODES_PER_GROUP(fs->super)) *
 		EXT2_INODE_SIZE(fs->super);

