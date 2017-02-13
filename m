From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] debugfs: with ls -l, include space between size and date
Date: Sun, 12 Feb 2017 16:01:40 -0800
Message-ID: <20170213000140.14250-1-ebiggers3@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Eric Biggers <ebiggers@google.com>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:35191 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751000AbdBMACU (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 12 Feb 2017 19:02:20 -0500
Received: by mail-pg0-f67.google.com with SMTP id 204so8111130pge.2
        for <linux-ext4@vger.kernel.org>; Sun, 12 Feb 2017 16:02:20 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

Before:
     11   40700 (2)      0      0   1228812-Feb-2017 12:51 lost+found

After:
     11   40700 (2)      0      0   12288 12-Feb-2017 12:51 lost+found

Fixes: 68a1de3df340 ("debugfs: pretty print encrypted filenames in the ls command")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 debugfs/ls.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/debugfs/ls.c b/debugfs/ls.c
index 057e3f6f..c990a93d 100644
--- a/debugfs/ls.c
+++ b/debugfs/ls.c
@@ -156,8 +156,7 @@ static int list_dir_proc(ext2_ino_t dir EXT2FS_ATTR((unused)),
 			fprintf(ls->f, "%5d", inode.i_size);
 		else
 			fprintf(ls->f, "%5llu", EXT2_I_SIZE(&inode));
-		fputs(datestr, ls->f);
-		fputc(' ', ls->f);
+		fprintf(ls->f, " %s ", datestr);
 		print_filename(ls->f, dirent, options);
 		fputc('\n', ls->f);
 	} else {
-- 
2.11.1
