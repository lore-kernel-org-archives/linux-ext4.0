From: David Howells <dhowells@redhat.com>
Subject: [PATCH 69/73] ext2: Add fallthru support [ver #2]
Date: Tue, 21 Feb 2012 18:06:11 +0000
Message-ID: <20120221180611.25235.63025.stgit@warthog.procyon.org.uk>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, Valerie Aurora <vaurora@redhat.com>,
	Jan Blunck <jblunck@suse.de>,
	David Howells <dhowells@redhat.com>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
	valerie.aurora@gmail.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Valerie Aurora <vaurora@redhat.com>

Add support for fallthru directory entries to ext2.

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org
---

 fs/ext2/dir.c           |   49 +++++++++++++++++++++++++++++++++++++++++------
 fs/ext2/ext2.h          |    1 +
 fs/ext2/namei.c         |   22 +++++++++++++++++++++
 fs/ext2/super.c         |    2 ++
 include/linux/ext2_fs.h |    4 ++++
 5 files changed, 72 insertions(+), 6 deletions(-)

diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index df4d6b1..5fd6bbe 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -220,7 +220,9 @@ fail:
 
 static inline int ext2_dirent_in_use(struct ext2_dir_entry_2 *de)
 {
-	return de->inode != 0 || de->file_type == EXT2_FT_WHT;
+	return de->inode != 0 ||
+		de->file_type == EXT2_FT_WHT ||
+		de->file_type == EXT2_FT_FALLTHRU;
 }
 
 /*
@@ -270,6 +272,7 @@ static unsigned char ext2_filetype_table[EXT2_FT_MAX] = {
 	[EXT2_FT_SOCK]		= DT_SOCK,
 	[EXT2_FT_SYMLINK]	= DT_LNK,
 	[EXT2_FT_WHT]		= DT_WHT,
+	[EXT2_FT_FALLTHRU]	= DT_UNKNOWN,
 };
 
 #define S_SHIFT 12
@@ -355,8 +358,20 @@ ext2_readdir (struct file * filp, void * dirent, filldir_t filldir)
 
 				offset = (char *)de - kaddr;
 				over = filldir(dirent, de->name, de->name_len,
-						(n<<PAGE_CACHE_SHIFT) | offset,
-						le32_to_cpu(de->inode), d_type);
+					       (n << PAGE_CACHE_SHIFT) | offset,
+					       le32_to_cpu(de->inode), d_type);
+				if (over) {
+					ext2_put_page(page);
+					return 0;
+				}
+			} else if (de->file_type == EXT2_FT_FALLTHRU) {
+				int over;
+
+				offset = (char *)de - kaddr;
+				/* XXX placeholder until generic_readdir_fallthru() arrives */
+				over = filldir(dirent, de->name, de->name_len,
+					       (n<<PAGE_CACHE_SHIFT) | offset,
+					       1, DT_UNKNOWN); /* XXX */
 				if (over) {
 					ext2_put_page(page);
 					return 0;
@@ -487,6 +502,10 @@ ino_t ext2_inode_by_dentry(struct inode *dir, struct dentry *dentry)
 			spin_lock(&dentry->d_lock);
 			dentry->d_flags |= DCACHE_WHITEOUT;
 			spin_unlock(&dentry->d_lock);
+		} else if (!res && de->file_type == EXT2_FT_FALLTHRU) {
+			spin_lock(&dentry->d_lock);
+			dentry->d_flags |= DCACHE_FALLTHRU;
+			spin_unlock(&dentry->d_lock);
 		}
 		ext2_put_page(page);
 	}
@@ -580,7 +599,9 @@ int ext2_add_entry(struct dentry *dentry, ino_t ino, umode_t mode,
 			rec_len = ext2_rec_len_from_disk(de->rec_len);
 			if (ext2_match(namelen, name, de)) {
 				err = -EEXIST;
-				/* XXX handle whiteouts and fallthroughs here */
+				/* XXX handle whiteouts here too */
+				if (de->file_type != EXT2_FT_FALLTHRU)
+					goto out_unlock;
 				printk("%s: found existing de\n", dentry->d_name.name);
 				goto got_it;
 			}
@@ -619,9 +640,17 @@ got_it:
 	err = -EEXIST;
 	if (ext2_match(namelen, name, de)) {
 		switch (de->file_type) {
+		case EXT2_FT_FALLTHRU:
+			if (new_file_type == EXT2_FT_FALLTHRU) {
+				WARN(1, "Ext2: Can't turn fallthru into fallthru: %s\n",
+				     dentry->d_name.name);
+				goto out_unlock;
+			}
+			break;
 		case EXT2_FT_WHT:
-			if (new_file_type == EXT2_FT_WHT) {
-				WARN(1, "Ext2: Can't turn whiteout into whiteout: %s\n",
+			if (new_file_type == EXT2_FT_WHT ||
+			    new_file_type == EXT2_FT_FALLTHRU) {
+				WARN(1, "Ext2: Can't turn whiteout into fallthru/whiteout: %s\n",
 				     dentry->d_name.name);
 				goto out_unlock;
 			}
@@ -675,6 +704,14 @@ int ext2_whiteout_entry(struct dentry *dentry)
 }
 
 /*
+ * Create a fallthru entry.
+ */
+int ext2_fallthru_entry(struct dentry *dentry)
+{
+	return ext2_add_entry(dentry, 0, 0, EXT2_FT_FALLTHRU);
+}
+
+/*
  * ext2_delete_entry deletes a directory entry by merging it with the
  * previous entry. Page is up-to-date. Releases the page.
  */
diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index b285d9a..dd82bc6 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -107,6 +107,7 @@ extern int ext2_make_empty(struct inode *, struct inode *);
 extern struct ext2_dir_entry_2 * ext2_find_entry (struct inode *,struct qstr *, struct page **);
 extern int ext2_delete_entry (struct ext2_dir_entry_2 *, struct page *);
 extern int ext2_whiteout_entry(struct dentry *);
+extern int ext2_fallthru_entry(struct dentry *);
 extern int ext2_empty_dir (struct inode *);
 extern struct ext2_dir_entry_2 * ext2_dotdot (struct inode *, struct page **);
 extern void ext2_set_link(struct inode *, struct ext2_dir_entry_2 *, struct page *, struct inode *, int);
diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index 8227267..957c4b9 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -331,6 +331,7 @@ static int ext2_whiteout(struct inode *dir, struct dentry *dentry,
 		goto out;
 
 	spin_lock(&new_dentry->d_lock);
+	new_dentry->d_flags &= ~DCACHE_FALLTHRU;
 	new_dentry->d_flags |= DCACHE_WHITEOUT;
 	spin_unlock(&new_dentry->d_lock);
 	d_add(new_dentry, NULL);
@@ -349,6 +350,26 @@ out:
 	return err;
 }
 
+/*
+ * Create a fallthru entry.
+ */
+static int ext2_fallthru(struct inode *dir, struct dentry *dentry)
+{
+	int err;
+
+	dquot_initialize(dir);
+
+	err = ext2_fallthru_entry(dentry);
+	if (err)
+		return err;
+
+	spin_lock(&dentry->d_lock);
+	dentry->d_flags |= DCACHE_FALLTHRU;
+	spin_unlock(&dentry->d_lock);
+	d_instantiate(dentry, NULL);
+	return 0;
+}
+
 static int ext2_rename (struct inode * old_dir, struct dentry * old_dentry,
 	struct inode * new_dir,	struct dentry * new_dentry )
 {
@@ -447,6 +468,7 @@ const struct inode_operations ext2_dir_inode_operations = {
 	.rmdir		= ext2_rmdir,
 	.mknod		= ext2_mknod,
 	.whiteout	= ext2_whiteout,
+	.fallthru	= ext2_fallthru,
 	.rename		= ext2_rename,
 #ifdef CONFIG_EXT2_FS_XATTR
 	.setxattr	= generic_setxattr,
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 8869794..bafd421 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1100,6 +1100,8 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 
 	if (EXT2_HAS_INCOMPAT_FEATURE(sb, EXT2_FEATURE_INCOMPAT_WHITEOUT))
 		sb->s_flags |= MS_WHITEOUT;
+	if (EXT2_HAS_INCOMPAT_FEATURE(sb, EXT2_FEATURE_INCOMPAT_FALLTHRU))
+		sb->s_flags |= MS_FALLTHRU;
 
 	if (ext2_setup_super (sb, es, sb->s_flags & MS_RDONLY))
 		sb->s_flags |= MS_RDONLY;
diff --git a/include/linux/ext2_fs.h b/include/linux/ext2_fs.h
index 2202faa..cd6d533 100644
--- a/include/linux/ext2_fs.h
+++ b/include/linux/ext2_fs.h
@@ -506,11 +506,14 @@ struct ext2_super_block {
 #define EXT3_FEATURE_INCOMPAT_JOURNAL_DEV	0x0008
 #define EXT2_FEATURE_INCOMPAT_META_BG		0x0010
 #define EXT2_FEATURE_INCOMPAT_WHITEOUT		0x0020
+/* ext3/4 incompat flags take up the intervening constants */
+#define EXT2_FEATURE_INCOMPAT_FALLTHRU		0x2000
 #define EXT2_FEATURE_INCOMPAT_ANY		0xffffffff
 
 #define EXT2_FEATURE_COMPAT_SUPP	EXT2_FEATURE_COMPAT_EXT_ATTR
 #define EXT2_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE| \
 					 EXT2_FEATURE_INCOMPAT_WHITEOUT| \
+					 EXT2_FEATURE_INCOMPAT_FALLTHRU| \
 					 EXT2_FEATURE_INCOMPAT_META_BG)
 #define EXT2_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE| \
@@ -578,6 +581,7 @@ enum {
 	EXT2_FT_SOCK		= 6,
 	EXT2_FT_SYMLINK		= 7,
 	EXT2_FT_WHT		= 8,
+	EXT2_FT_FALLTHRU	= 9,
 	EXT2_FT_MAX
 };
 

