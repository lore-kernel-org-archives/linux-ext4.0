From: Andreas Dilger <adilger@whamcloud.com>
Subject: [PATCH 1/2] misc: Allow "-E" and "-O" options multiple times
Date: Fri,  8 Jul 2011 18:49:03 -0600
Message-ID: <1310172544-18650-1-git-send-email-adilger@whamcloud.com>
Cc: Jim Garlick <garlick@llnl.gov>,
	Andreas Dilger <adilger@whamcloud.com>
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:58734 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab1GIAtH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Jul 2011 20:49:07 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Allow "-E" and "-O" options to be specified multiple times on the
command-line for mke2fs, tune2fs, and e2fsck, and parse them after
the config file options to more closely match user expectations.

It isn't correct to just parse these options as they are given,
since there may be a dependency on other options being specified
(e.g. blocksize), so the options are accumulated until all parsing
is finished, to avoid different behaviour if the other options are
given in a different order (e.g. passing "-E resize=40M -b 4096" might
behave differently from "-b 4096 -E resize=40M" on some filesystems).

Signed-off-by: Jim Garlick <garlick@llnl.gov>
Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
---
 e2fsck/e2fsck.h         |    2 ++
 e2fsck/unix.c           |   28 +++++++++++++++++-----------
 e2fsck/util.c           |   26 ++++++++++++++++++++++++++
 misc/mke2fs.c           |   35 +++++++++++++++++++++++++----------
 misc/tune2fs.c          |   21 ++++++++++++++-------
 misc/util.c             |   26 ++++++++++++++++++++++++++
 misc/util.h             |    2 ++
 tests/m_raid_opt/script |    2 +-
 8 files changed, 113 insertions(+), 29 deletions(-)

diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index b4a1a88..2574824 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -367,6 +367,8 @@ typedef struct region_struct *region_t;
 extern int e2fsck_strnlen(const char * s, int count);
 #endif
 
+extern errcode_t append_opts(char **old_opts, const char *added_opts);
+
 /*
  * Procedure declarations
  */
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 7e95ca8..0830175 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -618,14 +618,13 @@ static void parse_extended_opts(e2fsck_t ctx, const char *opts)
 				continue;
 			}
 			ea_ver = strtoul(arg, &p, 0);
-			if (*p ||
-			    ((ea_ver != 1) && (ea_ver != 2))) {
-				fprintf(stderr,
-					_("Invalid EA version.\n"));
+			if (*p == '\0' && (ea_ver == 1 || ea_ver == 2)) {
+				ctx->ext_attr_ver = ea_ver;
+			} else {
+				fprintf(stderr, _("Invalid EA version.\n"));
 				extended_usage++;
 				continue;
 			}
-			ctx->ext_attr_ver = ea_ver;
 		} else if (strcmp(token, "fragcheck") == 0) {
 			ctx->options |= E2F_OPT_FRAGCHECK;
 			continue;
@@ -686,11 +685,11 @@ static errcode_t PRS(int argc, char *argv[], e2fsck_t *ret_ctx)
 #ifdef HAVE_SIGNAL_H
 	struct sigaction	sa;
 #endif
-	char		*extended_opts = 0;
+	char		*extended_opts = NULL;
 	char		*cp;
-	int 		res;		/* result of sscanf */
+	int		res;		/* result of sscanf */
 #ifdef CONFIG_JBD_DEBUG
-	char 		*jbd_debug;
+	char		*jbd_debug;
 #endif
 
 	retval = e2fsck_allocate_context(&ctx);
@@ -748,7 +747,13 @@ static errcode_t PRS(int argc, char *argv[], e2fsck_t *ret_ctx)
 			ctx->options |= E2F_OPT_COMPRESS_DIRS;
 			break;
 		case 'E':
-			extended_opts = optarg;
+			retval = append_opts(&extended_opts, optarg);
+			if (retval) {
+				com_err(ctx->program_name, retval,
+					_("reallocating for options '%s'"),
+					optarg);
+				fatal_error(ctx, NULL);
+			}
 			break;
 		case 'p':
 		case 'a':
@@ -883,14 +888,15 @@ static errcode_t PRS(int argc, char *argv[], e2fsck_t *ret_ctx)
 			argv[optind]);
 		fatal_error(ctx, 0);
 	}
-	if (extended_opts)
-		parse_extended_opts(ctx, extended_opts);
 
 	if ((cp = getenv("E2FSCK_CONFIG")) != NULL)
 		config_fn[0] = cp;
 	profile_set_syntax_err_cb(syntax_err_report);
 	profile_init(config_fn, &ctx->profile);
 
+	if (extended_opts)
+		parse_extended_opts(ctx, extended_opts);
+
 	if (flush) {
 		fd = open(ctx->filesystem_name, O_RDONLY, 0);
 		if (fd < 0) {
diff --git a/e2fsck/util.c b/e2fsck/util.c
index fb9a87a..cb6c569 100644
--- a/e2fsck/util.c
+++ b/e2fsck/util.c
@@ -109,6 +109,32 @@ int e2fsck_strnlen(const char * s, int count)
 }
 #endif
 
+errcode_t append_opts(char **old_opts, const char *added_opts)
+{
+	/* First string adds NUL, others add ',' */
+	int newlen, oldlen = 0;
+	errcode_t retval;
+
+	if (*old_opts != NULL)
+		oldlen = strlen(*old_opts);
+
+	newlen = oldlen + strlen(added_opts) + 1;
+
+	retval = ext2fs_resize_mem(oldlen, newlen, old_opts);
+	if (retval != 0)
+		return retval;
+
+	if (oldlen != 0) {
+		if ((*old_opts)[oldlen - 1] !=',')
+			strcat(*old_opts, ",");
+		strcat(*old_opts, added_opts);
+	} else {
+		strcpy(*old_opts, added_opts);
+	}
+
+	return 0;
+}
+
 #ifndef HAVE_CONIO_H
 static int read_a_char(void)
 {
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index e062bda..e9711f0 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1178,7 +1178,7 @@ static void PRS(int argc, char *argv[])
 {
 	int		b, c;
 	int		cluster_size = 0;
-	char 		*tmp, **cpp;
+	char		*tmp, **cpp;
 	int		blocksize = 0;
 	int		inode_ratio = 0;
 	int		inode_size = 0;
@@ -1188,18 +1188,18 @@ static void PRS(int argc, char *argv[])
 	int		show_version_only = 0;
 	unsigned long long num_inodes = 0; /* unsigned long long to catch too-large input */
 	errcode_t	retval;
-	char *		oldpath = getenv("PATH");
-	char *		extended_opts = 0;
-	char *		fs_type = 0;
-	char *		usage_types = 0;
+	char		*oldpath = getenv("PATH");
+	char		*extended_opts = NULL;
+	char		*fs_type = NULL;
+	char		*usage_types = NULL;
 	blk64_t		dev_size;
 	blk64_t		fs_blocks_count = 0;
 #ifdef __linux__
-	struct 		utsname ut;
+	struct		utsname ut;
 #endif
 	long		sysval;
 	int		s_opt = -1, r_opt = -1;
-	char		*fs_features = 0;
+	char		*fs_features = NULL;
 	int		use_bsize;
 	char		*newpath;
 	int		pathlen = sizeof(PATH_SET) + 1;
@@ -1436,11 +1436,26 @@ profile_error:
 			}
 			break;
 		case 'O':
-			fs_features = optarg;
+			retval = append_opts(&fs_features, optarg);
+			if (retval) {
+				com_err(program_name, retval,
+					_("reallocating for options '%s'"),
+					optarg);
+				exit(1);
+			}
 			break;
-		case 'E':
 		case 'R':
-			extended_opts = optarg;
+			fprintf(stderr, _("Warning: '-R option' is deprecated "
+					  "and should not be used anymore. "
+					  "Use '-E option' instead!\n"));
+		case 'E':
+			retval = append_opts(&extended_opts, optarg);
+			if (retval) {
+				com_err(program_name, retval,
+					_("reallocating for options '%s'"),
+					optarg);
+				exit(1);
+			}
 			break;
 		case 'S':
 			super_only = 1;
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 5bf5187..672fe20 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -637,6 +637,7 @@ static void parse_tune2fs_options(int argc, char **argv)
 	char *tmp;
 	struct group *gr;
 	struct passwd *pw;
+	errcode_t retval;
 
 	open_flag = 0;
 
@@ -684,7 +685,13 @@ static void parse_tune2fs_options(int argc, char **argv)
 			open_flag = EXT2_FLAG_RW;
 			break;
 		case 'E':
-			extended_cmd = optarg;
+			retval = append_opts(&extended_cmd, optarg);
+			if (retval) {
+				com_err(program_name, retval,
+					_("reallocating for options '%s'"),
+					optarg);
+				exit(1);
+			}
 			open_flag |= EXT2_FLAG_RW;
 			break;
 		case 'f': /* Force */
@@ -786,14 +793,14 @@ static void parse_tune2fs_options(int argc, char **argv)
 			mntopts_cmd = optarg;
 			open_flag = EXT2_FLAG_RW;
 			break;
-			
 		case 'O':
-			if (features_cmd) {
-				com_err(program_name, 0,
-					_("-O may only be specified once"));
-				usage();
+			retval = append_opts(&features_cmd, optarg);
+			if (retval) {
+				com_err(program_name, retval,
+					_("reallocating for options '%s'"),
+					optarg);
+				exit(1);
 			}
-			features_cmd = optarg;
 			open_flag = EXT2_FLAG_RW;
 			break;
 		case 'r':
diff --git a/misc/util.c b/misc/util.c
index 51bdb60..5ec479d 100644
--- a/misc/util.c
+++ b/misc/util.c
@@ -174,6 +174,32 @@ void check_mount(const char *device, int force, const char *type)
 	}
 }
 
+errcode_t append_opts(char **old_opts, const char *added_opts)
+{
+	/* First string adds NUL, others add ',' */
+	int newlen, oldlen = 0;
+	errcode_t retval;
+
+	if (*old_opts != NULL)
+		oldlen = strlen(*old_opts);
+
+	newlen = oldlen + strlen(added_opts) + 1;
+
+	retval = ext2fs_resize_mem(oldlen, newlen, old_opts);
+	if (retval)
+		return retval;
+
+	if (oldlen != 0) {
+		if ((*old_opts)[oldlen - 1] !=',')
+			strcat(*old_opts, ",");
+		strcat(*old_opts, added_opts);
+	} else {
+		strcpy(*old_opts, added_opts);
+	}
+
+	return 0;
+}
+
 void parse_journal_opts(const char *opts)
 {
 	char	*buf, *token, *next, *p, *arg;
diff --git a/misc/util.h b/misc/util.h
index e0c99f6..afbb700 100644
--- a/misc/util.h
+++ b/misc/util.h
@@ -24,3 +24,5 @@ extern void parse_journal_opts(const char *opts);
 extern void check_mount(const char *device, int force, const char *type);
 extern unsigned int figure_journal_size(int size, ext2_filsys fs);
 extern void print_check_message(ext2_filsys fs);
+extern errcode_t append_opts(char **old_opts, const char *added_opts);
+
diff --git a/tests/m_raid_opt/script b/tests/m_raid_opt/script
index 1e47cc1..296fe94 100644
--- a/tests/m_raid_opt/script
+++ b/tests/m_raid_opt/script
@@ -1,4 +1,4 @@
 DESCRIPTION="raid options"
 FS_SIZE=131072
-MKE2FS_OPTS="-R stride=13 -O sparse_super -g 1024"
+MKE2FS_OPTS="-E stride=13 -O sparse_super -g 1024"
 . $cmd_dir/run_mke2fs
-- 
1.7.3.4

