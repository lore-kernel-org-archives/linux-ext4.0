From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Enable extent format for symlink.
Date: Tue,  4 Mar 2008 18:11:23 +0530
Message-ID: <1204634483-16527-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:45093 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764242AbYCDMl1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Mar 2008 07:41:27 -0500
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp01.in.ibm.com (8.13.1/8.13.1) with ESMTP id m24CfPOr023689
	for <linux-ext4@vger.kernel.org>; Tue, 4 Mar 2008 18:11:25 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m24CfOFF803006
	for <linux-ext4@vger.kernel.org>; Tue, 4 Mar 2008 18:11:24 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.13.1/8.13.3) with ESMTP id m24CfNxl027002
	for <linux-ext4@vger.kernel.org>; Tue, 4 Mar 2008 12:41:24 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch enable extent format for normal symlink. Extent format enables
to refere file system blocks > 32 bits. Enabling extent format for symlink
enables to have symlink block beyond 2**32 blocks. We still don't enable
extent format for fast symlink.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/ialloc.c |    4 ++--
 fs/ext4/namei.c  |    2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 5027af5..1462189 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -842,8 +842,8 @@ got:
 		goto fail_free_drop;
 	}
 	if (test_opt(sb, EXTENTS)) {
-		/* set extent flag only for directory and file */
-		if (S_ISDIR(mode) || S_ISREG(mode)) {
+		/* set extent flag only for diretory, file and normal symlink*/
+		if (S_ISDIR(mode) || S_ISREG(mode) || S_ISLNK(mode)) {
 			EXT4_I(inode)->i_flags |= EXT4_EXTENTS_FL;
 			ext4_ext_tree_init(handle, inode);
 			err = ext4_update_incompat_feature(handle, sb,
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index da942bc..63c33e0 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2222,6 +2222,8 @@ retry:
 			goto out_stop;
 		}
 	} else {
+		/* clear the extent format for fast symlink */
+		EXT4_I(inode)->i_flags &= ~EXT4_EXTENTS_FL;
 		inode->i_op = &ext4_fast_symlink_inode_operations;
 		memcpy((char*)&EXT4_I(inode)->i_data,symname,l);
 		inode->i_size = l-1;
-- 
1.5.4.3.422.g34cd6.dirty

