From: Radek Pazdera <rpazdera@redhat.com>
Subject: [RFC v2 3/9] ext4: Adding a link to itree to the dx_root struct
Date: Mon, 13 May 2013 17:42:04 +0200
Message-ID: <1368459730-3405-4-git-send-email-rpazdera@redhat.com>
References: <1368459730-3405-1-git-send-email-rpazdera@redhat.com>
Cc: lczerner@redhat.com, kasparek@fit.vutbr.cz,
	Radek Pazdera <rpazdera@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753843Ab3EMQmr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 May 2013 12:42:47 -0400
In-Reply-To: <1368459730-3405-1-git-send-email-rpazdera@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The dx_tail struct that can be stored at the end of each root block was
extended with an additional link to the itree root block.

This commit renames the dx_tail to dx_csum_entry and adds dx_itree_entry
that holds the 64bit block pointer to itree root. The two structures are
independent of each other, so in case any of the features is disabled,
the correspoinding structure doesn't have to be in the tail. However,
a case where the corresponding flag is off and the structure still
resides in the tail is possible when the flag is turned off by tune2fs.

Signed-off-by: Radek Pazdera <rpazdera@redhat.com>
---
 fs/ext4/namei.c | 204 ++++++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 162 insertions(+), 42 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 6f73f81..20cf635 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -235,9 +235,30 @@ struct dx_map_entry
 /*
  * This goes at the end of each htree block.
  */
+struct dx_csum_entry {
+	u32 de_reserved;
+	__le32 de_checksum;	/* crc32c(uuid+inum+dirblock) */
+};
+
+/*
+ * This goes at the end of a htree root block, if there is an itree
+ * available for that directory.
+ */
+struct dx_itree_entry {
+	__le64 de_itree_root;
+};
+
+/*
+ * This is a memory-only structure for easier handling the tail of
+ * dx_node. One or even both members can be set to NULL, which means
+ * that the node doesn't have the particular entry.
+ */
 struct dx_tail {
-	u32 dt_reserved;
-	__le32 dt_checksum;	/* crc32c(uuid+inum+dirblock) */
+	void *start;
+	int len;
+
+	struct dx_csum_entry *csum;
+	struct dx_itree_entry *itree;
 };
 
 static inline ext4_lblk_t dx_get_block(struct dx_entry *entry);
@@ -250,6 +271,10 @@ static void dx_set_count(struct dx_entry *entries, unsigned value);
 static void dx_set_limit(struct dx_entry *entries, unsigned value);
 static unsigned dx_root_limit(struct inode *dir, unsigned infosize);
 static unsigned dx_node_limit(struct inode *dir);
+static int dx_get_itree_root(struct inode *inode, struct ext4_dir_entry *dirent,
+			     ext4_fsblk_t *itree_root);
+static int dx_set_itree_root(struct inode *inode, struct ext4_dir_entry *dirent,
+			     ext4_fsblk_t itree_root);
 static struct dx_frame *dx_probe(const struct qstr *d_name,
 				 struct inode *dir,
 				 struct dx_hash_info *hinfo,
@@ -417,81 +442,136 @@ static struct dx_countlimit *get_dx_countlimit(struct inode *inode,
 	return (struct dx_countlimit *)(((void *)dirent) + count_offset);
 }
 
-static __le32 ext4_dx_csum(struct inode *inode, struct ext4_dir_entry *dirent,
-			   int count_offset, int count, struct dx_tail *t)
+static int dx_get_tail(struct inode *inode, struct ext4_dir_entry *dirent,
+		       struct dx_tail *tail)
+{
+	struct dx_countlimit *c;
+	int tail_space, limit, count_offset;
+	void *tail_ptr;
+
+	c = get_dx_countlimit(inode, dirent, &count_offset);
+	if (!c) {
+		EXT4_ERROR_INODE(inode, "dir seems corrupt?  Run e2fsck -D.");
+		return -EIO;
+	}
+	limit = le16_to_cpu(c->limit);
+
+	memset(tail, 0, sizeof(struct dx_tail));
+	tail_ptr = tail->start = (void *)(((struct dx_entry *)c) + limit);
+	tail_space = EXT4_BLOCK_SIZE(inode->i_sb) -
+		     (count_offset + (limit * sizeof(struct dx_entry)));
+
+	/* TODO This still requires some attention.
+	 *
+	 * We must handle cases where the tail structure is there,
+	 * but the feature flag is off. This can happen when the
+	 * feature is turned off using tune2fs.
+	 *
+	 * This means that, either the checksum part of the tail will
+	 * be always added along with the itree one, even when the csum
+	 * flag is off, or we need a way of differentiating between the
+	 * two structures in case there is only one present.
+	 *
+	 * Also, in case both features are on and itree is turned off,
+	 * we still need to use the structure while computing the checksum.
+	 *
+	 * Adding the pointer here will also require a patch for e2fsck.
+	 */
+	if (EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
+				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
+	    tail_space >= sizeof(struct dx_csum_entry)) {
+		tail->len += sizeof(struct dx_csum_entry);
+		tail->csum = (struct dx_csum_entry *)tail_ptr;
+		tail_ptr += sizeof(struct dx_csum_entry);
+		tail_space -= sizeof(struct dx_csum_entry);
+	}
+
+	if (dx_itree(inode) && tail_space >= sizeof(struct dx_itree_entry)) {
+		tail->len += sizeof(struct dx_itree_entry);
+		tail->itree = (struct dx_itree_entry *)tail_ptr;
+	}
+
+	return 0;
+}
+
+static int ext4_dx_csum(struct inode *inode, struct ext4_dir_entry *dirent,
+			struct dx_tail *tail, __le32 *csum)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	struct ext4_inode_info *ei = EXT4_I(inode);
-	__u32 csum;
-	__le32 save_csum;
-	int size;
+	struct dx_countlimit *c;
+	int size, count, count_offset;
+	__u32 new_csum;
+	__le32 old_csum;
+
+	c = get_dx_countlimit(inode, dirent, &count_offset);
+	if (!c)
+		return -EIO;
+	count = le16_to_cpu(c->count);
 
 	size = count_offset + (count * sizeof(struct dx_entry));
-	save_csum = t->dt_checksum;
-	t->dt_checksum = 0;
-	csum = ext4_chksum(sbi, ei->i_csum_seed, (__u8 *)dirent, size);
-	csum = ext4_chksum(sbi, csum, (__u8 *)t, sizeof(struct dx_tail));
-	t->dt_checksum = save_csum;
+	old_csum = tail->csum->de_checksum;
+	tail->csum->de_checksum = 0;
+	new_csum = ext4_chksum(sbi, ei->i_csum_seed, (__u8 *)dirent, size);
+	new_csum = ext4_chksum(sbi, new_csum, (__u8 *)tail->start, tail->len);
+	tail->csum->de_checksum = old_csum;
 
-	return cpu_to_le32(csum);
+	*csum = cpu_to_le32(new_csum);
+	return 0;
 }
 
 static int ext4_dx_csum_verify(struct inode *inode,
 			       struct ext4_dir_entry *dirent)
 {
-	struct dx_countlimit *c;
-	struct dx_tail *t;
-	int count_offset, limit, count;
+	struct dx_tail tail;
+	int err;
+	__le32 csum;
 
 	if (!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
 					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
 		return 1;
 
-	c = get_dx_countlimit(inode, dirent, &count_offset);
-	if (!c) {
-		EXT4_ERROR_INODE(inode, "dir seems corrupt?  Run e2fsck -D.");
+	err = dx_get_tail(inode, dirent, &tail);
+	if (err)
+		return err;
+
+	if (!tail.csum) {
+		warn_no_space_for_csum(inode);
 		return 1;
 	}
-	limit = le16_to_cpu(c->limit);
-	count = le16_to_cpu(c->count);
-	if (count_offset + (limit * sizeof(struct dx_entry)) >
-	    EXT4_BLOCK_SIZE(inode->i_sb) - sizeof(struct dx_tail)) {
-		warn_no_space_for_csum(inode);
+
+	err = ext4_dx_csum(inode, dirent, &tail, &csum);
+	if (err) {
+		EXT4_ERROR_INODE(inode, "dir seems corrupt?  Run e2fsck -D.");
 		return 1;
 	}
-	t = (struct dx_tail *)(((struct dx_entry *)c) + limit);
 
-	if (t->dt_checksum != ext4_dx_csum(inode, dirent, count_offset,
-					    count, t))
+	if (tail.csum->de_checksum != csum)
 		return 0;
 	return 1;
 }
 
 static void ext4_dx_csum_set(struct inode *inode, struct ext4_dir_entry *dirent)
 {
-	struct dx_countlimit *c;
-	struct dx_tail *t;
-	int count_offset, limit, count;
+	struct dx_tail tail;
+	int err;
 
 	if (!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
 					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
 		return;
 
-	c = get_dx_countlimit(inode, dirent, &count_offset);
-	if (!c) {
-		EXT4_ERROR_INODE(inode, "dir seems corrupt?  Run e2fsck -D.");
+	err = dx_get_tail(inode, dirent, &tail);
+	if (err)
 		return;
-	}
-	limit = le16_to_cpu(c->limit);
-	count = le16_to_cpu(c->count);
-	if (count_offset + (limit * sizeof(struct dx_entry)) >
-	    EXT4_BLOCK_SIZE(inode->i_sb) - sizeof(struct dx_tail)) {
+
+	if (!tail.csum) {
 		warn_no_space_for_csum(inode);
 		return;
 	}
-	t = (struct dx_tail *)(((struct dx_entry *)c) + limit);
 
-	t->dt_checksum = ext4_dx_csum(inode, dirent, count_offset, count, t);
+	err = ext4_dx_csum(inode, dirent, &tail, &(tail.csum->de_checksum));
+	if (err)
+		EXT4_ERROR_INODE(inode, "dir seems corrupt?  Run e2fsck -D.");
 }
 
 static inline int ext4_handle_dirty_dx_node(handle_t *handle,
@@ -564,7 +644,9 @@ static inline unsigned dx_root_limit(struct inode *dir, unsigned infosize)
 
 	if (EXT4_HAS_RO_COMPAT_FEATURE(dir->i_sb,
 				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
-		entry_space -= sizeof(struct dx_tail);
+		entry_space -= sizeof(struct dx_csum_entry);
+	if (dx_itree(dir))
+		entry_space -= sizeof(struct dx_itree_entry);
 	return entry_space / sizeof(struct dx_entry);
 }
 
@@ -574,10 +656,48 @@ static inline unsigned dx_node_limit(struct inode *dir)
 
 	if (EXT4_HAS_RO_COMPAT_FEATURE(dir->i_sb,
 				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
-		entry_space -= sizeof(struct dx_tail);
+		entry_space -= sizeof(struct dx_csum_entry);
 	return entry_space / sizeof(struct dx_entry);
 }
 
+static int dx_get_itree_root(struct inode *inode, struct ext4_dir_entry *dirent,
+			     ext4_fsblk_t *itree_root)
+{
+	int err;
+	struct dx_tail tail;
+
+	err = dx_get_tail(inode, dirent, &tail);
+	if (err)
+		return err;
+
+	if (!tail.itree) {
+		EXT4_ERROR_INODE(inode, "dir seems corrupt?  Run e2fsck -D.");
+		return -EIO;
+	}
+
+	*itree_root = le64_to_cpu(tail.itree->de_itree_root);
+	return 0;
+}
+
+static int dx_set_itree_root(struct inode *inode, struct ext4_dir_entry *dirent,
+			     ext4_fsblk_t itree_root)
+{
+	int err;
+	struct dx_tail tail;
+
+	err = dx_get_tail(inode, dirent, &tail);
+	if (err)
+		return err;
+
+	if (!tail.itree) {
+		EXT4_ERROR_INODE(inode, "dir seems corrupt?  Run e2fsck -D.");
+		return -EIO;
+	}
+
+	tail.itree->de_itree_root = cpu_to_le64(itree_root);
+	return 0;
+}
+
 /*
  * Debug
  */
-- 
1.7.11.7

