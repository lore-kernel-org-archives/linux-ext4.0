From: Li Haifeng <omycle@gmail.com>
Subject: [PATCH] fix the outdated comment in ext2_nfs_get_inode()
Date: Tue, 30 Aug 2011 20:11:28 +0800
Message-ID: <CAFNq8R7dt03bXJUe4gVcZOGRSqJ7uPJHTFeXoaGTu2pKuNBCfw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:44098 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab1H3ML2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Aug 2011 08:11:28 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I am sorry, the last patch "fix the outdated comment in
ext2_nfs_get_inode()" has some " whitespace errors detected". So
correct it and remake it.

I will be more careful later.

Signed-off-by: Li Haifeng <omycle@gmail.com>
---
 fs/ext2/super.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 1dd62ed..bda10cf 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -327,10 +327,9 @@ static struct inode *ext2_nfs_get_inode(struct
super_block *sb,
    if (ino > le32_to_cpu(EXT2_SB(sb)->s_es->s_inodes_count))
        return ERR_PTR(-ESTALE);

-   /* iget isn't really right if the inode is currently unallocated!!
-    * ext2_read_inode currently does appropriate checks, but
-    * it might be "neater" to call ext2_get_inode first and check
-    * if the inode is valid.....
+   /*
+    * ext2_iget isn't really right if the inode is currently unallocated!!
+    * And it also does appropriate checks to handle the stale inode.
     */
    inode = ext2_iget(sb, ino);
    if (IS_ERR(inode))
-- 
1.7.4.1
