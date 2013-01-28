From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH v2] ext4: remove unused variable flags
Date: Mon, 28 Jan 2013 10:13:19 +0100
Message-ID: <1359364399-4504-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176Ab3A1JNX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jan 2013 04:13:23 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Remove unused variable flags from dump_completed_IO(). The code is only
exercised when EXT4FS_DEBUG is defined.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
---
v2: no changes

 fs/ext4/page-io.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 0016fbc..3331a76 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -119,7 +119,6 @@ static void dump_completed_IO(struct inode *inode)
 #ifdef	EXT4FS_DEBUG
 	struct list_head *cur, *before, *after;
 	ext4_io_end_t *io, *io0, *io1;
-	unsigned long flags;
 
 	if (list_empty(&EXT4_I(inode)->i_completed_io_list)) {
 		ext4_debug("inode %lu completed_io list is empty\n",
-- 
1.7.7.6

