From: Kalpak Shah <kalpak@clusterfs.com>
Subject: [PATCH 3/6] Changes for 64-bit i_version
Date: Thu, 14 Jun 2007 21:26:17 +0530
Message-ID: <1181836577.7779.45.camel@garfield>
References: <1181835073.7779.9.camel@garfield>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-nVcnVT9h4PPxvCdex8VE"
Cc: Mingming Cao <cmm@us.ibm.com>,
	Jean noel Cordenner <jean-noel.cordenner@bull.net>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:32994 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbXFNP4Y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Jun 2007 11:56:24 -0400
In-Reply-To: <1181835073.7779.9.camel@garfield>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--=-nVcnVT9h4PPxvCdex8VE
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

ext4_i_version_hi_2.patch was still using ei->i_fs_version instead of
inode->i_version. I have corrected it.

Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
fs/ext4/inode.c         |   15 ++++++++++++++-
 include/linux/ext4_fs.h |    4 +++-
 2 files changed, 17 insertions(+), 2 deletions(-)



--=-nVcnVT9h4PPxvCdex8VE
Content-Disposition: attachment; filename=ext4_i_version_hi_2.patch
Content-Type: text/x-patch; name=ext4_i_version_hi_2.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

This patch adds 64-bit inode version support to ext4. The lower 32 bits
are stored in the osd1.linux1.l_i_version field while the high 32 bits
are stored in the i_version_hi field newly created in the ext4_inode.

Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>

Index: linux-2.6.21/fs/ext4/inode.c
===================================================================
--- linux-2.6.21.orig/fs/ext4/inode.c
+++ linux-2.6.21/fs/ext4/inode.c
@@ -2709,6 +2709,13 @@ void ext4_read_inode(struct inode * inod
 	EXT4_INODE_GET_XTIME(i_atime, inode, raw_inode);
 	EXT4_EINODE_GET_XTIME(i_crtime, ei, raw_inode);
 
+	inode->i_version = le32_to_cpu(raw_inode->i_disk_version);
+	if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE) {
+		if (EXT4_FITS_IN_INODE(raw_inode, ei, i_version_hi))
+			inode->i_version |=
+			(__u64)(le32_to_cpu(raw_inode->i_version_hi)) << 32;
+	}
+
 	if (S_ISREG(inode->i_mode)) {
 		inode->i_op = &ext4_file_inode_operations;
 		inode->i_fop = &ext4_file_operations;
@@ -2852,8 +2859,14 @@ static int ext4_do_update_inode(handle_t
 	} else for (block = 0; block < EXT4_N_BLOCKS; block++)
 		raw_inode->i_block[block] = ei->i_data[block];
 
-	if (ei->i_extra_isize)
+	raw_inode->i_disk_version = cpu_to_le32(inode->i_version);
+	if (ei->i_extra_isize) {
+		if (EXT4_FITS_IN_INODE(raw_inode, ei, i_version_hi)) {
+			raw_inode->i_version_hi =
+				cpu_to_le32(inode->i_version >> 32);
+		}
 		raw_inode->i_extra_isize = cpu_to_le16(ei->i_extra_isize);
+	}
 
 	BUFFER_TRACE(bh, "call ext4_journal_dirty_metadata");
 	rc = ext4_journal_dirty_metadata(handle, bh);
Index: linux-2.6.21/include/linux/ext4_fs.h
===================================================================
--- linux-2.6.21.orig/include/linux/ext4_fs.h
+++ linux-2.6.21/include/linux/ext4_fs.h
@@ -297,7 +297,7 @@ struct ext4_inode {
 	__le32	i_flags;	/* File flags */
 	union {
 		struct {
-			__u32  l_i_reserved1;
+			__u32  l_i_version;
 		} linux1;
 		struct {
 			__u32  h_i_translator;
@@ -406,6 +406,8 @@ do {									       \
 				       raw_inode->xtime ## _extra);	       \
 } while (0)
 
+#define i_disk_version osd1.linux1.l_i_version
+
 #if defined(__KERNEL__) || defined(__linux__)
 #define i_reserved1	osd1.linux1.l_i_reserved1
 #define i_frag		osd2.linux2.l_i_frag

--=-nVcnVT9h4PPxvCdex8VE--
