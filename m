From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC][PATCH] ext4: Enable extent format for symlink.
Date: Thu, 28 Feb 2008 23:35:11 +0530
Message-ID: <1204221911-9753-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1204221911-9753-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1204221911-9753-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1204221911-9753-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:52790 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755737AbYB1SF0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Feb 2008 13:05:26 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id m1SI588G018708
	for <linux-ext4@vger.kernel.org>; Fri, 29 Feb 2008 05:05:08 +1100
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1SI91kJ276898
	for <linux-ext4@vger.kernel.org>; Fri, 29 Feb 2008 05:09:02 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1SI5NJA012621
	for <linux-ext4@vger.kernel.org>; Fri, 29 Feb 2008 05:05:24 +1100
In-Reply-To: <1204221911-9753-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
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
index 78d1094..1462189 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -842,8 +842,8 @@ got:
 		goto fail_free_drop;
 	}
 	if (test_opt(sb, EXTENTS)) {
-		/* set extent flag only for diretory and file */
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
1.5.4.3.325.g6d216.dirty

