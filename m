From: akpm@linux-foundation.org
Subject: [patch 3/8] 64-bit i_version: afs fixes
Date: Thu, 29 Nov 2007 12:52:49 -0800
Message-ID: <200711292052.lATKqnvt006831@imap1.linux-foundation.org>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org,
	akpm@linux-foundation.org, dhowells@redhat.com,
	jean-noel.cordenner@bull.net
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35452 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759521AbXK2Uyd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 Nov 2007 15:54:33 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>

Please grep the whole tree and look for any similar bugs which this patch
introduces.

Cc: Jean Noel Cordenner <jean-noel.cordenner@bull.net>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/dir.c   |    9 +++++----
 fs/afs/inode.c |    3 ++-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff -puN fs/afs/dir.c~64-bit-i_version-afs-fixes fs/afs/dir.c
--- a/fs/afs/dir.c~64-bit-i_version-afs-fixes
+++ a/fs/afs/dir.c
@@ -546,11 +546,11 @@ static struct dentry *afs_lookup(struct 
 	dentry->d_op = &afs_fs_dentry_operations;
 
 	d_add(dentry, inode);
-	_leave(" = 0 { vn=%u u=%u } -> { ino=%lu v=%lu }",
+	_leave(" = 0 { vn=%u u=%u } -> { ino=%lu v=%llu }",
 	       fid.vnode,
 	       fid.unique,
 	       dentry->d_inode->i_ino,
-	       dentry->d_inode->i_version);
+	       (unsigned long long)dentry->d_inode->i_version);
 
 	return NULL;
 }
@@ -630,9 +630,10 @@ static int afs_d_revalidate(struct dentr
 		 * been deleted and replaced, and the original vnode ID has
 		 * been reused */
 		if (fid.unique != vnode->fid.unique) {
-			_debug("%s: file deleted (uq %u -> %u I:%lu)",
+			_debug("%s: file deleted (uq %u -> %u I:%llu)",
 			       dentry->d_name.name, fid.unique,
-			       vnode->fid.unique, dentry->d_inode->i_version);
+			       vnode->fid.unique,
+			       (unsigned long long)dentry->d_inode->i_version);
 			spin_lock(&vnode->lock);
 			set_bit(AFS_VNODE_DELETED, &vnode->flags);
 			spin_unlock(&vnode->lock);
diff -puN fs/afs/inode.c~64-bit-i_version-afs-fixes fs/afs/inode.c
--- a/fs/afs/inode.c~64-bit-i_version-afs-fixes
+++ a/fs/afs/inode.c
@@ -301,7 +301,8 @@ int afs_getattr(struct vfsmount *mnt, st
 
 	inode = dentry->d_inode;
 
-	_enter("{ ino=%lu v=%lu }", inode->i_ino, inode->i_version);
+	_enter("{ ino=%lu v=%llu }", inode->i_ino,
+		(unsigned long long)inode->i_version);
 
 	generic_fillattr(inode, stat);
 	return 0;
_
