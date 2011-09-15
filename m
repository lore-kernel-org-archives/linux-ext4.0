From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH] ext4: let ext4_page_mkwrite stop started handle in failure
Date: Thu, 15 Sep 2011 10:56:30 +0800
Message-ID: <1316055390-14476-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: jack@suse.cz, tytso@mit.edu, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gw0-f42.google.com ([74.125.83.42]:45271 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749Ab1IOEHD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Sep 2011 00:07:03 -0400
Received: by gwb17 with SMTP id 17so2779763gwb.1
        for <linux-ext4@vger.kernel.org>; Wed, 14 Sep 2011 21:07:03 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The started journal handle should be stopped in failure case.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/inode.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index bcf5257..c8529be 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4624,6 +4624,7 @@ retry_alloc:
 			  PAGE_CACHE_SIZE, NULL, do_journal_get_write_access)) {
 			unlock_page(page);
 			ret = VM_FAULT_SIGBUS;
+			ext4_journal_stop(handle);
 			goto out;
 		}
 		ext4_set_inode_state(inode, EXT4_STATE_JDATA);
-- 
1.7.5.1

