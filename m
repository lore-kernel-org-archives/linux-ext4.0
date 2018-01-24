From: Tyson Nottingham <tgnottingham@gmail.com>
Subject: [PATCH] debugfs: remove misplaced "MMP is unsupported" message.
Date: Tue, 23 Jan 2018 19:33:17 -0800
Message-ID: <1516764797-27781-1-git-send-email-tgnottingham@gmail.com>
Cc: tytso@mit.edu, Tyson Nottingham <tgnottingham@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:40486 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752478AbeAXDdW (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Jan 2018 22:33:22 -0500
Received: by mail-pg0-f67.google.com with SMTP id g16so1771583pgn.7
        for <linux-ext4@vger.kernel.org>; Tue, 23 Jan 2018 19:33:22 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This message was inadvertently copied from the version of do_dump_mmp
that is used when CONFIG_MMP is disabled.

Signed-off-by: Tyson Nottingham <tgnottingham@gmail.com>
---
 debugfs/debugfs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 91ededf..e46532f 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -2366,8 +2366,6 @@ void do_dump_mmp(int argc EXT2FS_ATTR((unused)), char *argv[])
 	fprintf(stdout, "device_name: %s\n", mmp_s->mmp_bdevname);
 	fprintf(stdout, "magic: 0x%x\n", mmp_s->mmp_magic);
 	fprintf(stdout, "checksum: 0x%08x\n", mmp_s->mmp_checksum);
-	fprintf(stdout, "MMP is unsupported, please recompile with "
-	                "--enable-mmp\n");
 }
 #else
 void do_dump_mmp(int argc EXT2FS_ATTR((unused)),
-- 
2.7.4
