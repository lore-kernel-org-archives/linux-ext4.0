From: Tao Ma <tm@tao.ma>
Subject: [PATCH] ext4: Use EXT4FS_DEBUG instead of EXT4_DEBUG in fsync.c
Date: Mon, 28 Mar 2011 23:41:12 +0800
Message-ID: <1301326873-9551-1-git-send-email-tm@tao.ma>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:54104 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752509Ab1C1Pla (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Mar 2011 11:41:30 -0400
Received: from [221.217.31.156] (helo=taoma-laptop2.localdomain6)
	by box585.bluehost.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <tm@tao.ma>)
	id 1Q4EZL-0006CL-H3
	for linux-ext4@vger.kernel.org; Mon, 28 Mar 2011 09:41:28 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

We have EXT4FS_DEBUG for some old debug and CONFIG_EXT4_DEBUG
for the new mballoc debug, but there isn't any EXT4_DEBUG.

As CONFIG_EXT4_DEBUG seems to be only used in mballoc, use
EXT4FS_DEBUG in fsync.c.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/fsync.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 7f74019..3278d6d 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -36,7 +36,7 @@
 
 static void dump_completed_IO(struct inode * inode)
 {
-#ifdef	EXT4_DEBUG
+#ifdef	EXT4FS_DEBUG
 	struct list_head *cur, *before, *after;
 	ext4_io_end_t *io, *io0, *io1;
 	unsigned long flags;
-- 
1.7.4

