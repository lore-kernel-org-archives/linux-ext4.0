From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/5] resize2fs: enforce the 16TB limit on 32-bit file systems correctly
Date: Thu, 13 Sep 2012 18:49:16 -0400
Message-ID: <1347576560-5820-2-git-send-email-tytso@mit.edu>
References: <1347576560-5820-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50591 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210Ab2IMXGQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Sep 2012 19:06:16 -0400
In-Reply-To: <1347576560-5820-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The 16TB limit must be enforced regardless of whether the new size is
specified on the command line or implied by the size of the device,
but only if the file system does not support 64-bit block sizes, or
the kernel does not advertise support of meta_bg resizing.

Previously we were unconditionally enforcing it when it was implied by
the device size, but not if the new size was specified on the command
line.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 resize/main.c      | 26 ++++++++++++++++++--------
 resize/resize2fs.h |  5 +++++
 2 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/resize/main.c b/resize/main.c
index e6604f2..f8bd983 100644
--- a/resize/main.c
+++ b/resize/main.c
@@ -37,6 +37,7 @@ extern int optind;
 #include "../version.h"
 
 char *program_name, *device_name, *io_options;
+int meta_bg_resizing;
 
 static void usage (char *prog)
 {
@@ -187,6 +188,10 @@ int main (int argc, char ** argv)
 	if (argc && *argv)
 		program_name = *argv;
 
+	if ((access("/sys/fs/ext4/features/meta_bg_resize", R_OK) == 0) &&
+	    !getenv("RESIZE2FS_NO_META_BG_RESIZE"))
+		meta_bg_resizing = 1;
+
 	while ((c = getopt (argc, argv, "d:fFhMPpS:")) != EOF) {
 		switch (c) {
 		case 'h':
@@ -385,19 +390,24 @@ int main (int argc, char ** argv)
 			exit(1);
 		}
 	} else {
-		/* Take down devices exactly 16T to 2^32-1 blocks */
-		if (max_size == (1ULL << 32))
-			max_size--;
-		else if (max_size > (1ULL << 32)) {
-			com_err(program_name, 0, _("New size too large to be "
-				"expressed in 32 bits\n"));
-			exit(1);
-		}
 		new_size = max_size;
 		/* Round down to an even multiple of a pagesize */
 		if (sys_page_size > fs->blocksize)
 			new_size &= ~((sys_page_size / fs->blocksize)-1);
 	}
+	if (!EXT2_HAS_INCOMPAT_FEATURE(fs->super,
+				       EXT4_FEATURE_INCOMPAT_64BIT) ||
+	    !meta_bg_resizing) {
+		/* Take 16T down to 2^32-1 blocks */
+		if (new_size == (1ULL << 32))
+			new_size--;
+		else if (new_size > (1ULL << 32)) {
+			com_err(program_name, 0,
+				_("New size too large to be "
+				  "expressed in 32 bits\n"));
+			exit(1);
+		}
+	}
 
 	if (!force && new_size < min_size) {
 		com_err(program_name, 0,
diff --git a/resize/resize2fs.h b/resize/resize2fs.h
index 2184759..31c2b6d 100644
--- a/resize/resize2fs.h
+++ b/resize/resize2fs.h
@@ -81,6 +81,11 @@ typedef struct ext2_sim_progress *ext2_sim_progmeter;
 #define RESIZE_VERBOSE			0x0200
 
 /*
+ * Is meta_bg resizing supported by the kernel?
+ */
+extern int meta_bg_resizing;
+
+/*
  * The core state structure for the ext2 resizer
  */
 typedef struct ext2_resize_struct *ext2_resize_t;
-- 
1.7.12.rc0.22.gcdd159b

