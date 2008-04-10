From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: mark inode dirty after initializing the extent tree
Date: Thu, 10 Apr 2008 19:36:34 +0530
Message-ID: <1207836394-9027-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:44176 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755149AbYDJOGm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Apr 2008 10:06:42 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id m3AE5uxZ015783
	for <linux-ext4@vger.kernel.org>; Fri, 11 Apr 2008 00:05:56 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m3AE6csD4337806
	for <linux-ext4@vger.kernel.org>; Fri, 11 Apr 2008 00:06:38 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m3AE6mfJ025549
	for <linux-ext4@vger.kernel.org>; Fri, 11 Apr 2008 00:06:48 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We should mark inode dirty only after initializing the extent
tree. Also if we fail during extent initialization we need
to call DQUOT_FREE_INODE.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/ialloc.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 4ee44fa..4fc0db5 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -835,11 +835,6 @@ got:
 	if (err)
 		goto fail_free_drop;
 
-	err = ext4_mark_inode_dirty(handle, inode);
-	if (err) {
-		ext4_std_error(sb, err);
-		goto fail_free_drop;
-	}
 	if (test_opt(sb, EXTENTS)) {
 		/* set extent flag only for diretory, file and normal symlink*/
 		if (S_ISDIR(mode) || S_ISREG(mode) || S_ISLNK(mode)) {
@@ -848,10 +843,16 @@ got:
 			err = ext4_update_incompat_feature(handle, sb,
 					EXT4_FEATURE_INCOMPAT_EXTENTS);
 			if (err)
-				goto fail;
+				goto fail_free_drop;
 		}
 	}
 
+	err = ext4_mark_inode_dirty(handle, inode);
+	if (err) {
+		ext4_std_error(sb, err);
+		goto fail_free_drop;
+	}
+
 	ext4_debug("allocating inode %lu\n", inode->i_ino);
 	goto really_out;
 fail:
-- 
1.5.5.23.g2a5fe.dirty

