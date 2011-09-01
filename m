From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 10/16] ext4: Verify and calculate checksums for extent tree
	blocks
Date: Wed, 31 Aug 2011 17:31:41 -0700
Message-ID: <20110901003140.31048.74275.stgit@elm3c44.beaverton.ibm.com>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110901003030.31048.99467.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Calculate and verify the checksum for each extent tree block.  The checksum is
located immediately after the last ext4_extent in the block, which is typically
4-8 bytes in size.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 fs/ext4/ext4_extents.h |   25 ++++++++++++++++++-
 fs/ext4/extents.c      |   64 +++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 84 insertions(+), 5 deletions(-)


diff --git a/fs/ext4/ext4_extents.h b/fs/ext4/ext4_extents.h
index 095c36f..24b106a 100644
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
index 4ac4303..94f09ce 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -41,11 +41,57 @@
 #include <linux/falloc.h>
 #include <asm/uaccess.h>
 #include <linux/fiemap.h>
+#include <linux/crc32c.h>
 #include "ext4_jbd2.h"
 #include "ext4_extents.h"
 
 #include <trace/events/ext4.h>
 
+static __le32 ext4_extent_block_csum(struct inode *inode,
+				     struct ext4_extent_header *eh)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	__le32 inum = cpu_to_le32(inode->i_ino);
+	__u32 crc = 0;
+
+	if (!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
+		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return 0;
+
+	crc = crc32c_le(~0, sbi->s_es->s_uuid, sizeof(sbi->s_es->s_uuid));
+	crc = crc32c_le(crc, (__u8 *)&inum, sizeof(inum));
+	crc = crc32c_le(crc, (__u8 *)eh, EXT4_EXTENT_TAIL_OFFSET(eh));
+	return cpu_to_le32(crc);
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
@@ -101,6 +147,7 @@ static int ext4_ext_dirty(handle_t *handle, struct inode *inode,
 {
 	int err;
 	if (path->p_bh) {
+		ext4_extent_block_csum_set(inode, ext_block_hdr(path->p_bh));
 		/* path points to block */
 		err = ext4_handle_dirty_metadata(handle, inode, path->p_bh);
 	} else {
@@ -382,6 +429,12 @@ static int __ext4_ext_check(const char *function, unsigned int line,
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
@@ -922,6 +975,7 @@ static int ext4_ext_split(handle_t *handle, struct inode *inode,
 		le16_add_cpu(&neh->eh_entries, m);
 	}
 
+	ext4_extent_block_csum_set(inode, neh);
 	set_buffer_uptodate(bh);
 	unlock_buffer(bh);
 
@@ -1000,6 +1054,7 @@ static int ext4_ext_split(handle_t *handle, struct inode *inode,
 				sizeof(struct ext4_extent_idx) * m);
 			le16_add_cpu(&neh->eh_entries, m);
 		}
+		ext4_extent_block_csum_set(inode, neh);
 		set_buffer_uptodate(bh);
 		unlock_buffer(bh);
 
@@ -1098,6 +1153,7 @@ static int ext4_ext_grow_indepth(handle_t *handle, struct inode *inode,
 	else
 		neh->eh_max = cpu_to_le16(ext4_ext_space_block(inode, 0));
 	neh->eh_magic = EXT4_EXT_MAGIC;
+	ext4_extent_block_csum_set(inode, neh);
 	set_buffer_uptodate(bh);
 	unlock_buffer(bh);
 
@@ -2458,10 +2514,6 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
 		if (uninitialized && num)
 			ext4_ext_mark_uninitialized(ex);
 
-		err = ext4_ext_dirty(handle, inode, path + depth);
-		if (err)
-			goto out;
-
 		/*
 		 * If the extent was completely released,
 		 * we need to remove it from the leaf
@@ -2483,6 +2535,10 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
 			le16_add_cpu(&eh->eh_entries, -1);
 		}
 
+		err = ext4_ext_dirty(handle, inode, path + depth);
+		if (err)
+			goto out;
+
 		ext_debug("new extent: %u:%u:%llu\n", block, num,
 				ext4_ext_pblock(ex));
 		ex--;
