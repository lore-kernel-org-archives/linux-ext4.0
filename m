From: akpm@linux-foundation.org
Subject: [patch 25/41] exportfs: add new methods
Date: Sun, 21 Oct 2007 16:42:05 -0700
Message-ID: <200710212342.l9LNg5xu000408@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, hch@lst.de, aia21@cantab.net,
	bfields@fieldses.org, dgc@sgi.com, hirofumi@mail.parknet.co.jp,
	hugh@veritas.com, jeffm@suse.com, linux-ext4@vger.kernel.org,
	mark.fasheh@oracle.com, mason@suse.com, neilb@suse.de,
	shaggy@austin.ibm.com, swhiteho@redhat.com, tes@sgi.com,
	vs@namesys.com
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57091 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754295AbXJUXxk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Oct 2007 19:53:40 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Add the guts for the new filesystem API to exportfs.

There's now a fh_to_dentry method that returns a dentry for the object looked
for given a filehandle fragment, and a fh_to_parent operation that returns the
dentry for the encoded parent directory in case the file handle contains it.

There are default implementations for these methods that only take a callback
for an nfs-enhanced iget variant and implement the rest of the semantics.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Neil Brown <neilb@suse.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: <linux-ext4@vger.kernel.org>
Cc: Dave Kleikamp <shaggy@austin.ibm.com>
Cc: Anton Altaparmakov <aia21@cantab.net>
Cc: David Chinner <dgc@sgi.com>
Cc: Timothy Shimmin <tes@sgi.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Chris Mason <mason@suse.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: "Vladimir V. Saveliev" <vs@namesys.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Mark Fasheh <mark.fasheh@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exportfs/expfs.c      |  136 +++++++++++++++++++++++++++++++++++--
 fs/libfs.c               |   88 +++++++++++++++++++++++
 include/linux/exportfs.h |   30 ++++++++
 3 files changed, 248 insertions(+), 6 deletions(-)

diff -puN fs/exportfs/expfs.c~exportfs-add-new-methods fs/exportfs/expfs.c
--- a/fs/exportfs/expfs.c~exportfs-add-new-methods
+++ a/fs/exportfs/expfs.c
@@ -514,17 +514,141 @@ struct dentry *exportfs_decode_fh(struct
 		int (*acceptable)(void *, struct dentry *), void *context)
 {
 	struct export_operations *nop = mnt->mnt_sb->s_export_op;
-	struct dentry *result;
+	struct dentry *result, *alias;
+	int err;
 
-	if (nop->decode_fh) {
-		result = nop->decode_fh(mnt->mnt_sb, fid->raw, fh_len,
+	/*
+	 * Old way of doing things.  Will go away soon.
+	 */
+	if (!nop->fh_to_dentry) {
+		if (nop->decode_fh) {
+			return nop->decode_fh(mnt->mnt_sb, fid->raw, fh_len,
 					fileid_type, acceptable, context);
+		} else {
+			return export_decode_fh(mnt->mnt_sb, fid->raw, fh_len,
+					fileid_type, acceptable, context);
+		}
+	}
+
+	/*
+	 * Try to get any dentry for the given file handle from the filesystem.
+	 */
+	result = nop->fh_to_dentry(mnt->mnt_sb, fid, fh_len, fileid_type);
+	if (!result)
+		result = ERR_PTR(-ESTALE);
+	if (IS_ERR(result))
+		return result;
+
+	if (S_ISDIR(result->d_inode->i_mode)) {
+		/*
+		 * This request is for a directory.
+		 *
+		 * On the positive side there is only one dentry for each
+		 * directory inode.  On the negative side this implies that we
+		 * to ensure our dentry is connected all the way up to the
+		 * filesystem root.
+		 */
+		if (result->d_flags & DCACHE_DISCONNECTED) {
+			err = reconnect_path(mnt->mnt_sb, result);
+			if (err)
+				goto err_result;
+		}
+
+		if (!acceptable(context, result)) {
+			err = -EACCES;
+			goto err_result;
+		}
+
+		return result;
 	} else {
-		result = export_decode_fh(mnt->mnt_sb, fid->raw, fh_len,
-					  fileid_type, acceptable, context);
+		/*
+		 * It's not a directory.  Life is a little more complicated.
+		 */
+		struct dentry *target_dir, *nresult;
+		char nbuf[NAME_MAX+1];
+
+		/*
+		 * See if either the dentry we just got from the filesystem
+		 * or any alias for it is acceptable.  This is always true
+		 * if this filesystem is exported without the subtreecheck
+		 * option.  If the filesystem is exported with the subtree
+		 * check option there's a fair chance we need to look at
+		 * the parent directory in the file handle and make sure
+		 * it's connected to the filesystem root.
+		 */
+		alias = find_acceptable_alias(result, acceptable, context);
+		if (alias)
+			return alias;
+
+		/*
+		 * Try to extract a dentry for the parent directory from the
+		 * file handle.  If this fails we'll have to give up.
+		 */
+		err = -ESTALE;
+		if (!nop->fh_to_parent)
+			goto err_result;
+
+		target_dir = nop->fh_to_parent(mnt->mnt_sb, fid,
+				fh_len, fileid_type);
+		if (!target_dir)
+			goto err_result;
+		err = PTR_ERR(target_dir);
+		if (IS_ERR(target_dir))
+			goto err_result;
+
+		/*
+		 * And as usual we need to make sure the parent directory is
+		 * connected to the filesystem root.  The VFS really doesn't
+		 * like disconnected directories..
+		 */
+		err = reconnect_path(mnt->mnt_sb, target_dir);
+		if (err) {
+			dput(target_dir);
+			goto err_result;
+		}
+
+		/*
+		 * Now that we've got both a well-connected parent and a
+		 * dentry for the inode we're after, make sure that our
+		 * inode is actually connected to the parent.
+		 */
+		err = exportfs_get_name(target_dir, nbuf, result);
+		if (!err) {
+			mutex_lock(&target_dir->d_inode->i_mutex);
+			nresult = lookup_one_len(nbuf, target_dir,
+						 strlen(nbuf));
+			mutex_unlock(&target_dir->d_inode->i_mutex);
+			if (!IS_ERR(nresult)) {
+				if (nresult->d_inode) {
+					dput(result);
+					result = nresult;
+				} else
+					dput(nresult);
+			}
+		}
+
+		/*
+		 * At this point we are done with the parent, but it's pinned
+		 * by the child dentry anyway.
+		 */
+		dput(target_dir);
+
+		/*
+		 * And finally make sure the dentry is actually acceptable
+		 * to NFSD.
+		 */
+		alias = find_acceptable_alias(result, acceptable, context);
+		if (!alias) {
+			err = -EACCES;
+			goto err_result;
+		}
+
+		return alias;
 	}
 
-	return result;
+ err_result:
+	dput(result);
+	return ERR_PTR(err);
 }
 EXPORT_SYMBOL_GPL(exportfs_decode_fh);
 
diff -puN fs/libfs.c~exportfs-add-new-methods fs/libfs.c
--- a/fs/libfs.c~exportfs-add-new-methods
+++ a/fs/libfs.c
@@ -8,6 +8,7 @@
 #include <linux/mount.h>
 #include <linux/vfs.h>
 #include <linux/mutex.h>
+#include <linux/exportfs.h>
 
 #include <asm/uaccess.h>
 
@@ -678,6 +679,93 @@ out:
 	return ret;
 }
 
+/*
+ * This is what d_alloc_anon should have been.  Once the exportfs
+ * argument transition has been finished I will update d_alloc_anon
+ * to this prototype and this wrapper will go away.   --hch
+ */
+static struct dentry *exportfs_d_alloc(struct inode *inode)
+{
+	struct dentry *dentry;
+
+	if (!inode)
+		return NULL;
+	if (IS_ERR(inode))
+		return ERR_PTR(PTR_ERR(inode));
+
+	dentry = d_alloc_anon(inode);
+	if (!dentry) {
+		iput(inode);
+		dentry = ERR_PTR(-ENOMEM);
+	}
+	return dentry;
+}
+
+/**
+ * generic_fh_to_dentry - generic helper for the fh_to_dentry export operation
+ * @sb:		filesystem to do the file handle conversion on
+ * @fid:	file handle to convert
+ * @fh_len:	length of the file handle in bytes
+ * @fh_type:	type of file handle
+ * @get_inode:	filesystem callback to retrieve inode
+ *
+ * This function decodes @fid as long as it has one of the well-known
+ * Linux filehandle types and calls @get_inode on it to retrieve the
+ * inode for the object specified in the file handle.
+ */
+struct dentry *generic_fh_to_dentry(struct super_block *sb, struct fid *fid,
+		int fh_len, int fh_type, struct inode *(*get_inode)
+			(struct super_block *sb, u64 ino, u32 gen))
+{
+	struct inode *inode = NULL;
+
+	if (fh_len < 2)
+		return NULL;
+
+	switch (fh_type) {
+	case FILEID_INO32_GEN:
+	case FILEID_INO32_GEN_PARENT:
+		inode = get_inode(sb, fid->i32.ino, fid->i32.gen);
+		break;
+	}
+
+	return exportfs_d_alloc(inode);
+}
+EXPORT_SYMBOL_GPL(generic_fh_to_dentry);
+
+/**
+ * generic_fh_to_dentry - generic helper for the fh_to_parent export operation
+ * @sb:		filesystem to do the file handle conversion on
+ * @fid:	file handle to convert
+ * @fh_len:	length of the file handle in bytes
+ * @fh_type:	type of file handle
+ * @get_inode:	filesystem callback to retrieve inode
+ *
+ * This function decodes @fid as long as it has one of the well-known
+ * Linux filehandle types and calls @get_inode on it to retrieve the
+ * inode for the _parent_ object specified in the file handle if it
+ * is specified in the file handle, or NULL otherwise.
+ */
+struct dentry *generic_fh_to_parent(struct super_block *sb, struct fid *fid,
+		int fh_len, int fh_type, struct inode *(*get_inode)
+			(struct super_block *sb, u64 ino, u32 gen))
+{
+	struct inode *inode = NULL;
+
+	if (fh_len <= 2)
+		return NULL;
+
+	switch (fh_type) {
+	case FILEID_INO32_GEN_PARENT:
+		inode = get_inode(sb, fid->i32.parent_ino,
+				  (fh_len > 3 ? fid->i32.parent_gen : 0));
+		break;
+	}
+
+	return exportfs_d_alloc(inode);
+}
+EXPORT_SYMBOL_GPL(generic_fh_to_parent);
+
 EXPORT_SYMBOL(dcache_dir_close);
 EXPORT_SYMBOL(dcache_dir_lseek);
 EXPORT_SYMBOL(dcache_dir_open);
diff -puN include/linux/exportfs.h~exportfs-add-new-methods include/linux/exportfs.h
--- a/include/linux/exportfs.h~exportfs-add-new-methods
+++ a/include/linux/exportfs.h
@@ -4,6 +4,7 @@
 #include <linux/types.h>
 
 struct dentry;
+struct inode;
 struct super_block;
 struct vfsmount;
 
@@ -101,6 +102,21 @@ struct fid {
  *    the filehandle fragment.  encode_fh() should return the number of bytes
  *    stored or a negative error code such as %-ENOSPC
  *
+ * fh_to_dentry:
+ *    @fh_to_dentry is given a &struct super_block (@sb) and a file handle
+ *    fragment (@fh, @fh_len). It should return a &struct dentry which refers
+ *    to the same file that the file handle fragment refers to.  If it cannot,
+ *    it should return a %NULL pointer if the file was found but no acceptable
+ *    &dentries were available, or an %ERR_PTR error code indicating why it
+ *    couldn't be found (e.g. %ENOENT or %ENOMEM).  Any suitable dentry can be
+ *    returned including, if necessary, a new dentry created with d_alloc_root.
+ *    The caller can then find any other extant dentries by following the
+ *    d_alias links.
+ *
+ * fh_to_parent:
+ *    Same as @fh_to_dentry, except that it returns a pointer to the parent
+ *    dentry if it was encoded into the filehandle fragment by @encode_fh.
+ *
  * get_name:
  *    @get_name should find a name for the given @child in the given @parent
  *    directory.  The name should be stored in the @name (with the
@@ -139,6 +155,10 @@ struct export_operations {
 			void *context);
 	int (*encode_fh)(struct dentry *de, __u32 *fh, int *max_len,
 			int connectable);
+	struct dentry * (*fh_to_dentry)(struct super_block *sb, struct fid *fid,
+			int fh_len, int fh_type);
+	struct dentry * (*fh_to_parent)(struct super_block *sb, struct fid *fid,
+			int fh_len, int fh_type);
 	int (*get_name)(struct dentry *parent, char *name,
 			struct dentry *child);
 	struct dentry * (*get_parent)(struct dentry *child);
@@ -161,4 +181,14 @@ extern struct dentry *exportfs_decode_fh
 	int fh_len, int fileid_type, int (*acceptable)(void *, struct dentry *),
 	void *context);
 
+/*
+ * Generic helpers for filesystems.
+ */
+extern struct dentry *generic_fh_to_dentry(struct super_block *sb,
+	struct fid *fid, int fh_len, int fh_type,
+	struct inode *(*get_inode) (struct super_block *sb, u64 ino, u32 gen));
+extern struct dentry *generic_fh_to_parent(struct super_block *sb,
+	struct fid *fid, int fh_len, int fh_type,
+	struct inode *(*get_inode) (struct super_block *sb, u64 ino, u32 gen));
+
 #endif /* LINUX_EXPORTFS_H */
_
