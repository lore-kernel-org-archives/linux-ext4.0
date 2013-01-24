From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/2] ext4: remove unused variable flags
Date: Thu, 24 Jan 2013 17:30:44 +0100
Message-ID: <1359045044-31435-2-git-send-email-lczerner@redhat.com>
References: <1359045044-31435-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44613 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721Ab3AXQbA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Jan 2013 11:31:00 -0500
In-Reply-To: <1359045044-31435-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Remove unused variable flags from dump_completed_IO(). The code is only
exercised when EXT4FS_DEBUG is defined.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
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

