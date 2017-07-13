From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] ext4: clean up ext4_remove_blocks() return
Date: Thu, 13 Jul 2017 11:17:03 -0400
Message-ID: <20170713151703.GA6383@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:35374 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752082AbdGMPNq (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Jul 2017 11:13:46 -0400
Received: by mail-qk0-f195.google.com with SMTP id 16so8455471qkg.2
        for <linux-ext4@vger.kernel.org>; Thu, 13 Jul 2017 08:13:45 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_remove_blocks() never returns anything other than 0, signifying
success.  Convert the function to void type to make this immediately
obvious at the call site.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 fs/ext4/extents.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index e0a8425..27da180 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2496,10 +2496,10 @@ static inline int get_default_free_blocks_flags(struct inode *inode)
 	return 0;
 }
 
-static int ext4_remove_blocks(handle_t *handle, struct inode *inode,
-			      struct ext4_extent *ex,
-			      long long *partial_cluster,
-			      ext4_lblk_t from, ext4_lblk_t to)
+static void ext4_remove_blocks(handle_t *handle, struct inode *inode,
+			       struct ext4_extent *ex,
+			       long long *partial_cluster,
+			       ext4_lblk_t from, ext4_lblk_t to)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	unsigned short ee_len = ext4_ext_get_actual_len(ex);
@@ -2592,7 +2592,6 @@ static int ext4_remove_blocks(handle_t *handle, struct inode *inode,
 		ext4_error(sbi->s_sb, "strange request: removal(2) "
 			   "%u-%u from %u:%u",
 			   from, to, le32_to_cpu(ex->ee_block), ee_len);
-	return 0;
 }
 
 
@@ -2720,10 +2719,7 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
 		if (err)
 			goto out;
 
-		err = ext4_remove_blocks(handle, inode, ex, partial_cluster,
-					 a, b);
-		if (err)
-			goto out;
+		ext4_remove_blocks(handle, inode, ex, partial_cluster, a, b);
 
 		if (num == 0)
 			/* this extent is removed; mark slot entirely unused */
-- 
2.1.4
