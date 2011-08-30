From: Li Haifeng <omycle@gmail.com>
Subject: [PATCH] fix the outdated comment in ext2_nfs_get_inode()
Date: Tue, 30 Aug 2011 17:53:58 +0800
Message-ID: <CAFNq8R62+5dLbDV3b_rtFgMwTZ2abW+h+tg013L=pij60tTRdw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35534 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab1H3Jx7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Aug 2011 05:53:59 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The function iget  referred by the comment is replaced by ext2_iget .
And the ext2_read_inode() is not exist, the ext2_iget is "neater". So
the comment is fixed here.

Signed-off-by: Li Haifeng <omycle@gmail.com>
---
 fs/ext2/super.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 1dd62ed..994ced3 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -327,10 +327,8 @@ static struct inode *ext2_nfs_get_inode(struct
super_block *sb,
    if (ino > le32_to_cpu(EXT2_SB(sb)->s_es->s_inodes_count))
        return ERR_PTR(-ESTALE);

-   /* iget isn't really right if the inode is currently unallocated!!
-    * ext2_read_inode currently does appropriate checks, but
-    * it might be "neater" to call ext2_get_inode first and check
-    * if the inode is valid.....
+   /*
+    * ext2_iget isn't really right if the inode is currently unallocated!!
     */
    inode = ext2_iget(sb, ino);
    if (IS_ERR(inode))
-- 
1.7.4.1
