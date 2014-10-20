From: Wang Shilong <wangshilong1991@gmail.com>
Subject: [PATCH] Ext4: update comments that use ext4_delete_inode()
Date: Mon, 20 Oct 2014 09:28:27 -0400
Message-ID: <1413811707-2612-1-git-send-email-wangshilong1991@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:58793 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbaJTF30 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Oct 2014 01:29:26 -0400
Received: by mail-pd0-f175.google.com with SMTP id v10so4279897pde.20
        for <linux-ext4@vger.kernel.org>; Sun, 19 Oct 2014 22:29:26 -0700 (PDT)
Received: from vm01.localdomain ([223.65.188.229])
        by mx.google.com with ESMTPSA id zq13sm8058024pab.44.2014.10.19.22.29.24
        for <linux-ext4@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 19 Oct 2014 22:29:25 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Wang Shilong <wshilong@ddn.com>

ext4_delete_inode() has been renamed for a long time, update
comments for this.

Signed-off-by: Wang Shilong <wshilong@ddn.com>
---
 fs/ext4/inode.c   | 2 +-
 fs/ext4/migrate.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index e9777f9..04fd885 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3643,7 +3643,7 @@ out_stop:
 	 * If this was a simple ftruncate() and the file will remain alive,
 	 * then we need to clear up the orphan record which we created above.
 	 * However, if this was a real unlink then we were called by
-	 * ext4_delete_inode(), and we allow that function to clean up the
+	 * ext4_evict_inode(), and we allow that function to clean up the
 	 * orphan info for us.
 	 */
 	if (inode->i_nlink)
diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index a432634..3cb267a 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -592,7 +592,7 @@ err_out:
 
 	/*
 	 * set the  i_blocks count to zero
-	 * so that the ext4_delete_inode does the
+	 * so that the ext4_evict_inode() does the
 	 * right job
 	 *
 	 * We don't need to take the i_lock because
-- 
1.8.3.1

