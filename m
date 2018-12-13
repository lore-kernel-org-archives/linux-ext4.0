Return-Path: <SRS0=vjzE=OW=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-it1-f194.google.com ([209.85.166.194]:40602 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbeLMVcn (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Dec 2018 16:32:43 -0500
Received: by mail-it1-f194.google.com with SMTP id h193so6191533ita.5
        for <linux-ext4@vger.kernel.org>; Thu, 13 Dec 2018 13:32:42 -0800 (PST)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca
Subject: [PATCH 2/2] debugfs: output large directory size
Date: Fri, 14 Dec 2018 00:31:56 +0300
Message-Id: <20181213213156.44773-2-artem.blagodarenko@gmail.com>
In-Reply-To: <20181213213156.44773-1-artem.blagodarenko@gmail.com>
References: <20181213213156.44773-1-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use hight part of directory size in debugfs output.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
---
 debugfs/debugfs.c | 2 +-
 debugfs/ls.c      | 3 ---
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index e03519c4..2e600b92 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -848,7 +848,7 @@ void internal_dump_inode(FILE *out, const char *prefix,
 	if (is_large_inode && large_inode->i_extra_isize >= 32)
 		fprintf(out, "   Project: %5d", large_inode->i_projid);
 	fputs("   Size: ", out);
-	if (LINUX_S_ISREG(inode->i_mode))
+	if (LINUX_S_ISREG(inode->i_mode) || LINUX_S_ISDIR(inode->i_mode))
 		fprintf(out, "%llu\n", EXT2_I_SIZE(inode));
 	else
 		fprintf(out, "%d\n", inode->i_size);
diff --git a/debugfs/ls.c b/debugfs/ls.c
index a1e8f4e9..41af15d2 100644
--- a/debugfs/ls.c
+++ b/debugfs/ls.c
@@ -152,9 +152,6 @@ static int list_dir_proc(ext2_ino_t dir EXT2FS_ATTR((unused)),
 		fprintf(ls->f, "(%d)  %5d  %5d   ",
 			ext2fs_dirent_file_type(dirent),
 			inode_uid(inode), inode_gid(inode));
-		if (LINUX_S_ISDIR(inode.i_mode))
-			fprintf(ls->f, "%5d", inode.i_size);
-		else
 			fprintf(ls->f, "%5llu", EXT2_I_SIZE(&inode));
 		fprintf(ls->f, " %s ", datestr);
 		print_filename(ls->f, dirent, options);
-- 
2.14.3
