From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 11/16] ext4: Calculate and verify checksums for htree nodes
Date: Wed, 31 Aug 2011 17:31:47 -0700
Message-ID: <20110901003147.31048.1245.stgit@elm3c44.beaverton.ibm.com>
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

Calculate and verify the checksum for directory index tree (htree) node blocks.
The checksum is stored in the last 4 bytes of the htree block and requires the
dx_entry array to stop 1 dx_entry short of the end of the block.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 fs/ext4/namei.c |  179 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 175 insertions(+), 4 deletions(-)


diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index a067835..89797bf 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -34,6 +34,7 @@
 #include <linux/quotaops.h>
 #include <linux/buffer_head.h>
 #include <linux/bio.h>
+#include <linux/crc32c.h>
 #include "ext4.h"
 #include "ext4_jbd2.h"
 
@@ -145,6 +146,15 @@ struct dx_map_entry
 	u16 size;
 };
 
+/*
+ * This goes at the end of each htree block.  If you want to use the
+ * reserved field, you'll have to update the checksum code to include it.
+ */
+struct dx_tail {
+	u32 reserved;
+	u32 checksum;	/* crc32c(uuid+inum+dirblock) */
+};
+
 static inline ext4_lblk_t dx_get_block(struct dx_entry *entry);
 static void dx_set_block(struct dx_entry *entry, ext4_lblk_t value);
 static inline unsigned dx_get_hash(struct dx_entry *entry);
@@ -180,6 +190,130 @@ static struct buffer_head * ext4_dx_find_entry(struct inode *dir,
 static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
 			     struct inode *inode);
 
+/* checksumming functions */
+static struct dx_countlimit *get_dx_countlimit(struct inode *inode,
+					       struct ext4_dir_entry *dirent,
+					       int *offset)
+{
+	struct ext4_dir_entry *dp;
+	struct dx_root_info *root;
+	int count_offset;
+
+	if (le16_to_cpu(dirent->rec_len) == EXT4_BLOCK_SIZE(inode->i_sb))
+		count_offset = 8;
+	else if (le16_to_cpu(dirent->rec_len) == 12) {
+		dp = (struct ext4_dir_entry *)(((void *)dirent) + 12);
+		if (le16_to_cpu(dp->rec_len) !=
+		    EXT4_BLOCK_SIZE(inode->i_sb) - 12)
+			return NULL;
+		root = (struct dx_root_info *)(((void *)dp + 12));
+		if (root->reserved_zero ||
+		    root->info_length != sizeof(struct dx_root_info))
+			return NULL;
+		count_offset = 32;
+	} else
+		return NULL;
+
+	if (offset)
+		*offset = count_offset;
+	return (struct dx_countlimit *)(((void *)dirent) + count_offset);
+}
+
+static __le32 ext4_dx_csum(struct inode *inode, struct ext4_dir_entry *dirent)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	__le32 inum = cpu_to_le32(inode->i_ino);
+	__u32 crc = 0;
+	int size, count_offset, limit, count;
+	struct dx_countlimit *c;
+
+	if (!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
+		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return 0;
+
+	c = get_dx_countlimit(inode, dirent, &count_offset);
+	if (!c)
+		return 0;
+	limit = le16_to_cpu(c->limit);
+	count = le16_to_cpu(c->count);
+	if (count_offset + (limit * sizeof(struct dx_entry)) >
+	    EXT4_BLOCK_SIZE(inode->i_sb) - sizeof(struct dx_tail))
+		return 0;
+	size = count_offset + (count * sizeof(struct dx_entry));
+
+	crc = crc32c_le(~0, sbi->s_es->s_uuid, sizeof(sbi->s_es->s_uuid));
+	crc = crc32c_le(crc, (__u8 *)&inum, sizeof(inum));
+	crc = crc32c_le(crc, (__u8 *)dirent, size);
+	return cpu_to_le32(crc);
+}
+
+static int ext4_dx_csum_verify(struct inode *inode,
+			       struct ext4_dir_entry *dirent)
+{
+	struct dx_countlimit *c;
+	struct dx_tail *t;
+	int count_offset, limit, count;
+
+	if (!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
+					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return 1;
+
+	c = get_dx_countlimit(inode, dirent, &count_offset);
+	if (!c) {
+		EXT4_ERROR_INODE(inode, "dir seems corrupt?  Run e2fsck -D.");
+		return 1;
+	}
+	limit = le16_to_cpu(c->limit);
+	count = le16_to_cpu(c->count);
+	if (count_offset + (limit * sizeof(struct dx_entry)) >
+	    EXT4_BLOCK_SIZE(inode->i_sb) - sizeof(struct dx_tail)) {
+		EXT4_ERROR_INODE(inode, "metadata_csum set but no space for "
+				 "tree checksum found.  Run e2fsck -D.");
+		return 1;
+	}
+	t = (struct dx_tail *)(((struct dx_entry *)c) + limit);
+
+	if (t->checksum != ext4_dx_csum(inode, dirent))
+		return 0;
+	return 1;
+}
+
+static void ext4_dx_csum_set(struct inode *inode, struct ext4_dir_entry *dirent)
+{
+	struct dx_countlimit *c;
+	struct dx_tail *t;
+	int count_offset, limit, count;
+
+	if (!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
+					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return;
+
+	c = get_dx_countlimit(inode, dirent, &count_offset);
+	if (!c) {
+		EXT4_ERROR_INODE(inode, "dir seems corrupt?  Run e2fsck -D.");
+		return;
+	}
+	limit = le16_to_cpu(c->limit);
+	count = le16_to_cpu(c->count);
+	if (count_offset + (limit * sizeof(struct dx_entry)) >
+	    EXT4_BLOCK_SIZE(inode->i_sb) - sizeof(struct dx_tail)) {
+		EXT4_ERROR_INODE(inode, "metadata_csum set but no space for "
+				 "tree checksum.  Run e2fsck -D.");
+		return;
+	}
+	t = (struct dx_tail *)(((struct dx_entry *)c) + limit);
+
+	t->checksum = ext4_dx_csum(inode, dirent);
+}
+
+static inline int ext4_handle_dirty_dx_node(handle_t *handle,
+					    struct inode *inode,
+					    struct buffer_head *bh)
+{
+	ext4_dx_csum_set(inode, (struct ext4_dir_entry *)bh->b_data);
+	return ext4_handle_dirty_metadata(handle, inode, bh);
+}
+
 /*
  * p is at least 6 bytes before the end of page
  */
@@ -239,12 +373,20 @@ static inline unsigned dx_root_limit(struct inode *dir, unsigned infosize)
 {
 	unsigned entry_space = dir->i_sb->s_blocksize - EXT4_DIR_REC_LEN(1) -
 		EXT4_DIR_REC_LEN(2) - infosize;
+
+	if (EXT4_HAS_RO_COMPAT_FEATURE(dir->i_sb,
+				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		entry_space -= sizeof(struct dx_tail);
 	return entry_space / sizeof(struct dx_entry);
 }
 
 static inline unsigned dx_node_limit(struct inode *dir)
 {
 	unsigned entry_space = dir->i_sb->s_blocksize - EXT4_DIR_REC_LEN(0);
+
+	if (EXT4_HAS_RO_COMPAT_FEATURE(dir->i_sb,
+				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		entry_space -= sizeof(struct dx_tail);
 	return entry_space / sizeof(struct dx_entry);
 }
 
@@ -390,6 +532,15 @@ dx_probe(const struct qstr *d_name, struct inode *dir,
 		goto fail;
 	}
 
+	if (!buffer_verified(bh) &&
+	    !ext4_dx_csum_verify(dir, (struct ext4_dir_entry *)bh->b_data)) {
+		ext4_warning(dir->i_sb, "Root failed checksum");
+		brelse(bh);
+		*err = ERR_BAD_DX_DIR;
+		goto fail;
+	}
+	set_buffer_verified(bh);
+
 	entries = (struct dx_entry *) (((char *)&root->info) +
 				       root->info.info_length);
 
@@ -450,6 +601,17 @@ dx_probe(const struct qstr *d_name, struct inode *dir,
 		if (!(bh = ext4_bread (NULL,dir, dx_get_block(at), 0, err)))
 			goto fail2;
 		at = entries = ((struct dx_node *) bh->b_data)->entries;
+
+		if (!buffer_verified(bh) &&
+		    !ext4_dx_csum_verify(dir,
+					 (struct ext4_dir_entry *)bh->b_data)) {
+			ext4_warning(dir->i_sb, "Node failed checksum");
+			brelse(bh);
+			*err = ERR_BAD_DX_DIR;
+			goto fail;
+		}
+		set_buffer_verified(bh);
+
 		if (dx_get_limit(entries) != dx_node_limit (dir)) {
 			ext4_warning(dir->i_sb,
 				     "dx entry: limit != node limit");
@@ -549,6 +711,15 @@ static int ext4_htree_next_block(struct inode *dir, __u32 hash,
 		if (!(bh = ext4_bread(NULL, dir, dx_get_block(p->at),
 				      0, &err)))
 			return err; /* Failure */
+
+		if (!buffer_verified(bh) &&
+		    !ext4_dx_csum_verify(dir,
+					 (struct ext4_dir_entry *)bh->b_data)) {
+			ext4_warning(dir->i_sb, "Node failed checksum");
+			return -EIO;
+		}
+		set_buffer_verified(bh);
+
 		p++;
 		brelse(p->bh);
 		p->bh = bh;
@@ -1223,7 +1394,7 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 	err = ext4_handle_dirty_metadata(handle, dir, bh2);
 	if (err)
 		goto journal_error;
-	err = ext4_handle_dirty_metadata(handle, dir, frame->bh);
+	err = ext4_handle_dirty_dx_node(handle, dir, frame->bh);
 	if (err)
 		goto journal_error;
 	brelse(bh2);
@@ -1410,7 +1581,7 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
 	frame->bh = bh;
 	bh = bh2;
 
-	ext4_handle_dirty_metadata(handle, dir, frame->bh);
+	ext4_handle_dirty_dx_node(handle, dir, frame->bh);
 	ext4_handle_dirty_metadata(handle, dir, bh);
 
 	de = do_split(handle,dir, &bh, frame, &hinfo, &retval);
@@ -1585,7 +1756,7 @@ static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
 			dxtrace(dx_show_index("node", frames[1].entries));
 			dxtrace(dx_show_index("node",
 			       ((struct dx_node *) bh2->b_data)->entries));
-			err = ext4_handle_dirty_metadata(handle, dir, bh2);
+			err = ext4_handle_dirty_dx_node(handle, dir, bh2);
 			if (err)
 				goto journal_error;
 			brelse (bh2);
@@ -1611,7 +1782,7 @@ static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
 			if (err)
 				goto journal_error;
 		}
-		err = ext4_handle_dirty_metadata(handle, dir, frames[0].bh);
+		err = ext4_handle_dirty_dx_node(handle, dir, frames[0].bh);
 		if (err) {
 			ext4_std_error(inode->i_sb, err);
 			goto cleanup;
