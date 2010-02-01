From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 02/23] vfs: Check for create permission during rename
Date: Mon,  1 Feb 2010 11:04:44 +0530
Message-ID: <1265002505-8387-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1265002505-8387-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: aneesh.kumar@linux.vnet.ibm.com, linux-fsdevel@vger.kernel.org,
	nfsv4@linux-nfs.org, linux-ext4@vger.kernel.org
To: sfrench@us.ibm.com, ffilz@us.ibm.com, agruen@suse.de,
	adilger@sun.com, sandeen@redhat.com, tytso@mit.edu,
	staubach@redhat.com, bfields@citi.umich.edu, jlayton@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:56038 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab0BAFfW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Feb 2010 00:35:22 -0500
In-Reply-To: <1265002505-8387-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the new dentry is already present we were just checking
for the delete permission. We also need to check after
deletion whether we are allowed to create new name. This
is needed in case of a acl model that differentiate between
delete and create permission like NFSv4acl

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/namei.c |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 3e842ac..2a1a1d6 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1380,12 +1380,11 @@ static int may_delete(struct inode *dir,struct dentry *victim,int isdir)
  *  3. We should have write and exec permissions on dir
  *  4. We can't do it if dir is immutable (done in permission())
  */
-static inline int may_create(struct inode *dir, struct dentry *child, int isdir)
+static inline int _do_may_create(struct inode *dir,
+				struct dentry *child, int isdir)
 {
 	int error;
 
-	if (child->d_inode)
-		return -EEXIST;
 	if (IS_DEADDIR(dir))
 		return -ENOENT;
 	if (dir->i_op->may_create) {
@@ -1403,6 +1402,13 @@ static inline int may_create(struct inode *dir, struct dentry *child, int isdir)
 	return error;
 }
 
+static inline int may_create(struct inode *dir, struct dentry *child, int isdir)
+{
+	if (child->d_inode)
+		return -EEXIST;
+	return _do_may_create(dir, child, isdir);
+}
+
 /* 
  * O_DIRECTORY translates into forcing a directory lookup.
  */
@@ -2673,8 +2679,12 @@ int vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 
 	if (!new_dentry->d_inode)
 		error = may_create(new_dir, new_dentry, is_dir);
-	else
+	else {
 		error = may_delete(new_dir, new_dentry, is_dir);
+		if (error)
+			return error;
+		error = _do_may_create(new_dir, new_dentry, is_dir);
+	}
 	if (error)
 		return error;
 
-- 
1.7.0.rc0.48.gdace5

