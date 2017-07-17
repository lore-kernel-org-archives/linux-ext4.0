From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH] e2fsck: eliminate bad update link count attempt
Date: Mon, 17 Jul 2017 05:50:35 -0700
Message-ID: <20170717125035.12852-1-tahsin@google.com>
Cc: Tahsin Erdogan <tahsin@google.com>
To: Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>,
        linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:33709 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751290AbdGQMuj (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Jul 2017 08:50:39 -0400
Received: by mail-pf0-f175.google.com with SMTP id e26so8205513pfd.0
        for <linux-ext4@vger.kernel.org>; Mon, 17 Jul 2017 05:50:39 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Extended attribute inodes have a link count of 1 but they are not
attached to any directories. When an xattr inode with zero ea
references is found, the remedy is to reconnect it to lost+found dir.
Since reconnect operation increments the link count, it would normally
become 2 but to avoid that, check_ea_inode() sets the link count to
zero in anticipation of reconnect operation. And it does it even when
e2fsck is invoked with -n option which causes a fatal e2fsck failure
as can be demonstrated with the following test script:

  mke2fs -b 4096 -I 256 -F -O extent,ea_inode /dev/sdb 1G
  mount /dev/sdb /mnt/sdb
  touch /mnt/sdb/x
  setfattr -n user.ie1 -v $(python -c "print 'v'*5000") /mnt/sdb/x
  umount /dev/sdb
  debugfs -w -R 'rm x' /dev/sdb
  e2fsck -f -n /dev/sdb

In this case, e2fsck fails with the following error:

  e2fsck 1.43.5-WIP (17-Feb-2017)
  Pass 1: Checking inodes, blocks, and sizes
  Pass 2: Checking directory structure
  Pass 3: Checking directory connectivity
  Pass 4: Checking reference counts
  ext2fs_write_inode: Attempt to write to filesystem opened read-only
  while writing inode 13 in check_ea_inode
  e2fsck: aborted

Setting link count to zero is not really required because e2fsck will
detect the discrepancy in link count and offer to fix it.

Signed-off-by: Tahsin Erdogan <tahsin@google.com>
---
 e2fsck/pass4.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/e2fsck/pass4.c b/e2fsck/pass4.c
index 663f87ab59c0..b23347cdb6b0 100644
--- a/e2fsck/pass4.c
+++ b/e2fsck/pass4.c
@@ -122,17 +122,8 @@ static void check_ea_inode(e2fsck_t ctx, ext2_ino_t i,
 
 	if (ctx->ea_inode_refs)
 		ea_refcount_fetch(ctx->ea_inode_refs, i, &actual_refs);
-	if (!actual_refs) {
-		/*
-		 * There are no attribute references to the ea_inode.
-		 * Zero the link count so that when  inode is linked to
-		 * lost+found it has correct link count.
-		 */
-		inode->i_links_count = 0;
-		e2fsck_write_inode(ctx, i, EXT2_INODE(inode), "check_ea_inode");
-		ext2fs_icount_store(ctx->inode_link_info, i, 0);
+	if (!actual_refs)
 		return;
-	}
 
 	/*
 	 * There are some attribute references, link_counted is now considered
-- 
2.13.2.932.g7449e964c-goog
