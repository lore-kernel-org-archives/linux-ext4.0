From: Valerie Aurora <valerie.aurora@gmail.com>
Subject: [PATCH 15/74] fallthru: ext2 fallthru support
Date: Tue, 22 Mar 2011 18:58:51 -0700
Message-ID: <1300845590-14184-16-git-send-email-valerie.aurora@gmail.com>
References: <1300845590-14184-1-git-send-email-valerie.aurora@gmail.com>
Cc: viro@zeniv.linux.org.uk, Valerie Aurora <vaurora@redhat.com>,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Jan Blunck <jblunck@suse.de>,
	Valerie Aurora <valerie.aurora@gmail.com>
To: linux-fsdevel@vger.kernel.org, linux@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35514 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756158Ab1CWCBE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Mar 2011 22:01:04 -0400
In-Reply-To: <1300845590-14184-1-git-send-email-valerie.aurora@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Valerie Aurora <vaurora@redhat.com>

Add support for fallthru directory entries to ext2.

Cc: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org
Signed-off-by: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Valerie Aurora <valerie.aurora@gmail.com>
---
 fs/ext2/dir.c           |   39 +++++++++++++++++++++++++++++++++++----
 fs/ext2/ext2.h          |    1 +
 fs/ext2/namei.c         |   22 ++++++++++++++++++++++
 fs/ext2/super.c         |    2 ++
 include/linux/ext2_fs.h |    4 ++++
 5 files changed, 64 insertions(+), 4 deletions(-)

diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index 6fa1217..daff471 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -212,7 +212,8 @@ fail:
 static inline int ext2_dirent_in_use(struct ext2_dir_entry_2 *de)
 {
 	return (de->inode ||
-		(de->file_type == EXT2_FT_WHT));
+		(de->file_type == EXT2_FT_WHT) ||
+		(de->file_type == EXT2_FT_FALLTHRU));
 }
 
 /*
@@ -262,6 +263,7 @@ static unsigned char ext2_filetype_table[EXT2_FT_MAX] = {
 	[EXT2_FT_SOCK]		= DT_SOCK,
 	[EXT2_FT_SYMLINK]	= DT_LNK,
 	[EXT2_FT_WHT]		= DT_WHT,
+	[EXT2_FT_FALLTHRU]	= DT_UNKNOWN,
 };
 
 #define S_SHIFT 12
@@ -348,6 +350,18 @@ ext2_readdir (struct file * filp, void * dirent, filldir_t filldir)
 					ext2_put_page(page);
 					return 0;
 				}
+			} else if (de->file_type == EXT2_FT_FALLTHRU) {
+				int over;
+
+				offset = (char *)de - kaddr;
+				/* XXX placeholder until generic_readdir_fallthru() arrives */
+				over = filldir(dirent, de->name, de->name_len,
+					       (n<<PAGE_CACHE_SHIFT) | offset,
+					       1, DT_UNKNOWN); /* XXX */
+				if (over) {
+					ext2_put_page(page);
+					return 0;
+				}
 			}
 			filp->f_pos += ext2_rec_len_from_disk(de->rec_len);
 		}
@@ -474,6 +488,10 @@ ino_t ext2_inode_by_dentry(struct inode *dir, struct dentry *dentry)
 			spin_lock(&dentry->d_lock);
 			dentry->d_flags |= DCACHE_WHITEOUT;
 			spin_unlock(&dentry->d_lock);
+		} else if(!res && de->file_type == EXT2_FT_FALLTHRU) {
+			spin_lock(&dentry->d_lock);
+			dentry->d_flags |= DCACHE_FALLTHRU;
+			spin_unlock(&dentry->d_lock);
 		}
 		ext2_put_page(page);
 	}
@@ -572,15 +590,18 @@ got_it:
 	/*
 	 * Pre-existing entries with the same name are allowable
 	 * depending on the type of the entry being created.  Regular
-	 * entries replace whiteouts.  Whiteouts replace regular
-	 * entries.
+	 * entries replace whiteouts and fallthrus.  Whiteouts replace
+	 * regular entries.  Fallthrus replace nothing.
 	 */
 	err = -EEXIST;
 	if (ext2_match(namelen, name, de)) {
 		if (new_file_type == EXT2_FT_WHT) {
 			if (de->file_type == EXT2_FT_WHT)
 				goto out_unlock;
-		} else if (de->file_type != EXT2_FT_WHT) {
+		} else if (new_file_type == EXT2_FT_FALLTHRU) {
+			goto out_unlock;
+		} else if ((de->file_type != EXT2_FT_WHT) &&
+			   (de->file_type != EXT2_FT_FALLTHRU)) {
 			goto out_unlock;
 		}
 	}
@@ -631,6 +652,16 @@ int ext2_whiteout_entry (struct dentry *dentry, ext2_dirent *de, struct page *pa
 }
 
 /*
+ * Create a fallthru entry.
+ */
+int ext2_fallthru_entry (struct dentry *dentry)
+{
+	ext2_dirent *de = NULL;
+	struct page *page = NULL;
+	return ext2_add_entry(dentry, NULL, de, page, EXT2_FT_FALLTHRU);
+}
+
+/*
  * ext2_delete_entry deletes a directory entry by merging it with the
  * previous entry. Page is up-to-date. Releases the page.
  */
diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index 799dedb..3df5572 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -107,6 +107,7 @@ extern int ext2_make_empty(struct inode *, struct inode *);
 extern struct ext2_dir_entry_2 * ext2_find_entry (struct inode *,struct qstr *, struct page **);
 extern int ext2_delete_entry (struct ext2_dir_entry_2 *, struct page *);
 extern int ext2_whiteout_entry (struct dentry *, struct ext2_dir_entry_2 *, struct page *);
+extern int ext2_fallthru_entry (struct dentry *);
 extern int ext2_empty_dir (struct inode *);
 extern struct ext2_dir_entry_2 * ext2_dotdot (struct inode *, struct page **);
 extern void ext2_set_link(struct inode *, struct ext2_dir_entry_2 *, struct page *, struct inode *, int);
diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index 08ad675..c65349b 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -345,6 +345,7 @@ static int ext2_whiteout(struct inode *dir, struct dentry *dentry,
 		goto out;
 
 	spin_lock(&new_dentry->d_lock);
+	new_dentry->d_flags &= ~DCACHE_FALLTHRU;
 	new_dentry->d_flags |= DCACHE_WHITEOUT;
 	spin_unlock(&new_dentry->d_lock);
 	d_add(new_dentry, NULL);
@@ -363,6 +364,26 @@ out:
 	return err;
 }
 
+/*
+ * Create a fallthru entry.
+ */
+static int ext2_fallthru (struct inode *dir, struct dentry *dentry)
+{
+	int err;
+
+	dquot_initialize(dir);
+
+	err = ext2_fallthru_entry(dentry);
+	if (err)
+		return err;
+
+	d_instantiate(dentry, NULL);
+	spin_lock(&dentry->d_lock);
+	dentry->d_flags |= DCACHE_FALLTHRU;
+	spin_unlock(&dentry->d_lock);
+	return 0;
+}
+
 static int ext2_rename (struct inode * old_dir, struct dentry * old_dentry,
 	struct inode * new_dir,	struct dentry * new_dentry )
 {
@@ -466,6 +487,7 @@ const struct inode_operations ext2_dir_inode_operations = {
 	.rmdir		= ext2_rmdir,
 	.mknod		= ext2_mknod,
 	.whiteout	= ext2_whiteout,
+	.fallthru	= ext2_fallthru,
 	.rename		= ext2_rename,
 #ifdef CONFIG_EXT2_FS_XATTR
 	.setxattr	= generic_setxattr,
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index b941b99..e88329e 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1083,6 +1083,8 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 
 	if (EXT2_HAS_INCOMPAT_FEATURE(sb, EXT2_FEATURE_INCOMPAT_WHITEOUT))
 		sb->s_flags |= MS_WHITEOUT;
+	if (EXT2_HAS_INCOMPAT_FEATURE(sb, EXT2_FEATURE_INCOMPAT_FALLTHRU))
+		sb->s_flags |= MS_FALLTHRU;
 
 	if (ext2_setup_super (sb, es, sb->s_flags & MS_RDONLY))
 		sb->s_flags |= MS_RDONLY;
diff --git a/include/linux/ext2_fs.h b/include/linux/ext2_fs.h
index b0fb356..1a6f929 100644
--- a/include/linux/ext2_fs.h
+++ b/include/linux/ext2_fs.h
@@ -505,11 +505,14 @@ struct ext2_super_block {
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
@@ -577,6 +580,7 @@ enum {
 	EXT2_FT_SOCK		= 6,
 	EXT2_FT_SYMLINK		= 7,
 	EXT2_FT_WHT		= 8,
+	EXT2_FT_FALLTHRU	= 9,
 	EXT2_FT_MAX
 };
 
-- 
1.7.0.4

