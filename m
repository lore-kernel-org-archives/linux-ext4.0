From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/5] mke2fs.conf: remove legacy entry for ext4dev
Date: Wed, 23 Aug 2017 11:42:06 -0400
Message-ID: <20170823154210.8756-1-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45862 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754155AbdHWPmS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 23 Aug 2017 11:42:18 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 misc/mke2fs.conf.in  | 5 -----
 tests/mke2fs.conf.in | 5 -----
 2 files changed, 10 deletions(-)

diff --git a/misc/mke2fs.conf.in b/misc/mke2fs.conf.in
index 812f7c742..d0066b78b 100644
--- a/misc/mke2fs.conf.in
+++ b/misc/mke2fs.conf.in
@@ -14,11 +14,6 @@
 		features = has_journal,extent,huge_file,flex_bg,uninit_bg,64bit,dir_nlink,extra_isize
 		inode_size = 256
 	}
-	ext4dev = {
-		features = has_journal,extent,huge_file,flex_bg,uninit_bg,inline_data,64bit,dir_nlink,extra_isize
-		inode_size = 256
-		options = test_fs=1
-	}
 	small = {
 		blocksize = 1024
 		inode_size = 128
diff --git a/tests/mke2fs.conf.in b/tests/mke2fs.conf.in
index c06050d8d..ee246ba8b 100644
--- a/tests/mke2fs.conf.in
+++ b/tests/mke2fs.conf.in
@@ -17,11 +17,6 @@
 		features = has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize
 		inode_size = 256
 	}
-	ext4dev = {
-		features = has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize
-		inode_size = 256
-		options = test_fs=1
-	}
 	small = {
 		blocksize = 1024
 		inode_size = 128
-- 
2.11.0.rc0.7.gbe5a750
