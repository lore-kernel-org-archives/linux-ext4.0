From: Aditya Kali <adityakali@google.com>
Subject: [PATCH 2/4] libquota: fix quota_inode_truncate()
Date: Fri, 13 Jul 2012 15:25:07 -0700
Message-ID: <1342218309-25983-2-git-send-email-adityakali@google.com>
References: <1342218309-25983-1-git-send-email-adityakali@google.com>
Cc: Aditya Kali <adityakali@google.com>
To: tytso@mit.edu, johann@whamcloud.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:55729 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434Ab2GMWZP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Jul 2012 18:25:15 -0400
Received: by yenl3 with SMTP id l3so390733yen.1
        for <linux-ext4@vger.kernel.org>; Fri, 13 Jul 2012 15:25:15 -0700 (PDT)
In-Reply-To: <1342218309-25983-1-git-send-email-adityakali@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We failed to clear EXT2_FLAG_SUPER_ONLY after deleting the
quota inode and so, the updated block bitmap was not written
back. This caused fsck to complain after running
'tune2fs -O ^quota <dev>'. Clear this flag so that updated
block bitmap gets written. Also, avoid truncating the quota
inode if it is not hidden.

Signed-off-by: Aditya Kali <adityakali@google.com>
---
 lib/quota/quotaio.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/lib/quota/quotaio.c b/lib/quota/quotaio.c
index c0ebaa1..7cdd653 100644
--- a/lib/quota/quotaio.c
+++ b/lib/quota/quotaio.c
@@ -133,14 +133,18 @@ errcode_t quota_inode_truncate(ext2_filsys fs, ext2_ino_t ino)
 	if ((err = ext2fs_read_inode(fs, ino, &inode)))
 		return err;
 
-	inode.i_dtime = fs->now ? fs->now : time(0);
-	if (!ext2fs_inode_has_valid_blocks2(fs, &inode))
-		return 0;
-
-	ext2fs_block_iterate3(fs, ino, BLOCK_FLAG_READ_ONLY, NULL,
-			      release_blocks_proc, NULL);
