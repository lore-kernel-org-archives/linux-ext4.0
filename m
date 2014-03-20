From: Robert Yang <liezhi.yang@windriver.com>
Subject: [PATCH] e2fsprogs: misc/mke2fs.c: return error when failed to populate fs
Date: Thu, 20 Mar 2014 14:09:26 +0800
Message-ID: <1395295766-10637-1-git-send-email-liezhi.yang@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-ext4@vger.kernel.org>
To: <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:46425 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbaCTGEG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Mar 2014 02:04:06 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We need return retval when "mke2fs -d" failed, otherwise the "$?" would
be 0 which is misleading.

Signed-off-by: Robert Yang <liezhi.yang@windriver.com>
---
 misc/mke2fs.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index aecd5d5..f659e6f 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -2990,10 +2990,11 @@ no_journal:
 
 		retval = populate_fs(fs, EXT2_ROOT_INO, root_dir,
 				     EXT2_ROOT_INO);
-		if (retval)
+		if (retval) {
 			fprintf(stderr, "%s",
-				_("\nError while populating file system"));
-		else if (!quiet)
+				_("\nError while populating file system\n"));
+			return retval;
+		} else if (!quiet)
 			printf("%s", _("done\n"));
 	}
 
-- 
1.8.3.1

