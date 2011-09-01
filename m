From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 06/37] libext2fs: Add inode checksum support
Date: Wed, 31 Aug 2011 17:35:49 -0700
Message-ID: <20110901003549.1176.81379.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e38.co.us.ibm.com ([32.97.110.159]:52643 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757321Ab1IAAf6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 31 Aug 2011 20:35:58 -0400
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by e38.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p810RxI1021195
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 18:27:59 -0600
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p810Zq5F178326
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 18:35:52 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p810Zpou004527
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 18:35:52 -0600
In-Reply-To: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds the ability for the libext2fs functions to read and write the
inode checksum.  It also fixes a few fields that were omitted from the byte
swapping routines.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 lib/ext2fs/csum.c         |   59 +++++++++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/ext2_err.et.in |    9 +++++++
 lib/ext2fs/ext2_fs.h      |    4 ++-
 lib/ext2fs/ext2fs.h       |    6 +++++
 lib/ext2fs/inode.c        |   20 +++++++++++++++
 lib/ext2fs/swapfs.c       |   10 ++++++--
 6 files changed, 104 insertions(+), 4 deletions(-)


diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
index 2fece68..57adc4c 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -29,6 +29,65 @@
 #define STATIC static
 #endif
 
+__u32 ext2fs_inode_csum(ext2_filsys fs, ext2_ino_t inum,
+			struct ext2_inode_large *inode)
+{
+	struct ext2_inode_large *desc = inode;
+	int offset = offsetof(struct ext2_inode_large, i_checksum);
+	int extra_size = inode->i_extra_isize;
+	size_t size = fs->super->s_inode_size;
+	__u32 crc = 0;
+
+	if (size < EXT2_GOOD_OLD_INODE_SIZE + extra_size)
+		printf("ERROR: inode %d size %d != extra_size %d!\n", inum,
+		       size, extra_size + EXT2_GOOD_OLD_INODE_SIZE);
+
+	if (fs->super->s_creator_os != EXT2_OS_LINUX)
+		return 0;
+
+	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+
+		return 0;
+
+#ifdef WORDS_BIGENDIAN
+	char buf[EXT2_INODE_CORE_SIZE(fs->super)];
+	struct ext2_inode_large *swabinode = (struct ext2_inode_large *)buf;
+
+	/* Have to swab back to little-endian to do the checksum */
+	memcpy(swabinode, inode, size);
+	ext2fs_swap_inode_full(fs, swabinode, swabinode, 1, size);
+	desc = swabinode;
+#endif
+	inum = ext2fs_cpu_to_le32(inum);
+	crc = crc32c_le(~0, fs->super->s_uuid, sizeof(fs->super->s_uuid));
+	crc = crc32c_le(crc, (char *)&inum, sizeof(inum));
+	crc = crc32c_le(crc, (char *)desc, offset);
+	offset += sizeof(inode->i_checksum); /* skip checksum */
+	crc = crc32c_le(crc, (char *)desc + offset,
+			   EXT2_GOOD_OLD_INODE_SIZE + extra_size - offset);
+	return crc;
+}
+
+int ext2fs_inode_csum_verify(ext2_filsys fs, ext2_ino_t inum,
+			     struct ext2_inode_large *inode)
+{
+	if (fs->super->s_creator_os == EXT2_OS_LINUX &&
+	    EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
+	    (inode->i_checksum != ext2fs_inode_csum(fs, inum, inode)))
+		return 0;
+	return 1;
+}
+
+void ext2fs_inode_csum_set(ext2_filsys fs, ext2_ino_t inum,
+			   struct ext2_inode_large *inode)
+{
+	if (fs->super->s_creator_os != EXT2_OS_LINUX)
+		return;
+	inode->i_checksum = ext2fs_inode_csum(fs, inum, inode);
+}
+
 STATIC __u16 ext2fs_group_desc_csum(ext2_filsys fs, dgrp_t group)
 {
 	__u16 crc = 0;
diff --git a/lib/ext2fs/ext2_err.et.in b/lib/ext2fs/ext2_err.et.in
index 995ddc3..31c8fe1 100644
--- a/lib/ext2fs/ext2_err.et.in
+++ b/lib/ext2fs/ext2_err.et.in
@@ -422,4 +422,13 @@ ec	EXT2_NO_MTAB_FILE,
 ec	EXT2_ET_CANT_USE_LEGACY_BITMAPS,
 	"Filesystem too large to use legacy bitmaps"
 
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
index ae7662e..1f08673 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -362,7 +362,7 @@ struct ext2_inode_large {
 			__u16	l_i_file_acl_high;
 			__u16	l_i_uid_high;	/* these 2 fields    */
 			__u16	l_i_gid_high;	/* were reserved2[0] */
-			__u32	l_i_reserved2;
+			__u32	l_i_checksum;	/* crc32c(uuid+inum+inode) */
 		} linux2;
 		struct {
 			__u8	h_i_frag;	/* Fragment number */
@@ -393,7 +393,7 @@ struct ext2_inode_large {
 #define i_gid_low	i_gid
 #define i_uid_high	osd2.linux2.l_i_uid_high
 #define i_gid_high	osd2.linux2.l_i_gid_high
-#define i_reserved2	osd2.linux2.l_i_reserved2
+#define i_checksum	osd2.linux2.l_i_checksum
 #else
 #if defined(__GNU__)
 
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index e571508..db8b28b 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -892,6 +892,12 @@ extern __u32 crc32c_be(__u32 crc, unsigned char const *p, size_t len);
 extern __u32 crc32c_le(__u32 crc, unsigned char const *p, size_t len);
 
 /* csum.c */
+extern __u32 ext2fs_inode_csum(ext2_filsys fs, ext2_ino_t inum,
+			      struct ext2_inode_large *inode);
+extern void ext2fs_inode_csum_set(ext2_filsys fs, ext2_ino_t inum,
+				  struct ext2_inode_large *inode);
+extern int ext2fs_inode_csum_verify(ext2_filsys fs, ext2_ino_t inum,
+				    struct ext2_inode_large *inode);
 extern void ext2fs_group_desc_csum_set(ext2_filsys fs, dgrp_t group);
 extern int ext2fs_group_desc_csum_verify(ext2_filsys fs, dgrp_t group);
 extern errcode_t ext2fs_set_gdt_csum(ext2_filsys fs);
diff --git a/lib/ext2fs/inode.c b/lib/ext2fs/inode.c
index 76893fd..0789505 100644
--- a/lib/ext2fs/inode.c
+++ b/lib/ext2fs/inode.c
@@ -509,6 +509,12 @@ errcode_t ext2fs_get_next_inode_full(ext2_inode_scan scan, ext2_ino_t *ino,
 	if (EXT2_INODE_SIZE(scan->fs->super) == EXT2_GOOD_OLD_INODE_SIZE)
 		inode->i_extra_isize = 0;
 
+	/* Verify the inode checksum. */
+	if (!(scan->fs->flags & EXT2_FLAG_IGNORE_CSUM_ERRORS) &&
+	    !ext2fs_inode_csum_verify(scan->fs, scan->current_inode, inode))
+		return EXT2_ET_INODE_CSUM_INVALID;
+
+
 	scan->inodes_left--;
 	scan->current_inode++;
 	*ino = scan->current_inode;
@@ -617,6 +623,10 @@ errcode_t ext2fs_read_inode_full(ext2_filsys fs, ext2_ino_t ino,
 			       (struct ext2_inode_large *) inode,
 			       0, bufsize);
 #endif
+	/* Verify the inode checksum. */
+	if (!(fs->flags & EXT2_FLAG_IGNORE_CSUM_ERRORS) &&
+	    !ext2fs_inode_csum_verify(fs, ino, inode))
+		return EXT2_ET_INODE_CSUM_INVALID;
 
 	/* Update the inode cache */
 	fs->icache->cache_last = (fs->icache->cache_last + 1) %
@@ -685,6 +695,16 @@ errcode_t ext2fs_write_inode_full(ext2_filsys fs, ext2_ino_t ino,
 		w_inode = &temp_inode;
 	memset(w_inode, 0, length);
 
+	/*
+	 * If inode checksum enabled, ensure that we actually have the whole
+	 * inode in memory.
+	 */
+	if (EXT2_INODE_SIZE(fs->super) > EXT2_GOOD_OLD_INODE_SIZE &&
+	    bufsize <= EXT2_GOOD_OLD_INODE_SIZE) {
+		fprintf(stderr, "inode %d has a too-short buffer!\n", ino);
+		abort();
+	}
+	ext2fs_inode_csum_set(fs, ino, inode);
 #ifdef WORDS_BIGENDIAN
 	ext2fs_swap_inode_full(fs, w_inode, inode, 1, bufsize);
 #else
diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
index 517f1d7..df604ba 100644
--- a/lib/ext2fs/swapfs.c
+++ b/lib/ext2fs/swapfs.c
@@ -244,8 +244,7 @@ void ext2fs_swap_inode_full(ext2_filsys fs, struct ext2_inode_large *t,
 		  ext2fs_swab16 (f->osd2.linux2.l_i_uid_high);
 		t->osd2.linux2.l_i_gid_high =
 		  ext2fs_swab16 (f->osd2.linux2.l_i_gid_high);
-		t->osd2.linux2.l_i_reserved2 =
-			ext2fs_swab32(f->osd2.linux2.l_i_reserved2);
+		t->i_checksum = ext2fs_swab32(f->i_checksum);
 		break;
 	case EXT2_OS_HURD:
 		t->osd1.hurd1.h_i_translator =
@@ -279,6 +278,13 @@ void ext2fs_swap_inode_full(ext2_filsys fs, struct ext2_inode_large *t,
 		return;
 	}
 
+	t->i_ctime_extra = ext2fs_swab32(f->i_ctime_extra);
+	t->i_mtime_extra = ext2fs_swab32(f->i_mtime_extra);
+	t->i_atime_extra = ext2fs_swab32(f->i_atime_extra);
+	t->i_crtime = ext2fs_swab32(f->i_crtime);
+	t->i_crtime_extra = ext2fs_swab32(f->i_crtime_extra);
+	t->i_version_hi = ext2fs_swab32(f->i_version_hi);
+
 	i = EXT2_GOOD_OLD_INODE_SIZE + extra_isize + sizeof(__u32);
 	if (bufsize < (int) i)
 		return; /* no space for EA magic */

