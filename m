From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 11/28] ext4: Calculate and verify inode checksums
Date: Sat, 08 Oct 2011 00:54:56 -0700
Message-ID: <20111008075456.20506.47319.stgit@elm3c44.beaverton.ibm.com>
References: <20111008075343.20506.23155.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
	Martin K Petersen <martin.petersen@oracle.com>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20111008075343.20506.23155.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch introduces to ext4 the ability to calculate and verify inode
checksums.  This requires the use of a new ro compatibility flag and some
accompanying e2fsprogs patches to provide the relevant features in tune2fs and
e2fsck.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 fs/ext4/ext4.h   |   10 ++++-
 fs/ext4/ialloc.c |   10 +++++
 fs/ext4/inode.c  |  108 ++++++++++++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 117 insertions(+), 11 deletions(-)


diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index c99e44c..227210a 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -611,7 +611,8 @@ struct ext4_inode {
 			__le16	l_i_file_acl_high;
 			__le16	l_i_uid_high;	/* these 2 fields */
 			__le16	l_i_gid_high;	/* were reserved2[0] */
-			__u32	l_i_reserved2;
+			__le16	l_i_checksum_lo;/* crc32c(uuid+inum+inode) LE */
+			__le16	l_i_reserved;
 		} linux2;
 		struct {
 			__le16	h_i_reserved1;	/* Obsoleted fragment number/size which are removed in ext4 */
@@ -627,7 +628,7 @@ struct ext4_inode {
 		} masix2;
 	} osd2;				/* OS dependent 2 */
 	__le16	i_extra_isize;
-	__le16	i_pad1;
+	__le16	i_checksum_hi;	/* crc32c(uuid+inum+inode) BE */
 	__le32  i_ctime_extra;  /* extra Change time      (nsec << 2 | epoch) */
 	__le32  i_mtime_extra;  /* extra Modification time(nsec << 2 | epoch) */
 	__le32  i_atime_extra;  /* extra Access time      (nsec << 2 | epoch) */
@@ -729,7 +730,7 @@ do {									       \
 #define i_gid_low	i_gid
 #define i_uid_high	osd2.linux2.l_i_uid_high
 #define i_gid_high	osd2.linux2.l_i_gid_high
-#define i_reserved2	osd2.linux2.l_i_reserved2
+#define i_checksum_lo	osd2.linux2.l_i_checksum_lo
 
 #elif defined(__GNU__)
 
@@ -868,6 +869,9 @@ struct ext4_inode_info {
 	 */
 	tid_t i_sync_tid;
 	tid_t i_datasync_tid;
+
+	/* crc32c(uuid+inum) */
+	__u32 i_uuid_inum_crc;
 };
 
 /*
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 9c63f27..6e5876a 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -1028,6 +1028,16 @@ got:
 	inode->i_generation = sbi->s_next_generation++;
 	spin_unlock(&sbi->s_next_gen_lock);
 
+	/* Precompute second piece of crc */
+	if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
+			EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
+		struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+		__le32 inum = cpu_to_le32(inode->i_ino);
+		ei->i_uuid_inum_crc = ext4_chksum(sbi, sbi->s_uuid_crc,
+						  (__u8 *)&inum,
+						  sizeof(inum));
+	}
+
 	ext4_clear_state_flags(ei); /* Only relevant on 32-bit archs */
 	ext4_set_inode_state(inode, EXT4_STATE_NEW);
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 6e64e0b..b00315d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -49,6 +49,73 @@
 
 #define MPAGE_DA_EXTENT_TAIL 0x01
 
+static __u32 ext4_inode_csum(struct inode *inode, struct ext4_inode *raw,
+			      struct ext4_inode_info *ei)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	__u16 crc_lo;
+	__u16 crc_hi = 0;
+	__u32 crc;
+
+	crc_lo = raw->i_checksum_lo;
+	raw->i_checksum_lo = 0;
+	if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE &&
+	    EXT4_FITS_IN_INODE(raw, ei, i_checksum_hi)) {
+		crc_hi = raw->i_checksum_hi;
+		raw->i_checksum_hi = 0;
+	}
+
+	crc = ext4_chksum(sbi, ei->i_uuid_inum_crc, (__u8 *)raw,
+			  EXT4_INODE_SIZE(inode->i_sb));
+
+	raw->i_checksum_lo = crc_lo;
+	if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE &&
+	    EXT4_FITS_IN_INODE(raw, ei, i_checksum_hi))
+		raw->i_checksum_hi = crc_hi;
+
+	return crc;
+}
+
+static int ext4_inode_csum_verify(struct inode *inode, struct ext4_inode *raw,
+				  struct ext4_inode_info *ei)
+{
+	__u32 provided, calculated;
+
+	if (EXT4_SB(inode->i_sb)->s_es->s_creator_os !=
+	    cpu_to_le32(EXT4_OS_LINUX) ||
+	    !EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
+		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return 1;
+
+	provided = le16_to_cpu(raw->i_checksum_lo);
+	calculated = ext4_inode_csum(inode, raw, ei);
+	if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE &&
+	    EXT4_FITS_IN_INODE(raw, ei, i_checksum_hi))
+		provided |= ((__u32)le16_to_cpu(raw->i_checksum_hi)) << 16;
+	else
+		calculated &= 0xFFFF;
+
+	return provided == calculated;
+}
+
+static void ext4_inode_csum_set(struct inode *inode, struct ext4_inode *raw,
+				struct ext4_inode_info *ei)
+{
+	__u32 crc;
+
+	if (EXT4_SB(inode->i_sb)->s_es->s_creator_os !=
+	    cpu_to_le32(EXT4_OS_LINUX) ||
+	    !EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
+		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return;
+
+	crc = ext4_inode_csum(inode, raw, ei);
+	raw->i_checksum_lo = cpu_to_le16(crc & 0xFFFF);
+	if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE &&
+	    EXT4_FITS_IN_INODE(raw, ei, i_checksum_hi))
+		raw->i_checksum_hi = cpu_to_le16(crc >> 16);
+}
+
 static inline int ext4_begin_ordered_truncate(struct inode *inode,
 					      loff_t new_size)
 {
@@ -3407,6 +3474,36 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 	if (ret < 0)
 		goto bad_inode;
 	raw_inode = ext4_raw_inode(&iloc);
+
+	if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE) {
+		ei->i_extra_isize = le16_to_cpu(raw_inode->i_extra_isize);
+		if (EXT4_GOOD_OLD_INODE_SIZE + ei->i_extra_isize >
+		    EXT4_INODE_SIZE(inode->i_sb)) {
+			EXT4_ERROR_INODE(inode, "bad extra_isize (%u != %u)",
+				EXT4_GOOD_OLD_INODE_SIZE + ei->i_extra_isize,
+				EXT4_INODE_SIZE(inode->i_sb));
+			ret = -EIO;
+			goto bad_inode;
+		}
+	} else
+		ei->i_extra_isize = 0;
+
+	/* Precompute second piece of crc */
+	if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
+			EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
+		struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+		__le32 inum = cpu_to_le32(inode->i_ino);
+		ei->i_uuid_inum_crc = ext4_chksum(sbi, sbi->s_uuid_crc,
+						  (__u8 *)&inum,
+						  sizeof(inum));
+	}
+
+	if (!ext4_inode_csum_verify(inode, raw_inode, ei)) {
+		EXT4_ERROR_INODE(inode, "checksum invalid");
+		ret = -EIO;
+		goto bad_inode;
+	}
+
 	inode->i_mode = le16_to_cpu(raw_inode->i_mode);
 	inode->i_uid = (uid_t)le16_to_cpu(raw_inode->i_uid_low);
 	inode->i_gid = (gid_t)le16_to_cpu(raw_inode->i_gid_low);
@@ -3484,12 +3581,6 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 	}
 
 	if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE) {
-		ei->i_extra_isize = le16_to_cpu(raw_inode->i_extra_isize);
-		if (EXT4_GOOD_OLD_INODE_SIZE + ei->i_extra_isize >
-		    EXT4_INODE_SIZE(inode->i_sb)) {
-			ret = -EIO;
-			goto bad_inode;
-		}
 		if (ei->i_extra_isize == 0) {
 			/* The extra space is currently unused. Use it. */
 			ei->i_extra_isize = sizeof(struct ext4_inode) -
@@ -3501,8 +3592,7 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 			if (*magic == cpu_to_le32(EXT4_XATTR_MAGIC))
 				ext4_set_inode_state(inode, EXT4_STATE_XATTR);
 		}
-	} else
-		ei->i_extra_isize = 0;
+	}
 
 	EXT4_INODE_GET_XTIME(i_ctime, inode, raw_inode);
 	EXT4_INODE_GET_XTIME(i_mtime, inode, raw_inode);
@@ -3727,6 +3817,8 @@ static int ext4_do_update_inode(handle_t *handle,
 		raw_inode->i_extra_isize = cpu_to_le16(ei->i_extra_isize);
 	}
 
+	ext4_inode_csum_set(inode, raw_inode, ei);
+
 	BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
 	rc = ext4_handle_dirty_metadata(handle, NULL, bh);
 	if (!err)

