From: Girish Shilamkar <girish@clusterfs.com>
Subject: [Patch 10/13] SLES10 patch which adds -m flag support to fsck
Date: Tue, 24 Jul 2007 16:35:07 +0530
Message-ID: <1185275107.3789.75.camel@dhcp4.linsyssoft.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@clusterfs.com>,
	Theodore Tso <tytso@mit.edu>
To: Ext4 Mailing List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:40578 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933062AbXGXLEt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Jul 2007 07:04:49 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

SLES10 patch which adds -m flag support to fsck

Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
Signed-off-by: Girish Shilamkar <girish@clusterfs.com>

Index: e2fsprogs-1.40.1/misc/fsck.8.in
===================================================================
--- e2fsprogs-1.40.1.orig/misc/fsck.8.in
+++ e2fsprogs-1.40.1/misc/fsck.8.in
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
Index: e2fsprogs-1.40.1/misc/fsck.c
===================================================================
--- e2fsprogs-1.40.1.orig/misc/fsck.c
+++ e2fsprogs-1.40.1/misc/fsck.c
@@ -103,6 +103,7 @@ int noexecute = 0;
 int serialize = 0;
 int skip_root = 0;
 int like_mount = 0;
+int ignore_mounted = 0;
 int notitle = 0;
 int parallel_root = 0;
 int progress = 0;
@@ -793,7 +794,7 @@ static void compile_fs_type(char *fs_typ
 #if 0
 		printf("Adding %s to list (type %d).\n", s, cmp->type[num]);
 #endif
-	        cmp->list[num++] = string_copy(s);
+		cmp->list[num++] = string_copy(s);
 		s = strtok(NULL, ",");
 	}
 	free(list);
@@ -819,7 +820,7 @@ static int opt_in_list(char *opt, char *
 		}
 		s = strtok(NULL, ",");
 	}
-        free(list);
+	free(list);
 	return 0;
 }
 
@@ -855,6 +856,56 @@ static int fs_match(struct fs_info *fs, 
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
@@ -1002,6 +1053,15 @@ static int check_all(NOARGS)
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
@@ -1179,6 +1239,9 @@ static void PRS(int argc, char *argv[])
 			case 'P':
 				parallel_root++;
 				break;
+			case 'm':
+				ignore_mounted++;
+				break;
 			case 's':
 				serialize++;
 				break;
@@ -1254,6 +1317,10 @@ int main(int argc, char *argv[])
 		fstab = _PATH_MNTTAB;
 	load_fs_info(fstab);
 
+	/* Load info from /proc/mounts, too */
+	if (ignore_mounted)
+		load_fs_info("/proc/mounts");
+
 	/* Update our search path to include uncommon directories. */
 	if (oldpath) {
 		fsck_path = malloc (strlen (fsck_prefix_path) + 1 +
@@ -1296,6 +1363,14 @@ int main(int argc, char *argv[])
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
