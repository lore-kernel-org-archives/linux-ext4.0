From: Robert Yang <liezhi.yang@windriver.com>
Subject: [RFC 01/10] mke2fs.c: add an option: -d root-directory
Date: Wed, 28 Aug 2013 13:25:51 +0800
Message-ID: <1377667560-20089-2-git-send-email-liezhi.yang@windriver.com>
References: <1377667560-20089-1-git-send-email-liezhi.yang@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <tytso@mit.edu>, <dvhart@linux.intel.com>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:56004 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab3H1Fae (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Aug 2013 01:30:34 -0400
In-Reply-To: <1377667560-20089-1-git-send-email-liezhi.yang@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This option is used for adding the files from the root-directory to the
filesystem, it is similiar to genext2fs, but genext2fs doesn't fully
support ext4.

This commit describes the skeleton of the implementation:
* The "struct hdlink_s" will be used for saving hard links, I
  referred this from the genext2fs.

* The do_xxx_internal will be used by both mke2fs and debugfs, most of
  their operations are similar.

Signed-off-by: Robert Yang <liezhi.yang@windriver.com>
---
 misc/mke2fs.c | 39 ++++++++++++++++++++++++++++++++++-----
 misc/util.c   | 35 +++++++++++++++++++++++++++++++++++
 misc/util.h   | 32 ++++++++++++++++++++++++++++++++
 3 files changed, 101 insertions(+), 5 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index d96f156..6401ae0 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -44,8 +44,6 @@ extern int optind;
 #include <errno.h>
 #endif
 #include <sys/ioctl.h>
-#include <sys/types.h>
-#include <sys/stat.h>
 #include <libgen.h>
 #include <limits.h>
 #include <blkid/blkid.h>
@@ -105,6 +103,7 @@ char *mount_dir;
 char *journal_device;
 int sync_kludge;	/* Set using the MKE2FS_SYNC env. option */
 char **fs_types;
+const char *root_dir;  /* Copy files from the specified directory */
 
 profile_t	profile;
 
@@ -116,7 +115,8 @@ static void usage(void)
 	fprintf(stderr, _("Usage: %s [-c|-l filename] [-b block-size] "
 	"[-C cluster-size]\n\t[-i bytes-per-inode] [-I inode-size] "
 	"[-J journal-options]\n"
-	"\t[-G flex-group-size] [-N number-of-inodes]\n"
+	"\t[-G flex-group-size] [-N number-of-inodes] "
+	"[-d root-directory]\n"
 	"\t[-m reserved-blocks-percentage] [-o creator-os]\n"
 	"\t[-g blocks-per-group] [-L volume-label] "
 	"[-M last-mounted-directory]\n\t[-O feature[,...]] "
@@ -1386,7 +1386,7 @@ profile_error:
 	}
 
 	while ((c = getopt (argc, argv,
-		    "b:cg:i:jl:m:no:qr:s:t:vC:DE:FG:I:J:KL:M:N:O:R:ST:U:V")) != EOF) {
+		    "b:cg:i:jl:m:no:qr:s:t:d:vC:DE:FG:I:J:KL:M:N:O:R:ST:U:V")) != EOF) {
 		switch (c) {
 		case 'b':
 			blocksize = parse_num_blocks2(optarg, -1);
@@ -1572,6 +1572,9 @@ profile_error:
 		case 'U':
 			fs_uuid = optarg;
 			break;
+		case 'd':
+			root_dir = optarg;
+			break;
 		case 'v':
 			verbose = 1;
 			break;
@@ -2773,7 +2776,6 @@ no_journal:
 		       "filesystem accounting information: "));
 	checkinterval = fs->super->s_checkinterval;
 	max_mnt_count = fs->super->s_max_mnt_count;
-	retval = ext2fs_close(fs);
 	if (retval) {
 		fprintf(stderr,
 			_("\nWarning, had trouble writing out superblocks."));
@@ -2789,5 +2791,32 @@ no_journal:
 	for (i=0; fs_types[i]; i++)
 		free(fs_types[i]);
 	free(fs_types);
+
+	/* Copy files from the specified directory */
+	if (root_dir) {
+		if (!quiet)
+			printf(_("Copying files into the device...\n"));
+
+		/*
+		 * Allocate memory for the hardlinks, we don't need free()
+		 * since the lifespan will be over after the fs populated.
+		 */
+		if ((hdlinks.hdl = (struct hdlink_s *)
+				malloc(hdlink_cnt * sizeof(struct hdlink_s))) == NULL) {
+			fprintf(stderr, _("\nNot enough memory"));
+			retval = ext2fs_close(fs);
+			return retval;
+		}
+
+		current_fs = fs;
+		root = EXT2_ROOT_INO;
+		retval = populate_fs(root, root_dir);
+		if (retval)
+			fprintf(stderr,
+				_("\nError while populating %s"), root_dir);
+	}
+
+	retval = ext2fs_close(fs);
+
 	return retval;
 }
diff --git a/misc/util.c b/misc/util.c
index 6c93e1c..cbc7cc0 100644
--- a/misc/util.c
+++ b/misc/util.c
@@ -32,8 +32,18 @@
 #include "ext2fs/ext2fs.h"
 #include "nls-enable.h"
 #include "blkid/blkid.h"
+
+#include <fcntl.h>
+
 #include "util.h"
 
+int	journal_size;
+int	journal_flags;
+char	*journal_device;
+
+/* For saving the hard links */
+int hdlink_cnt = HDLINK_CNT;
+
 #ifndef HAVE_STRCASECMP
 int strcasecmp (char *s1, char *s2)
 {
@@ -303,3 +313,28 @@ void dump_mmp_msg(struct mmp_struct *mmp, const char *msg)
 		       ctime(&t), mmp->mmp_nodename, mmp->mmp_bdevname);
 	}
 }
+
+/* Make a special file which is block, character and fifo */
+errcode_t do_mknod_internal(ext2_ino_t cwd, const char *name, struct stat *st)
+{
+}
+
+/* Make a symlink name -> target */
+errcode_t do_symlink_internal(ext2_ino_t cwd, const char *name, char *target)
+{
+}
+
+/* Make a directory in the fs */
+errcode_t do_mkdir_internal(ext2_ino_t cwd, const char *name, struct stat *st)
+{
+}
+
+/* Copy the native file to the fs */
+errcode_t do_write_internal(ext2_ino_t cwd, const char *src, const char *dest)
+{
+}
+
+/* Copy files from source_dir to fs */
+errcode_t populate_fs(ext2_ino_t parent_ino, const char *source_dir)
+{
+}
diff --git a/misc/util.h b/misc/util.h
index f872c38..e71caf0 100644
--- a/misc/util.h
+++ b/misc/util.h
@@ -14,6 +14,31 @@ extern int	 journal_size;
 extern int	 journal_flags;
 extern char	*journal_device;
 
+/* For struct stat */
+#include <sys/types.h>
+#include <sys/stat.h>
+
+struct hdlink_s
+{
+	ext2_ino_t src_ino;
+	ext2_ino_t dst_ino;
+};
+
+struct hdlinks_s
+{
+	int count;
+	struct hdlink_s *hdl;
+};
+
+struct hdlinks_s hdlinks;
+
+ext2_filsys	current_fs;
+ext2_ino_t	root;
+
+/* For saving the hard links */
+#define HDLINK_CNT	4
+extern int hdlink_cnt;
+
 #ifndef HAVE_STRCASECMP
 extern int strcasecmp (char *s1, char *s2);
 #endif
@@ -25,3 +50,10 @@ extern void check_mount(const char *device, int force, const char *type);
 extern unsigned int figure_journal_size(int size, ext2_filsys fs);
 extern void print_check_message(int, unsigned int);
 extern void dump_mmp_msg(struct mmp_struct *mmp, const char *msg);
+
+/* For populating the filesystem */
+extern errcode_t populate_fs(ext2_ino_t parent_ino, const char *source_dir);
+extern errcode_t do_mknod_internal(ext2_ino_t cwd, const char *name, struct stat *st);
+extern errcode_t do_symlink_internal(ext2_ino_t cwd, const char *name, char *target);
+extern errcode_t do_mkdir_internal(ext2_ino_t cwd, const char *name, struct stat *st);
+extern errcode_t do_write_internal(ext2_ino_t cwd, const char *src, const char *dest);
-- 
1.8.1.2

