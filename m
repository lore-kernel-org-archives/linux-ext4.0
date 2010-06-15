From: Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 11/38] whiteout: ext2 whiteout support
Date: Tue, 15 Jun 2010 11:39:41 -0700
Message-ID: <1276627208-17242-12-git-send-email-vaurora@redhat.com>
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
	Christoph Hellwig <hch@infradead.org>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Valerie Aurora <vaurora@redhat.com>,
	Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Alexander Viro <viro@zeniv.linux.org.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1276627208-17242-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Jan Blunck <jblunck@suse.de>

This patch adds whiteout support to EXT2. A whiteout is an empty directory
entry (inode == 0) with the file type set to EXT2_FT_WHT. Therefore it
allocates space in directories. Due to being implemented as a filetype it is
necessary to have the EXT2_FEATURE_INCOMPAT_FILETYPE flag set.

XXX - Needs serious review.  Al wonders: What happens with a delete at
the beginning of a block?  Will we find the matching dentry or the
first empty space?

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Valerie Aurora <vaurora@redhat.com>
Cc: Theodore Tso <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org
---
 fs/ext2/dir.c           |   96 +++++++++++++++++++++++++++++++++++++++++++++--
 fs/ext2/ext2.h          |    3 +
 fs/ext2/inode.c         |   11 ++++-
 fs/ext2/namei.c         |   67 +++++++++++++++++++++++++++++++-
 fs/ext2/super.c         |    6 +++
 include/linux/ext2_fs.h |    4 ++
 6 files changed, 177 insertions(+), 10 deletions(-)

diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index 57207a9..030bd46 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -219,7 +219,7 @@ static inline int ext2_match (int len, const char * const name,
 {
 	if (len != de->name_len)
 		return 0;
-	if (!de->inode)
+	if (!de->inode && (de->file_type != EXT2_FT_WHT))
 		return 0;
 	return !memcmp(name, de->name, len);
 }
@@ -255,6 +255,7 @@ static unsigned char ext2_filetype_table[EXT2_FT_MAX] = {
 	[EXT2_FT_FIFO]		= DT_FIFO,
 	[EXT2_FT_SOCK]		= DT_SOCK,
 	[EXT2_FT_SYMLINK]	= DT_LNK,
+	[EXT2_FT_WHT]		= DT_WHT,
 };
 
 #define S_SHIFT 12
@@ -448,6 +449,26 @@ ino_t ext2_inode_by_name(struct inode *dir, struct qstr *child)
 	return res;
 }
 
+/* Special version for filetype based whiteout support */
+ino_t ext2_inode_by_dentry(struct inode *dir, struct dentry *dentry)
+{
+	ino_t res = 0;
+	struct ext2_dir_entry_2 *de;
+	struct page *page;
+
+	de = ext2_find_entry (dir, &dentry->d_name, &page);
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
@@ -523,7 +544,8 @@ static ext2_dirent * ext2_append_entry(struct dentry * dentry,
 				goto got_it;
 			name_len = EXT2_DIR_REC_LEN(de->name_len);
 			rec_len = ext2_rec_len_from_disk(de->rec_len);
-			if (!de->inode && rec_len >= reclen)
+			if (!de->inode && (de->file_type != EXT2_FT_WHT) &&
+			    (rec_len >= reclen))
 				goto got_it;
 			if (rec_len >= name_len + reclen)
 				goto got_it;
@@ -564,8 +586,11 @@ int ext2_add_link (struct dentry *dentry, struct inode *inode)
 		return PTR_ERR(de);
 
 	err = -EEXIST;
-	if (ext2_match (namelen, name, de))
+	if (ext2_match (namelen, name, de)) {
+		if (de->file_type == EXT2_FT_WHT)
+			goto got_it;
 		goto out_unlock;
+	}
 
 got_it:
 	name_len = EXT2_DIR_REC_LEN(de->name_len);
@@ -577,7 +602,8 @@ got_it:
 							&page, NULL);
 	if (err)
 		goto out_unlock;
-	if (de->inode) {
+	if (de->inode || ((de->file_type == EXT2_FT_WHT) &&
+			  !ext2_match (namelen, name, de))) {
 		ext2_dirent *de1 = (ext2_dirent *) ((char *) de + name_len);
 		de1->rec_len = ext2_rec_len_to_disk(rec_len - name_len);
 		de->rec_len = ext2_rec_len_to_disk(name_len);
@@ -646,6 +672,68 @@ out:
 	return err;
 }
 
+int ext2_whiteout_entry (struct inode * dir, struct dentry * dentry,
+			 struct ext2_dir_entry_2 * de, struct page * page)
+{
+	const char *name = dentry->d_name.name;
+	int namelen = dentry->d_name.len;
+	unsigned short rec_len, name_len;
+	loff_t pos;
+	int err;
+
+	if (!de) {
+		de = ext2_append_entry(dentry, &page);
+		BUG_ON(!de);
+	}
+
+	err = -EEXIST;
+	if (ext2_match (namelen, name, de) &&
+	    (de->file_type == EXT2_FT_WHT)) {
+		ext2_error(dir->i_sb, __func__,
+			   "entry is already a whiteout in directory #%lu",
+			   dir->i_ino);
+		goto out_unlock;
+	}
+
+	name_len = EXT2_DIR_REC_LEN(de->name_len);
+	rec_len = ext2_rec_len_from_disk(de->rec_len);
+
+	pos = page_offset(page) +
+		(char*)de - (char*)page_address(page);
+	err = __ext2_write_begin(NULL, page->mapping, pos, rec_len, 0,
+							&page, NULL);
+	if (err)
+		goto out_unlock;
+	/*
+	 * We whiteout an existing entry. Do what ext2_delete_entry() would do,
+	 * except that we don't need to merge with the previous entry since
+	 * we are going to reuse it.
+	 */
+	if (ext2_match (namelen, name, de))
+		de->inode = 0;
+	if (de->inode || (de->file_type == EXT2_FT_WHT)) {
+		ext2_dirent *de1 = (ext2_dirent *) ((char *) de + name_len);
+		de1->rec_len = ext2_rec_len_to_disk(rec_len - name_len);
+		de->rec_len = ext2_rec_len_to_disk(name_len);
+		de = de1;
+	}
+	de->name_len = namelen;
+	memcpy(de->name, name, namelen);
+	de->inode = 0;
+	de->file_type = EXT2_FT_WHT;
+	err = ext2_commit_chunk(page, pos, rec_len);
+	dir->i_mtime = dir->i_ctime = CURRENT_TIME_SEC;
+	EXT2_I(dir)->i_flags &= ~EXT2_BTREE_FL;
+	mark_inode_dirty(dir);
+	/* OFFSET_CACHE */
+out_put:
+	ext2_put_page(page);
+	return err;
+out_unlock:
+	unlock_page(page);
+	goto out_put;
+}
+
 /*
  * Set the first fragment of directory.
  */
diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index 0b038e4..44d190c 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -102,9 +102,12 @@ extern void ext2_rsv_window_add(struct super_block *sb, struct ext2_reserve_wind
 /* dir.c */
 extern int ext2_add_link (struct dentry *, struct inode *);
 extern ino_t ext2_inode_by_name(struct inode *, struct qstr *);
+extern ino_t ext2_inode_by_dentry(struct inode *, struct dentry *);
 extern int ext2_make_empty(struct inode *, struct inode *);
 extern struct ext2_dir_entry_2 * ext2_find_entry (struct inode *,struct qstr *, struct page **);
 extern int ext2_delete_entry (struct ext2_dir_entry_2 *, struct page *);
+extern int ext2_whiteout_entry (struct inode *, struct dentry *,
+				struct ext2_dir_entry_2 *, struct page *);
 extern int ext2_empty_dir (struct inode *);
 extern struct ext2_dir_entry_2 * ext2_dotdot (struct inode *, struct page **);
 extern void ext2_set_link(struct inode *, struct ext2_dir_entry_2 *, struct page *, struct inode *, int);
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index fc13cc1..5ad2cbb 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1184,7 +1184,8 @@ void ext2_set_inode_flags(struct inode *inode)
 {
 	unsigned int flags = EXT2_I(inode)->i_flags;
 
-	inode->i_flags &= ~(S_SYNC|S_APPEND|S_IMMUTABLE|S_NOATIME|S_DIRSYNC);
+	inode->i_flags &= ~(S_SYNC|S_APPEND|S_IMMUTABLE|S_NOATIME|S_DIRSYNC|
+			    S_OPAQUE);
 	if (flags & EXT2_SYNC_FL)
 		inode->i_flags |= S_SYNC;
 	if (flags & EXT2_APPEND_FL)
@@ -1195,6 +1196,8 @@ void ext2_set_inode_flags(struct inode *inode)
 		inode->i_flags |= S_NOATIME;
 	if (flags & EXT2_DIRSYNC_FL)
 		inode->i_flags |= S_DIRSYNC;
+	if (flags & EXT2_OPAQUE_FL)
+		inode->i_flags |= S_OPAQUE;
 }
 
 /* Propagate flags from i_flags to EXT2_I(inode)->i_flags */
@@ -1202,8 +1205,8 @@ void ext2_get_inode_flags(struct ext2_inode_info *ei)
 {
 	unsigned int flags = ei->vfs_inode.i_flags;
 
-	ei->i_flags &= ~(EXT2_SYNC_FL|EXT2_APPEND_FL|
-			EXT2_IMMUTABLE_FL|EXT2_NOATIME_FL|EXT2_DIRSYNC_FL);
+	ei->i_flags &= ~(EXT2_SYNC_FL|EXT2_APPEND_FL|EXT2_IMMUTABLE_FL|
+			 EXT2_NOATIME_FL|EXT2_DIRSYNC_FL|EXT2_OPAQUE_FL);
 	if (flags & S_SYNC)
 		ei->i_flags |= EXT2_SYNC_FL;
 	if (flags & S_APPEND)
@@ -1214,6 +1217,8 @@ void ext2_get_inode_flags(struct ext2_inode_info *ei)
 		ei->i_flags |= EXT2_NOATIME_FL;
 	if (flags & S_DIRSYNC)
 		ei->i_flags |= EXT2_DIRSYNC_FL;
+	if (flags & S_OPAQUE)
+		ei->i_flags |= EXT2_OPAQUE_FL;
 }
 
 struct inode *ext2_iget (struct super_block *sb, unsigned long ino)
diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index 71efb0e..12195a5 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -55,15 +55,16 @@ static inline int ext2_add_nondir(struct dentry *dentry, struct inode *inode)
  * Methods themselves.
  */
 
-static struct dentry *ext2_lookup(struct inode * dir, struct dentry *dentry, struct nameidata *nd)
+static struct dentry *ext2_lookup(struct inode * dir, struct dentry *dentry,
+				  struct nameidata *nd)
 {
 	struct inode * inode;
 	ino_t ino;
-	
+
 	if (dentry->d_name.len > EXT2_NAME_LEN)
 		return ERR_PTR(-ENAMETOOLONG);
 
-	ino = ext2_inode_by_name(dir, &dentry->d_name);
+	ino = ext2_inode_by_dentry(dir, dentry);
 	inode = NULL;
 	if (ino) {
 		inode = ext2_iget(dir->i_sb, ino);
@@ -242,6 +243,10 @@ static int ext2_mkdir(struct inode * dir, struct dentry * dentry, int mode)
 	else
 		inode->i_mapping->a_ops = &ext2_aops;
 
+	/* if we call mkdir on a whiteout create an opaque directory */
+	if (dentry->d_flags & DCACHE_WHITEOUT)
+		inode->i_flags |= S_OPAQUE;
+
 	inode_inc_link_count(inode);
 
 	err = ext2_make_empty(inode, dir);
@@ -307,6 +312,61 @@ static int ext2_rmdir (struct inode * dir, struct dentry *dentry)
 	return err;
 }
 
+/*
+ * Create a whiteout for the dentry
+ */
+static int ext2_whiteout(struct inode *dir, struct dentry *dentry,
+			 struct dentry *new_dentry)
+{
+	struct inode * inode = dentry->d_inode;
+	struct ext2_dir_entry_2 * de = NULL;
+	struct page * page;
+	int err = -ENOTEMPTY;
+
+	if (!EXT2_HAS_INCOMPAT_FEATURE(dir->i_sb,
+				       EXT2_FEATURE_INCOMPAT_FILETYPE)) {
+		ext2_error (dir->i_sb, "ext2_whiteout",
+			    "can't set whiteout filetype");
+		err = -EPERM;
+		goto out;
+	}
+
+	dquot_initialize(dir);
+
+	if (inode) {
+		if (S_ISDIR(inode->i_mode) && !ext2_empty_dir(inode))
+			goto out;
+
+		err = -ENOENT;
+		de = ext2_find_entry (dir, &dentry->d_name, &page);
+		if (!de)
+			goto out;
+		lock_page(page);
+	}
+
+	err = ext2_whiteout_entry (dir, dentry, de, page);
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
@@ -409,6 +469,7 @@ const struct inode_operations ext2_dir_inode_operations = {
 	.mkdir		= ext2_mkdir,
 	.rmdir		= ext2_rmdir,
 	.mknod		= ext2_mknod,
+	.whiteout	= ext2_whiteout,
 	.rename		= ext2_rename,
 #ifdef CONFIG_EXT2_FS_XATTR
 	.setxattr	= generic_setxattr,
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 42e4a30..000ee17 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1079,6 +1079,12 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 	if (EXT2_HAS_COMPAT_FEATURE(sb, EXT3_FEATURE_COMPAT_HAS_JOURNAL))
 		ext2_msg(sb, KERN_WARNING,
 			"warning: mounting ext3 filesystem as ext2");
+	/*
+	 * Whiteouts (and fallthrus) require explicit whiteout support.
+	 */
+	if (EXT2_HAS_INCOMPAT_FEATURE(sb, EXT2_FEATURE_INCOMPAT_WHITEOUT))
+		sb->s_flags |= MS_WHITEOUT;
+
 	ext2_setup_super (sb, es, sb->s_flags & MS_RDONLY);
 	return 0;
 
diff --git a/include/linux/ext2_fs.h b/include/linux/ext2_fs.h
index 2dfa707..20468bd 100644
--- a/include/linux/ext2_fs.h
+++ b/include/linux/ext2_fs.h
@@ -189,6 +189,7 @@ struct ext2_group_desc
 #define EXT2_NOTAIL_FL			FS_NOTAIL_FL	/* file tail should not be merged */
 #define EXT2_DIRSYNC_FL			FS_DIRSYNC_FL	/* dirsync behaviour (directories only) */
 #define EXT2_TOPDIR_FL			FS_TOPDIR_FL	/* Top of directory hierarchies*/
+#define EXT2_OPAQUE_FL			0x00040000
 #define EXT2_RESERVED_FL		FS_RESERVED_FL	/* reserved for ext2 lib */
 
 #define EXT2_FL_USER_VISIBLE		FS_FL_USER_VISIBLE	/* User visible flags */
@@ -503,10 +504,12 @@ struct ext2_super_block {
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
@@ -573,6 +576,7 @@ enum {
 	EXT2_FT_FIFO		= 5,
 	EXT2_FT_SOCK		= 6,
 	EXT2_FT_SYMLINK		= 7,
+	EXT2_FT_WHT		= 8,
 	EXT2_FT_MAX
 };
 
-- 
1.6.3.3
