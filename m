From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: set EXT4_EXTENTS_FL only for directory and regular files
Date: Wed, 20 Feb 2008 01:19:05 +0530
Message-ID: <1203450545-9938-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: sandeen@redhat.com, tytso@mit.edu, cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:60562 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752394AbYBSTtJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Feb 2008 14:49:09 -0500
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp02.in.ibm.com (8.13.1/8.13.1) with ESMTP id m1JJn6rQ014818
	for <linux-ext4@vger.kernel.org>; Wed, 20 Feb 2008 01:19:06 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1JJn6Fu262256
	for <linux-ext4@vger.kernel.org>; Wed, 20 Feb 2008 01:19:06 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id m1JJn6Vm028517
	for <linux-ext4@vger.kernel.org>; Tue, 19 Feb 2008 19:49:06 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Also don't inherit EXT4_EXTENTS_FL from parent directory.
If we have a directory with extent flag set and later mount the file
system with -o noextents, the files created in that directory will also
have extent flag set but we would not have called ext4_ext_tree_init for
them. This will cause error later when we are verifying the extent header

Also we don't want to set extent flag for symlinks, char, block, fifo
or socket

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/ialloc.c |   22 +++++++++++++++-------
 fs/ext4/namei.c  |    1 -
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 028e601..78d1094 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -794,7 +794,12 @@ got:
 	ei->i_dir_start_lookup = 0;
 	ei->i_disksize = 0;
 
-	ei->i_flags = EXT4_I(dir)->i_flags & ~EXT4_INDEX_FL;
+	/*
+	 * Don't inherit extent flag from directory. We set extent flag on
+	 * newly created directory and file only if -o extent mount option is
+	 * specified
+	 */
+	ei->i_flags = EXT4_I(dir)->i_flags & ~(EXT4_INDEX_FL|EXT4_EXTENTS_FL);
 	if (S_ISLNK(mode))
 		ei->i_flags &= ~(EXT4_IMMUTABLE_FL|EXT4_APPEND_FL);
 	/* dirsync only applies to directories */
@@ -837,12 +842,15 @@ got:
 		goto fail_free_drop;
 	}
 	if (test_opt(sb, EXTENTS)) {
-		EXT4_I(inode)->i_flags |= EXT4_EXTENTS_FL;
-		ext4_ext_tree_init(handle, inode);
-		err = ext4_update_incompat_feature(handle, sb,
-						EXT4_FEATURE_INCOMPAT_EXTENTS);
-		if (err)
-			goto fail;
+		/* set extent flag only for diretory and file */
+		if (S_ISDIR(mode) || S_ISREG(mode)) {
+			EXT4_I(inode)->i_flags |= EXT4_EXTENTS_FL;
+			ext4_ext_tree_init(handle, inode);
+			err = ext4_update_incompat_feature(handle, sb,
+					EXT4_FEATURE_INCOMPAT_EXTENTS);
+			if (err)
+				goto fail;
+		}
 	}
 
 	ext4_debug("allocating inode %lu\n", inode->i_ino);
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 39d4af4..da942bc 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2225,7 +2225,6 @@ retry:
 		inode->i_op = &ext4_fast_symlink_inode_operations;
 		memcpy((char*)&EXT4_I(inode)->i_data,symname,l);
 		inode->i_size = l-1;
-		EXT4_I(inode)->i_flags &= ~EXT4_EXTENTS_FL;
 	}
 	EXT4_I(inode)->i_disksize = inode->i_size;
 	err = ext4_add_nondir(handle, dentry, inode);
-- 
1.5.4.1.97.g40aab-dirty
