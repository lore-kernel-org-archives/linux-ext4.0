From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Set directory link count to zero if we fail to create the directory.
Date: Tue, 12 Feb 2008 22:15:08 +0530
Message-ID: <1202834708-961-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: tytso@mit.edu, cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:48052 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764245AbYBLQpJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Feb 2008 11:45:09 -0500
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp04.in.ibm.com (8.13.1/8.13.1) with ESMTP id m1CGj7aF019561
	for <linux-ext4@vger.kernel.org>; Tue, 12 Feb 2008 22:15:07 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1CGj7mA913440
	for <linux-ext4@vger.kernel.org>; Tue, 12 Feb 2008 22:15:07 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id m1CGjBhH022397
	for <linux-ext4@vger.kernel.org>; Tue, 12 Feb 2008 16:45:11 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

With ext4 we fail directory creation if we fail to allocate initial
block for the directory. With EXT4_FEATURE_RO_COMPAT_DIR_NLINK,
if we fail to create the directory, the inode link count was wrongly
set to 1.  This cause e2fsck throws the below warning

Inode 1015 is a zero-length directory.  Clear? yes
Inode 1120 is a zero-length directory.  Clear? yes
Inode 1121 is a zero-length directory.  Clear? yes

Fix the same by dropping the inode link count using drop_nlink

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/namei.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index a9347fb..fd3b031 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1805,7 +1805,7 @@ retry:
 	inode->i_size = EXT4_I(inode)->i_disksize = inode->i_sb->s_blocksize;
 	dir_block = ext4_bread (handle, inode, 0, 1, &err);
 	if (!dir_block) {
-		ext4_dec_count(handle, inode); /* is this nlink == 0? */
+		drop_nlink(inode);
 		ext4_mark_inode_dirty(handle, inode);
 		iput (inode);
 		goto out_stop;
-- 
1.5.4.1.97.g40aab-dirty
