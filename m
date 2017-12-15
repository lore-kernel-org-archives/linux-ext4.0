From: zhouzhouyi@gmail.com
Subject: [PATCH] FS: EXT4: syn error in __ext4_grp_locked_error
Date: Fri, 15 Dec 2017 02:32:16 +0000
Message-ID: <1513305136-27652-1-git-send-email-zhouzhouyi@gmail.com>
Cc: Zhouyi Zhou <zhouzhouyi@gmail.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:42803 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754594AbdLOCcd (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Dec 2017 21:32:33 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zhouyi Zhou <zhouzhouyi@gmail.com>

In function __ext4_grp_locked_error,   __save_error_info
is called to save error info in super block block, but does not sync
that information to disk to info the subsequence fsck after reboot.

This patch sync the error information to disk. After this patch,
I think there is no obvious EXT4 error handle branche which leads to
"Remounting filesystem read-only" will leave the disk partition miss
the subsequence fsck.

Compiled in x86_64 Linux
Signed-off-by: Zhouyi Zhou <zhouzhouyi@gmail.com>
---
 fs/ext4/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 7c46693..7159438 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -742,6 +742,7 @@ __acquires(bitlock)
 	}
 
 	ext4_unlock_group(sb, grp);
+	ext4_commit_super(sb, 1);
 	ext4_handle_error(sb);
 	/*
 	 * We only get here in the ERRORS_RO case; relocking the group
-- 
2.1.4
