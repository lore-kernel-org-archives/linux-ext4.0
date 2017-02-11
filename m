From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] e2fsprogs: remove duplicate default values in mke2fs.conf
Date: Sat, 11 Feb 2017 16:15:35 +0100
Message-ID: <20170211151535.3242-1-xose.vazquez@gmail.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Theodore Ts'o <tytso@mit.edu>,
        EXT4 ml <linux-ext4@vger.kernel.org>
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:33504 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750707AbdBKPPj (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 11 Feb 2017 10:15:39 -0500
Received: by mail-wr0-f196.google.com with SMTP id i10so18110175wrb.0
        for <linux-ext4@vger.kernel.org>; Sat, 11 Feb 2017 07:15:38 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Cc: Theodore Ts'o <tytso@mit.edu>
Cc: EXT4 ml <linux-ext4@vger.kernel.org>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 misc/mke2fs.conf.in | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/misc/mke2fs.conf.in b/misc/mke2fs.conf.in
index 812f7c74..3d612594 100644
--- a/misc/mke2fs.conf.in
+++ b/misc/mke2fs.conf.in
@@ -12,11 +12,9 @@
 	}
 	ext4 = {
 		features = has_journal,extent,huge_file,flex_bg,uninit_bg,64bit,dir_nlink,extra_isize
-		inode_size = 256
 	}
 	ext4dev = {
 		features = has_journal,extent,huge_file,flex_bg,uninit_bg,inline_data,64bit,dir_nlink,extra_isize
-		inode_size = 256
 		options = test_fs=1
 	}
 	small = {
@@ -47,6 +45,5 @@
 		blocksize = -1
 	}
 	hurd = {
-	     blocksize = 4096
 	     inode_size = 128
 	}
-- 
2.11.1
