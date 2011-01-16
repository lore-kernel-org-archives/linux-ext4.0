From: Manish Katiyar <mkatiyar@gmail.com>
Subject: [PATCH] ext4: Fix missing iput for root inode in case of all failed
 mount paths.
Date: Sat, 15 Jan 2011 23:30:12 -0800
Message-ID: <AANLkTik8jweuA_kDfzY7H=wP-ikSSwdf-FF1NX09DDCT@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: mkatiyar@gmail.com
To: "Theodore Ts'o" <tytso@mit.edu>, ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:60958 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273Ab1APHad (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 16 Jan 2011 02:30:33 -0500
Received: by qwa26 with SMTP id 26so3894485qwa.19
        for <linux-ext4@vger.kernel.org>; Sat, 15 Jan 2011 23:30:33 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix missing iput for root inode in case of all failed mount paths.
Fixes bug#26752

Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>

---
 fs/ext4/super.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index cb10a06..9570fcc 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3587,6 +3587,7 @@ no_journal:
        if (err) {
                ext4_msg(sb, KERN_ERR, "failed to initialize system "
                         "zone (%d)", err);
+               iput(root);
                goto failed_mount4;
        }

@@ -3595,12 +3596,15 @@ no_journal:
        if (err) {
                ext4_msg(sb, KERN_ERR, "failed to initialize mballoc (%d)",
                         err);
+               iput(root);
                goto failed_mount4;
        }

        err = ext4_register_li_request(sb, first_not_zeroed);
-       if (err)
+       if (err) {
+               iput(root);
                goto failed_mount4;
+       }

        sbi->s_kobj.kset = ext4_kset;
        init_completion(&sbi->s_kobj_unregister);
@@ -3609,6 +3613,7 @@ no_journal:
        if (err) {
                ext4_mb_release(sb);
                ext4_ext_release(sb);
+               iput(root);
                goto failed_mount4;
        };

@@ -3648,6 +3653,7 @@ cantfind_ext4:
        goto failed_mount;

 failed_mount4:
+       sb->s_root = NULL;
        ext4_msg(sb, KERN_ERR, "mount failed");
        destroy_workqueue(EXT4_SB(sb)->dio_unwritten_wq);
 failed_mount_wq:
-- 
1.7.1


-- 
Thanks -
Manish
==================================
[$\*.^ -- I miss being one of them
==================================
