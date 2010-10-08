From: Dmitry Monakhov <dmonakhov@gmail.com>
Subject: [PATCH 1/2] writeback: sync quota after inodes writeback
Date: Fri,  8 Oct 2010 19:00:26 +0400
Message-ID: <1286550027-9684-1-git-send-email-dmonakhov@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Dmitry Monakhov <dmonakhov@gmail.com>
To: jaxboe@fusionio.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:37780 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893Ab0JHPAf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Oct 2010 11:00:35 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

inode writeback usually result in quota changes especially
on filesystems with delalloc. So quota_sync() before writeback
seems pointless. Let's do the job in a natural way.

Signed-off-by: Dmitry Monakhov <dmonakhov@gmail.com>
---
 fs/sync.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/sync.c b/fs/sync.c
index ba76b96..b0e2c6c 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -36,14 +36,14 @@ static int __sync_filesystem(struct super_block *sb, int wait)
 	if (!sb->s_bdi || sb->s_bdi == &noop_backing_dev_info)
 		return 0;
 
-	if (sb->s_qcop && sb->s_qcop->quota_sync)
-		sb->s_qcop->quota_sync(sb, -1, wait);
