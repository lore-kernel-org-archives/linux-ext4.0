From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 3/3] fscrypt: consolidate
	fscrypt_has_permitted_context() checks
Date: Thu, 15 Dec 2016 11:19:44 -0800
Message-ID: <1481829584-50218-3-git-send-email-ebiggers3@gmail.com>
References: <1481829584-50218-1-git-send-email-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: David Gstir <david@sigma-star.at>, "Theodore Y . Ts'o" <tytso@mit.edu>,
	Eric Biggers <ebiggers@google.com>, Richard Weinberger <richard@nod.at>,
	linux-f2fs-devel@lists.sourceforge.net,
	Jaegeuk Kim <jaegeuk@kernel.org>, linux-ext4@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <1481829584-50218-1-git-send-email-ebiggers3@gmail.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Now that fscrypt_has_permitted_context() compares the fscrypt_context
rather than the fscrypt_info when needed, it is no longer necessary to
delay fscrypt_has_permitted_context() from ->lookup() to ->open() for
regular files, as introduced in commit ff978b09f973 ("ext4 crypto: move
context consistency check to ext4_file_open()").  Therefore the check in
->open(), along with the dget_parent() hack, can be removed.

It's also no longer necessary to check the file type before calling
fscrypt_has_permitted_context().

This patch makes these changes for both ext4 and f2fs.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/file.c  | 12 ------------
 fs/ext4/namei.c | 10 ++--------
 fs/f2fs/file.c  | 15 +++++----------
 fs/f2fs/namei.c |  7 ++-----
 4 files changed, 9 insertions(+), 35 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index b5f1844..2123cd8 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -398,7 +398,6 @@ static int ext4_file_open(struct inode * inode, struct file * filp)
 	struct super_block *sb = inode->i_sb;
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	struct vfsmount *mnt = filp->f_path.mnt;
-	struct dentry *dir;
 	struct path path;
 	char buf[64], *cp;
 	int ret;
@@ -443,17 +442,6 @@ static int ext4_file_open(struct inode * inode, struct file * filp)
 			return -ENOKEY;
 	}
 
-	dir = dget_parent(file_dentry(filp));
-	if (ext4_encrypted_inode(d_inode(dir)) &&
-			!fscrypt_has_permitted_context(d_inode(dir), inode)) {
-		ext4_warning(inode->i_sb,
-			     "Inconsistent encryption contexts: %lu/%lu",
-			     (unsigned long) d_inode(dir)->i_ino,
-			     (unsigned long) inode->i_ino);
-		dput(dir);
-		return -EPERM;
-	}
-	dput(dir);
 	/*
 	 * Set up the jbd2_inode if we are opening the inode for
 	 * writing and the journal is present
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index eadba91..eb8b064 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1612,17 +1612,11 @@ static struct dentry *ext4_lookup(struct inode *dir, struct dentry *dentry, unsi
 			return ERR_PTR(-EFSCORRUPTED);
 		}
 		if (!IS_ERR(inode) && ext4_encrypted_inode(dir) &&
-		    (S_ISDIR(inode->i_mode) || S_ISLNK(inode->i_mode)) &&
 		    !fscrypt_has_permitted_context(dir, inode)) {
-			int nokey = ext4_encrypted_inode(inode) &&
-				!fscrypt_has_encryption_key(inode);
-			iput(inode);
-			if (nokey)
-				return ERR_PTR(-ENOKEY);
 			ext4_warning(inode->i_sb,
 				     "Inconsistent encryption contexts: %lu/%lu",
-				     (unsigned long) dir->i_ino,
-				     (unsigned long) inode->i_ino);
+				     dir->i_ino, inode->i_ino);
+			iput(inode);
 			return ERR_PTR(-EPERM);
 		}
 	}
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 49f10dc..381d39b 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -443,23 +443,18 @@ static int f2fs_file_mmap(struct file *file, struct vm_area_struct *vma)
 static int f2fs_file_open(struct inode *inode, struct file *filp)
 {
 	int ret = generic_file_open(inode, filp);
-	struct dentry *dir;
 
-	if (!ret && f2fs_encrypted_inode(inode)) {
+	if (ret)
+		return ret;
+
+	if (f2fs_encrypted_inode(inode)) {
 		ret = fscrypt_get_encryption_info(inode);
 		if (ret)
 			return -EACCES;
 		if (!fscrypt_has_encryption_key(inode))
 			return -ENOKEY;
 	}
-	dir = dget_parent(file_dentry(filp));
-	if (f2fs_encrypted_inode(d_inode(dir)) &&
-			!fscrypt_has_permitted_context(d_inode(dir), inode)) {
-		dput(dir);
-		return -EPERM;
-	}
-	dput(dir);
-	return ret;
+	return 0;
 }
 
 int truncate_data_blocks_range(struct dnode_of_data *dn, int count)
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index db33b56..980f783 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -322,11 +322,8 @@ static struct dentry *f2fs_lookup(struct inode *dir, struct dentry *dentry,
 			goto err_out;
 	}
 	if (!IS_ERR(inode) && f2fs_encrypted_inode(dir) &&
-			(S_ISDIR(inode->i_mode) || S_ISLNK(inode->i_mode)) &&
-			!fscrypt_has_permitted_context(dir, inode)) {
-		bool nokey = f2fs_encrypted_inode(inode) &&
-			!fscrypt_has_encryption_key(inode);
-		err = nokey ? -ENOKEY : -EPERM;
+	    !fscrypt_has_permitted_context(dir, inode)) {
+		err = -EPERM;
 		goto err_out;
 	}
 	return d_splice_alias(inode, dentry);
-- 
2.8.0.rc3.226.g39d4020


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
