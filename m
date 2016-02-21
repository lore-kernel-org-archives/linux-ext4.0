From: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH] ext4: iterate over buffer heads correctly in move_extent_per_page()
Date: Sun, 21 Feb 2016 23:57:29 +0800
Message-ID: <1456070249-29945-1-git-send-email-guaneryu@gmail.com>
Cc: tytso@mit.edu, Eryu Guan <guaneryu@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:35533 "EHLO
	mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbcBURhq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 21 Feb 2016 12:37:46 -0500
Received: by mail-pf0-f178.google.com with SMTP id c10so81935261pfc.2
        for <linux-ext4@vger.kernel.org>; Sun, 21 Feb 2016 09:37:46 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In commit bcff24887d00 ("ext4: don't read blocks from disk after extents
being swapped") bh is not updated correctly in the for loop and wrong
data has been written to disk. generic/324 catches this on sub-page
block size ext4.

Fixes: bcff24887d00 ("ext4: don't read blocks from disk after extentsbeing swapped")
Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---

Not sure why I didn't notice generic/324 failure in the first place, it fails
every time for me with 4.5-rc5 kernel. Sorry about that!

I tested this patch with 1k/2k/4k block size ext4 with all defrag related tests
in xfstests (ext4/301 ext4/302 ext4/303 ext4/304 ext4/307 ext4/308 generic/324)
and results showed no regression. Test with the reproducer in commit
bcff24887d00 also passed.

 fs/ext4/move_extent.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index e032a04..4098acc 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -390,6 +390,7 @@ data_copy:
 		*err = ext4_get_block(orig_inode, orig_blk_offset + i, bh, 0);
 		if (*err < 0)
 			break;
+		bh = bh->b_this_page;
 	}
 	if (!*err)
 		*err = block_commit_write(pagep[0], from, from + replaced_size);
-- 
2.5.0

