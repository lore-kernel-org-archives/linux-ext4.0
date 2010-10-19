From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH] ext3: Check return value of sb_getblk()
Date: Tue, 19 Oct 2010 15:34:21 +0900
Message-ID: <1287470061-4158-1-git-send-email-namhyung@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:48190 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab0JSGeg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Oct 2010 02:34:36 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Check return value of sb_getblk() is NULL. unlikely is addded here
since it is called from a loop and we've been OK without the check
until now.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 fs/ext3/inode.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index ef1c23a..a7ac778 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -655,6 +655,12 @@ static int ext3_alloc_branch(handle_t *handle, struct inode *inode,
 		 * parent to disk.
 		 */
 		bh = sb_getblk(inode->i_sb, new_blocks[n-1]);
+		if (unlikely(!bh)) {
+			n--;
+			err = -ENOMEM;
+			goto failed;
+		}
+
 		branch[n].bh = bh;
 		lock_buffer(bh);
 		BUFFER_TRACE(bh, "call get_create_access");
-- 
1.7.0.4

