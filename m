From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 02/51] libext2fs: Change ext4 on-disk layout to support
	metadata checksumming
Date: Tue, 13 Dec 2011 17:13:30 -0800
Message-ID: <20111214011330.20947.96607.stgit@elm3c44.beaverton.ibm.com>
References: <20111214011316.20947.13706.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e3.ny.us.ibm.com ([32.97.182.143]:51018 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756413Ab1LNBNg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Dec 2011 20:13:36 -0500
Received: from /spool/local
	by e3.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Tue, 13 Dec 2011 20:13:35 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pBE1DXnf257746
	for <linux-ext4@vger.kernel.org>; Tue, 13 Dec 2011 20:13:33 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pBE1DWJL003275
	for <linux-ext4@vger.kernel.org>; Tue, 13 Dec 2011 23:13:33 -0200
In-Reply-To: <20111214011316.20947.13706.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Define flags and extend ext4 structure definitions to support metadata
checksumming.  Ted T'so covered many of these fields in an earlier patch, but
there are more required changes to the disk layout.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 lib/blkid/probe.h          |    1 +
 lib/ext2fs/ext2_ext_attr.h |    4 +++-
 lib/ext2fs/ext2_fs.h       |   36 ++++++++++++++++++++++++++++++++++--
 lib/ext2fs/ext2fs.h        |    1 +
 lib/ext2fs/ext3_extents.h  |   11 +++++++++++
 5 files changed, 50 insertions(+), 3 deletions(-)


diff --git a/lib/blkid/probe.h b/lib/blkid/probe.h
index 37e80ef..d6809e1 100644
--- a/lib/blkid/probe.h
+++ b/lib/blkid/probe.h
@@ -110,6 +110,7 @@ struct ext2_super_block {
 #define EXT4_FEATURE_RO_COMPAT_DIR_NLINK	0x0020
 #define EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE	0x0040
 #define EXT4_FEATURE_RO_COMPAT_QUOTA		0x0100
+#define EXT4_FEATURE_RO_COMPAT_METADATA_CSUM	0x0400
 
 /* for s_feature_incompat */
 #define EXT2_FEATURE_INCOMPAT_FILETYPE		0x0002
diff --git a/lib/ext2fs/ext2_ext_attr.h b/lib/ext2fs/ext2_ext_attr.h
index ed548d1..bbb0aaa 100644
--- a/lib/ext2fs/ext2_ext_attr.h
+++ b/lib/ext2fs/ext2_ext_attr.h
@@ -20,7 +20,9 @@ struct ext2_ext_attr_header {
 	__u32	h_refcount;	/* reference count */
 	__u32	h_blocks;	/* number of disk blocks used */
 	__u32	h_hash;		/* hash value of all attributes */
-	__u32	h_reserved[4];	/* zero right now */
+	__u32	h_checksum;	/* crc32c(uuid+id+xattrs) */
+				/* id = inum if refcount = 1, else blknum */
+	__u32	h_reserved[3];	/* zero right now */
 };
 
 struct ext2_ext_attr_entry {
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 0f8cde8..ce2fd66 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -234,6 +234,13 @@ struct ext2_dx_countlimit {
 	__u16 count;
 };
 
+/*
+ * This goes at the end of each htree block.
+ */
+struct ext2_dx_tail {
+	__u32 reserved;
+	__u32 checksum;	/* crc32c(uuid+inum+dxblock) */
+};
 
 /*
  * Macro-instructions used to manage group descriptors
@@ -462,6 +469,7 @@ struct ext2_inode_large {
 #define i_gid_low	i_gid
 #define i_uid_high	osd2.linux2.l_i_uid_high
 #define i_gid_high	osd2.linux2.l_i_gid_high
+#define i_checksum_lo	osd2.linux2.l_i_checksum_lo
 #else
 #if defined(__GNU__)
 
@@ -533,6 +541,9 @@ struct ext2_inode_large {
 #define ext4_offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
 #endif
 
+/* Metadata checksum algorithms */
+#define EXT2_CRC32C_CHKSUM		1
+
 /*
  * Structure of the super block
  */
@@ -618,7 +629,7 @@ struct ext2_super_block {
 	__u64   s_mmp_block;            /* Block for multi-mount protection */
 	__u32   s_raid_stripe_width;    /* blocks on all data disks (N*stride)*/
 	__u8	s_log_groups_per_flex;	/* FLEX_BG group size */
-	__u8    s_reserved_char_pad;
+	__u8    s_checksum_type;	/* metadata checksum algorithm */
 	__u16	s_reserved_pad;		/* Padding to next 32bits */
 	__u64	s_kbytes_written;	/* nr of lifetime kilobytes written */
 	__u32	s_snapshot_inum;	/* Inode number of active snapshot */
@@ -719,6 +730,7 @@ struct ext2_super_block {
 #define EXT4_FEATURE_INCOMPAT_FLEX_BG		0x0200
 #define EXT4_FEATURE_INCOMPAT_EA_INODE		0x0400
 #define EXT4_FEATURE_INCOMPAT_DIRDATA		0x1000
+#define EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM	0x2000
 
 #define EXT2_FEATURE_COMPAT_SUPP	0
 #define EXT2_FEATURE_INCOMPAT_SUPP    (EXT2_FEATURE_INCOMPAT_FILETYPE| \
@@ -778,6 +790,17 @@ struct ext2_dir_entry_2 {
 };
 
 /*
+ * This is a bogus directory entry at the end of each leaf block that
+ * records checksums.
+ */
+struct ext2_dir_entry_tail {
+	__u32	reserved_zero1;		/* Pretend to be unused */
+	__u16	rec_len;		/* 12 */
+	__u16	reserved_name_len;	/* 0xDE00, fake namelen/filetype */
+	__u32	checksum;		/* crc32c(uuid+inode+dirent) */
+};
+
+/*
  * Ext2 directory file types.  Only the low 3 bits are used.  The
  * other bits are reserved for now.
  */
@@ -793,6 +816,14 @@ struct ext2_dir_entry_2 {
 #define EXT2_FT_MAX		8
 
 /*
+ * Annoyingly, e2fsprogs always swab16s ext2_dir_entry.name_len, so we
+ * have to build ext2_dir_entry_tail with that assumption too.  This
+ * constant helps to build the dir_entry_tail to look like it has an
+ * "invalid" file type.
+ */
+#define EXT2_DIR_NAME_LEN_CSUM	0xDE00
+
+/*
  * EXT2_DIR_PAD defines the directory entries boundaries
  *
  * NOTE: It must be a multiple of 4
@@ -833,7 +864,8 @@ struct mmp_struct {
 	char	mmp_bdevname[32];	/* Bdev which last updated MMP block */
 	__u16	mmp_check_interval;	/* Changed mmp_check_interval */
 	__u16	mmp_pad1;
-	__u32	mmp_pad2[227];
+	__u32	mmp_pad2[226];
+	__u32	mmp_checksum;		/* crc32c(uuid+mmp_block) */
 };
 
 /*
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 227ee58..16c4567 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -199,6 +199,7 @@ typedef struct ext2_file *ext2_file_t;
 #define EXT2_FLAG_PRINT_PROGRESS	0x40000
 #define EXT2_FLAG_DIRECT_IO		0x80000
 #define EXT2_FLAG_SKIP_MMP		0x100000
+#define EXT2_FLAG_IGNORE_CSUM_ERRORS	0x200000
 
 /*
  * Special flag in the ext2 inode i_flag field that means that this is
diff --git a/lib/ext2fs/ext3_extents.h b/lib/ext2fs/ext3_extents.h
index 88fabc9..4163436 100644
--- a/lib/ext2fs/ext3_extents.h
+++ b/lib/ext2fs/ext3_extents.h
@@ -19,6 +19,17 @@
  */
 
 /*
+ * This is extent tail on-disk structure.
+ * All other extent structures are 12 bytes long.  It turns out that
+ * block_size % 12 >= 4 for at least all powers of 2 greater than 512, which
+ * covers all valid ext4 block sizes.  Therefore, this tail structure can be
+ * crammed into the end of the block without having to rebalance the tree.
+ */
+struct ext3_extent_tail {
+	__u32	et_checksum;	/* crc32c(uuid+inum+extent_block) */
+};
+
+/*
  * this is extent on-disk structure
  * it's used at the bottom of the tree
  */

