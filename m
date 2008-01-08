From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] e2fsprogs: play with 8TB to 16TB fs's better
Date: Tue, 8 Jan 2008 14:33:25 -0500
Message-ID: <20080108193325.GB3323@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36800 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757426AbYAHTdk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Jan 2008 14:33:40 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m08JXeB4008689
	for <linux-ext4@vger.kernel.org>; Tue, 8 Jan 2008 14:33:40 -0500
Received: from pobox.corp.redhat.com (pobox.corp.redhat.com [10.11.255.20])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m08JXdM6007126
	for <linux-ext4@vger.kernel.org>; Tue, 8 Jan 2008 14:33:39 -0500
Received: from unused (unused [10.11.231.15] (may be forged))
	by pobox.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m08JXdBQ015692
	for <linux-ext4@vger.kernel.org>; Tue, 8 Jan 2008 14:33:39 -0500
Received: from unused (localhost.localdomain [127.0.0.1])
	by unused (8.14.1/8.14.1) with ESMTP id m08JXPhW003492
	for <linux-ext4@vger.kernel.org>; Tue, 8 Jan 2008 14:33:25 -0500
Received: (from jwhiter@localhost)
	by unused (8.14.1/8.14.1/Submit) id m08JXPOi003491
	for linux-ext4@vger.kernel.org; Tue, 8 Jan 2008 14:33:25 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

Currently in order to mkfs a >8TB fs with 4k blocks you have to do -F, which is
kind of dumb since you can go to 16TB-4k.  This patch removes that one check
that won't let you go above 8TB and fixes getsize so that if you have a 16TB fs
instead of complaining that the device is too big just -1 from the size and go
ahead on business as usual.  Tested this with my box and it works fine (yay
having >16tb to play with).  Thank you,

Josef


Index: e2fsprogs/lib/ext2fs/getsize.c
===================================================================
--- e2fsprogs.orig/lib/ext2fs/getsize.c
+++ e2fsprogs/lib/ext2fs/getsize.c
@@ -190,8 +190,13 @@ errcode_t ext2fs_get_device_size(const c
 	    ioctl(fd, BLKGETSIZE64, &size64) >= 0) {
 		if ((sizeof(*retblocks) < sizeof(unsigned long long)) &&
 		    ((size64 / blocksize) > 0xFFFFFFFF)) {
-			rc = EFBIG;
-			goto out;
+			/* 16tb fs is fine, just adjust slightly */
+			if ((size64 / blocksize) == 0x100000000) {
+				size64--;
+			} else {
+				rc = EFBIG;
+				goto out;
+			}
 		}
 		*retblocks = size64 / blocksize;
 		goto out;
@@ -252,13 +257,19 @@ errcode_t ext2fs_get_device_size(const c
 		struct stat	st;
 		if (fstat(fd, &st) == 0)
 #endif
+			size64 = st.st_size;
 			if (S_ISREG(st.st_mode)) {
 				if ((sizeof(*retblocks) < sizeof(unsigned long long)) &&
-				    ((st.st_size / blocksize) > 0xFFFFFFFF)) {
-					rc = EFBIG;
-					goto out;
+				    ((size64 / blocksize) > 0xFFFFFFFF)) {
+					/* 16tb fs is fine, just adjust slightly */
+					if ((size64 / blocksize) > 0x100000000) {
+						size64--;
+					} else {
+						rc = EFBIG;
+						goto out;
+					}
 				}
-				*retblocks = st.st_size / blocksize;
+				*retblocks = size64 / blocksize;
 				goto out;
 			}
 	}
@@ -284,8 +295,13 @@ errcode_t ext2fs_get_device_size(const c
 	size64 = low + 1;
 	if ((sizeof(*retblocks) < sizeof(unsigned long long))
 	    && ((size64 / blocksize) > 0xFFFFFFFF)) {
-		rc = EFBIG;
-		goto out;
+		/* 16tb fs is fine, just adjust slightly */
+		if ((size64 / blocksize) > 0x100000000) {
+			size64--;
+		} else {
+			rc = EFBIG;
+			goto out;
+		}
 	}
 	*retblocks = size64 / blocksize;
 out:
Index: e2fsprogs/misc/mke2fs.c
===================================================================
--- e2fsprogs.orig/misc/mke2fs.c
+++ e2fsprogs/misc/mke2fs.c
@@ -1455,13 +1455,6 @@ static void PRS(int argc, char *argv[])
 		}
 	}
 
-	if (!force && fs_param.s_blocks_count >= ((unsigned) 1 << 31)) {
-		com_err(program_name, 0,
-			_("Filesystem too large.  No more than 2**31-1 blocks\n"
-			  "\t (8TB using a blocksize of 4k) are currently supported."));
-             exit(1);
-	}
-
 	if ((blocksize > 4096) &&
 	    (fs_param.s_feature_compat & EXT3_FEATURE_COMPAT_HAS_JOURNAL))
 		fprintf(stderr, _("\nWarning: some 2.4 kernels do not support "
