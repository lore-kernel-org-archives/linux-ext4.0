From: Curt Wohlgemuth <curtw@google.com>
Subject: [PATCH 1/2] ext4: mark multi-page IO complete on mapping failure
Date: Fri, 18 Feb 2011 13:31:38 -0800
Message-ID: <1298064699-17987-1-git-send-email-curtw@google.com>
Cc: Curt Wohlgemuth <curtw@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:35951 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756755Ab1BRVbx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Feb 2011 16:31:53 -0500
Received: from kpbe16.cbf.corp.google.com (kpbe16.cbf.corp.google.com [172.25.105.80])
	by smtp-out.google.com with ESMTP id p1ILVpmZ005427
	for <linux-ext4@vger.kernel.org>; Fri, 18 Feb 2011 13:31:51 -0800
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In mpage_da_map_and_submit(), if we have a delayed block
allocation failure from ext4_map_blocks(), we need to mark
the IO as complete, by setting

      mpd->io_done = 1;

Otherwise, we could end up submitting the pages in an outer
loop; since they are unlocked on mapping failure in
ext4_da_block_invalidatepages(), this will cause a bug check
in mpage_da_submit_io().

I tested this by injected failures into ext4_map_blocks().
Without this patch, a simple fsstress run will bug check;
with the patch, it works fine.

Signed-off-by: Curt Wohlgemuth <curtw@google.com>
---
 fs/ext4/inode.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9f7f9e4..1cff229 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2314,6 +2314,9 @@ static void mpage_da_map_and_submit(struct mpage_da_data *mpd)
 		/* invalidate all the pages */
 		ext4_da_block_invalidatepages(mpd, next,
 				mpd->b_size >> mpd->inode->i_blkbits);
+
+		/* Mark this page range as having been completed */
+		mpd->io_done = 1;
 		return;
 	}
 	BUG_ON(blks == 0);
-- 
1.7.3.1

