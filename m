From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [RFC][PATCH 1/8] exchange the blocks between two inodes
Date: Fri, 04 Apr 2008 20:19:14 +0900
Message-ID: <47F60EB2.9080005@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org,
	Akira Fujita <a-fujita@rs.jp.nec.com>
To: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
	Mingming Cao <cmm@us.ibm.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:50562 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbYDDLV1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Apr 2008 07:21:27 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4: online defrag-- Exchange the blocks between two inodes

From: Akira Fujita <a-fujita@rs.jp.nec.com>

Exchange the data blocks between the temporary inode and
the original inode.

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
---
 fs/ext4/Makefile       |    2 +-
 fs/ext4/defrag.c       |  272 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/ext4_extents.h |    2 +
 fs/ext4/extents.c      |    2 +-
 4 files changed, 276 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/Makefile b/fs/ext4/Makefile
index ac6fa8c..8028102 100644
--- a/fs/ext4/Makefile
+++ b/fs/ext4/Makefile
@@ -6,7 +6,7 @@ obj-$(CONFIG_EXT4DEV_FS) += ext4dev.o

 ext4dev-y	:= balloc.o bitmap.o dir.o file.o fsync.o ialloc.o inode.o \
 		   ioctl.o namei.o super.o symlink.o hash.o resize.o extents.o \
-		   ext4_jbd2.o migrate.o mballoc.o
+		   ext4_jbd2.o migrate.o mballoc.o defrag.o

 ext4dev-$(CONFIG_EXT4DEV_FS_XATTR)	+= xattr.o xattr_user.o xattr_trusted.o
 ext4dev-$(CONFIG_EXT4DEV_FS_POSIX_ACL)	+= acl.o
diff --git a/fs/ext4/defrag.c b/fs/ext4/defrag.c
index e69de29..5cdf610 100644
--- a/fs/ext4/defrag.c
+++ b/fs/ext4/defrag.c
@@ -0,0 +1,272 @@
+/* Online defragmentation for EXT4 */
+
+#include <linux/quotaops.h>
+#include "ext4_jbd2.h"
+#include "ext4_extents.h"
+#include "group.h"
+
+/**
+ * ext4_defrag_merge_across_blocks - Merge extents across leaf block
+ *
+ * @handle	journal handle
+ * @inode	target file's inode
+ * @o_start	first original extent to be defraged
+ * @o_end	last original extent to be defraged
+ * @start_ext	first new extent to be merged
+ * @new_ext	middle of new extent to be merged
+ * @end_ext	last new extent to be merged
+ *
+ * This function returns 0 if succeed, otherwise returns error value.
+ */
+static int
+ext4_defrag_merge_across_blocks(handle_t *handle, struct inode *inode,
+		struct ext4_extent *o_start,
+		struct ext4_extent *o_end, struct ext4_extent *start_ext,
+		struct ext4_extent *new_ext, struct ext4_extent *end_ext)
+{
+	struct ext4_ext_path *org_path = NULL;
+	ext4_lblk_t eblock = 0;
+	int err = 0;
+	int new_flag = 0;
+	int end_flag = 0;
+
+	if (le16_to_cpu(start_ext->ee_len) &&
+		le16_to_cpu(new_ext->ee_len) &&
+		le16_to_cpu(end_ext->ee_len)) {
+
+		if ((o_start) == (o_end)) {
+
+			/*       start_ext   new_ext    end_ext
+			 * dest |---------|-----------|--------|
+			 * org  |------------------------------|
+			 */
+
+			end_flag = 1;
+		} else {
+
+			/*       start_ext   new_ext   end_ext
+			 * dest |---------|----------|---------|
+			 * org  |---------------|--------------|
+			 */
+
+			o_end->ee_block = end_ext->ee_block;
+			o_end->ee_len = end_ext->ee_len;
+			ext4_ext_store_pblock(o_end, ext_pblock(end_ext));
+		}
+
+		o_start->ee_len = start_ext->ee_len;
+		new_flag = 1;
+
+	} else if ((le16_to_cpu(start_ext->ee_len)) &&
+			(le16_to_cpu(new_ext->ee_len)) &&
+			(!le16_to_cpu(end_ext->ee_len)) &&
+			((o_start) == (o_end))) {
+
+		/*	 start_ext	new_ext
+		 * dest |--------------|---------------|
+		 * org  |------------------------------|
+		 */
+
+		o_start->ee_len = start_ext->ee_len;
+		new_flag = 1;
+
+	} else if ((!le16_to_cpu(start_ext->ee_len)) &&
+			(le16_to_cpu(new_ext->ee_len)) &&
+			(le16_to_cpu(end_ext->ee_len)) &&
+			((o_start) == (o_end))) {
+
+		/*	  new_ext	end_ext
+		 * dest |--------------|---------------|
+		 * org  |------------------------------|
+		 */
+
+		o_end->ee_block = end_ext->ee_block;
+		o_end->ee_len = end_ext->ee_len;
+		ext4_ext_store_pblock(o_end, ext_pblock(end_ext));
+
+		/*
+		 * Set 0 to the extent block if new_ext was
+		 * the first block.
+		 */
+		if (!new_ext->ee_block)
+			eblock = 0;
+		else
+			eblock = le32_to_cpu(new_ext->ee_block);
+
+		new_flag = 1;
+	} else {
+		printk(KERN_ERR "ext4 defrag: Unexpected merge case\n");
+		return -EIO;
+	}
+
+	if (new_flag) {
+		org_path = ext4_ext_find_extent(inode, eblock, NULL);
+		if (IS_ERR(org_path)) {
+			err = PTR_ERR(org_path);
+			org_path = NULL;
+			goto out;
+		}
+		err = ext4_ext_insert_extent(handle, inode, org_path, new_ext);
+		if (err)
+			goto out;
+	}
+
+	if (end_flag) {
+		org_path = ext4_ext_find_extent(inode,
+				le32_to_cpu(end_ext->ee_block) - 1, org_path);
+		if (IS_ERR(org_path)) {
+			err = PTR_ERR(org_path);
+			org_path = NULL;
+			goto out;
+		}
+		err = ext4_ext_insert_extent(handle, inode, org_path, end_ext);
+		if (err)
+			goto out;
+	}
+out:
+	if (org_path) {
+		ext4_ext_drop_refs(org_path);
+		kfree(org_path);
+	}
+
+	return err;
+
+}
+
+/**
+ * ext4_defrag_merge_inside_block - Merge new extent to the extent block
+ *
+ * @handle		journal handle
+ * @inode		target file's inode
+ * @o_start		first original extent to be defraged
+ * @o_end		last original extent to be merged
+ * @start_ext		first new extent to be merged
+ * @new_ext		middle of new extent to be merged
+ * @end_ext		last new extent to be merged
+ * @eh			extent header of target leaf block
+ * @replaced		the number of blocks which will be replaced with new_ext
+ * @range_to_move	used to decide how to merge
+ *
+ * This function always returns 0.
+ */
+static int
+ext4_defrag_merge_inside_block(handle_t *handle, struct inode *inode,
+		struct ext4_extent *o_start, struct ext4_extent *o_end,
+		struct ext4_extent *start_ext, struct ext4_extent *new_ext,
+		struct ext4_extent *end_ext, struct ext4_extent_header *eh,
+		ext4_fsblk_t replaced, int range_to_move)
+{
+	int i = 0;
+	unsigned len;
+
+	/* Move the existing extents */
+	if (range_to_move && o_end < EXT_LAST_EXTENT(eh)) {
+		len = (unsigned long)(EXT_LAST_EXTENT(eh) + 1) -
+			(unsigned long)(o_end + 1);
+		memmove(o_end + 1 + range_to_move, o_end + 1, len);
+	}
+
+	/* Insert start entry */
+	if (le16_to_cpu(start_ext->ee_len))
+		o_start[i++].ee_len = start_ext->ee_len;
+
+	/* Insert new entry */
+	if (le16_to_cpu(new_ext->ee_len)) {
+		o_start[i].ee_block = new_ext->ee_block;
+		o_start[i].ee_len = cpu_to_le16(replaced);
+		ext4_ext_store_pblock(&o_start[i++], ext_pblock(new_ext));
+	}
+
+	/* Insert end entry */
+	if (end_ext->ee_len)
+		o_start[i] = *end_ext;
+
+	/* Increment the total entries counter on the extent block */
+	eh->eh_entries
+		= cpu_to_le16(le16_to_cpu(eh->eh_entries) + range_to_move);
+
+	return 0;
+}
+
+/**
+ * ext4_defrag_merge_extents - Merge new extent
+ *
+ * @handle	journal handle
+ * @inode	target file's inode
+ * @org_path	path indicates first extent to be defraged
+ * @o_start	first original extent to be defraged
+ * @o_end	last original extent to be defraged
+ * @start_ext	first new extent to be merged
+ * @new_ext	middle of new extent to be merged
+ * @end_ext	last new extent to be merged
+ * @replaced	the number of blocks which will be replaced with new_ext
+ *
+ * This function returns 0 if succeed, otherwise returns error value.
+ */
+static int
+ext4_defrag_merge_extents(handle_t *handle, struct inode *inode,
+		struct ext4_ext_path *org_path,
+		struct ext4_extent *o_start, struct ext4_extent *o_end,
+		struct ext4_extent *start_ext, struct ext4_extent *new_ext,
+		struct ext4_extent *end_ext, ext4_fsblk_t replaced)
+{
+	struct  ext4_extent_header *eh;
+	unsigned need_slots, slots_range;
+	int	range_to_move, depth, ret;
+
+	/*
+	 * The extents need to be inserted
+	 * start_extent + new_extent + end_extent.
+	 */
+	need_slots = (le16_to_cpu(start_ext->ee_len) ? 1 : 0) +
+			(le16_to_cpu(end_ext->ee_len) ? 1 : 0) +
+			(le16_to_cpu(new_ext->ee_len) ? 1 : 0);
+
+	/* The number of slots between start and end */
+	slots_range = ((unsigned long)(o_end + 1) - (unsigned long)o_start + 1)
+					/ sizeof(struct ext4_extent);
+
+	/* Range to move the end of extent */
+	range_to_move = need_slots - slots_range;
+	depth = org_path->p_depth;
+	org_path += depth;
+	eh = org_path->p_hdr;
+
+	if (depth) {
+		/* Register to journal */
+		ret = ext4_journal_get_write_access(handle, org_path->p_bh);
+		if (ret)
+			return ret;
+	}
+
+	/* Expansion */
+	if ((range_to_move > 0) &&
+		(range_to_move > le16_to_cpu(eh->eh_max)
+			- le16_to_cpu(eh->eh_entries))) {
+
+		ret = ext4_defrag_merge_across_blocks(handle, inode, o_start,
+						o_end, start_ext, new_ext,
+						end_ext);
+		if (ret < 0)
+			return ret;
+	} else {
+		ret = ext4_defrag_merge_inside_block(handle, inode, o_start,
+					o_end, start_ext, new_ext, end_ext,
+					eh, replaced, range_to_move);
+		if (ret < 0)
+			return ret;
+	}
+
+	if (depth) {
+		ret = ext4_journal_dirty_metadata(handle, org_path->p_bh);
+		if (ret)
+			return ret;
+	} else {
+		ret = ext4_mark_inode_dirty(handle, inode);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+
+}
diff --git a/fs/ext4/ext4_extents.h b/fs/ext4/ext4_extents.h
index 75333b5..9868c02 100644
--- a/fs/ext4/ext4_extents.h
+++ b/fs/ext4/ext4_extents.h
@@ -228,5 +228,7 @@ extern int ext4_ext_search_left(struct inode *, struct ext4_ext_path *,
 extern int ext4_ext_search_right(struct inode *, struct ext4_ext_path *,
 						ext4_lblk_t *, ext4_fsblk_t *);
 extern void ext4_ext_drop_refs(struct ext4_ext_path *);
+extern ext4_fsblk_t ext_pblock(struct ext4_extent *ex);
+extern void ext4_ext_drop_refs(struct ext4_ext_path *path);
 #endif /* _EXT4_EXTENTS */

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 30f0f99..1293b47 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -48,7 +48,7 @@
  * ext_pblock:
  * combine low and high parts of physical block number into ext4_fsblk_t
  */
-static ext4_fsblk_t ext_pblock(struct ext4_extent *ex)
+ext4_fsblk_t ext_pblock(struct ext4_extent *ex)
 {
 	ext4_fsblk_t block;

