From: akpm@linux-foundation.org
Subject: + exportfs-remove-old-methods.patch added to -mm tree
Date: Thu, 20 Sep 2007 17:13:33 -0700
Message-ID: <200709210013.l8L0DXim009794@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: hch@lst.de, aia21@cantab.net, bfields@fieldses.org, dgc@sgi.com,
	hirofumi@mail.parknet.co.jp, hugh@veritas.com, jeffm@suse.com,
	linux-ext4@vger.kernel.org, mark.fasheh@oracle.com, mason@suse.com,
	neilb@suse.de, shaggy@austin.ibm.com, swhiteho@redhat.com,
	tes@sgi.com, vs@namesys.com
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     exportfs: remove old methods
has been added to the -mm tree.  Its filename is
     exportfs-remove-old-methods.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: exportfs: remove old methods
From: Christoph Hellwig <hch@lst.de>

Now that all filesystems are converted remove support for the old methods.

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

 fs/exportfs/expfs.c      |  179 -------------------------------------
 fs/nfsd/export.c         |    8 -
 include/linux/exportfs.h |   41 --------
 3 files changed, 3 insertions(+), 225 deletions(-)

diff -puN fs/exportfs/expfs.c~exportfs-remove-old-methods fs/exportfs/expfs.c
--- a/fs/exportfs/expfs.c~exportfs-remove-old-methods
+++ a/fs/exportfs/expfs.c
@@ -13,19 +13,6 @@ static int get_name(struct dentry *dentr
 		struct dentry *child);
 
 
-static struct dentry *exportfs_get_dentry(struct super_block *sb, void *obj)
-{
-	struct dentry *result = ERR_PTR(-ESTALE);
-
-	if (sb->s_export_op->get_dentry) {
-		result = sb->s_export_op->get_dentry(sb, obj);
-		if (!result)
-			result = ERR_PTR(-ESTALE);
-	}
-
-	return result;
-}
-
 static int exportfs_get_name(struct dentry *dir, char *name,
 		struct dentry *child)
 {
@@ -214,125 +201,6 @@ reconnect_path(struct super_block *sb, s
 	return 0;
 }
 
-/**
- * find_exported_dentry - helper routine to implement export_operations->decode_fh
- * @sb:		The &super_block identifying the filesystem
- * @obj:	An opaque identifier of the object to be found - passed to
- *		get_inode
- * @parent:	An optional opqaue identifier of the parent of the object.
- * @acceptable:	A function used to test possible &dentries to see if they are
- *		acceptable
- * @context:	A parameter to @acceptable so that it knows on what basis to
- *		judge.
- *
- * find_exported_dentry is the central helper routine to enable file systems
- * to provide the decode_fh() export_operation.  It's main task is to take
- * an &inode, find or create an appropriate &dentry structure, and possibly
- * splice this into the dcache in the correct place.
- *
- * The decode_fh() operation provided by the filesystem should call
- * find_exported_dentry() with the same parameters that it received except
- * that instead of the file handle fragment, pointers to opaque identifiers
- * for the object and optionally its parent are passed.  The default decode_fh
- * routine passes one pointer to the start of the filehandle fragment, and
- * one 8 bytes into the fragment.  It is expected that most filesystems will
- * take this approach, though the offset to the parent identifier may well be
- * different.
- *
- * find_exported_dentry() will call get_dentry to get an dentry pointer from
- * the file system.  If any &dentry in the d_alias list is acceptable, it will
- * be returned.  Otherwise find_exported_dentry() will attempt to splice a new
- * &dentry into the dcache using get_name() and get_parent() to find the
- * appropriate place.
- */
-
-struct dentry *
-find_exported_dentry(struct super_block *sb, void *obj, void *parent,
-		     int (*acceptable)(void *context, struct dentry *de),
-		     void *context)
-{
-	struct dentry *result, *alias;
-	int err = -ESTALE;
-
-	/*
-	 * Attempt to find the inode.
-	 */
-	result = exportfs_get_dentry(sb, obj);
-	if (IS_ERR(result))
-		return result;
-
-	if (S_ISDIR(result->d_inode->i_mode)) {
-		if (!(result->d_flags & DCACHE_DISCONNECTED)) {
-			if (acceptable(context, result))
-				return result;
-			err = -EACCES;
-			goto err_result;
-		}
-
-		err = reconnect_path(sb, result);
-		if (err)
-			goto err_result;
-	} else {
-		struct dentry *target_dir, *nresult;
-		char nbuf[NAME_MAX+1];
-
-		alias = find_acceptable_alias(result, acceptable, context);
-		if (alias)
-			return alias;
-
-		if (parent == NULL)
-			goto err_result;
-
-		target_dir = exportfs_get_dentry(sb,parent);
-		if (IS_ERR(target_dir)) {
-			err = PTR_ERR(target_dir);
-			goto err_result;
-		}
-
-		err = reconnect_path(sb, target_dir);
-		if (err) {
-			dput(target_dir);
-			goto err_result;
-		}
-
-		/*
-		 * As we weren't after a directory, have one more step to go.
-		 */
-		err = exportfs_get_name(target_dir, nbuf, result);
-		if (!err) {
-			mutex_lock(&target_dir->d_inode->i_mutex);
-			nresult = lookup_one_len(nbuf, target_dir,
-						 strlen(nbuf));
-			mutex_unlock(&target_dir->d_inode->i_mutex);
-			if (!IS_ERR(nresult)) {
-				if (nresult->d_inode) {
-					dput(result);
-					result = nresult;
-				} else
-					dput(nresult);
-			}
-		}
-		dput(target_dir);
-	}
-
-	alias = find_acceptable_alias(result, acceptable, context);
-	if (alias)
-		return alias;
-
-	/* drat - I just cannot find anything acceptable */
-	dput(result);
-	/* It might be justifiable to return ESTALE here,
-	 * but the filehandle at-least looks reasonable good
-	 * and it may just be a permission problem, so returning
-	 * -EACCESS is safer
-	 */
-	return ERR_PTR(-EACCES);
-
- err_result:
-	dput(result);
-	return ERR_PTR(err);
-}
-
 struct getdents_callback {
 	char *name;		/* name that was found. It already points to a
 				   buffer NAME_MAX+1 is size */
@@ -462,38 +330,6 @@ static int export_encode_fh(struct dentr
 	return type;
 }
 
-
-/**
- * export_decode_fh - default export_operations->decode_fh function
- * @sb:  The superblock
- * @fh:  pointer to the file handle fragment
- * @fh_len: length of file handle fragment
- * @acceptable: function for testing acceptability of dentrys
- * @context:   context for @acceptable
- *
- * This is the default decode_fh() function.
- * a fileid_type of 1 indicates that the filehandlefragment
- * just contains an object identifier understood by  get_dentry.
- * a fileid_type of 2 says that there is also a directory
- * identifier 8 bytes in to the filehandlefragement.
- */
-static struct dentry *export_decode_fh(struct super_block *sb, __u32 *fh, int fh_len,
-			      int fileid_type,
-			 int (*acceptable)(void *context, struct dentry *de),
-			 void *context)
-{
-	__u32 parent[2];
-	parent[0] = parent[1] = 0;
-	if (fh_len < 2 || fileid_type > 2)
-		return NULL;
-	if (fileid_type == 2) {
-		if (fh_len > 2) parent[0] = fh[2];
-		if (fh_len > 3) parent[1] = fh[3];
-	}
-	return find_exported_dentry(sb, fh, parent,
-				   acceptable, context);
-}
-
 int exportfs_encode_fh(struct dentry *dentry, struct fid *fid, int *max_len,
 		int connectable)
 {
@@ -518,19 +354,6 @@ struct dentry *exportfs_decode_fh(struct
 	int err;
 
 	/*
-	 * Old way of doing things.  Will go away soon.
-	 */
-	if (!nop->fh_to_dentry) {
-		if (nop->decode_fh) {
-			return nop->decode_fh(mnt->mnt_sb, fid->raw, fh_len,
-					fileid_type, acceptable, context);
-		} else {
-			return export_decode_fh(mnt->mnt_sb, fid->raw, fh_len,
-					fileid_type, acceptable, context);
-		}
-	}
-
-	/*
 	 * Try to get any dentry for the given file handle from the filesystem.
 	 */
 	result = nop->fh_to_dentry(mnt->mnt_sb, fid, fh_len, fileid_type);
@@ -652,6 +475,4 @@ struct dentry *exportfs_decode_fh(struct
 }
 EXPORT_SYMBOL_GPL(exportfs_decode_fh);
 
-EXPORT_SYMBOL(find_exported_dentry);
-
 MODULE_LICENSE("GPL");
diff -puN fs/nfsd/export.c~exportfs-remove-old-methods fs/nfsd/export.c
--- a/fs/nfsd/export.c~exportfs-remove-old-methods
+++ a/fs/nfsd/export.c
@@ -386,15 +386,13 @@ static int check_export(struct inode *in
 		dprintk("exp_export: export of non-dev fs without fsid\n");
 		return -EINVAL;
 	}
-	if (!inode->i_sb->s_export_op) {
+
+	if (!inode->i_sb->s_export_op ||
+	    !inode->i_sb->s_export_op->fh_to_dentry) {
 		dprintk("exp_export: export of invalid fs type.\n");
 		return -EINVAL;
 	}
 
-	/* Ok, we can export it */;
-	if (!inode->i_sb->s_export_op->find_exported_dentry)
-		inode->i_sb->s_export_op->find_exported_dentry =
-			find_exported_dentry;
 	return 0;
 
 }
diff -puN include/linux/exportfs.h~exportfs-remove-old-methods include/linux/exportfs.h
--- a/include/linux/exportfs.h~exportfs-remove-old-methods
+++ a/include/linux/exportfs.h
@@ -54,8 +54,6 @@ struct fid {
  * @get_name:       find the name for a given inode in a given directory
  * @get_parent:     find the parent of a given directory
  * @get_dentry:     find a dentry for the inode given a file handle sub-fragment
- * @find_exported_dentry:
- *	set by the exporting module to a standard helper function.
  *
  * Description:
  *    The export_operations structure provides a means for nfsd to communicate
@@ -82,16 +80,6 @@ struct fid {
  *    looking for the next.  As soon as an acceptable one is found, it should
  *    be returned.
  *
- * decode_fh:
- *    @decode_fh is given a &struct super_block (@sb), a file handle fragment
- *    (@fh, @fh_len) and an acceptability testing function (@acceptable,
- *    @context).  It should return a &struct dentry which refers to the same
- *    file that the file handle fragment refers to,  and which passes the
- *    acceptability test.  If it cannot, it should return a %NULL pointer if
- *    the file was found but no acceptable &dentries were available, or a
- *    %ERR_PTR error code indicating why it couldn't be found (e.g. %ENOENT or
- *    %ENOMEM).
- *
  * encode_fh:
  *    @encode_fh should store in the file handle fragment @fh (using at most
  *    @max_len bytes) information that can be used by @decode_fh to recover the
@@ -129,30 +117,12 @@ struct fid {
  *    is also a directory.  In the event that it cannot be found, or storage
  *    space cannot be allocated, a %ERR_PTR should be returned.
  *
- * get_dentry:
- *    Given a &super_block (@sb) and a pointer to a file-system specific inode
- *    identifier, possibly an inode number, (@inump) get_dentry() should find
- *    the identified inode and return a dentry for that inode.  Any suitable
- *    dentry can be returned including, if necessary, a new dentry created with
- *    d_alloc_root.  The caller can then find any other extant dentrys by
- *    following the d_alias links.  If a new dentry was created using
- *    d_alloc_root, DCACHE_NFSD_DISCONNECTED should be set, and the dentry
- *    should be d_rehash()ed.
- *
- *    If the inode cannot be found, either a %NULL pointer or an %ERR_PTR code
- *    can be returned.  The @inump will be whatever was passed to
- *    nfsd_find_fh_dentry() in either the @obj or @parent parameters.
- *
  * Locking rules:
  *    get_parent is called with child->d_inode->i_mutex down
  *    get_name is not (which is possibly inconsistent)
  */
 
 struct export_operations {
-	struct dentry *(*decode_fh)(struct super_block *sb, __u32 *fh,
-			int fh_len, int fh_type,
-			int (*acceptable)(void *context, struct dentry *de),
-			void *context);
 	int (*encode_fh)(struct dentry *de, __u32 *fh, int *max_len,
 			int connectable);
 	struct dentry * (*fh_to_dentry)(struct super_block *sb, struct fid *fid,
@@ -162,19 +132,8 @@ struct export_operations {
 	int (*get_name)(struct dentry *parent, char *name,
 			struct dentry *child);
 	struct dentry * (*get_parent)(struct dentry *child);
-	struct dentry * (*get_dentry)(struct super_block *sb, void *inump);
-
-	/* This is set by the exporting module to a standard helper */
-	struct dentry * (*find_exported_dentry)(
-			struct super_block *sb, void *obj, void *parent,
-			int (*acceptable)(void *context, struct dentry *de),
-			void *context);
 };
 
-extern struct dentry *find_exported_dentry(struct super_block *sb, void *obj,
-	void *parent, int (*acceptable)(void *context, struct dentry *de),
-	void *context);
-
 extern int exportfs_encode_fh(struct dentry *dentry, struct fid *fid,
 	int *max_len, int connectable);
 extern struct dentry *exportfs_decode_fh(struct vfsmount *mnt, struct fid *fid,
_

Patches currently in -mm which might be from hch@lst.de are

git-nfs.patch
git-nfsd.patch
partially-fix-up-the-lookup_one_noperm-mess.patch
optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft.patch
optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft-fix.patch
git-xfs.patch
sysv-convert-to-new-aops.patch
alpha-convert-to-generic-sys_ptrace.patch
kill-declare_mutex_locked.patch
remove-unneded-lock_kernel-in-driver-block-loopc.patch
ufs-move-non-layout-parts-of-ufs_fsh-to-fs-ufs.patch
fix-execute-checking-in-permission.patch
exec-remove-unnecessary-check-for-mnt_noexec.patch
fix-f_version-type-should-be-u64-instead-of-unsigned-long.patch
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
unprivileged-mounts-propagation-inherit-owner-from-parent.patch
unprivileged-mounts-add-no-submounts-flag.patch
revoke-special-mmap-handling.patch
revoke-core-code.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
exportfs-add-fid-type.patch
exportfs-add-new-methods.patch
ext2-new-export-ops.patch
ext3-new-export-ops.patch
ext4-new-export-ops.patch
efs-new-export-ops.patch
jfs-new-export-ops.patch
ntfs-new-export-ops.patch
xfs-new-export-ops.patch
fat-new-export-ops.patch
isofs-new-export-ops.patch
shmem-new-export-ops.patch
reiserfs-new-export-ops.patch
gfs2-new-export-ops.patch
ocfs2-new-export-ops.patch
exportfs-remove-old-methods.patch
exportfs-make-struct-export_operations-const.patch
exportfs-update-documentation.patch
