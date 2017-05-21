From: Richard Weinberger <richard@nod.at>
Subject: [PATCH 4/6] ubifs: Maintain a parent pointer
Date: Sun, 21 May 2017 22:20:49 +0200
Message-ID: <1495398051-4604-5-git-send-email-richard@nod.at>
References: <1495398051-4604-1-git-send-email-richard@nod.at>
Cc: david@sigma-star.at, dedekind1@gmail.com, adrian.hunter@intel.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        adilger.kernel@dilger.ca, akpm@linux-foundation.org,
        linux-ext4@vger.kernel.org, bfields@redhat.com,
        marcus.folkesson@gmail.com, hyc.lee@gmail.com,
        rockdotlee@gmail.com, leon.pollak@gmail.com,
        Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1495398051-4604-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The new feature UBIFS_FLG_PARENTPOINTER allows looking
up the parent. Usually the Linux VFS walks down the filesystem
and no parent pointers are needed. But when a filesystem
is exportable via NFS such a lookup is needed.
We can use a padding field in struct ubifs_ino_node to
maintain a pointer to the parent inode.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 fs/ubifs/dir.c         | 21 +++++++++++++++++++--
 fs/ubifs/journal.c     |  5 ++++-
 fs/ubifs/sb.c          |  2 ++
 fs/ubifs/super.c       |  1 +
 fs/ubifs/ubifs-media.h | 12 +++++++++---
 fs/ubifs/ubifs.h       |  4 ++++
 6 files changed, 39 insertions(+), 6 deletions(-)

diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index e79b529df9c3..a6eadb52a1a8 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -171,6 +171,7 @@ struct inode *ubifs_new_inode(struct ubifs_info *c, struct inode *dir,
 	}
 
 	inode->i_ino = ++c->highest_inum;
+	ui->parent_inum = dir->i_ino;
 	/*
 	 * The creation sequence number remains with this inode for its
 	 * lifetime. All nodes for this inode have a greater sequence number,
@@ -1374,7 +1375,7 @@ static int do_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if (unlink)
 		ubifs_assert(inode_is_locked(new_inode));
 
-	if (old_dir != new_dir) {
+	if (move) {
 		if (ubifs_crypt_is_encrypted(new_dir) &&
 		    !fscrypt_has_permitted_context(new_dir, old_inode))
 			return -EPERM;
@@ -1528,8 +1529,12 @@ static int do_rename(struct inode *old_dir, struct dentry *old_dentry,
 		mark_inode_dirty(whiteout);
 		whiteout->i_state &= ~I_LINKABLE;
 		iput(whiteout);
+		whiteout_ui->parent_inum = new_dir->i_ino;
 	}
 
+	if (move)
+		old_inode_ui->parent_inum = new_dir->i_ino;
+
 	err = ubifs_jnl_rename(c, old_dir, old_inode, &old_nm, new_dir,
 			       new_inode, &new_nm, whiteout, sync);
 	if (err)
@@ -1571,6 +1576,8 @@ static int do_rename(struct inode *old_dir, struct dentry *old_dentry,
 				inc_nlink(old_dir);
 		}
 	}
+	if (move)
+		old_inode_ui->parent_inum = old_dir->i_ino;
 	if (whiteout) {
 		drop_nlink(whiteout);
 		iput(whiteout);
@@ -1592,6 +1599,8 @@ static int ubifs_xrename(struct inode *old_dir, struct dentry *old_dentry,
 	int sync = IS_DIRSYNC(old_dir) || IS_DIRSYNC(new_dir);
 	struct inode *fst_inode = d_inode(old_dentry);
 	struct inode *snd_inode = d_inode(new_dentry);
+	struct ubifs_inode *fst_inode_ui = ubifs_inode(fst_inode);
+	struct ubifs_inode *snd_inode_ui = ubifs_inode(snd_inode);
 	struct timespec time;
 	int err;
 	struct fscrypt_name fst_nm, snd_nm;
@@ -1623,7 +1632,10 @@ static int ubifs_xrename(struct inode *old_dir, struct dentry *old_dentry,
 	old_dir->i_mtime = old_dir->i_ctime = time;
 	new_dir->i_mtime = new_dir->i_ctime = time;
 
-	if (old_dir != new_dir) {
+	if (new_dir != old_dir) {
+		fst_inode_ui->parent_inum = new_dir->i_ino;
+		snd_inode_ui->parent_inum = old_dir->i_ino;
+
 		if (S_ISDIR(fst_inode->i_mode) && !S_ISDIR(snd_inode->i_mode)) {
 			inc_nlink(new_dir);
 			drop_nlink(old_dir);
@@ -1637,6 +1649,11 @@ static int ubifs_xrename(struct inode *old_dir, struct dentry *old_dentry,
 	err = ubifs_jnl_xrename(c, old_dir, fst_inode, &fst_nm, new_dir,
 				snd_inode, &snd_nm, sync);
 
+	if (err && new_dir != old_dir) {
+		fst_inode_ui->parent_inum = old_dir->i_ino;
+		snd_inode_ui->parent_inum = new_dir->i_ino;
+	}
+
 	unlock_4_inodes(old_dir, new_dir, NULL, NULL);
 	ubifs_release_budget(c, &req);
 
diff --git a/fs/ubifs/journal.c b/fs/ubifs/journal.c
index 294519b98874..8eaf8f2f1fe1 100644
--- a/fs/ubifs/journal.c
+++ b/fs/ubifs/journal.c
@@ -66,7 +66,6 @@
  */
 static inline void zero_ino_node_unused(struct ubifs_ino_node *ino)
 {
-	memset(ino->padding1, 0, 4);
 	memset(ino->padding2, 0, 26);
 }
 
@@ -470,6 +469,10 @@ static void pack_inode(struct ubifs_info *c, struct ubifs_ino_node *ino,
 	ino->xattr_cnt   = cpu_to_le32(ui->xattr_cnt);
 	ino->xattr_size  = cpu_to_le32(ui->xattr_size);
 	ino->xattr_names = cpu_to_le32(ui->xattr_names);
+	if (c->parent_pointer)
+		ino->parent_inum = cpu_to_le32(ui->parent_inum);
+	else
+		ino->parent_inum = 0;
 	zero_ino_node_unused(ino);
 
 	/*
diff --git a/fs/ubifs/sb.c b/fs/ubifs/sb.c
index 8c25081a5109..f2097c47f629 100644
--- a/fs/ubifs/sb.c
+++ b/fs/ubifs/sb.c
@@ -166,6 +166,7 @@ static int create_default_filesystem(struct ubifs_info *c)
 	if (big_lpt)
 		sup_flags |= UBIFS_FLG_BIGLPT;
 	sup_flags |= UBIFS_FLG_DOUBLE_HASH;
+	sup_flags |= UBIFS_FLG_PARENTPOINTER;
 
 	sup->ch.node_type  = UBIFS_SB_NODE;
 	sup->key_hash      = UBIFS_KEY_HASH_R5;
@@ -639,6 +640,7 @@ int ubifs_read_superblock(struct ubifs_info *c)
 	c->space_fixup = !!(sup_flags & UBIFS_FLG_SPACE_FIXUP);
 	c->double_hash = !!(sup_flags & UBIFS_FLG_DOUBLE_HASH);
 	c->encrypted = !!(sup_flags & UBIFS_FLG_ENCRYPTION);
+	c->parent_pointer = !!(sup_flags & UBIFS_FLG_PARENTPOINTER);
 
 	if ((sup_flags & ~UBIFS_FLG_MASK) != 0) {
 		ubifs_err(c, "Unknown feature flags found: %#x",
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index cf4cc99b75b5..7560071534bf 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -154,6 +154,7 @@ struct inode *ubifs_iget(struct super_block *sb, unsigned long inum)
 	ui->synced_i_size = ui->ui_size = inode->i_size;
 
 	ui->xattr = (ui->flags & UBIFS_XATTR_FL) ? 1 : 0;
+	ui->parent_inum = le32_to_cpu(ino->parent_inum);
 
 	err = validate_inode(c, inode);
 	if (err)
diff --git a/fs/ubifs/ubifs-media.h b/fs/ubifs/ubifs-media.h
index 5939776c7359..b3cb76cedf20 100644
--- a/fs/ubifs/ubifs-media.h
+++ b/fs/ubifs/ubifs-media.h
@@ -427,15 +427,21 @@ enum {
  * UBIFS_FLG_DOUBLE_HASH: store a 32bit cookie in directory entry nodes to
  *			  support 64bit cookies for lookups by hash
  * UBIFS_FLG_ENCRYPTION: this filesystem contains encrypted files
+ * UBIFS_FLG_PARENTPOINTER: inode nodes maintain a pointer to the parent dir
  */
 enum {
 	UBIFS_FLG_BIGLPT = 0x02,
 	UBIFS_FLG_SPACE_FIXUP = 0x04,
 	UBIFS_FLG_DOUBLE_HASH = 0x08,
 	UBIFS_FLG_ENCRYPTION = 0x10,
+	UBIFS_FLG_PARENTPOINTER = 0x20,
 };
 
-#define UBIFS_FLG_MASK (UBIFS_FLG_BIGLPT|UBIFS_FLG_SPACE_FIXUP|UBIFS_FLG_DOUBLE_HASH|UBIFS_FLG_ENCRYPTION)
+#define UBIFS_FLG_MASK (UBIFS_FLG_BIGLPT		\
+			|UBIFS_FLG_SPACE_FIXUP		\
+			|UBIFS_FLG_DOUBLE_HASH		\
+			|UBIFS_FLG_ENCRYPTION		\
+			|UBIFS_FLG_PARENTPOINTER)
 
 /**
  * struct ubifs_ch - common header node.
@@ -494,7 +500,7 @@ union ubifs_dev_desc {
  * @data_len: inode data length
  * @xattr_cnt: count of extended attributes this inode has
  * @xattr_size: summarized size of all extended attributes in bytes
- * @padding1: reserved for future, zeroes
+ * @parent_inum: parent inode number
  * @xattr_names: sum of lengths of all extended attribute names belonging to
  *               this inode
  * @compr_type: compression type used for this inode
@@ -528,7 +534,7 @@ struct ubifs_ino_node {
 	__le32 data_len;
 	__le32 xattr_cnt;
 	__le32 xattr_size;
-	__u8 padding1[4]; /* Watch 'zero_ino_node_unused()' if changing! */
+	__le32 parent_inum;
 	__le32 xattr_names;
 	__le16 compr_type;
 	__u8 padding2[26]; /* Watch 'zero_ino_node_unused()' if changing! */
diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index f14dcc890e47..3c64481f4032 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -353,6 +353,7 @@ struct ubifs_gced_idx_leb {
  *                 currently stored on the flash; used only for regular file
  *                 inodes
  * @ui_size: inode size used by UBIFS when writing to flash
+ * @parent_inum: inode number of the parent directory
  * @flags: inode flags (@UBIFS_COMPR_FL, etc)
  * @compr_type: default compression type used for this inode
  * @last_page_read: page number of last page read (for bulk read)
@@ -404,6 +405,7 @@ struct ubifs_inode {
 	spinlock_t ui_lock;
 	loff_t synced_i_size;
 	loff_t ui_size;
+	ino_t parent_inum;
 	int flags;
 	pgoff_t last_page_read;
 	pgoff_t read_in_a_row;
@@ -1012,6 +1014,7 @@ struct ubifs_debug_info;
  * @space_fixup: flag indicating that free space in LEBs needs to be cleaned up
  * @double_hash: flag indicating that we can do lookups by hash
  * @encrypted: flag indicating that this file system contains encrypted files
+ * @parent_pointer: flag indicating that inodes have pointers to the parent dir
  * @no_chk_data_crc: do not check CRCs when reading data nodes (except during
  *                   recovery)
  * @bulk_read: enable bulk-reads
@@ -1255,6 +1258,7 @@ struct ubifs_info {
 	unsigned int space_fixup:1;
 	unsigned int double_hash:1;
 	unsigned int encrypted:1;
+	unsigned int parent_pointer:1;
 	unsigned int no_chk_data_crc:1;
 	unsigned int bulk_read:1;
 	unsigned int default_compr:2;
-- 
2.12.0
