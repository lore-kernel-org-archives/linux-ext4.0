From: Robert Yang <liezhi.yang@windriver.com>
Subject: [RFC 06/10] misc/util.c: create directory
Date: Wed, 28 Aug 2013 13:25:56 +0800
Message-ID: <1377667560-20089-7-git-send-email-liezhi.yang@windriver.com>
References: <1377667560-20089-1-git-send-email-liezhi.yang@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <tytso@mit.edu>, <dvhart@linux.intel.com>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:56014 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403Ab3H1Fan (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Aug 2013 01:30:43 -0400
In-Reply-To: <1377667560-20089-1-git-send-email-liezhi.yang@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The do_mkdir_internal() is used for making dir on the target fs, most of
the code are from debugfs/debugfs.c, the debugfs/debugfs.c will be
modified to use this function.

Signed-off-by: Robert Yang <liezhi.yang@windriver.com>
---
 misc/util.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/misc/util.c b/misc/util.c
index e35fd88..7a45120 100644
--- a/misc/util.c
+++ b/misc/util.c
@@ -471,6 +471,40 @@ fail:
 /* Make a directory in the fs */
 errcode_t do_mkdir_internal(ext2_ino_t cwd, const char *name, struct stat *st)
 {
+	char			*cp;
+	ext2_ino_t		parent_ino, ino;
+	errcode_t		retval;
+	struct ext2_inode	inode;
+	char			*func_name = "do_mkdir_internal";
+
+
+	cp = strrchr(name, '/');
+	if (cp) {
+		*cp = 0;
+		if ((retval =  ext2fs_namei(current_fs, root, cwd, name, &parent_ino))){
+			com_err(name, retval, 0);
+			return retval;
+		}
+		name = cp+1;
+	} else {
+		parent_ino = cwd;
+		name = name;
+	}
+
+try_again:
+	retval = ext2fs_mkdir(current_fs, parent_ino, 0, name);
+	if (retval == EXT2_ET_DIR_NO_SPACE) {
+		retval = ext2fs_expand_dir(current_fs, parent_ino);
+		if (retval) {
+			com_err(func_name, retval, "while expanding directory");
+			return retval;
+		}
+		goto try_again;
+	}
+	if (retval) {
+		com_err("ext2fs_mkdir", retval, 0);
+		return retval;
+	}
 }
 
 /* Copy the native file to the fs */
-- 
1.8.1.2

