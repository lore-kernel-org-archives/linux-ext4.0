From: amir73il@users.sourceforge.net
Subject: [RESEND PATCH 04/12] e2fsprogs: Next3 snapshot control with chattr/lsattr -X
Date: Mon, 26 Jul 2010 10:40:16 +0300
Message-ID: <1280130016-22663-1-git-send-email-amir73il@users.sourceforge.net>
References: <1279638973-14561-5-git-send-email-amir73il@users.sf.net>
Cc: linux-ext4@vger.kernel.org, Amir Goldstein <amir73il@users.sf.net>
To: tytso@mit.edu, andreas.dilger@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64629 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab0GZHii (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Jul 2010 03:38:38 -0400
Received: by wwj40 with SMTP id 40so6461581wwj.1
        for <linux-ext4@vger.kernel.org>; Mon, 26 Jul 2010 00:38:37 -0700 (PDT)
In-Reply-To: <1279638973-14561-5-git-send-email-amir73il@users.sf.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

Set/clear snapshots parent directory with chattr +/-x.
Take/delete snapshot with chattr -X +/-S.
Enable/disable snapshot with chattr -X +/-n.
View snapshot status with lsattr -X.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
---
 lib/e2p/e2p.h |   18 ++++++++++++++++++
 lib/e2p/pf.c  |   33 ++++++++++++++++++++++++++++++++-
 misc/chattr.c |   38 ++++++++++++++++++++++++++++++++++++--
 misc/lsattr.c |   13 ++++++++++---
 4 files changed, 96 insertions(+), 6 deletions(-)

diff --git a/lib/e2p/e2p.h b/lib/e2p/e2p.h
index 4a68dd9..1fbbe1b 100644
--- a/lib/e2p/e2p.h
+++ b/lib/e2p/e2p.h
@@ -26,6 +26,24 @@
 /* `options' for print_flags() */
 
 #define PFOPT_LONG  1 /* Must be 1 for compatibility with `int long_format'. */
+#define PFOPT_SNAPSHOT  2 /* list/control snapshot flags */
+#define PFOPT_SNAPSHOT_X 4 /* -X option for 'Snapshot' flags */
+
+/*
+ * snapshot status/control flags for lsattr/chattr -X.
+ * reusing compression flags on the GET/SETFLAGS ioctl for snapshot control API.
+ * all the flags below are either read-only on-disk inode flags (deleted and
+ * shrunk) or in-memory inode status flags (the rest).
+ * TODO: implement new ioctls for snapshot status/control.
+ */
+#define NEXT3_SNAPFILE_LIST_FL		0x00000100 /* snapshot is on list */
+#define NEXT3_SNAPFILE_ENABLED_FL	0x00000200 /* snapshot is enabled */
+#define NEXT3_SNAPFILE_ACTIVE_FL	0x00000400 /* snapshot is active */
+#define NEXT3_SNAPFILE_INUSE_FL		0x00000800 /* snapshot is in-use */
+#define NEXT3_SNAPFILE_DELETED_FL	0x04000000 /* snapshot is deleted */
+#define NEXT3_SNAPFILE_SHRUNK_FL	0x08000000 /* snapshot is shrunk */
+#define NEXT3_SNAPFILE_OPEN_FL		0x10000000 /* snapshot is mounted */
+#define NEXT3_SNAPFILE_TAGGED_FL	0x20000000 /* snapshot is tagged */
 
 
 int fgetflags (const char * name, unsigned long * flags);
diff --git a/lib/e2p/pf.c b/lib/e2p/pf.c
index f34a5cc..063bf2a 100644
--- a/lib/e2p/pf.c
+++ b/lib/e2p/pf.c
@@ -48,16 +48,47 @@ static struct flags_name flags_array[] = {
 	{ EXT2_TOPDIR_FL, "T", "Top_of_Directory_Hierarchies" },
 	{ EXT4_EXTENTS_FL, "e", "Extents" },
 	{ EXT4_HUGE_FILE_FL, "h", "Huge_file" },
+	{ EXT4_SNAPFILE_FL, "x", "Snapshot_File" },
+	{ 0, NULL, NULL }
+};
+
+/* Traditional snapshot flags */
+static struct flags_name snapshot_flags_array[] = {
+	{ NEXT3_SNAPFILE_LIST_FL, "l", "on_List" },
+	{ NEXT3_SNAPFILE_ENABLED_FL, "e", "Enabled" },
+	{ NEXT3_SNAPFILE_ACTIVE_FL, "a", "Active" },
+	{ NEXT3_SNAPFILE_INUSE_FL, "i", "Inuse_by_previous" },
+	{ NEXT3_SNAPFILE_DELETED_FL, "d", "Deleted" },
+	{ NEXT3_SNAPFILE_SHRUNK_FL, "s", "Shrunk" },
+	{ NEXT3_SNAPFILE_OPEN_FL, "m", "Mounted" },
+	{ NEXT3_SNAPFILE_TAGGED_FL, "t", "Tagged" },
+	{ 0, NULL, NULL }
+};
+
+/* Cool 'Snapshot' flags */
+static struct flags_name snapshot_X_flags_array[] = {
+	{ NEXT3_SNAPFILE_LIST_FL, "S", "on_liSt" },
+	{ NEXT3_SNAPFILE_ENABLED_FL, "n", "eNabled" },
+	{ NEXT3_SNAPFILE_ACTIVE_FL, "a", "Active" },
+	{ NEXT3_SNAPFILE_INUSE_FL, "p", "inuse_by_Previous" },
+	{ NEXT3_SNAPFILE_DELETED_FL, "s", "Deleted" },
+	{ NEXT3_SNAPFILE_SHRUNK_FL, "h", "sHrunk" },
+	{ NEXT3_SNAPFILE_OPEN_FL, "o", "mOunted" },
+	{ NEXT3_SNAPFILE_TAGGED_FL, "t", "Tagged" },
 	{ 0, NULL, NULL }
 };
 
 void print_flags (FILE * f, unsigned long flags, unsigned options)
 {
+	struct flags_name *array = ((options & PFOPT_SNAPSHOT_X) ?
+			snapshot_X_flags_array :
+			((options & PFOPT_SNAPSHOT) ?
+			 snapshot_flags_array : flags_array));
 	int long_opt = (options & PFOPT_LONG);
 	struct flags_name *fp;
 	int	first = 1;
 
-	for (fp = flags_array; fp->flag != 0; fp++) {
+	for (fp = array; fp->flag != 0; fp++) {
 		if (flags & fp->flag) {
 			if (long_opt) {
 				if (first)
diff --git a/misc/chattr.c b/misc/chattr.c
index de33b08..449101f 100644
--- a/misc/chattr.c
+++ b/misc/chattr.c
@@ -56,6 +56,8 @@
 
 static const char * program_name = "chattr";
 
+static int chsnap;
+
 static int add;
 static int rem;
 static int set;
@@ -81,8 +83,12 @@ static unsigned long sf;
 
 static void usage(void)
 {
+	fprintf(stderr, chsnap ?
+		_("Usage: %s [-+=let] snapshot files...\n") :
+		_("Usage: %s [-RVf] [-+=AacDdeijsSux] [-v version] files...\n"),
+		program_name);
 	fprintf(stderr,
-		_("Usage: %s [-RVf] [-+=AacDdeijsSu] [-v version] files...\n"),
+		_("Usage: %s -X [-+=Snt] snapshot files...\n"),
 		program_name);
 	exit(1);
 }
@@ -92,7 +98,7 @@ struct flags_char {
 	char 		optchar;
 };
 
-static const struct flags_char flags_array[] = {
+static const struct flags_char ext2_flags_array[] = {
 	{ EXT2_NOATIME_FL, 'A' },
 	{ EXT2_SYNC_FL, 'S' },
 	{ EXT2_DIRSYNC_FL, 'D' },
@@ -106,6 +112,25 @@ static const struct flags_char flags_array[] = {
 	{ EXT2_UNRM_FL, 'u' },
 	{ EXT2_NOTAIL_FL, 't' },
 	{ EXT2_TOPDIR_FL, 'T' },
+	{ EXT4_SNAPFILE_FL, 'x' },
+	{ 0, 0 }
+};
+
+static const struct flags_char *flags_array = ext2_flags_array;
+
+/* Traditional snapshot flags */
+static struct flags_char snapshot_flags_array[] = {
+	{ NEXT3_SNAPFILE_LIST_FL, 'l' },
+	{ NEXT3_SNAPFILE_ENABLED_FL, 'e' },
+	{ NEXT3_SNAPFILE_TAGGED_FL, 't' },
+	{ 0, 0 }
+};
+
+/* Cool 'Snapshot' flags */
+static struct flags_char snapshot_X_flags_array[] = {
+	{ NEXT3_SNAPFILE_LIST_FL, 'S' },
+	{ NEXT3_SNAPFILE_ENABLED_FL, 'n' },
+	{ NEXT3_SNAPFILE_TAGGED_FL, 't' },
 	{ 0, 0 }
 };
 
@@ -131,6 +156,10 @@ static int decode_arg (int * i, int argc, char ** argv)
 	{
 	case '-':
 		for (p = &argv[*i][1]; *p; p++) {
+			if (*p == 'X') {
+				flags_array = snapshot_X_flags_array;
+				continue;
+			}
 			if (*p == 'R') {
 				recursive = 1;
 				continue;
@@ -303,6 +332,11 @@ int main (int argc, char ** argv)
 #endif
 	if (argc && *argv)
 		program_name = *argv;
+	i = strlen(program_name);
+	if (i >= 6 && !strcmp(program_name + i - 6, "chsnap")) {
+		flags_array = snapshot_flags_array;
+		chsnap = 1;
+	}
 	i = 1;
 	while (i < argc && !end_arg) {
 		/* '--' arg should end option processing */
diff --git a/misc/lsattr.c b/misc/lsattr.c
index 15b17ad..3885628 100644
--- a/misc/lsattr.c
+++ b/misc/lsattr.c
@@ -70,7 +70,7 @@ static int generation_opt;
 
 static void usage(void)
 {
-	fprintf(stderr, _("Usage: %s [-RVadlv] [files...]\n"), program_name);
+	fprintf(stderr, _("Usage: %s [-XRVadlv] [files...]\n"), program_name);
 	exit(1);
 }
 
@@ -169,9 +169,16 @@ int main (int argc, char ** argv)
 #endif
 	if (argc && *argv)
 		program_name = *argv;
-	while ((c = getopt (argc, argv, "RVadlv")) != EOF)
+	i = strlen(program_name);
+	if (i >= 6 && !strcmp(program_name + i - 6, "lssnap"))
+		pf_options |= PFOPT_SNAPSHOT;
+
+	while ((c = getopt (argc, argv, "XRVadlv")) != EOF)
 		switch (c)
 		{
+			case 'X':
+				pf_options |= PFOPT_SNAPSHOT_X;
+				break;
 			case 'R':
 				recursive = 1;
 				break;
@@ -185,7 +192,7 @@ int main (int argc, char ** argv)
 				dirs_opt = 1;
 				break;
 			case 'l':
-				pf_options = PFOPT_LONG;
+				pf_options |= PFOPT_LONG;
 				break;
 			case 'v':
 				generation_opt = 1;
-- 
1.6.6

