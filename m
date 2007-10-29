From: Coly Li <coyli@suse.de>
Subject: [PATCH] e2fsprogs: directory inode reservation (V1) to mke2fs
Date: Tue, 30 Oct 2007 01:03:38 +0800
Message-ID: <4726126A.3060303@suse.de>
Reply-To: coyli@suse.de
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:34140 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262AbXJ2RCy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Oct 2007 13:02:54 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch adds directory inode reservation supporting to mke2fs. Ask for review.

Signed-off-by: Coly Li <coyli@suse.de>
---
 lib/ext2fs/ext2_fs.h |    9 ++++++++-
 misc/mke2fs.c        |   27 ++++++++++++++++++++++++---
 2 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index a316665..b007a1b 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -111,6 +111,13 @@
 #endif

 /*
+ * Macro-instructions used to reserve inodes for directories
+ */
+#define EXT4_DIR_IRESERVE_LOW		16
+#define EXT4_DIR_IRESERVE_NORMAL	64
+#define EXT4_DIR_IRESERVE_HIGH		128
+
+/*
  * ACL structures
  */
 struct ext2_acl_header	/* Header of Access Control Lists */
@@ -167,7 +174,7 @@ struct ext4_group_desc
 	__u16	bg_free_blocks_count_hi;/* Free blocks count MSB */
 	__u16	bg_free_inodes_count_hi;/* Free inodes count MSB */
 	__u16	bg_used_dirs_count_hi;	/* Directories count MSB */
-	__u16   bg_pad;
+	__u16	bg_itable_unused_hi;	/* Unused inodes count MSB */
 	__u32	bg_reserved2[3];
 };

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 4a6cace..fcb4830 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -86,6 +86,7 @@ char *volume_label;
 char *mount_dir;
 char *journal_device;
 int sync_kludge;	/* Set using the MKE2FS_SYNC env. option */
+int dir_inodes_reserve = 0;

 profile_t	profile;

@@ -100,7 +101,8 @@ static void usage(void)
 	"\t[-N number-of-inodes] [-m reserved-blocks-percentage] "
 	"[-o creator-os]\n\t[-g blocks-per-group] [-L volume-label] "
 	"[-M last-mounted-directory]\n\t[-O feature[,...]] "
-	"[-r fs-revision] [-R options] [-qvSV]\n\tdevice [blocks-count]\n"),
+	"[-r fs-revision] [-E extended-option[,...]] [-qvSV]\n"
+	"\tdevice [blocks-count]\n"),
 		program_name);
 	exit(1);
 }
@@ -575,6 +577,16 @@ static void reserve_inodes(ext2_filsys fs)
 	ext2fs_mark_ib_dirty(fs);
 }

+static void setup_itable_unused(ext2_filsys fs)
+{
+	dgrp_t	i;
+	int inodes_pgroup = fs->super->s_inodes_per_group;
+	fs->group_desc[0].bg_itable_unused =
+		inodes_pgroup - EXT4_DIR_IRESERVE_NORMAL;
+	for (i = 1; i < fs->group_desc_count; i++)
+		fs->group_desc[i].bg_itable_unused = inodes_pgroup;
+}
+
 #define BSD_DISKMAGIC   (0x82564557UL)  /* The disk magic number */
 #define BSD_MAGICDISK   (0x57455682UL)  /* The disk magic number reversed */
 #define BSD_LABEL_OFFSET        64
@@ -761,7 +773,7 @@ static void parse_extended_opts(struct ext2_super_block *param,
 	int	r_usage = 0;

 	len = strlen(opts);
-	buf = malloc(len+1);
+	buf = (char *)malloc(len+1);
 	if (!buf) {
 		fprintf(stderr,
 			_("Couldn't allocate memory to parse options!\n"));
@@ -849,6 +861,12 @@ static void parse_extended_opts(struct ext2_super_block *param,

 				param->s_reserved_gdt_blocks = rsv_gdb;
 			}
+		} else if (!strcmp(token, "dir_ireserve")) {
+			if (arg) {
+				r_usage ++;
+				continue;
+			}
+			dir_inodes_reserve = 1;
 		} else
 			r_usage++;
 	}
@@ -859,7 +877,8 @@ static void parse_extended_opts(struct ext2_super_block *param,
 			"\tis set off by an equals ('=') sign.\n\n"
 			"Valid extended options are:\n"
 			"\tstride=<stride length in blocks>\n"
-			"\tresize=<resize maximum size in blocks>\n\n"));
+			"\tresize=<resize maximum size in blocks>\n"
+			"\tdir_ireserve\n\n"));
 		free(buf);
 		exit(1);
 	}
@@ -1689,6 +1708,8 @@ int main (int argc, char *argv[])
 				exit(1);
 			}
 		}
+		if (dir_inodes_reserve)
+			setup_itable_unused(fs);
 	}

 	if (journal_device) {


-- 
Coly Li
SuSE PRC Labs
