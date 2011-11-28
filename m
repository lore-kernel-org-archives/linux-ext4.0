From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 10/22] ext4: Verify and calculate checksums for extent tree
	blocks
Date: Mon, 28 Nov 2011 15:27:25 -0800
Message-ID: <20111128232725.19194.12626.stgit@elm3c44.beaverton.ibm.com>
References: <20111128232615.19194.80081.stgit@elm3c44.beaverton.ibm.com>
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
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:34779 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755823Ab1K1XaK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Nov 2011 18:30:10 -0500
Received: from /spool/local
	by e2.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Mon, 28 Nov 2011 18:30:08 -0500
In-Reply-To: <20111128232615.19194.80081.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Calculate and verify the checksum for each extent tree block.  The checksum is
located in the space immediately after the last possible ext4_extent in the
block.  The space is is typically the last 4-8 bytes in the block.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 fs/ext4/ext4_extents.h |   25 +++++++++++++++++++++++-
 fs/ext4/extents.c      |   50 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 74 insertions(+), 1 deletions(-)


diff --git a/fs/ext4/ext4_extents.h b/fs/ext4/ext4_extents.h
index a52db3a..56e891a 100644
--- a/fs/ext4/ext4_extents.h
+++ b/fs/ext4/ext4_extents.h
@@ -62,10 +62,22 @@
 /*
  * ext4_inode has i_block array (60 bytes total).
  * The first 12 bytes store ext4_extent_header;
- * the remainder stores an array of ext4_extent.
+ * the remainder stores an array of ext4_extent,
+ * followed by ext4_extent_tail.
  */
 
 /*
+ * This is the extent tail on-disk structure.
+ * All other extent structures are 12 bytes long.  It turns out that
+ * block_size % 12 >= 4 for all valid block sizes (1k, 2k, 4k).
+ * Therefore, this tail structure can be crammed into the end of the block
+ * without having to rebalance the tree.
+ */
+struct ext4_extent_tail {
+	__le32	et_checksum;	/* crc32c(uuid+inum+extent_block) */
+};
+
+/*
  * This is the extent on-disk structure.
  * It's used at the bottom of the tree.
  */
@@ -101,6 +113,17 @@ struct ext4_extent_header {
 
 #define EXT4_EXT_MAGIC		cpu_to_le16(0xf30a)
 
+#define EXT4_EXTENT_TAIL_OFFSET(hdr) \
+	(sizeof(struct ext4_extent_header) + \
+	 (sizeof(struct ext4_extent) * le16_to_cpu((hdr)->eh_max)))
+
+static inline struct ext4_extent_tail *
+find_ext4_extent_tail(struct ext4_extent_header *eh)
+{
+	return (struct ext4_extent_tail *)(((void *)eh) +
+					   EXT4_EXTENT_TAIL_OFFSET(eh));
+}
+
 /*
  * Array of ext4_ext_path contains path to some extent.
  * Creation/lookup routines use it for traversal/splitting/etc.
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 00f97f4..5db751e 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -45,6 +45,46 @@
 
 #include <trace/events/ext4.h>
 
+static __le32 ext4_extent_block_csum(struct inode *inode,
+				     struct ext4_extent_header *eh)
+{
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	__u32 csum;
+
+	csum = ext4_chksum(sbi, ei->i_uuid_inum_csum, (__u8 *)eh,
+			   EXT4_EXTENT_TAIL_OFFSET(eh));
+	return cpu_to_le32(csum);
+}
+
+static int ext4_extent_block_csum_verify(struct inode *inode,
+					 struct ext4_extent_header *eh)
+{
+	struct ext4_extent_tail *et;
+
+	if (!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
+		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return 1;
+
+	et = find_ext4_extent_tail(eh);
+	if (et->et_checksum != ext4_extent_block_csum(inode, eh))
+		return 0;
+	return 1;
+}
+
+static void ext4_extent_block_csum_set(struct inode *inode,
+				       struct ext4_extent_header *eh)
+{
+	struct ext4_extent_tail *et;
+
+	if (!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
+		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return;
+
+	et = find_ext4_extent_tail(eh);
+	et->et_checksum = ext4_extent_block_csum(inode, eh);
+}
+
 static int ext4_split_extent(handle_t *handle,
 				struct inode *inode,
 				struct ext4_ext_path *path,
@@ -103,6 +143,7 @@ static int __ext4_ext_dirty(const char *where, unsigned int line,
 {
 	int err;
 	if (path->p_bh) {
+		ext4_extent_block_csum_set(inode, ext_block_hdr(path->p_bh));
 		/* path points to block */
 		err = __ext4_handle_dirty_metadata(where, line, handle,
 						   inode, path->p_bh);
@@ -375,6 +416,12 @@ static int __ext4_ext_check(const char *function, unsigned int line,
 		error_msg = "invalid extent entries";
 		goto corrupted;
 	}
+	/* Verify checksum on non-root extent tree nodes */
+	if (ext_depth(inode) != depth &&
+	    !ext4_extent_block_csum_verify(inode, eh)) {
+		error_msg = "extent tree corrupted";
+		goto corrupted;
+	}
 	return 0;
 
 corrupted:
@@ -914,6 +961,7 @@ static int ext4_ext_split(handle_t *handle, struct inode *inode,
 		le16_add_cpu(&neh->eh_entries, m);
 	}
 
+	ext4_extent_block_csum_set(inode, neh);
 	set_buffer_uptodate(bh);
 	unlock_buffer(bh);
 
@@ -992,6 +1040,7 @@ static int ext4_ext_split(handle_t *handle, struct inode *inode,
 				sizeof(struct ext4_extent_idx) * m);
 			le16_add_cpu(&neh->eh_entries, m);
 		}
+		ext4_extent_block_csum_set(inode, neh);
 		set_buffer_uptodate(bh);
 		unlock_buffer(bh);
 
@@ -1089,6 +1138,7 @@ static int ext4_ext_grow_indepth(handle_t *handle, struct inode *inode,
 	else
 		neh->eh_max = cpu_to_le16(ext4_ext_space_block(inode, 0));
 	neh->eh_magic = EXT4_EXT_MAGIC;
+	ext4_extent_block_csum_set(inode, neh);
 	set_buffer_uptodate(bh);
 	unlock_buffer(bh);
 

