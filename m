From: Matthias Koenig <mkoenig@suse.de>
Subject: [PATCH] [RFC] New fsck option to ignore device-mapper crypto devices
Date: Thu, 06 Mar 2008 14:41:22 +0100
Message-ID: <n7xejaoynp9.fsf@sor.suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: ludwig.nussel@suse.de, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:53169 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091AbYCFNlY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Mar 2008 08:41:24 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=

Hi,

Current practice in defining crypto devices in common distributions
has:
1. A definition of the device-mapper name with the corresponding device
   in /etc/crypttab
2. A definition in /etc/fstab for the mountpoint of the dm device.

Steps involved into setting up the crypto devices are
a. fsck local filesystems
b. mount local filesystems
c. device-mapper set up of crypto devices
d. fsck crypto filesystems
e. mount crypto filesystems

Steps a.+b. have to be done before the crypto device setup, because
the crypto device could be in a file container on a local filesystem.

Now, the problem appears if /etc/fstab contains a mount point of a
crypto device which is supposed to be fsck'd in step d.  fsck will
fail in step a., since this device does not exist at this point in
the boot process (it will be set up in step c.)

In order to address this, I propose a new option for fsck, lets say '-X'.
Enabling this will skip a device-mapper device which is currently
nonexistent, but is defined in /etc/crypttab.
In this way crypto devices could be skipped without fsck failure when
running fsck -A.
Proposed patch to implement this below.

Regards,
Matthias


--=-=-=
Content-Type: text/x-patch
Content-Disposition: inline; filename=e2fsprogs-1.40.7-ignore_crypto.patch

Index: e2fsprogs-1.40.7/misc/fsck.c
===================================================================
--- e2fsprogs-1.40.7.orig/misc/fsck.c
+++ e2fsprogs-1.40.7/misc/fsck.c
@@ -102,6 +102,7 @@ int noexecute = 0;
 int serialize = 0;
 int skip_root = 0;
 int ignore_mounted = 0;
+int ignore_crypto = 0;
 int notitle = 0;
 int parallel_root = 0;
 int progress = 0;
@@ -937,6 +938,67 @@ static int device_already_active(char *d
 	return 0;
 }
 
+/*
+ * Check if a device exists
+ */
+static int device_exists(const char *device)
+{
+	struct stat st;
+
+	if (stat(device, &st) == -1)
+		return 0;
+
+	if (!S_ISBLK(st.st_mode))
+		return 0;
+
+	return 1;
+}
+
+static void skipline(FILE *file)
+{
+	int c;
+
+	do {
+		c = fgetc(file);
+	} while (c != '\n' && c != EOF);
+}
+
+/*
+ * Check if a device is defined in /etc/crypttab
+ */
+static int device_in_crypttab(const char *device)
+{
+	const char crypttab[]="/etc/crypttab";
+	const char dmpath[]="/dev/mapper/";
+	char name[1024];
+	FILE *file;
+
+	/* check if device is a dm device
+	 * we can skip parsing if not
+	 */
+	if (strncmp(dmpath, device, strlen(dmpath)) != 0)
+		return 0;
+
+	file = fopen(crypttab, "r");
+	if (!file)
+		return 0;
+
+	while (fscanf(file, "%1023s", name) == 1) {
+		if (name[0] == '#') {
+			skipline(file);
+			continue;
+		}
+
+		if (strcmp(device+strlen(dmpath), name) == 0) {
+			fclose(file);
+			return 1;
+		}
+		skipline(file);
+	}
+	fclose(file);
+	return 0;
+}
+
 /* Check all file systems, using the /etc/fstab table. */
 static int check_all(NOARGS)
 {
@@ -1005,6 +1067,17 @@ static int check_all(NOARGS)
 				not_done_yet++;
 				continue;
 			}
+			/* ignore devices which do not exist yet, but are defined
+			 * in /etc/crypttab
+			 */
+			if (ignore_crypto && !device_exists(fs->device) &&
+					device_in_crypttab(fs->device)) {
+				if (verbose)
+					printf("Skipping nonexistent crypto device %s\n",
+							fs->device);
+				fs->flags |= FLAG_DONE;
+				continue;
+			}
 			if (ignore_mounted && is_mounted(fs->device)) {
 				fs->flags |= FLAG_DONE;
 				continue;
@@ -1058,7 +1131,7 @@ static int check_all(NOARGS)
 
 static void usage(NOARGS)
 {
-	fputs(_("Usage: fsck [-AMNPRTV] [ -C [ fd ] ] [-t fstype] [fs-options] [filesys ...]\n"), stderr);
+	fputs(_("Usage: fsck [-AMNPRTVX] [ -C [ fd ] ] [-t fstype] [fs-options] [filesys ...]\n"), stderr);
 	exit(EXIT_USAGE);
 }
 
@@ -1202,6 +1275,9 @@ static void PRS(int argc, char *argv[])
 				fstype = string_copy(tmp);
 				compile_fs_type(fstype, &fs_type_compiled);
 				goto next_arg;
+			case 'X':
+				ignore_crypto = 1;
+				break;
 			case '-':
 				opts_for_fsck++;
 				break;
@@ -1303,6 +1379,17 @@ int main(int argc, char *argv[])
 			if (!fs)
 				continue;
 		}
+		/*
+		 * Ignore devices which do not exist,
+		 * but are defined in /etc/crypttab
+		 */
+		if (ignore_crypto && !device_exists(fs->device) &&
+			   device_in_crypttab(fs->device)) {
+			if (verbose)
+				printf("Skipping nonexistent crypto device %s\n",
+						fs->device);
+			continue;
+		}
 		if (ignore_mounted && is_mounted(fs->device))
 			continue;
 		fsck_device(fs, interactive);
Index: e2fsprogs-1.40.7/misc/fsck.8.in
===================================================================
--- e2fsprogs-1.40.7.orig/misc/fsck.8.in
+++ e2fsprogs-1.40.7/misc/fsck.8.in
@@ -263,6 +263,10 @@ Don't show the title on startup.
 Produce verbose output, including all file system-specific commands
 that are executed.
 .TP
+.B \-X
+Skip device-mapper devices which currently do not exist, but are defined in 
+.BR crypttab (5).
+.TP
 .B fs-specific-options
 Options which are not understood by 
 .B fsck 

--=-=-=--
