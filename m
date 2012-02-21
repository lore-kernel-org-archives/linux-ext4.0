From: David Howells <dhowells@redhat.com>
Subject: [PATCH 68/73] ext2: Add whiteout and opaque directory support [ver #2]
Date: Tue, 21 Feb 2012 18:06:02 +0000
Message-ID: <20120221180602.25235.86103.stgit@warthog.procyon.org.uk>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org,
	David Howells <dhowells@redhat.com> (Further development),
	linux-ext4@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
	valerie.aurora@gmail.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Add support for whiteouts and opaque directories to ext2.

Original-author: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com> (Further development)
cc: linux-ext4@vger.kernel.org
---

 fs/ext2/dir.c           |   62 ++++++++++++++++++++++++++++++++++++++++++++++-
 fs/ext2/ext2.h          |    2 ++
 fs/ext2/inode.c         |   11 ++++++--
 fs/ext2/namei.c         |   51 +++++++++++++++++++++++++++++++++++++--
 fs/ext2/super.c         |    4 +++
 include/linux/ext2_fs.h |    4 +++
 6 files changed, 128 insertions(+), 6 deletions(-)

diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index dcb2d64..df4d6b1 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -220,7 +220,7 @@ fail:
 
 static inline int ext2_dirent_in_use(struct ext2_dir_entry_2 *de)
 {
-	return de->inode != 0;
+	return de->inode != 0 || de->file_type == EXT2_FT_WHT;
 }
 
 /*
@@ -269,6 +269,7 @@ static unsigned char ext2_filetype_table[EXT2_FT_MAX] = {
 	[EXT2_FT_FIFO]		= DT_FIFO,
 	[EXT2_FT_SOCK]		= DT_SOCK,
 	[EXT2_FT_SYMLINK]	= DT_LNK,
+	[EXT2_FT_WHT]		= DT_WHT,
 };
 
 #define S_SHIFT 12
@@ -472,6 +473,26 @@ static int ext2_prepare_chunk(struct page *page, loff_t pos, unsigned len)
 	return __block_write_begin(page, pos, len, ext2_get_block);
 }
 
+/* Special version for filetype based whiteout support */
+ino_t ext2_inode_by_dentry(struct inode *dir, struct dentry *dentry)
+{
+	ino_t res = 0;
+	struct ext2_dir_entry_2 *de;
+	struct page *page;
+
+	de = ext2_find_entry(dir, &dentry->d_name, &page);
+	if (de) {
+		res = le32_to_cpu(de->inode);
+		if (!res && de->file_type == EXT2_FT_WHT) {
+			spin_lock(&dentry->d_lock);
+			dentry->d_flags |= DCACHE_WHITEOUT;
+			spin_unlock(&dentry->d_lock);
+		}
+		ext2_put_page(page);
+	}
+	return res;
+}
+
 /* Releases the page */
 void ext2_set_link(struct inode *dir, struct ext2_dir_entry_2 *de,
 		   struct page *page, struct inode *inode, int update_times)
@@ -580,6 +601,40 @@ int ext2_add_entry(struct dentry *dentry, ino_t ino, umode_t mode,
 	return -EINVAL;
 
 got_it:
+	/* Pre-existing entries with the same name are allowable depending on
+	 * the type of the entry being created, so we need to sanity check what
+	 * we got.
+	 *
+	 * - Fallthru entries may be replaced by regular entries (copyup or
+	 *   rename) or whiteouts (unlink, rmdir or rename), but not by another
+	 *   fallthru.
+	 * - Whiteout entries may be replaced by a regular entry (open, link,
+	 *   symlink, mkdir, mknod, socket or rename).
+	 * - Regular entries may be replaced by a whiteout (unlink, rmdir or
+	 *   rename).
+	 *
+	 * Fallthru entries may only be created during directory copyup and
+	 * should not already exist in the top directory at that time.
+	 */
+	err = -EEXIST;
+	if (ext2_match(namelen, name, de)) {
+		switch (de->file_type) {
+		case EXT2_FT_WHT:
+			if (new_file_type == EXT2_FT_WHT) {
+				WARN(1, "Ext2: Can't turn whiteout into whiteout: %s\n",
+				     dentry->d_name.name);
+				goto out_unlock;
+			}
+			break;
+		default:
+			if (new_file_type != EXT2_FT_WHT) {
+				WARN(1, "Ext2: Can't turn dirent into non-whiteout: %s\n",
+				     dentry->d_name.name);
+				goto out_unlock;
+			}
+			break;
+		}
+	}
 	pos = page_offset(page) +
 		(char*)de - (char*)page_address(page);
 	err = ext2_prepare_chunk(page, pos, rec_len);
@@ -614,6 +669,11 @@ int ext2_add_link(struct dentry *dentry, struct inode *inode)
 	return ext2_add_entry(dentry, inode->i_ino, inode->i_mode, 0);
 }
 
+int ext2_whiteout_entry(struct dentry *dentry)
+{
+	return ext2_add_entry(dentry, 0, 0, EXT2_FT_WHT);
+}
+
 /*
  * ext2_delete_entry deletes a directory entry by merging it with the
  * previous entry. Page is up-to-date. Releases the page.
diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index 75ad433..b285d9a 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -102,9 +102,11 @@ extern void ext2_rsv_window_add(struct super_block *sb, struct ext2_reserve_wind
 /* dir.c */
 extern int ext2_add_link (struct dentry *, struct inode *);
 extern ino_t ext2_inode_by_name(struct inode *, struct qstr *);
+extern ino_t ext2_inode_by_dentry(struct inode *, struct dentry *);
 extern int ext2_make_empty(struct inode *, struct inode *);
 extern struct ext2_dir_entry_2 * ext2_find_entry (struct inode *,struct qstr *, struct page **);
 extern int ext2_delete_entry (struct ext2_dir_entry_2 *, struct page *);
+extern int ext2_whiteout_entry(struct dentry *);
 extern int ext2_empty_dir (struct inode *);
 extern struct ext2_dir_entry_2 * ext2_dotdot (struct inode *, struct page **);
 extern void ext2_set_link(struct inode *, struct ext2_dir_entry_2 *, struct page *, struct inode *, int);
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 740cad8..2ffc91a 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1253,7 +1253,8 @@ void ext2_set_inode_flags(struct inode *inode)
 {
 	unsigned int flags = EXT2_I(inode)->i_flags;
 
-	inode->i_flags &= ~(S_SYNC|S_APPEND|S_IMMUTABLE|S_NOATIME|S_DIRSYNC);
+	inode->i_flags &= ~(S_SYNC|S_APPEND|S_IMMUTABLE|S_NOATIME|S_DIRSYNC|
+			    S_OPAQUE);
 	if (flags & EXT2_SYNC_FL)
 		inode->i_flags |= S_SYNC;
 	if (flags & EXT2_APPEND_FL)
@@ -1264,6 +1265,8 @@ void ext2_set_inode_flags(struct inode *inode)
 		inode->i_flags |= S_NOATIME;
 	if (flags & EXT2_DIRSYNC_FL)
 		inode->i_flags |= S_DIRSYNC;
+	if (flags & EXT2_OPAQUE_FL)
+		inode->i_flags |= S_OPAQUE;
 }
 
 /* Propagate flags from i_flags to EXT2_I(inode)->i_flags */
@@ -1271,8 +1274,8 @@ void ext2_get_inode_flags(struct ext2_inode_info *ei)
 {
 	unsigned int flags = ei->vfs_inode.i_flags;
 
-	ei->i_flags &= ~(EXT2_SYNC_FL|EXT2_APPEND_FL|
-			EXT2_IMMUTABLE_FL|EXT2_NOATIME_FL|EXT2_DIRSYNC_FL);
+	ei->i_flags &= ~(EXT2_SYNC_FL|EXT2_APPEND_FL|EXT2_IMMUTABLE_FL|
+			 EXT2_NOATIME_FL|EXT2_DIRSYNC_FL|EXT2_OPAQUE_FL);
 	if (flags & S_SYNC)
 		ei->i_flags |= EXT2_SYNC_FL;
 	if (flags & S_APPEND)
@@ -1283,6 +1286,8 @@ void ext2_get_inode_flags(struct ext2_inode_info *ei)
 		ei->i_flags |= EXT2_NOATIME_FL;
 	if (flags & S_DIRSYNC)
 		ei->i_flags |= EXT2_DIRSYNC_FL;
+	if (flags & S_OPAQUE)
+		ei->i_flags |= EXT2_OPAQUE_FL;
 }
 
 struct inode *ext2_iget (struct super_block *sb, unsigned long ino)
diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index 0804198..8227267 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -55,7 +55,8 @@ static inline int ext2_add_nondir(struct dentry *dentry, struct inode *inode)
  * Methods themselves.
  */
 
-static struct dentry *ext2_lookup(struct inode * dir, struct dentry *dentry, struct nameidata *nd)
+static struct dentry *ext2_lookup(struct inode * dir, struct dentry *dentry,
+				  struct nameidata *nd)
 {
 	struct inode * inode;
 	ino_t ino;
@@ -63,7 +64,7 @@ static struct dentry *ext2_lookup(struct inode * dir, struct dentry *dentry, str
 	if (dentry->d_name.len > EXT2_NAME_LEN)
 		return ERR_PTR(-ENAMETOOLONG);
 
-	ino = ext2_inode_by_name(dir, &dentry->d_name);
+	ino = ext2_inode_by_dentry(dir, dentry);
 	inode = NULL;
 	if (ino) {
 		inode = ext2_iget(dir->i_sb, ino);
@@ -303,6 +304,51 @@ static int ext2_rmdir (struct inode * dir, struct dentry *dentry)
 	return err;
 }
 
+/*
+ * Create a whiteout for the dentry
+ */
+static int ext2_whiteout(struct inode *dir, struct dentry *dentry,
+			 struct dentry *new_dentry)
+{
+	struct inode *inode = dentry->d_inode;
+	int err = -ENOTEMPTY;
+
+	if (!EXT2_HAS_INCOMPAT_FEATURE(dir->i_sb,
+				       EXT2_FEATURE_INCOMPAT_FILETYPE)) {
+		ext2_error(dir->i_sb, "ext2_whiteout",
+			   "can't set whiteout filetype");
+		err = -EPERM;
+		goto out;
+	}
+
+	dquot_initialize(dir);
+
+	if (inode && S_ISDIR(inode->i_mode) && !ext2_empty_dir(inode))
+		goto out;
+
+	err = ext2_whiteout_entry(dentry);
+	if (err)
+		goto out;
+
+	spin_lock(&new_dentry->d_lock);
+	new_dentry->d_flags |= DCACHE_WHITEOUT;
+	spin_unlock(&new_dentry->d_lock);
+	d_add(new_dentry, NULL);
+
+	if (inode) {
+		inode->i_ctime = dir->i_ctime;
+		inode_dec_link_count(inode);
+		if (S_ISDIR(inode->i_mode)) {
+			inode->i_size = 0;
+			inode_dec_link_count(inode);
+			inode_dec_link_count(dir);
+		}
+	}
+	err = 0;
+out:
+	return err;
+}
+
 static int ext2_rename (struct inode * old_dir, struct dentry * old_dentry,
 	struct inode * new_dir,	struct dentry * new_dentry )
 {
@@ -400,6 +446,7 @@ const struct inode_operations ext2_dir_inode_operations = {
 	.mkdir		= ext2_mkdir,
 	.rmdir		= ext2_rmdir,
 	.mknod		= ext2_mknod,
+	.whiteout	= ext2_whiteout,
 	.rename		= ext2_rename,
 #ifdef CONFIG_EXT2_FS_XATTR
 	.setxattr	= generic_setxattr,
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 0090595..8869794 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1097,6 +1097,10 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 	if (EXT2_HAS_COMPAT_FEATURE(sb, EXT3_FEATURE_COMPAT_HAS_JOURNAL))
 		ext2_msg(sb, KERN_WARNING,
 			"warning: mounting ext3 filesystem as ext2");
+
+	if (EXT2_HAS_INCOMPAT_FEATURE(sb, EXT2_FEATURE_INCOMPAT_WHITEOUT))
+		sb->s_flags |= MS_WHITEOUT;
+
 	if (ext2_setup_super (sb, es, sb->s_flags & MS_RDONLY))
 		sb->s_flags |= MS_RDONLY;
 	ext2_write_super(sb);
diff --git a/include/linux/ext2_fs.h b/include/linux/ext2_fs.h
index ce1b719..2202faa 100644
--- a/include/linux/ext2_fs.h
+++ b/include/linux/ext2_fs.h
@@ -190,6 +190,7 @@ struct ext2_group_desc
 #define EXT2_NOTAIL_FL			FS_NOTAIL_FL	/* file tail should not be merged */
 #define EXT2_DIRSYNC_FL			FS_DIRSYNC_FL	/* dirsync behaviour (directories only) */
 #define EXT2_TOPDIR_FL			FS_TOPDIR_FL	/* Top of directory hierarchies*/
+#define EXT2_OPAQUE_FL			FS_OPAQUE_FL	/* Dir is opaque */
 #define EXT2_RESERVED_FL		FS_RESERVED_FL	/* reserved for ext2 lib */
 
 #define EXT2_FL_USER_VISIBLE		FS_FL_USER_VISIBLE	/* User visible flags */
@@ -504,10 +505,12 @@ struct ext2_super_block {
 #define EXT3_FEATURE_INCOMPAT_RECOVER		0x0004
 #define EXT3_FEATURE_INCOMPAT_JOURNAL_DEV	0x0008
 #define EXT2_FEATURE_INCOMPAT_META_BG		0x0010
+#define EXT2_FEATURE_INCOMPAT_WHITEOUT		0x0020
 #define EXT2_FEATURE_INCOMPAT_ANY		0xffffffff
 
 #define EXT2_FEATURE_COMPAT_SUPP	EXT2_FEATURE_COMPAT_EXT_ATTR
 #define EXT2_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE| \
+					 EXT2_FEATURE_INCOMPAT_WHITEOUT| \
 					 EXT2_FEATURE_INCOMPAT_META_BG)
 #define EXT2_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE| \
@@ -574,6 +577,7 @@ enum {
 	EXT2_FT_FIFO		= 5,
 	EXT2_FT_SOCK		= 6,
 	EXT2_FT_SYMLINK		= 7,
+	EXT2_FT_WHT		= 8,
 	EXT2_FT_MAX
 };
 
