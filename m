From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/2] debugfs: fix gcc -Wall complaints
Date: Thu, 17 Nov 2011 16:12:44 -0500
Message-ID: <1321564364-22803-2-git-send-email-tytso@mit.edu>
References: <1321564364-22803-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33085 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843Ab1KQVMp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Nov 2011 16:12:45 -0500
In-Reply-To: <1321564364-22803-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 debugfs/debugfs.c    |    8 +++---
 debugfs/debugfs.h    |    3 ++
 debugfs/filefrag.c   |    2 +-
 debugfs/set_fields.c |   55 ++++++++++++++++++++++++++-----------------------
 misc/e2freefrag.c    |   44 +++++++++++++++++++++------------------
 5 files changed, 61 insertions(+), 51 deletions(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index fda8d92..5751004 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -284,7 +284,6 @@ void do_init_filesys(int argc, char **argv)
 	root = cwd = EXT2_ROOT_INO;
 	return;
 }
-#endif /* READ_ONLY */
 
 static void print_features(struct ext2_super_block * s, FILE *f)
 {
@@ -304,6 +303,7 @@ static void print_features(struct ext2_super_block * s, FILE *f)
 		fputs("(none)", f);
 	fputs("\n", f);
 }
+#endif /* READ_ONLY */
 
 static void print_bg_opts(ext2_filsys fs, dgrp_t group, int mask,
 			  const char *str, int *first, FILE *f)
@@ -933,7 +933,7 @@ void do_dump_extents(int argc, char **argv)
 
 static int print_blocks_proc(ext2_filsys fs EXT2FS_ATTR((unused)),
 			     blk64_t *blocknr,
-			     e2_blkcnt_t blockcnt,
+			     e2_blkcnt_t blockcnt EXT2FS_ATTR((unused)),
 			     blk64_t ref_block EXT2FS_ATTR((unused)),
 			     int ref_offset EXT2FS_ATTR((unused)),
 			     void *private EXT2FS_ATTR((unused)))
@@ -1286,6 +1286,7 @@ void do_print_working_directory(int argc, char *argv[])
 	return;
 }
 
+#ifndef READ_ONLY
 /*
  * Given a mode, return the ext2 file type
  */
@@ -1315,7 +1316,6 @@ static int ext2_file_type(unsigned int mode)
 	return 0;
 }
 
-#ifndef READ_ONLY
 static void make_link(char *sourcename, char *destname)
 {
 	ext2_ino_t	ino;
@@ -2190,7 +2190,7 @@ void do_punch(int argc, char *argv[])
 }
 #endif /* READ_ONLY */
 
-void do_dump_mmp(int argc, char *argv[])
+void do_dump_mmp(int argc EXT2FS_ATTR((unused)), char *argv[])
 {
 	struct ext2_super_block *sb;
 	struct mmp_struct *mmp_s;
diff --git a/debugfs/debugfs.h b/debugfs/debugfs.h
index 0afa1df..eb044b1 100644
--- a/debugfs/debugfs.h
+++ b/debugfs/debugfs.h
@@ -133,5 +133,8 @@ extern void do_set_current_time(int argc, char **argv);
 extern void do_supported_features(int argc, char **argv);
 extern void do_punch(int argc, char **argv);
 
+extern void do_dump_mmp(int argc, char **argv);
+extern void do_set_mmp_value(int argc, char **argv);
+
 extern void do_freefrag(int argc, char **argv);
 extern void do_filefrag(int argc, char *argv[]);
diff --git a/debugfs/filefrag.c b/debugfs/filefrag.c
index 30933b6..7f28bc0 100644
--- a/debugfs/filefrag.c
+++ b/debugfs/filefrag.c
@@ -271,7 +271,7 @@ void do_filefrag(int argc, char *argv[])
 		return;
 
 	reset_getopt();
-	while ((c = getopt (argc, argv, "dvr")) != EOF) {
+	while ((c = getopt(argc, argv, "dvr")) != EOF) {
 		switch (c) {
 		case 'd':
 			fs.options |= DIR_OPT;
diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
index 0041160..08bfd8d 100644
--- a/debugfs/set_fields.c
+++ b/debugfs/set_fields.c
@@ -44,6 +44,7 @@ static struct ext2_super_block set_sb;
 static struct ext2_inode_large set_inode;
 static struct ext2_group_desc set_gd;
 static struct ext4_group_desc set_gd4;
+static struct mmp_struct set_mmp;
 static dgrp_t set_bg;
 static ext2_ino_t set_ino;
 static int array_idx;
@@ -68,6 +69,8 @@ static errcode_t parse_hashalg(struct field_set_info *info, char *field, char *a
 static errcode_t parse_time(struct field_set_info *info, char *field, char *arg);
 static errcode_t parse_bmap(struct field_set_info *info, char *field, char *arg);
 static errcode_t parse_gd_csum(struct field_set_info *info, char *field, char *arg);
+static errcode_t parse_mmp_clear(struct field_set_info *info, char *field,
+				 char *arg);
 
 static struct field_set_info super_fields[] = {
 	{ "inodes_count", &set_sb.s_inodes_count, NULL, 4, parse_uint },
@@ -242,8 +245,17 @@ static struct field_set_info ext4_bg_fields[] = {
 	{ 0, 0, 0, 0 }
 };
 
-/* forward declaration */
-static struct field_set_info mmp_fields[];
+static struct field_set_info mmp_fields[] = {
+	{ "clear", &set_mmp.mmp_magic, NULL, sizeof(set_mmp), parse_mmp_clear },
+	{ "magic", &set_mmp.mmp_magic, NULL, 4, parse_uint },
+	{ "seq", &set_mmp.mmp_seq, NULL, 4, parse_uint },
+	{ "time", &set_mmp.mmp_time, NULL, 8, parse_uint },
+	{ "nodename", &set_mmp.mmp_nodename, NULL, sizeof(set_mmp.mmp_nodename),
+		parse_string },
+	{ "bdevname", &set_mmp.mmp_bdevname, NULL, sizeof(set_mmp.mmp_bdevname),
+		parse_string },
+	{ "check_interval", &set_mmp.mmp_check_interval, NULL, 2, parse_uint },
+};
 
 static int check_suffix(const char *field)
 {
@@ -412,7 +424,8 @@ static errcode_t parse_uint(struct field_set_info *info, char *field,
 	return 0;
 }
 
-static errcode_t parse_int(struct field_set_info *info, char *field, char *arg)
+static errcode_t parse_int(struct field_set_info *info,
+			   char *field EXT2FS_ATTR((unused)), char *arg)
 {
 	long	num;
 	char *tmp;
@@ -443,8 +456,8 @@ static errcode_t parse_int(struct field_set_info *info, char *field, char *arg)
 	return 0;
 }
 
-static errcode_t parse_string(struct field_set_info *info, char *field,
-			      char *arg)
+static errcode_t parse_string(struct field_set_info *info,
+			      char *field EXT2FS_ATTR((unused)), char *arg)
 {
 	char	*cp = (char *) info->ptr;
 
@@ -457,7 +470,8 @@ static errcode_t parse_string(struct field_set_info *info, char *field,
 	return 0;
 }
 
-static errcode_t parse_time(struct field_set_info *info, char *field, char *arg)
+static errcode_t parse_time(struct field_set_info *info,
+			    char *field EXT2FS_ATTR((unused)), char *arg)
 {
 	time_t		t;
 	__u32		*ptr32;
@@ -475,7 +489,8 @@ static errcode_t parse_time(struct field_set_info *info, char *field, char *arg)
 	return 0;
 }
 
-static errcode_t parse_uuid(struct field_set_info *info, char *field, char *arg)
+static errcode_t parse_uuid(struct field_set_info *info,
+			    char *field EXT2FS_ATTR((unused)), char *arg)
 {
 	unsigned char *	p = (unsigned char *) info->ptr;
 
@@ -493,8 +508,8 @@ static errcode_t parse_uuid(struct field_set_info *info, char *field, char *arg)
 	return 0;
 }
 
-static errcode_t parse_hashalg(struct field_set_info *info, char *field,
-			       char *arg)
+static errcode_t parse_hashalg(struct field_set_info *info,
+			       char *field EXT2FS_ATTR((unused)), char *arg)
 {
 	int	hashv;
 	unsigned char	*p = (unsigned char *) info->ptr;
@@ -508,8 +523,8 @@ static errcode_t parse_hashalg(struct field_set_info *info, char *field,
 	return 0;
 }
 
-static errcode_t parse_bmap(struct field_set_info *info, char *field,
-			    char *arg)
+static errcode_t parse_bmap(struct field_set_info *info,
+			    char *field EXT2FS_ATTR((unused)), char *arg)
 {
 	unsigned long	num;
 	blk_t		blk;
@@ -733,8 +748,9 @@ void do_set_block_group_descriptor(int argc, char *argv[])
 	}
 }
 
-static errcode_t parse_mmp_clear(struct field_set_info *info, char *field,
-				 char *arg)
+static errcode_t parse_mmp_clear(struct field_set_info *info,
+				 char *field EXT2FS_ATTR((unused)),
+				 char *arg EXT2FS_ATTR((unused)))
 {
 	errcode_t retval;
 
@@ -747,19 +763,6 @@ static errcode_t parse_mmp_clear(struct field_set_info *info, char *field,
 	return 1; /* we don't need the MMP block written again */
 }
 
-struct mmp_struct set_mmp;
-static struct field_set_info mmp_fields[] = {
-	{ "clear", &set_mmp.mmp_magic, NULL, sizeof(set_mmp), parse_mmp_clear },
-	{ "magic", &set_mmp.mmp_magic, NULL, 4, parse_uint },
-	{ "seq", &set_mmp.mmp_seq, NULL, 4, parse_uint },
-	{ "time", &set_mmp.mmp_time, NULL, 8, parse_uint },
-	{ "nodename", &set_mmp.mmp_nodename, NULL, sizeof(set_mmp.mmp_nodename),
-		parse_string },
-	{ "bdevname", &set_mmp.mmp_bdevname, NULL, sizeof(set_mmp.mmp_bdevname),
-		parse_string },
-	{ "check_interval", &set_mmp.mmp_check_interval, NULL, 2, parse_uint },
-};
-
 void do_set_mmp_value(int argc, char *argv[])
 {
 	const char *usage = "<field> <value>\n"
diff --git a/misc/e2freefrag.c b/misc/e2freefrag.c
index 0964e66..30af43e 100644
--- a/misc/e2freefrag.c
+++ b/misc/e2freefrag.c
@@ -30,7 +30,7 @@ extern int optind;
 #include "ext2fs/ext2fs.h"
 #include "e2freefrag.h"
 
-void usage(const char *prog)
+static void usage(const char *prog)
 {
 	fprintf(stderr, "usage: %s [-c chunksize in kb] [-h] "
 		"device_name\n", prog);
@@ -51,7 +51,7 @@ static int ul_log2(unsigned long arg)
         return l;
 }
 
-void init_chunk_info(ext2_filsys fs, struct chunk_info *info)
+static void init_chunk_info(ext2_filsys fs, struct chunk_info *info)
 {
 	int i;
 
@@ -74,15 +74,16 @@ void init_chunk_info(ext2_filsys fs, struct chunk_info *info)
 	}
 }
 
-void update_chunk_stats(struct chunk_info *info, unsigned long chunk_size)
+static void update_chunk_stats(struct chunk_info *info,
+			       unsigned long chunk_size)
 {
-	unsigned long index;
+	unsigned long idx;
 
-	index = ul_log2(chunk_size) + 1;
-	if (index >= MAX_HIST)
-		index = MAX_HIST-1;
-	info->histogram.fc_chunks[index]++;
-	info->histogram.fc_blocks[index] += chunk_size;
+	idx = ul_log2(chunk_size) + 1;
+	if (idx >= MAX_HIST)
+		idx = MAX_HIST-1;
+	info->histogram.fc_chunks[idx]++;
+	info->histogram.fc_blocks[idx] += chunk_size;
 
 	if (chunk_size > info->max)
 		info->max = chunk_size;
@@ -92,7 +93,7 @@ void update_chunk_stats(struct chunk_info *info, unsigned long chunk_size)
 	info->real_free_chunks++;
 }
 
-void scan_block_bitmap(ext2_filsys fs, struct chunk_info *info)
+static void scan_block_bitmap(ext2_filsys fs, struct chunk_info *info)
 {
 	unsigned long long blocks_count = ext2fs_blocks_count(fs->super);
 	unsigned long long chunks = (blocks_count + info->blks_in_chunk) >>
@@ -142,10 +143,11 @@ void scan_block_bitmap(ext2_filsys fs, struct chunk_info *info)
 		update_chunk_stats(info, last_chunk_size);
 }
 
-errcode_t get_chunk_info(ext2_filsys fs, struct chunk_info *info, FILE *f)
+static errcode_t get_chunk_info(ext2_filsys fs, struct chunk_info *info,
+				FILE *f)
 {
 	unsigned long total_chunks;
-	char *unitp = "KMGTPEZY";
+	const char *unitp = "KMGTPEZY";
 	int units = 10;
 	unsigned long start = 0, end;
 	int i, retval = 0;
@@ -211,7 +213,7 @@ errcode_t get_chunk_info(ext2_filsys fs, struct chunk_info *info, FILE *f)
 	return retval;
 }
 
-void close_device(char *device_name, ext2_filsys fs)
+static void close_device(char *device_name, ext2_filsys fs)
 {
 	int retval = ext2fs_close(fs);
 
@@ -219,7 +221,7 @@ void close_device(char *device_name, ext2_filsys fs)
 		com_err(device_name, retval, "while closing the filesystem.\n");
 }
 
-void collect_info(ext2_filsys fs, struct chunk_info *chunk_info, FILE *f)
+static void collect_info(ext2_filsys fs, struct chunk_info *chunk_info, FILE *f)
 {
 	unsigned int retval = 0;
 
@@ -243,7 +245,8 @@ void collect_info(ext2_filsys fs, struct chunk_info *chunk_info, FILE *f)
 	}
 }
 
-void open_device(char *device_name, ext2_filsys *fs)
+#ifndef DEBUGFS
+static void open_device(char *device_name, ext2_filsys *fs)
 {
 	int retval;
 	int flag = EXT2_FLAG_FORCE;
@@ -254,9 +257,9 @@ void open_device(char *device_name, ext2_filsys *fs)
 		exit(1);
 	}
 }
+#endif
 
 #ifdef DEBUGFS
-
 #include "debugfs.h"
 
 void do_freefrag(int argc, char **argv)
@@ -264,10 +267,8 @@ void do_freefrag(int argc, char **argv)
 int main(int argc, char *argv[])
 #endif
 {
-	struct chunk_info chunk_info = { };
-	errcode_t retval = 0;
+	struct chunk_info chunk_info;
 	ext2_filsys fs = NULL;
-	char *device_name;
 	char *progname;
 	char *end;
 	int c;
@@ -276,9 +277,12 @@ int main(int argc, char *argv[])
 	if (check_fs_open(argv[0]))
 		return;
 #else
+	char *device_name;
+
 	add_error_table(&et_ext2_error_table);
 #endif
 	progname = argv[0];
+	memset(&chunk_info, 0, sizeof(chunk_info));
 
 	while ((c = getopt(argc, argv, "c:h")) != EOF) {
 		switch (c) {
@@ -326,6 +330,6 @@ int main(int argc, char *argv[])
 #ifndef DEBUGFS
 	close_device(device_name, fs);
 
-	return retval;
+	return 0;
 #endif
 }
-- 
1.7.4.1.22.gec8e1.dirty

