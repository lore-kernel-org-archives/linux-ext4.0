Return-Path: <SRS0=b4XO=OX=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-it1-f194.google.com ([209.85.166.194]:38539 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726533AbeLNHvc (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Dec 2018 02:51:32 -0500
Received: by mail-it1-f194.google.com with SMTP id h65so8024169ith.3
        for <linux-ext4@vger.kernel.org>; Thu, 13 Dec 2018 23:51:31 -0800 (PST)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca
Subject: [PATCH v2 2/2] debugfs: output large directory size
Date: Fri, 14 Dec 2018 10:50:54 +0300
Message-Id: <20181214075054.47359-2-artem.blagodarenko@gmail.com>
In-Reply-To: <20181214075054.47359-1-artem.blagodarenko@gmail.com>
References: <20181214075054.47359-1-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

large_dir option allows to create directory with size > 2GB.
debugfs utility outputs negative size value for large directories
and ignores high part of directory size.

Fix debugfs to use high part of directory size in debugfs output
and use appropriate output format.

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
