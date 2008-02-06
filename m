From: Matthias Koenig <mkoenig-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 3/3] fsck: Do not check mounted filesystems
Date: Wed, 06 Feb 2008 12:39:03 +0100
Message-ID: <20080206113903.7833.6511.stgit@sor.suse.de>
References: <20080206113426.7833.59505.stgit@sor.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: util-linux-ng-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20080206113426.7833.59505.stgit-qv7XSOoqp4Ab1SvskN2V4Q@public.gmane.org>
Sender: util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

Add option -m to ignore and return an exit code of 0
for mounted filesystems.

Signed-off-by: Matthias Koenig <mkoenig-l3A5Bk7waGM@public.gmane.org>
---

 fsck/fsck.8.in |    4 +++
 fsck/fsck.c    |   77 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 80 insertions(+), 1 deletions(-)

diff --git a/fsck/fsck.8.in b/fsck/fsck.8.in
index 4a12677..087321b 100644
--- a/fsck/fsck.8.in
+++ b/fsck/fsck.8.in
@@ -180,6 +180,10 @@ option,
 will use the specified filesystem type.  If this type is not
 available, then the default file system type (currently ext2) is used. 
 .TP
+.B \-m
+Do not check mounted filesystems and return an exit code of 0
+for mounted filesystems.
+.TP
 .B \-A
 Walk through the
 .I /etc/fstab
diff --git a/fsck/fsck.c b/fsck/fsck.c
index c7905c4..14d490f 100644
--- a/fsck/fsck.c
+++ b/fsck/fsck.c
@@ -89,6 +89,7 @@ int noexecute = 0;
 int serialize = 0;
 int skip_root = 0;
 int like_mount = 0;
+int ignore_mounted = 0;
 int notitle = 0;
 int parallel_root = 0;
 int progress = 0;
@@ -837,6 +838,56 @@ static int fs_match(struct fs_info *fs, struct fs_type_compile *cmp)
 	return (cmp->negate ? !ret : ret);
 }
 
+/* Check to see whether a filesystem is already mounted */
+static int is_mounted(struct fs_info *fs)
+{
+	struct stat st_buf;
+	dev_t fs_rdev;
+	char *testdir;
+	int retval = 0;
+
+	if (!fs->mountpt) {
+		/*
+		 * We have already read /proc/mounts
+		 * so any device without a mountpoint
+		 * is indeed not mounted.
+		 */
+		return 0;
+	}
+
+	if (!strcmp(fs->mountpt,"/")) {
+		/* Root should be always mounted */
+		return 1;
+	}
+
+	if (stat(fs->mountpt, &st_buf) < 0)
+		return 0;
+
+	if (!S_ISDIR(st_buf.st_mode)) {
+		/* This is not a directory, cannot be mounted */
+		return 0;
+	}
+
+	fs_rdev = st_buf.st_dev;
+
+	/* Compare with the upper directory */
+	testdir = malloc(strlen(fs->mountpt) + 4);
+	strcpy(testdir,fs->mountpt);
+	if (fs->mountpt[strlen(fs->mountpt) - 1] == '/')
+		strcat(testdir,"..");
+	else
+		strcat(testdir,"/..");
+
+	if (stat(testdir, &st_buf) == 0) {
+		if (st_buf.st_dev != fs_rdev) {
+			retval = 1;
+		}
+	}
+	free(testdir);
+
+	return retval;
+}
+
 /* Check if we should ignore this filesystem. */
 static int ignore(struct fs_info *fs)
 {
@@ -994,6 +1045,15 @@ static int check_all(NOARGS)
 				not_done_yet++;
 				continue;
 			}
+			if (ignore_mounted) {
+				/*
+				 * Ignore mounted devices.
+				 */
+				if (is_mounted(fs)) {
+					fs->flags |= FLAG_DONE;
+					continue;
+				}
+			}
 			/*
 			 * If a filesystem on a particular device has
 			 * already been spawned, then we need to defer
@@ -1043,7 +1103,7 @@ static int check_all(NOARGS)
 
 static void usage(NOARGS)
 {
-	fputs(_("Usage: fsck [-ANPRTV] [ -C [ fd ] ] [-t fstype] [fs-options] [filesys ...]\n"), stderr);
+	fputs(_("Usage: fsck [-AmNPRTV] [ -C [ fd ] ] [-t fstype] [fs-options] [filesys ...]\n"), stderr);
 	exit(EXIT_USAGE);
 }
 
@@ -1171,6 +1231,9 @@ static void PRS(int argc, char *argv[])
 			case 'P':
 				parallel_root++;
 				break;
+			case 'm':
+				ignore_mounted++;
+				break;
 			case 's':
 				serialize++;
 				break;
@@ -1245,6 +1308,10 @@ int main(int argc, char *argv[])
 		fstab = _PATH_MNTTAB;
 	load_fs_info(fstab);
 
+	/* Load info from /proc/mounts, too */
+	if (ignore_mounted)
+		load_fs_info("/proc/mounts");
+
 	/* Update our search path to include uncommon directories. */
 	if (oldpath) {
 		fsck_path = malloc (strlen (fsck_prefix_path) + 1 +
@@ -1287,6 +1354,14 @@ int main(int argc, char *argv[])
 			if (!fs)
 				continue;
 		}
+		if (ignore_mounted) {
+			/*
+			 * Ignore mounted devices.
+			 */
+			if (is_mounted(fs)) {
+				continue;
+			}
+		}
 		fsck_device(fs, interactive);
 		if (serialize ||
 		    (max_running && (num_running >= max_running))) {
