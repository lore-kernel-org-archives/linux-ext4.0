From: Aditya Kali <adityakali@google.com>
Subject: [PATCH 4/4] tune2fs: fix quota feature removal
Date: Fri, 13 Jul 2012 15:25:09 -0700
Message-ID: <1342218309-25983-4-git-send-email-adityakali@google.com>
References: <1342218309-25983-1-git-send-email-adityakali@google.com>
Cc: Aditya Kali <adityakali@google.com>
To: tytso@mit.edu, johann@whamcloud.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:61123 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab2GMWZO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Jul 2012 18:25:14 -0400
Received: by fat25 with SMTP id 25so205213fat.1
        for <linux-ext4@vger.kernel.org>; Fri, 13 Jul 2012 15:25:13 -0700 (PDT)
In-Reply-To: <1342218309-25983-1-git-send-email-adityakali@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When the last quota inode is removed, the 'quota' feature
flag was not removed from superblock in some cases.
Ex:
 $ mke2fs -t ext4 -O quota <dev>  # creates both usr & grp
                                  # quota inodes
 $ tune2fs -Q ^usrquota <dev>  # removes usr quota inode
 $ tune2fs -Q ^grpquota <dev>  # removes grp quota inode,
                               # but the 'quota' feature flag
                               # was not removed from superblock
This patch removes the 'quota' feature flag from superblock
if none of the quota inodes are set.

Signed-off-by: Aditya Kali <adityakali@google.com>
---
 misc/tune2fs.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 73bc10c..fb46fb6 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -734,7 +734,8 @@ void handle_quota_options(ext2_filsys fs)
 	if ((usrquota == QOPT_ENABLE) || (grpquota == QOPT_ENABLE)) {
 		fs->super->s_feature_ro_compat |= EXT4_FEATURE_RO_COMPAT_QUOTA;
 		ext2fs_mark_super_dirty(fs);
-	} else if ((usrquota == QOPT_DISABLE) && (grpquota == QOPT_DISABLE)) {
+	} else if (!fs->super->s_usr_quota_inum &&
+		   !fs->super->s_grp_quota_inum) {
 		fs->super->s_feature_ro_compat &= ~EXT4_FEATURE_RO_COMPAT_QUOTA;
 		ext2fs_mark_super_dirty(fs);
 	}
-- 
1.7.7.3

