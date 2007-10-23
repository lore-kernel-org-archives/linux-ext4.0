From: akpm@linux-foundation.org
Subject: - exportfs-add-fid-type.patch removed from -mm tree
Date: Mon, 22 Oct 2007 23:47:18 -0700
Message-ID: <200710230647.l9N6lIiD004275@imap1.linux-foundation.org>
To: hch@lst.de, aia21@cantab.net, bfields@fieldses.org, dgc@sgi.com,
	hirofumi@mail.parknet.co.jp, hugh@veritas.com, jeffm@suse.com,
	linux-ext4@vger.kernel.org, mark.fasheh@oracle.com, maso
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37960 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752579AbXJWHEz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Oct 2007 03:04:55 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     exportfs: add fid type
has been removed from the -mm tree.  Its filename was
     exportfs-add-fid-type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: exportfs: add fid type
From: Christoph Hellwig <hch@lst.de>

This patchset is a medium scale rewrite of the export operations interface. 
The goal is to make the interface less complex, and easier to understand from
the filesystem side, aswell as preparing generic support for exporting of
64bit inode numbers.

This touches all nfs exporting filesystems, and I've done testing on all of
the filesystems I have here locally (xfs, ext2, ext3, reiserfs, jfs)


This patch:

Add a structured fid type so that we don't have to pass an array of u32 values
around everywhere.  It's a union of possible layouts.

As a start there's only the u32 array and the traditional 32bit inode format,
but there will be more in one of my next patchset when I start to document the
various filehandle formats we have in lowlevel filesystems better.

Also add an enum that gives the various filehandle types human- readable
names.

Note: Some people might think the struct containing an anonymous union is
ugly, but I didn't want to pass around a raw union type.

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

 fs/exportfs/expfs.c      |   36 +++++++++----------
 fs/nfsd/nfsfh.c          |   67 +++++++++++++++++--------------------
 include/linux/exportfs.h |   44 ++++++++++++++++++++++--
 3 files changed, 90 insertions(+), 57 deletions(-)

diff -puN fs/exportfs/expfs.c~exportfs-add-fid-type fs/exportfs/expfs.c
--- a/fs/exportfs/expfs.c~exportfs-add-fid-type
+++ a/fs/exportfs/expfs.c
@@ -434,29 +434,29 @@ out:
  * can be used to check that it is still valid.  It places them in the
  * filehandle fragment where export_decode_fh expects to find them.
  */
-static int export_encode_fh(struct dentry *dentry, __u32 *fh, int *max_len,
-		   int connectable)
+static int export_encode_fh(struct dentry *dentry, struct fid *fid,
+		int *max_len, int connectable)
 {
 	struct inode * inode = dentry->d_inode;
 	int len = *max_len;
-	int type = 1;
+	int type = FILEID_INO32_GEN;
 	
 	if (len < 2 || (connectable && len < 4))
 		return 255;
 
 	len = 2;
-	fh[0] = inode->i_ino;
-	fh[1] = inode->i_generation;
+	fid->i32.ino = inode->i_ino;
+	fid->i32.gen = inode->i_generation;
 	if (connectable && !S_ISDIR(inode->i_mode)) {
 		struct inode *parent;
 
 		spin_lock(&dentry->d_lock);
 		parent = dentry->d_parent->d_inode;
-		fh[2] = parent->i_ino;
-		fh[3] = parent->i_generation;
+		fid->i32.parent_ino = parent->i_ino;
+		fid->i32.parent_gen = parent->i_generation;
 		spin_unlock(&dentry->d_lock);
 		len = 4;
-		type = 2;
+		type = FILEID_INO32_GEN_PARENT;
 	}
 	*max_len = len;
 	return type;
@@ -494,34 +494,34 @@ static struct dentry *export_decode_fh(s
 				   acceptable, context);
 }
 
-int exportfs_encode_fh(struct dentry *dentry, __u32 *fh, int *max_len,
+int exportfs_encode_fh(struct dentry *dentry, struct fid *fid, int *max_len,
 		int connectable)
 {
  	struct export_operations *nop = dentry->d_sb->s_export_op;
 	int error;
 
 	if (nop->encode_fh)
-		error = nop->encode_fh(dentry, fh, max_len, connectable);
+		error = nop->encode_fh(dentry, fid->raw, max_len, connectable);
 	else
-		error = export_encode_fh(dentry, fh, max_len, connectable);
+		error = export_encode_fh(dentry, fid, max_len, connectable);
 
 	return error;
 }
 EXPORT_SYMBOL_GPL(exportfs_encode_fh);
 
-struct dentry *exportfs_decode_fh(struct vfsmount *mnt, __u32 *fh, int fh_len,
-		int fileid_type, int (*acceptable)(void *, struct dentry *),
-		void *context)
+struct dentry *exportfs_decode_fh(struct vfsmount *mnt, struct fid *fid,
+		int fh_len, int fileid_type,
+		int (*acceptable)(void *, struct dentry *), void *context)
 {
 	struct export_operations *nop = mnt->mnt_sb->s_export_op;
 	struct dentry *result;
 
 	if (nop->decode_fh) {
-		result = nop->decode_fh(mnt->mnt_sb, fh, fh_len, fileid_type,
-			acceptable, context);
+		result = nop->decode_fh(mnt->mnt_sb, fid->raw, fh_len,
+					fileid_type, acceptable, context);
 	} else {
-		result = export_decode_fh(mnt->mnt_sb, fh, fh_len, fileid_type,
-			acceptable, context);
+		result = export_decode_fh(mnt->mnt_sb, fid->raw, fh_len,
+					  fileid_type, acceptable, context);
 	}
 
 	return result;
diff -puN fs/nfsd/nfsfh.c~exportfs-add-fid-type fs/nfsd/nfsfh.c
--- a/fs/nfsd/nfsfh.c~exportfs-add-fid-type
+++ a/fs/nfsd/nfsfh.c
@@ -115,8 +115,7 @@ fh_verify(struct svc_rqst *rqstp, struct
 	dprintk("nfsd: fh_verify(%s)\n", SVCFH_fmt(fhp));
 
 	if (!fhp->fh_dentry) {
-		__u32 *datap=NULL;
-		__u32 tfh[3];		/* filehandle fragment for oldstyle filehandles */
+		struct fid *fid = NULL, sfid;
 		int fileid_type;
 		int data_left = fh->fh_size/4;
 
@@ -128,7 +127,6 @@ fh_verify(struct svc_rqst *rqstp, struct
 
 		if (fh->fh_version == 1) {
 			int len;
-			datap = fh->fh_auth;
 			if (--data_left<0) goto out;
 			switch (fh->fh_auth_type) {
 			case 0: break;
@@ -144,9 +142,11 @@ fh_verify(struct svc_rqst *rqstp, struct
 				fh->fh_fsid[1] = fh->fh_fsid[2];
 			}
 			if ((data_left -= len)<0) goto out;
-			exp = rqst_exp_find(rqstp, fh->fh_fsid_type, datap);
-			datap += len;
+			exp = rqst_exp_find(rqstp, fh->fh_fsid_type,
+					    fh->fh_auth);
+			fid = (struct fid *)(fh->fh_auth + len);
 		} else {
+			__u32 tfh[2];
 			dev_t xdev;
 			ino_t xino;
 			if (fh->fh_size != NFS_FHSIZE)
@@ -190,22 +190,22 @@ fh_verify(struct svc_rqst *rqstp, struct
 			error = nfserr_badhandle;
 
 		if (fh->fh_version != 1) {
-			tfh[0] = fh->ofh_ino;
-			tfh[1] = fh->ofh_generation;
-			tfh[2] = fh->ofh_dirino;
-			datap = tfh;
+			sfid.i32.ino = fh->ofh_ino;
+			sfid.i32.gen = fh->ofh_generation;
+			sfid.i32.parent_ino = fh->ofh_dirino;
+			fid = &sfid;
 			data_left = 3;
 			if (fh->ofh_dirino == 0)
-				fileid_type = 1;
+				fileid_type = FILEID_INO32_GEN;
 			else
-				fileid_type = 2;
+				fileid_type = FILEID_INO32_GEN_PARENT;
 		} else
 			fileid_type = fh->fh_fileid_type;
 
-		if (fileid_type == 0)
+		if (fileid_type == FILEID_ROOT)
 			dentry = dget(exp->ex_dentry);
 		else {
-			dentry = exportfs_decode_fh(exp->ex_mnt, datap,
+			dentry = exportfs_decode_fh(exp->ex_mnt, fid,
 					data_left, fileid_type,
 					nfsd_acceptable, exp);
 		}
@@ -286,16 +286,21 @@ out:
  * an inode.  In this case a call to fh_update should be made
  * before the fh goes out on the wire ...
  */
-static inline int _fh_update(struct dentry *dentry, struct svc_export *exp,
-			     __u32 *datap, int *maxsize)
+static void _fh_update(struct svc_fh *fhp, struct svc_export *exp,
+		struct dentry *dentry)
 {
-	if (dentry == exp->ex_dentry) {
-		*maxsize = 0;
-		return 0;
-	}
+	if (dentry != exp->ex_dentry) {
+		struct fid *fid = (struct fid *)
+			(fhp->fh_handle.fh_auth + fhp->fh_handle.fh_size/4 - 1);
+		int maxsize = (fhp->fh_maxsize - fhp->fh_handle.fh_size)/4;
+		int subtreecheck = !(exp->ex_flags & NFSEXP_NOSUBTREECHECK);
 
-	return exportfs_encode_fh(dentry, datap, maxsize,
-			  !(exp->ex_flags & NFSEXP_NOSUBTREECHECK));
+		fhp->fh_handle.fh_fileid_type =
+			exportfs_encode_fh(dentry, fid, &maxsize, subtreecheck);
+		fhp->fh_handle.fh_size += maxsize * 4;
+	} else {
+		fhp->fh_handle.fh_fileid_type = FILEID_ROOT;
+	}
 }
 
 /*
@@ -457,12 +462,8 @@ fh_compose(struct svc_fh *fhp, struct sv
 		datap += len/4;
 		fhp->fh_handle.fh_size = 4 + len;
 
-		if (inode) {
-			int size = (fhp->fh_maxsize-len-4)/4;
-			fhp->fh_handle.fh_fileid_type =
-				_fh_update(dentry, exp, datap, &size);
-			fhp->fh_handle.fh_size += size*4;
-		}
+		if (inode)
+			_fh_update(fhp, exp, dentry);
 		if (fhp->fh_handle.fh_fileid_type == 255)
 			return nfserr_opnotsupp;
 	}
@@ -479,7 +480,6 @@ __be32
 fh_update(struct svc_fh *fhp)
 {
 	struct dentry *dentry;
-	__u32 *datap;
 
 	if (!fhp->fh_dentry)
 		goto out_bad;
@@ -490,15 +490,10 @@ fh_update(struct svc_fh *fhp)
 	if (fhp->fh_handle.fh_version != 1) {
 		_fh_update_old(dentry, fhp->fh_export, &fhp->fh_handle);
 	} else {
-		int size;
-		if (fhp->fh_handle.fh_fileid_type != 0)
+		if (fhp->fh_handle.fh_fileid_type != FILEID_ROOT)
 			goto out;
-		datap = fhp->fh_handle.fh_auth+
-			fhp->fh_handle.fh_size/4 -1;
-		size = (fhp->fh_maxsize - fhp->fh_handle.fh_size)/4;
-		fhp->fh_handle.fh_fileid_type =
-			_fh_update(dentry, fhp->fh_export, datap, &size);
-		fhp->fh_handle.fh_size += size*4;
+
+		_fh_update(fhp, fhp->fh_export, dentry);
 		if (fhp->fh_handle.fh_fileid_type == 255)
 			return nfserr_opnotsupp;
 	}
diff -puN include/linux/exportfs.h~exportfs-add-fid-type include/linux/exportfs.h
--- a/include/linux/exportfs.h~exportfs-add-fid-type
+++ a/include/linux/exportfs.h
@@ -7,6 +7,44 @@ struct dentry;
 struct super_block;
 struct vfsmount;
 
+/*
+ * The fileid_type identifies how the file within the filesystem is encoded.
+ * In theory this is freely set and parsed by the filesystem, but we try to
+ * stick to conventions so we can share some generic code and don't confuse
+ * sniffers like ethereal/wireshark.
+ *
+ * The filesystem must not use the value '0' or '0xff'.
+ */
+enum fid_type {
+	/*
+	 * The root, or export point, of the filesystem.
+	 * (Never actually passed down to the filesystem.
+	 */
+	FILEID_ROOT = 0,
+
+	/*
+	 * 32bit inode number, 32 bit generation number.
+	 */
+	FILEID_INO32_GEN = 1,
+
+	/*
+	 * 32bit inode number, 32 bit generation number,
+	 * 32 bit parent directory inode number.
+	 */
+	FILEID_INO32_GEN_PARENT = 2,
+};
+
+struct fid {
+	union {
+		struct {
+			u32 ino;
+			u32 gen;
+			u32 parent_ino;
+			u32 parent_gen;
+		} i32;
+		__u32 raw[6];
+	};
+};
 
 /**
  * struct export_operations - for nfsd to communicate with file systems
@@ -117,9 +155,9 @@ extern struct dentry *find_exported_dent
 	void *parent, int (*acceptable)(void *context, struct dentry *de),
 	void *context);
 
-extern int exportfs_encode_fh(struct dentry *dentry, __u32 *fh, int *max_len,
-	int connectable);
-extern struct dentry *exportfs_decode_fh(struct vfsmount *mnt, __u32 *fh,
+extern int exportfs_encode_fh(struct dentry *dentry, struct fid *fid,
+	int *max_len, int connectable);
+extern struct dentry *exportfs_decode_fh(struct vfsmount *mnt, struct fid *fid,
 	int fh_len, int fileid_type, int (*acceptable)(void *, struct dentry *),
 	void *context);
 
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
git-unionfs.patch
git-xfs.patch
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
unprivileged-mounts-propagation-inherit-owner-from-parent.patch
unprivileged-mounts-add-no-submounts-flag.patch
r-o-bind-mounts-stub-functions.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes-touch-command-causes-oops.patch
r-o-bind-mounts-track-number-of-mount-writers.patch
r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch
revoke-special-mmap-handling.patch
revoke-core-code.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
dont-touch-fs_struct-in-drivers.patch
dont-touch-fs_struct-in-usermodehelper.patch
remove-path_release_on_umount.patch
move-struct-path-into-its-own-header.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
introduce-path_put.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
introduce-path_get.patch
use-struct-path-in-fs_struct.patch
make-set_fs_rootpwd-take-a-struct-path.patch
make-__d_path-to-take-a-struct-path-argument.patch
use-struct-path-argument-in-proc_get_link.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-unionfs.patch
introduce-path_put-unionfs.patch
introduce-path_get-unionfs.patch
