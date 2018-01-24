From: Tyson Nottingham <tgnottingham@gmail.com>
Subject: [PATCH] ext4: make huge file flag user visible.
Date: Tue, 23 Jan 2018 20:15:48 -0800
Message-ID: <1516767348-30444-1-git-send-email-tgnottingham@gmail.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca,
        Tyson Nottingham <tgnottingham@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:46736 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932521AbeAXEQI (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Jan 2018 23:16:08 -0500
Received: by mail-pf0-f195.google.com with SMTP id y5so2090562pff.13
        for <linux-ext4@vger.kernel.org>; Tue, 23 Jan 2018 20:16:08 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Make huge file flag visible to clients of FS_IOC_GETFLAGS ioctl, e.g.
the userspace tool lsattr, which expects the flag to be visible.

Signed-off-by: Tyson Nottingham <tgnottingham@gmail.com>
---
 fs/ext4/ext4.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 3241475..dbd6318 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -400,7 +400,7 @@ struct flex_groups {
 #define EXT4_PROJINHERIT_FL		0x20000000 /* Create with parents projid */
 #define EXT4_RESERVED_FL		0x80000000 /* reserved for ext4 lib */
 
-#define EXT4_FL_USER_VISIBLE		0x304BDFFF /* User visible flags */
+#define EXT4_FL_USER_VISIBLE		0x304FDFFF /* User visible flags */
 #define EXT4_FL_USER_MODIFIABLE		0x204BC0FF /* User modifiable flags */
 
 /* Flags we can manipulate with through EXT4_IOC_FSSETXATTR */
-- 
2.7.4
