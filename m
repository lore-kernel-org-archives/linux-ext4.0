From: gmail <yngsion@gmail.com>
Subject: [PATCH] ext4: release bh in make_indexed_dir
Date: Fri, 30 Sep 2016 01:36:30 +0800
Message-ID: <1475170590.1830.13.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, jack@suse.cz
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34684 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933853AbcI2Rgv (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Sep 2016 13:36:51 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The commit 6050d47adcad
("ext4: bail out from make_indexed_dir() on first error")
miss to release bh in make_indexed_dir.

Signed-off-by: yangsheng <yngsion@gmail.com>
---
 fs/ext4/namei.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 38ca0fe..465f960 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2058,19 +2058,18 @@ static int make_indexed_dir(handle_t *handle, struct ext4_filename *fname,
 		retval = PTR_ERR(de);
 		goto out_frames;
 	}
-	dx_release(frames);
 
 	retval = add_dirent_to_buf(handle, fname, dir, inode, de, bh);
-	brelse(bh);
-	return retval;
 out_frames:
 	/*
 	 * Even if the block split failed, we have to properly write
 	 * out all the changes we did so far. Otherwise we can end up
 	 * with corrupted filesystem.
 	 */
-	ext4_mark_inode_dirty(handle, dir);
+	if (retval)
+		ext4_mark_inode_dirty(handle, dir);
 	dx_release(frames);
+	brelse(bh);
 	return retval;
 }
 


