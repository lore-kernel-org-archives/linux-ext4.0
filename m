From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 19/74] misc: don't leak file descriptors
Date: Tue, 10 Dec 2013 17:20:27 -0800
Message-ID: <20131211012027.30655.29492.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26299 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab3LKBUc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:20:32 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/e2image.c  |    1 +
 misc/filefrag.c |    2 ++
 resize/online.c |   12 +++++++++---
 3 files changed, 12 insertions(+), 3 deletions(-)


diff --git a/misc/e2image.c b/misc/e2image.c
index 25d8d4e..624525b 100644
--- a/misc/e2image.c
+++ b/misc/e2image.c
@@ -1227,6 +1227,7 @@ static void install_image(char *device, char *image_fn, int type)
 		exit(1);
 	}
 
+	close(fd);
 	ext2fs_close (fs);
 }
 
diff --git a/misc/filefrag.c b/misc/filefrag.c
index 35b3544..a050a22 100644
--- a/misc/filefrag.c
+++ b/misc/filefrag.c
@@ -360,12 +360,14 @@ static void frag_report(const char *filename)
 #else
 	if (fstat(fd, &st) < 0) {
 #endif
+		close(fd);
 		perror("stat");
 		return;
 	}
 
 	if (last_device != st.st_dev) {
 		if (fstatfs(fd, &fsinfo) < 0) {
+			close(fd);
 			perror("fstatfs");
 			return;
 		}
diff --git a/resize/online.c b/resize/online.c
index 2d34640..defcac1 100644
--- a/resize/online.c
+++ b/resize/online.c
@@ -184,12 +184,16 @@ errcode_t online_resize_fs(ext2_filsys fs, const char *mtpt,
 		ext2fs_blocks_count(sb);
 
 	retval = ext2fs_read_bitmaps(fs);
-	if (retval)
+	if (retval) {
+		close(fd);
 		return retval;
+	}
 
 	retval = ext2fs_dup_handle(fs, &new_fs);
-	if (retval)
+	if (retval) {
+		close(fd);
 		return retval;
+	}
 
 	/* The current method of adding one block group at a time to a
 	 * mounted filesystem means it is impossible to accomodate the
@@ -203,8 +207,10 @@ errcode_t online_resize_fs(ext2_filsys fs, const char *mtpt,
 	 */
 	new_fs->super->s_feature_incompat &= ~EXT4_FEATURE_INCOMPAT_FLEX_BG;
 	retval = adjust_fs_info(new_fs, fs, 0, *new_size);
-	if (retval)
+	if (retval) {
+		close(fd);
 		return retval;
+	}
 
 	printf(_("Performing an on-line resize of %s to %llu (%dk) blocks.\n"),
 	       fs->device_name, *new_size, fs->blocksize / 1024);

