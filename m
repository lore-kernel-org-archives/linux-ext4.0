From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH] ext[234]: cleanup ext[234]_bg_num_gdb()
Date: Sun, 9 Dec 2007 00:31:56 +0900
Message-ID: <20071208153156.GA4878@APFDCB5C>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephen Tweedie <sct@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	adilger@clusterfs.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:11206 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbXLHPct (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Dec 2007 10:32:49 -0500
Received: by wa-out-1112.google.com with SMTP id v27so2154929wah
        for <linux-ext4@vger.kernel.org>; Sat, 08 Dec 2007 07:32:49 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use ext[234]_bg_has_super() to remove duplicate code.

Cc: Stephen Tweedie <sct@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: adilger@clusterfs.com
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 fs/ext2/balloc.c |    5 +----
 fs/ext3/balloc.c |    6 +-----
 fs/ext4/balloc.c |    6 +-----
 3 files changed, 3 insertions(+), 14 deletions(-)

Index: 2.6-git/fs/ext2/balloc.c
===================================================================
--- 2.6-git.orig/fs/ext2/balloc.c
+++ 2.6-git/fs/ext2/balloc.c
@@ -1466,9 +1466,6 @@ int ext2_bg_has_super(struct super_block
  */
 unsigned long ext2_bg_num_gdb(struct super_block *sb, int group)
 {
-	if (EXT2_HAS_RO_COMPAT_FEATURE(sb,EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER)&&
-	    !ext2_group_sparse(group))
-		return 0;
-	return EXT2_SB(sb)->s_gdb_count;
+	return ext2_bg_has_super(sb, group) ? EXT2_SB(sb)->s_gdb_count : 0;
 }
 
Index: 2.6-git/fs/ext3/balloc.c
===================================================================
--- 2.6-git.orig/fs/ext3/balloc.c
+++ 2.6-git/fs/ext3/balloc.c
@@ -1782,11 +1782,7 @@ static unsigned long ext3_bg_num_gdb_met
 
 static unsigned long ext3_bg_num_gdb_nometa(struct super_block *sb, int group)
 {
-	if (EXT3_HAS_RO_COMPAT_FEATURE(sb,
-				EXT3_FEATURE_RO_COMPAT_SPARSE_SUPER) &&
-			!ext3_group_sparse(group))
-		return 0;
-	return EXT3_SB(sb)->s_gdb_count;
+	return ext3_bg_has_super(sb, group) ? EXT3_SB(sb)->s_gdb_count : 0;
 }
 
 /**
Index: 2.6-git/fs/ext4/balloc.c
===================================================================
--- 2.6-git.orig/fs/ext4/balloc.c
+++ 2.6-git/fs/ext4/balloc.c
@@ -1902,11 +1902,7 @@ static unsigned long ext4_bg_num_gdb_met
 
 static unsigned long ext4_bg_num_gdb_nometa(struct super_block *sb, int group)
 {
-	if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
-				EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER) &&
-			!ext4_group_sparse(group))
-		return 0;
-	return EXT4_SB(sb)->s_gdb_count;
+	return ext4_bg_has_super(sb, group) ? EXT4_SB(sb)->s_gdb_count : 0;
 }
 
 /**
