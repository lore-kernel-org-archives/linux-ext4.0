From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] resize2fs: add debug switch to use old online interface
Date: Fri, 11 Jan 2013 11:52:53 -0600
Message-ID: <50F05175.8060502@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Carlos Maiolino <cmaiolino@redhat.com>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754776Ab3AKRwz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Jan 2013 12:52:55 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0BHqtHj028192
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Fri, 11 Jan 2013 12:52:55 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The old online resize ioctl interfaces are still present
in the kernel; add a debug switch to resize2fs to be able
to test them.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/resize/online.c b/resize/online.c
index d3d3546..9b38ac8 100644
--- a/resize/online.c
+++ b/resize/online.c
@@ -22,7 +22,7 @@ extern char *program_name;
 #define MAX_32_NUM ((((unsigned long long) 1) << 32) - 1)
 
 errcode_t online_resize_fs(ext2_filsys fs, const char *mtpt,
-			   blk64_t *new_size, int flags EXT2FS_ATTR((unused)))
+			   blk64_t *new_size, int flags)
 {
 #ifdef __linux__
 	struct ext2_new_group_input input;
@@ -94,9 +94,11 @@ errcode_t online_resize_fs(ext2_filsys fs, const char *mtpt,
 		exit(1);
 	}
 
-	if (ioctl(fd, EXT4_IOC_RESIZE_FS, new_size)) {
+	if (flags & RESIZE_DEBUG_OLD ||
+	    ioctl(fd, EXT4_IOC_RESIZE_FS, new_size)) {
 		/*
-		 * If kernel does not support EXT4_IOC_RESIZE_FS, use the
+		 * If kernel does not support EXT4_IOC_RESIZE_FS, or -d 16
+		 * is specified on the resize2fs command line, use the
 		 * old online resize. Note that the old approach does not
 		 * handle >32 bit file systems
 		 *
@@ -109,7 +111,9 @@ errcode_t online_resize_fs(ext2_filsys fs, const char *mtpt,
 		 * in the kernel sources.  This is probably a kernel
 		 * bug, but work around it here.
 		 */
-		if ((errno != ENOTTY) && (errno != EINVAL)) {
+		if (flags & RESIZE_DEBUG_OLD) {
+			printf("Old resize interface requested.\n");
+		} else if ((errno != ENOTTY) && (errno != EINVAL)) {
 			if (errno == EPERM)
 				com_err(program_name, 0,
 				_("Permission denied to resize filesystem"));
diff --git a/resize/resize2fs.8.in b/resize/resize2fs.8.in
index 9ff6e0a..766c4d8 100644
--- a/resize/resize2fs.8.in
+++ b/resize/resize2fs.8.in
@@ -99,6 +99,8 @@ from the following list:
 	4	\-\ Debug inode relocations
 .br
 	8	\-\ Debug moving the inode table
+.br
+	16	\-\ Debug old online resize interface
 .TP 
 .B \-f
 Forces resize2fs to proceed with the filesystem resize operation, overriding
diff --git a/resize/resize2fs.h b/resize/resize2fs.h
index 2184759..58fc04d 100644
--- a/resize/resize2fs.h
+++ b/resize/resize2fs.h
@@ -76,6 +76,8 @@ typedef struct ext2_sim_progress *ext2_sim_progmeter;
 #define RESIZE_DEBUG_BMOVE		0x0002
 #define RESIZE_DEBUG_INODEMAP		0x0004
 #define RESIZE_DEBUG_ITABLEMOVE		0x0008
+/* old online resize interface */
+#define RESIZE_DEBUG_OLD		0x0010
 
 #define RESIZE_PERCENT_COMPLETE		0x0100
 #define RESIZE_VERBOSE			0x0200


