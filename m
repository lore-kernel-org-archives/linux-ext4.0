From: Peng Tao <bergwolf@gmail.com>
Subject: [PATCH]mke2fs: don't check mount flags for regular files
Date: Tue, 24 Mar 2009 16:31:33 +0800
Message-ID: <1237883493-30521-1-git-send-email-bergwolf@gmail.com>
Cc: tytso@mit.edu, Peng Tao <bergwolf@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.187]:63845 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbZCXIbq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Mar 2009 04:31:46 -0400
Received: by ti-out-0910.google.com with SMTP id i7so1814140tid.23
        for <linux-ext4@vger.kernel.org>; Tue, 24 Mar 2009 01:31:43 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

mke2fs scans /proc/mounts for mount flags of a device. But for regular files,
this is unnecessary and may cause troubles.

This can be triggered by:
$dd if=/dev/null of=rootfs bs=1024 seek=100000 count=0
$mke2fs -t ext3 -F rootfs
mke2fs 1.41.4 (27-Jan-2009)
rootfs is mounted; will not make a filesystem here!

Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 lib/ext2fs/mkjournal.c |    5 +++++
 misc/util.c            |    3 +++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/lib/ext2fs/mkjournal.c b/lib/ext2fs/mkjournal.c
index f5a9dba..ba7c6a8 100644
--- a/lib/ext2fs/mkjournal.c
+++ b/lib/ext2fs/mkjournal.c
@@ -466,6 +466,11 @@ errcode_t ext2fs_add_journal_inode(ext2_filsys fs, blk_t size, int flags)
 					       jfile, sizeof(jfile)-10)))
 		return retval;
 
+	/*
+	 * Discard mounted flag if it is a regular file.
+	 */
+	if (stat(fs->device_name, &st) < 0 || S_ISREG(st.st_mode))
+		mount_flags &= ~EXT2_MF_MOUNTED;
 	if (mount_flags & EXT2_MF_MOUNTED) {
 		strcat(jfile, "/.journal");
 
diff --git a/misc/util.c b/misc/util.c
index 837d60f..d5b8033 100644
--- a/misc/util.c
+++ b/misc/util.c
@@ -144,7 +144,10 @@ void check_mount(const char *device, int force, const char *type)
 {
 	errcode_t	retval;
 	int		mount_flags;
+	struct stat	st_buf;
 
+	if ((stat(device, &st_buf) != 0) || S_ISREG(st_buf.st_mode))
+		return;
 	retval = ext2fs_check_if_mounted(device, &mount_flags);
 	if (retval) {
 		com_err("ext2fs_check_if_mount", retval,
-- 
1.6.2-rc2.GIT

