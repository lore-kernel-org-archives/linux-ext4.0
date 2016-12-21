From: Sam Voss <samuel.voss@rockwellcollins.com>
Subject: [PATCH] debugfs: ls -p can print invalid characters
Date: Wed, 21 Dec 2016 13:11:45 -0600
Message-ID: <1482347505-11200-1-git-send-email-samuel.voss@rockwellcollins.com>
Cc: Clayton Shotwell <clayton.shotwell@rockwellcollins.com>,
        Samuel Voss <samuel.voss@rockwellcollins.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from secvs01.rockwellcollins.com ([205.175.225.240]:60441 "EHLO
        secvs01.rockwellcollins.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753541AbcLUTXF (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 21 Dec 2016 14:23:05 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Clayton Shotwell <clayton.shotwell@rockwellcollins.com>

The recent modification to the "ls -p" function can print out characters
that the other ls functions do not print out. Adding a slight change to
use the same print function for all of the ls options.

Signed-off-by: Clayton Shotwell <clayton.shotwell@rockwellcollins.com>
Signed-off-by: Samuel Voss <samuel.voss@rockwellcollins.com>
---
 debugfs/ls.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/debugfs/ls.c b/debugfs/ls.c
index 057e3f6..cb40627 100644
--- a/debugfs/ls.c
+++ b/debugfs/ls.c
@@ -122,8 +122,10 @@ static int list_dir_proc(ext2_ino_t dir EXT2FS_ATTR((unused)),
 				return 0;
 		} else
 			memset(&inode, 0, sizeof(struct ext2_inode));
-		fprintf(ls->f,"/%u/%06o/%d/%d/%*s/", ino, inode.i_mode,
-			inode.i_uid, inode.i_gid, thislen, dirent->name);
+		fprintf(ls->f,"/%u/%06o/%d/%d/", ino, inode.i_mode,
+			inode.i_uid, inode.i_gid);
+		print_filename(ls->f, dirent, options);
+		fputc('/', ls->f);
 		if (LINUX_S_ISDIR(inode.i_mode))
 			fprintf(ls->f, "/");
 		else
-- 
1.9.1

