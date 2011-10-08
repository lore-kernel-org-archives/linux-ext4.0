From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 04/47] libext2fs: Add inode checksum support
Date: Sat, 08 Oct 2011 00:33:41 -0700
Message-ID: <20111008073341.17888.7555.stgit@elm3c44.beaverton.ibm.com>
References: <20111008073315.17888.22132.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e5.ny.us.ibm.com ([32.97.182.145]:35631 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132Ab1JHHgR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Oct 2011 03:36:17 -0400
Received: from /spool/local
	by e5.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Sat, 8 Oct 2011 03:36:16 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p987XiJE191428
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 03:33:44 -0400
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p987Xg6b009536
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 01:33:44 -0600
In-Reply-To: <20111008073315.17888.22132.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds the ability for the libext2fs functions to read and write the
inode checksum.  It also fixes a few fields that were omitted from the byte
swapping routines.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 lib/ext2fs/csum.c         |   95 +++++++++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/ext2_err.et.in |    9 ++++
 lib/ext2fs/ext2_fs.h      |    5 ++
 lib/ext2fs/ext2fs.h       |    4 ++
 lib/ext2fs/inode.c        |   46 +++++++++++++++++-----
 5 files changed, 148 insertions(+), 11 deletions(-)


diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
index 596923e..b8945ad 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -30,6 +30,101 @@
 #define STATIC static
 #endif
 
+static errcode_t ext2fs_inode_csum(ext2_filsys fs, ext2_ino_t inum,
+			       struct ext2_inode_large *inode,
+			       __u32 *crc)
+{
+	__u32 ncrc;
+	struct ext2_inode_large *desc = inode;
+	size_t size = fs->super->s_inode_size;
+	__u16 old_lo;
+	__u16 old_hi;
+	errcode_t retval = 0;
+
+	old_lo = inode->i_checksum_lo;
+	inode->i_checksum_lo = 0;
+	if (EXT2_INODE_SIZE(fs->super) > EXT2_GOOD_OLD_INODE_SIZE &&
+	    inode->i_extra_isize >= EXT4_INODE_CSUM_HI_EXTRA_LOCATION) {
+		old_hi = inode->i_checksum_hi;
+		inode->i_checksum_hi = 0;
+	}
+
+#ifdef WORDS_BIGENDIAN
+	struct ext2_inode_large *swabinode;
+	retval = ext2fs_get_mem(size, &swabinode);
+	if (retval)
+		goto err;
+
+	/* Have to swab back to little-endian to do the checksum */
+	memcpy(swabinode, inode, size);
+	ext2fs_swap_inode_full(fs, swabinode, swabinode, 1, size);
+	desc = swabinode;
+#endif
+
+	inum = ext2fs_cpu_to_le32(inum);
+	ncrc = ext2fs_crc32c_le(~0, fs->super->s_uuid,
+				sizeof(fs->super->s_uuid));
+	ncrc = ext2fs_crc32c_le(ncrc, (unsigned char *)&inum, sizeof(inum));
+	ncrc = ext2fs_crc32c_le(ncrc, (unsigned char *)desc, size);
+	*crc = ncrc;
+
+#ifdef WORDS_BIGENDIAN
+	ext2fs_free_mem(&swabinode);
+err:
+#endif
+
+	inode->i_checksum_lo = old_lo;
+	if (EXT2_INODE_SIZE(fs->super) > EXT2_GOOD_OLD_INODE_SIZE &&
+	    inode->i_extra_isize >= EXT4_INODE_CSUM_HI_EXTRA_LOCATION)
+		inode->i_checksum_hi = old_hi;
+	return retval;
+}
+
+int ext2fs_inode_csum_verify(ext2_filsys fs, ext2_ino_t inum,
+			     struct ext2_inode_large *inode)
+{
+	errcode_t retval;
+	__u32 provided, calculated;
+
+	if (fs->super->s_creator_os != EXT2_OS_LINUX ||
+	    !EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return 1;
+
+	provided = inode->i_checksum_lo;
+	retval = ext2fs_inode_csum(fs, inum, inode, &calculated);
+	if (retval)
+		return 0;
+	if (EXT2_INODE_SIZE(fs->super) > EXT2_GOOD_OLD_INODE_SIZE &&
+	    inode->i_extra_isize >= EXT4_INODE_CSUM_HI_EXTRA_LOCATION)
+		provided |= ((__u32)inode->i_checksum_hi) << 16;
+	else
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
+
+	if (fs->super->s_creator_os != EXT2_OS_LINUX ||
+	    !EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return 0;
+
+	retval = ext2fs_inode_csum(fs, inum, inode, &crc);
+	if (retval)
+		return retval;
+	inode->i_checksum_lo = crc & 0xFFFF;
+	if (EXT2_INODE_SIZE(fs->super) > EXT2_GOOD_OLD_INODE_SIZE &&
+	    inode->i_extra_isize >= EXT4_INODE_CSUM_HI_EXTRA_LOCATION)
+		inode->i_checksum_hi = crc >> 16;
+	return 0;
+}
+
 STATIC __u16 ext2fs_group_desc_csum(ext2_filsys fs, dgrp_t group)
 {
 	__u16 crc = 0;
diff --git a/lib/ext2fs/ext2_err.et.in b/lib/ext2fs/ext2_err.et.in
index e759b6f..fa66b85 100644
--- a/lib/ext2fs/ext2_err.et.in
+++ b/lib/ext2fs/ext2_err.et.in
@@ -443,4 +443,13 @@ ec	EXT2_ET_MMP_CHANGE_ABORT,
 ec	EXT2_ET_MMP_OPEN_DIRECT,
 	"MMP: open with O_DIRECT failed"
 
+ec	EXT2_ET_INODE_CSUM_INVALID,
+	"Inode checksum is incorrect"
+
+ec	EXT2_ET_INODE_CORRUPT,
+	"Inode checksum indicates corruption"
+
+ec	EXT2_ET_INODE_CSUM_NONZERO,
+	"Inode checksum should not be set"
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
index 4a3e7af..04db632 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -925,6 +925,10 @@ extern __u32 ext2fs_crc32c_be(__u32 crc, unsigned char const *p, size_t len);
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
index 7b0db60..6236976 100644
--- a/lib/ext2fs/inode.c
+++ b/lib/ext2fs/inode.c
@@ -417,7 +417,7 @@ errcode_t ext2fs_get_next_inode_full(ext2_inode_scan scan, ext2_ino_t *ino,
 	errcode_t	retval;
 	int		extra_bytes = 0;
 	const int	length = EXT2_INODE_SIZE(scan->fs->super);
-	struct ext2_inode	*iptr = inode;
+	struct ext2_inode_large	*iptr = (struct ext2_inode_large *)inode;
 
 	EXT2_CHECK_MAGIC(scan, EXT2_ET_MAGIC_INODE_SCAN);
 
@@ -521,11 +521,18 @@ errcode_t ext2fs_get_next_inode_full(ext2_inode_scan scan, ext2_ino_t *ino,
 			retval = EXT2_ET_BAD_BLOCK_IN_INODE_TABLE;
 	}
 
+	/* Verify the inode checksum. */
+	if (!(scan->fs->flags & EXT2_FLAG_IGNORE_CSUM_ERRORS) &&
+	    !ext2fs_inode_csum_verify(scan->fs, scan->current_inode, iptr))
+		retval = EXT2_ET_INODE_CSUM_INVALID;
+
 	scan->inodes_left--;
 	scan->current_inode++;
 	*ino = scan->current_inode;
-	if (inode != iptr) {
-		memcpy(inode, iptr, bufsize);
+
+	if (iptr != (struct ext2_inode_large *)inode) {
+		if (!retval)
+			memcpy(inode, iptr, bufsize);
 		ext2fs_free_mem(&iptr);
 	}
 	return retval;
@@ -547,11 +554,11 @@ errcode_t ext2fs_read_inode_full(ext2_filsys fs, ext2_ino_t ino,
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
 
@@ -633,6 +640,12 @@ errcode_t ext2fs_read_inode_full(ext2_filsys fs, ext2_ino_t ino,
 			       (struct ext2_inode_large *) iptr,
 			       0, length);
 #endif
+	/* Verify the inode checksum. */
+	if (!(fs->flags & EXT2_FLAG_IGNORE_CSUM_ERRORS) &&
+	    !ext2fs_inode_csum_verify(fs, ino, iptr)) {
+		retval = EXT2_ET_INODE_CSUM_INVALID;
+		goto err;
+	}
 
 	/* Update the inode cache */
 	fs->icache->cache_last = (fs->icache->cache_last + 1) %
@@ -640,12 +653,14 @@ errcode_t ext2fs_read_inode_full(ext2_filsys fs, ext2_ino_t ino,
 	fs->icache->cache[fs->icache->cache_last].ino = ino;
 	memcpy(fs->icache->cache[fs->icache->cache_last].inode, iptr, length);
 
-	if (iptr != inode) {
-		memcpy(inode, iptr, bufsize);
+err:
+	if (iptr != (struct ext2_inode_large *)inode) {
+		if (!retval)
+			memcpy(inode, iptr, bufsize);
 		ext2fs_free_mem(&iptr);
 	}
 
-	return 0;
+	return retval;
 }
 
 errcode_t ext2fs_read_inode(ext2_filsys fs, ext2_ino_t ino,
@@ -682,12 +697,17 @@ errcode_t ext2fs_write_inode_full(ext2_filsys fs, ext2_ino_t ino,
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
@@ -710,6 +730,10 @@ errcode_t ext2fs_write_inode_full(ext2_filsys fs, ext2_ino_t ino,
 		goto errout;
 	}
 
+	retval = ext2fs_inode_csum_set(fs, ino, w_inode);
+	if (retval)
+		goto errout;
+
 #ifdef WORDS_BIGENDIAN
 	ext2fs_swap_inode_full(fs, w_inode, w_inode, 1, length);
 #endif

