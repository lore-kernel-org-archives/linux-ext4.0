From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 06/16] ext4: Calculate and verify inode checksums
Date: Wed, 31 Aug 2011 17:31:12 -0700
Message-ID: <20110901003112.31048.36302.stgit@elm3c44.beaverton.ibm.com>
References: <20110901003030.31048.99467.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
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
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:33437 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757242Ab1IAAbp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 31 Aug 2011 20:31:45 -0400
In-Reply-To: <20110901003030.31048.99467.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch introduces to ext4 the ability to calculate and verify inode
checksums.  This requires the use of a new ro compatibility flag and some
accompanying e2fsprogs patches to provide the relevant features in tune2fs and
e2fsck.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 fs/ext4/ext4.h  |    4 ++--
 fs/ext4/inode.c |   62 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+), 2 deletions(-)


diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index f79ddac..e2361cc 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -609,7 +609,7 @@ struct ext4_inode {
 			__le16	l_i_file_acl_high;
 			__le16	l_i_uid_high;	/* these 2 fields */
 			__le16	l_i_gid_high;	/* were reserved2[0] */
-			__u32	l_i_reserved2;
+			__le32	l_i_checksum;	/* crc32c(uuid+inum+inode) */
 		} linux2;
 		struct {
 			__le16	h_i_reserved1;	/* Obsoleted fragment number/size which are removed in ext4 */
@@ -727,7 +727,7 @@ do {									       \
 #define i_gid_low	i_gid
 #define i_uid_high	osd2.linux2.l_i_uid_high
 #define i_gid_high	osd2.linux2.l_i_gid_high
-#define i_reserved2	osd2.linux2.l_i_reserved2
+#define i_checksum	osd2.linux2.l_i_checksum
 
 #elif defined(__GNU__)
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c4da98a..44a7f88 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -38,6 +38,7 @@
 #include <linux/printk.h>
 #include <linux/slab.h>
 #include <linux/ratelimit.h>
+#include <linux/crc32c.h>
 
 #include "ext4_jbd2.h"
 #include "xattr.h"
@@ -49,6 +50,53 @@
 
 #define MPAGE_DA_EXTENT_TAIL 0x01
 
+static __le32 ext4_inode_csum(struct inode *inode, struct ext4_inode *raw)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	int offset = offsetof(struct ext4_inode, i_checksum);
+	__le32 inum = cpu_to_le32(inode->i_ino);
+	__u32 crc = 0;
+
+	if (EXT4_SB(inode->i_sb)->s_es->s_creator_os !=
+	    cpu_to_le32(EXT4_OS_LINUX))
+		return 0;
+	if (!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
+		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return 0;
+
+	crc = crc32c_le(~0, sbi->s_es->s_uuid, sizeof(sbi->s_es->s_uuid));
+	crc = crc32c_le(crc, (__u8 *)&inum, sizeof(inum));
+	crc = crc32c_le(crc, (__u8 *)raw, offset);
+	offset += sizeof(raw->i_checksum); /* skip checksum */
+	crc = crc32c_le(crc, (__u8 *)raw + offset,
+		    EXT4_GOOD_OLD_INODE_SIZE + ei->i_extra_isize -
+		    offset);
+	return cpu_to_le32(crc);
+}
+
+static int ext4_inode_csum_verify(struct inode *inode, struct ext4_inode *raw)
+{
+	if (EXT4_SB(inode->i_sb)->s_es->s_creator_os ==
+	    cpu_to_le32(EXT4_OS_LINUX) &&
+	    EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
+		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
+	    (raw->i_checksum != ext4_inode_csum(inode, raw)))
+		return 0;
+	return 1;
+}
+
+static void ext4_inode_csum_set(struct inode *inode, struct ext4_inode *raw)
+{
+	if (EXT4_SB(inode->i_sb)->s_es->s_creator_os !=
+	    cpu_to_le32(EXT4_OS_LINUX) ||
+	    !EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
+		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return;
+
+	raw->i_checksum = ext4_inode_csum(inode, raw);
+}
+
 static inline int ext4_begin_ordered_truncate(struct inode *inode,
 					      loff_t new_size)
 {
@@ -3410,6 +3458,15 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 	if (ret < 0)
 		goto bad_inode;
 	raw_inode = ext4_raw_inode(&iloc);
+
+	if (!ext4_inode_csum_verify(inode, raw_inode)) {
+		EXT4_ERROR_INODE(inode, "checksum invalid (0x%x != 0x%x)",
+		       le32_to_cpu(ext4_inode_csum(inode, raw_inode)),
+		       le32_to_cpu(raw_inode->i_checksum));
+		ret = -EIO;
+		goto bad_inode;
+	}
+
 	inode->i_mode = le16_to_cpu(raw_inode->i_mode);
 	inode->i_uid = (uid_t)le16_to_cpu(raw_inode->i_uid_low);
 	inode->i_gid = (gid_t)le16_to_cpu(raw_inode->i_gid_low);
@@ -3490,6 +3547,9 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 		ei->i_extra_isize = le16_to_cpu(raw_inode->i_extra_isize);
 		if (EXT4_GOOD_OLD_INODE_SIZE + ei->i_extra_isize >
 		    EXT4_INODE_SIZE(inode->i_sb)) {
+			EXT4_ERROR_INODE(inode, "bad extra_isize (%u != %u)",
+				EXT4_GOOD_OLD_INODE_SIZE + ei->i_extra_isize,
+				EXT4_INODE_SIZE(inode->i_sb));
 			ret = -EIO;
 			goto bad_inode;
 		}
@@ -3731,6 +3791,8 @@ static int ext4_do_update_inode(handle_t *handle,
 		raw_inode->i_extra_isize = cpu_to_le16(ei->i_extra_isize);
 	}
 
+	ext4_inode_csum_set(inode, raw_inode);
+
 	BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
 	rc = ext4_handle_dirty_metadata(handle, NULL, bh);
 	if (!err)

