From: Jean noel Cordenner <jean-noel.cordenner@bull.net>
Subject: [patch 1/2] i_version update - vfs part
Date: Fri, 25 May 2007 18:25:53 +0200
Message-ID: <46570E11.80304@bull.net>
Reply-To: jean-noel.cordenner@bull.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060308060104020702080307"
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	nfsv4@linux-nfs.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a multi-part message in MIME format.
--------------060308060104020702080307
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed

Concerning the first part of the set, the i_version field of the inode
structure has been reused. The field has been redefined as the counter 
has to be 64-bits.


--------------060308060104020702080307
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
 name="i_version_update_vfs"
Content-Disposition: inline;
 filename="i_version_update_vfs"

The patch modifies the i_version field of the inode on the VFS layer.
The i_version field become a 64bit counter that is set on inode creation and
that is incremented every time the inode data is modified (similarly to the
"ctime" time-stamp).
The aim is to fulfill a NFSv4 requirement for rfc3530:
"5.5.  Mandatory Attributes - Definitions
Name		#	DataType   Access   Description
___________________________________________________________________
change		3	uint64       READ     A value created by the
		server that the client can use to determine if file
		data, directory contents or attributes of the object
		have been modified.  The servermay return the object's
		time_metadata attribute for this attribute's value but
		only if the filesystem object can not be updated more
		frequently than the resolution of time_metadata."

Signed-off-by: Jean Noel Cordenner <jean-noel.cordenner@bull.net>

Index: linux-2.6.22-rc2-ext4-1/fs/binfmt_misc.c
===================================================================
--- linux-2.6.22-rc2-ext4-1.orig/fs/binfmt_misc.c	2007-05-25 18:01:51.000000000 +0200
+++ linux-2.6.22-rc2-ext4-1/fs/binfmt_misc.c	2007-05-25 18:01:56.000000000 +0200
@@ -508,6 +508,7 @@
 		inode->i_blocks = 0;
 		inode->i_atime = inode->i_mtime = inode->i_ctime =
 			current_fs_time(inode->i_sb);
+		inode->i_version = 1;
 	}
 	return inode;
 }
Index: linux-2.6.22-rc2-ext4-1/fs/libfs.c
===================================================================
--- linux-2.6.22-rc2-ext4-1.orig/fs/libfs.c	2007-05-25 18:01:51.000000000 +0200
+++ linux-2.6.22-rc2-ext4-1/fs/libfs.c	2007-05-25 18:01:56.000000000 +0200
@@ -232,6 +232,7 @@
 	root->i_mode = S_IFDIR | S_IRUSR | S_IWUSR;
 	root->i_uid = root->i_gid = 0;
 	root->i_atime = root->i_mtime = root->i_ctime = CURRENT_TIME;
+	root->i_version = 1;
 	dentry = d_alloc(NULL, &d_name);
 	if (!dentry) {
 		iput(root);
@@ -255,6 +256,8 @@
 	struct inode *inode = old_dentry->d_inode;
 
 	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
+	inode->i_version++;
+	dir->i_version++;
 	inc_nlink(inode);
 	atomic_inc(&inode->i_count);
 	dget(dentry);
@@ -287,6 +290,8 @@
 	struct inode *inode = dentry->d_inode;
 
 	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
+	inode->i_version++;
+	dir->i_version++;
 	drop_nlink(inode);
 	dput(dentry);
 	return 0;
@@ -323,6 +328,8 @@
 
 	old_dir->i_ctime = old_dir->i_mtime = new_dir->i_ctime =
 		new_dir->i_mtime = inode->i_ctime = CURRENT_TIME;
+	old_dir->i_version++;
+	new_dir->i_version++;
 
 	return 0;
 }
@@ -399,6 +406,7 @@
 	inode->i_uid = inode->i_gid = 0;
 	inode->i_blocks = 0;
 	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+	inode->i_version = 1;
 	inode->i_op = &simple_dir_inode_operations;
 	inode->i_fop = &simple_dir_operations;
 	inode->i_nlink = 2;
@@ -427,6 +435,7 @@
 		inode->i_uid = inode->i_gid = 0;
 		inode->i_blocks = 0;
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+		inode->i_version = 1;
 		inode->i_fop = files->ops;
 		inode->i_ino = i;
 		d_add(dentry, inode);
Index: linux-2.6.22-rc2-ext4-1/fs/pipe.c
===================================================================
--- linux-2.6.22-rc2-ext4-1.orig/fs/pipe.c	2007-05-25 18:01:51.000000000 +0200
+++ linux-2.6.22-rc2-ext4-1/fs/pipe.c	2007-05-25 18:01:56.000000000 +0200
@@ -882,6 +882,7 @@
 	inode->i_uid = current->fsuid;
 	inode->i_gid = current->fsgid;
 	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+	inode->i_version = 1;
 
 	return inode;
 
Index: linux-2.6.22-rc2-ext4-1/include/linux/fs.h
===================================================================
--- linux-2.6.22-rc2-ext4-1.orig/include/linux/fs.h	2007-05-25 18:01:51.000000000 +0200
+++ linux-2.6.22-rc2-ext4-1/include/linux/fs.h	2007-05-25 18:01:56.000000000 +0200
@@ -549,7 +549,7 @@
 	uid_t			i_uid;
 	gid_t			i_gid;
 	dev_t			i_rdev;
-	unsigned long		i_version;
+	uint64_t		i_version;
 	loff_t			i_size;
 #ifdef __NEED_I_SIZE_ORDERED
 	seqcount_t		i_size_seqcount;

--------------060308060104020702080307--
