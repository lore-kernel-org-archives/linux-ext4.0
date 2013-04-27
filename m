From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH] libext2fs: do not print any error message from libext2fs
Date: Sat, 27 Apr 2013 18:44:41 +0800
Message-ID: <1367059481-6090-1-git-send-email-wenqing.lz@taobao.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:38595 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab3D0K12 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 27 Apr 2013 06:27:28 -0400
Received: by mail-pd0-f171.google.com with SMTP id t10so62646pdi.16
        for <linux-ext4@vger.kernel.org>; Sat, 27 Apr 2013 03:27:27 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

In libext2fs we don't print any error message form it except that OMIT_COM_ERR
is defined.  In lib/ext2fs/inline_data.c it doesn't obey this rule.  So fix it.
Meanwhile when we find an dir entry in inline data, we will print the message in
debugfs rather than in libext2fs.

Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
[This patch is against pu branch of e2fsprogs tree]

 debugfs/htree.c          | 5 ++++-
 lib/ext2fs/inline_data.c | 6 +++---
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/debugfs/htree.c b/debugfs/htree.c
index ca39b4b..e042fd7 100644
--- a/debugfs/htree.c
+++ b/debugfs/htree.c
@@ -388,8 +388,11 @@ void do_dirsearch(int argc, char *argv[])
 	pb.len = strlen(pb.search_name);
 
 	if (ext2fs_inode_has_inline_data(current_fs, inode)) {
-		ext2fs_inline_data_dirsearch(current_fs, inode,
+		errcode_t retval;
+		retval = ext2fs_inline_data_dirsearch(current_fs, inode,
 					     argv[2], strlen(argv[2]));
+		if (retval)
+			printf("Entry found at inline data\n");
 		goto out;
 	}
 
diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
index ea3736c..6d5cf52 100644
--- a/lib/ext2fs/inline_data.c
+++ b/lib/ext2fs/inline_data.c
@@ -134,16 +134,16 @@ static int do_search_dir(ext2_filsys fs, void *start, unsigned int size,
 		de = (struct ext2_dir_entry *)(start + offset);
 		errcode = ext2fs_get_rec_len(fs, de, &rec_len);
 		if (errcode) {
+#ifndef OMIT_COM_ERR
 			com_err("search_dir_inline_data", errcode,
 				"while getting rec_len for inline data");
+#endif
 			return errcode;
 		}
 		if (de->inode &&
 		    len == (de->name_len & 0xFF) &&
-		    strncmp(name, de->name, len) == 0) {
-			printf("Entry found at inline data\n");
+		    strncmp(name, de->name, len) == 0)
 			return 1;
-		}
 		offset += rec_len;
 	}
 	return 0;
-- 
1.7.12.rc2.18.g61b472e

