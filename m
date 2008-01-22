From: Theodore Tso <tytso@MIT.EDU>
Subject: [PATCH, RFC] Add new "development flag" to the ext4 filesystem
Date: Tue, 22 Jan 2008 18:17:08 -0500
Message-ID: <20080122231707.GA21968@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="liOOAslEiF7prFVr"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:58023 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753393AbYAVXRL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Jan 2008 18:17:11 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

As discussed on RFC, this flag is simply a generic "this is a
crash/burn test filesystem" marker.  If it is set, then filesystem
code which is "in development" will be allowed to mount the
filesystem.  Filesystem code which is not considered ready for
prime-time will check for this flag, and if it is not set, it will
refuse to touch the filesystem.

As we start rolling ext4 out to distro's like Fedora, et. al, this
makes it less likely that a user might accidentally start using ext4
on a production filesystem; a bad thing, since that will essentially
make it be unfsckable until e2fsprogs catches up.

						- Ted


--liOOAslEiF7prFVr
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="kernel.patch"

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index cf2f612..a8c599a 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1991,6 +1991,17 @@ static int ext4_fill_super (struct super_block *sb, void *data, int silent)
 		printk(KERN_WARNING
 		       "EXT4-fs warning: feature flags set on rev 0 fs, "
 		       "running e2fsck is recommended\n");
+
+	/*
+	 * Since ext4 is still considered development code, we require
+	 * that the TEST_FILESYS flag in s->flags be set.
+	 */
+	if (!(le32_to_cpu(es->s_flags) & EXT2_FLAGS_TEST_FILESYS)) {
+		printk(KERN_WARNING, "EXT4-fs: %s: test filesystem flag "
+		       "not set.\n");
+		goto failed_mount;
+	}
+
 	/*
 	 * Check feature flags regardless of the revision level, since we
 	 * previously didn't change the revision level when setting the flags,
diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index 98d1c3c..d203543 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -547,6 +547,13 @@ do {									       \
 #define	EXT4_ORPHAN_FS			0x0004	/* Orphans being recovered */
 
 /*
+ * Misc. filesystem flags
+ */
+#define EXT2_FLAGS_SIGNED_HASH		0x0001  /* Signed dirhash in use */
+#define EXT2_FLAGS_UNSIGNED_HASH	0x0002  /* Unsigned dirhash in use */
+#define EXT2_FLAGS_TEST_FILESYS		0x0004	/* OK for use on development code */
+
+/*
  * Mount flags
  */
 #define EXT4_MOUNT_CHECK		0x00001	/* Do mount-time checks */

--liOOAslEiF7prFVr
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="e2fsprogs.patch"

diff --git a/lib/e2p/ls.c b/lib/e2p/ls.c
index b9ae14a..957ba5b 100644
--- a/lib/e2p/ls.c
+++ b/lib/e2p/ls.c
@@ -147,11 +147,15 @@ static void print_super_flags(struct ext2_super_block * s, FILE *f)
 
 	fputs("Filesystem flags:         ", f);
 	if (s->s_flags & EXT2_FLAGS_SIGNED_HASH) {
-		fputs("signed directory hash ", f);
+		fputs("signed_directory_hash ", f);
 		flags_found++;
 	}
 	if (s->s_flags & EXT2_FLAGS_UNSIGNED_HASH) {
-		fputs("unsigned directory hash ", f);
+		fputs("unsigned_directory_hash ", f);
+		flags_found++;
+	}
+	if (s->s_flags & EXT2_FLAGS_TEST_FILESYS) {
+		fputs("test_filesystem ", f);
 		flags_found++;
 	}
 	if (flags_found)
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index e096577..dd5e495 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -467,12 +467,14 @@ struct ext2_inode_large {
  */
 #define EXT2_VALID_FS			0x0001	/* Unmounted cleanly */
 #define EXT2_ERROR_FS			0x0002	/* Errors detected */
+#define EXT4_ORPHAN_FS			0x0004	/* Orphans being recovered */
 
 /*
  * Misc. filesystem flags
  */
 #define EXT2_FLAGS_SIGNED_HASH		0x0001  /* Signed dirhash in use */
 #define EXT2_FLAGS_UNSIGNED_HASH	0x0002  /* Unsigned dirhash in use */
+#define EXT2_FLAGS_TEST_FILESYS		0x0004	/* OK for use on development code */
 
 /*
  * Mount flags
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 7a360ea..e754d6b 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -849,6 +849,8 @@ static void parse_extended_opts(struct ext2_super_block *param,
 
 				param->s_reserved_gdt_blocks = rsv_gdb;
 			}
+		} else if (!strcmp(token, "test_fs")) {
+			param->s_flags |= EXT2_FLAGS_TEST_FILESYS;
 		} else
 			r_usage++;
 	}
@@ -859,7 +861,8 @@ static void parse_extended_opts(struct ext2_super_block *param,
 			"\tis set off by an equals ('=') sign.\n\n"
 			"Valid extended options are:\n"
 			"\tstride=<stride length in blocks>\n"
-			"\tresize=<resize maximum size in blocks>\n\n"));
+			"\tresize=<resize maximum size in blocks>\n"
+			"\ttest_fs\n"));
 		free(buf);
 		exit(1);
 	}
@@ -1556,6 +1559,9 @@ int main (int argc, char *argv[])
 		exit(1);
 	}
 
+	if (fs_param.s_flags & EXT2_FLAGS_TEST_FILESYS)
+		fs->super->s_flags |= EXT2_FLAGS_TEST_FILESYS;
+
 	/*
 	 * Wipe out the old on-disk superblock
 	 */
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 833b994..a714530 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -71,6 +71,7 @@ static unsigned short errors;
 static int open_flag;
 static char *features_cmd;
 static char *mntopts_cmd;
+static char *extended_cmd;
 
 int journal_size, journal_flags;
 char *journal_device;
@@ -505,7 +506,7 @@ static void parse_tune2fs_options(int argc, char **argv)
 	struct passwd * pw;
 
 	printf("tune2fs %s (%s)\n", E2FSPROGS_VERSION, E2FSPROGS_DATE);
-	while ((c = getopt(argc, argv, "c:e:fg:i:jlm:o:r:s:u:C:J:L:M:O:T:U:")) != EOF)
+	while ((c = getopt(argc, argv, "c:e:fg:i:jlm:o:r:s:u:C:E:J:L:M:O:T:U:")) != EOF)
 		switch (c)
 		{
 			case 'c':
@@ -548,6 +549,10 @@ static void parse_tune2fs_options(int argc, char **argv)
 				e_flag = 1;
 				open_flag = EXT2_FLAG_RW;
 				break;
+			case 'E':
+				extended_cmd = optarg;
+				open_flag = EXT2_FLAG_RW;
+				break;
 			case 'f': /* Force */
 				f_flag = 1;
 				break;
@@ -739,6 +744,56 @@ void do_findfs(int argc, char **argv)
 	exit(0);
 }
 
+static void parse_extended_opts(ext2_filsys fs, const char *opts)
+{
+	char	*buf, *token, *next, *p, *arg;
+	int	len;
+	int	r_usage = 0;
+
+	len = strlen(opts);
+	buf = malloc(len+1);
+	if (!buf) {
+		fprintf(stderr,
+			_("Couldn't allocate memory to parse options!\n"));
+		exit(1);
+	}
+	strcpy(buf, opts);
+	for (token = buf; token && *token; token = next) {
+		p = strchr(token, ',');
+		next = 0;
+		if (p) {
+			*p = 0;
+			next = p+1;
+		}
+		arg = strchr(token, '=');
+		if (arg) {
+			*arg = 0;
+			arg++;
+		}
+		if (!strcmp(token, "test_fs")) {
+			fs->super->s_flags |= EXT2_FLAGS_TEST_FILESYS;
+			printf("Setting test filesystem flag\n");
+			ext2fs_mark_super_dirty(fs);
+		} else if (!strcmp(token, "production_fs")) {
+			fs->super->s_flags &= ~EXT2_FLAGS_TEST_FILESYS;
+			printf("Clearing test filesystem flag\n");
+			ext2fs_mark_super_dirty(fs);
+		} else
+			r_usage++;
+	}
+	if (r_usage) {
+		fprintf(stderr, _("\nBad options specified.\n\n"
+			"Extended options are separated by commas, "
+			"and may take an argument which\n"
+			"\tis set off by an equals ('=') sign.\n\n"
+			"Valid extended options are:\n"
+			"\ttestfs\n"));
+		free(buf);
+		exit(1);
+	}
+	free(buf);
+}	
+
 
 int main (int argc, char ** argv)
 {
@@ -902,6 +957,8 @@ int main (int argc, char ** argv)
 		update_mntopts(fs, mntopts_cmd);
 	if (features_cmd)
 		update_feature_set(fs, features_cmd);
+	if (extended_cmd)
+		parse_extended_opts(fs, extended_cmd);
 	if (journal_size || journal_device)
 		add_journal(fs);
 	

--liOOAslEiF7prFVr--
