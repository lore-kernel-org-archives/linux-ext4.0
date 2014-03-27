From: Robert Yang <liezhi.yang@windriver.com>
Subject: [PATCH V2] e2fsprogs: misc/mke2fs.c: return error when failed to populate fs
Date: Thu, 27 Mar 2014 10:03:07 +0800
Message-ID: <1395885787-25947-1-git-send-email-liezhi.yang@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-ext4@vger.kernel.org>, <gnehzuil.liu@gmail.com>
To: <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:62060 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbaC0B5K (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Mar 2014 21:57:10 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We need return retval when "mke2fs -d" failed, otherwise the "$?" would
be 0 which is misleading.

Signed-off-by: Robert Yang <liezhi.yang@windriver.com>
---
 misc/mke2fs.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index aecd5d5..60e7466 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -2990,10 +2990,11 @@ no_journal:
 
 		retval = populate_fs(fs, EXT2_ROOT_INO, root_dir,
 				     EXT2_ROOT_INO);
-		if (retval)
-			fprintf(stderr, "%s",
-				_("\nError while populating file system"));
-		else if (!quiet)
+		if (retval) {
+			com_err(program_name, retval, "%s",
+				_("\nError while populating file system\n"));
+			exit(1);
+		} else if (!quiet)
 			printf("%s", _("done\n"));
 	}
 
-- 
1.8.3.1

