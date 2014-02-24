From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 1/2] mke2fs: Add revision to the is_before_linux_ver()
Date: Mon, 24 Feb 2014 18:41:05 +0100
Message-ID: <1393263666-21246-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59466 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846AbaBXRlO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Feb 2014 12:41:14 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 misc/mke2fs.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index facbe4c..957b4b6 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -177,7 +177,8 @@ static int parse_version_number(const char *s)
 	return KERNEL_VERSION(major, minor, rev);
 }
 
-static int is_before_linux_ver(unsigned int major, unsigned int minor)
+static int is_before_linux_ver(unsigned int major, unsigned int minor,
+			       unsigned int rev)
 {
 	struct		utsname ut;
 	static int	linux_version_code = -1;
@@ -191,10 +192,11 @@ static int is_before_linux_ver(unsigned int major, unsigned int minor)
 	if (linux_version_code == 0)
 		return 0;
 
-	return linux_version_code < KERNEL_VERSION(major, minor, 0);
+	return linux_version_code < KERNEL_VERSION(major, minor, rev);
 }
 #else
-static int is_before_linux_ver(unsigned int major, unsigned int minor)
+static int is_before_linux_ver(unsigned int major, unsigned int minor,
+			       unsigned int rev)
 {
 	return 0;
 }
@@ -1513,7 +1515,7 @@ profile_error:
 	memset(&fs_param, 0, sizeof(struct ext2_super_block));
 	fs_param.s_rev_level = 1;  /* Create revision 1 filesystems now */
 
-	if (is_before_linux_ver(2, 2))
+	if (is_before_linux_ver(2, 2, 0))
 		fs_param.s_rev_level = 0;
 
 	if (argc && *argv) {
@@ -1952,7 +1954,7 @@ profile_error:
 
 		if (use_bsize == -1) {
 			use_bsize = sys_page_size;
-			if (is_before_linux_ver(2, 6) && use_bsize > 4096)
+			if (is_before_linux_ver(2, 6, 0) && use_bsize > 4096)
 				use_bsize = 4096;
 		}
 		if (lsector_size && use_bsize < lsector_size)
-- 
1.8.3.1

