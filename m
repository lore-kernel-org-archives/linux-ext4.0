From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] e4defrag: Handle device symlinks
Date: Thu, 19 Jul 2012 14:02:30 -0500
Message-ID: <500859C6.6040401@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Kazuya Mio <k-mio@sx.jp.nec.com>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019Ab2GSTCf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Jul 2012 15:02:35 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Device nodes are commonly accessed via symlinks, i.e.

# ls -l /dev/mapper/testvg-testlv 
lrwxrwxrwx. 1 root root 7 Jul 19 13:01 /dev/mapper/testvg-testlv -> ../dm-0

Today, e4defrag on such a device will fail:

# e4defrag -c /dev/mapper/testvg-testlv 
File is not regular file
 "/dev/mapper/testvg-testlv"

due to it being a link, and e4defrag on the link target does as well:

# e4defrag -c /dev/dm-0 
Filesystem is not mounted

due to the target not being found in /etc/mtab.

Fix this by checking whether the symlink target is a block device
and if so, using that device in main(), and also changing get_mount_point()
to search for a matching device number, not device name.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---


diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index 6491edd..260265c 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -266,8 +266,15 @@ static int get_mount_point(const char *devname, char *mount_point,
 {
 	/* Refer to /etc/mtab */
 	const char	*mtab = MOUNTED;
-	FILE	*fp = NULL;
+	FILE		*fp = NULL;
 	struct mntent	*mnt = NULL;
+	struct stat64	sb;
+
+	if (stat64(devname, &sb) < 0) {
+		perror(NGMSG_FILE_INFO);
+		PRINT_FILE_NAME(devname);
+		return -1;
+	}
 
 	fp = setmntent(mtab, "r");
 	if (fp == NULL) {
@@ -276,7 +283,15 @@ static int get_mount_point(const char *devname, char *mount_point,
 	}
 
 	while ((mnt = getmntent(fp)) != NULL) {
-		if (strcmp(devname, mnt->mnt_fsname) != 0)
+		struct stat64 ms;
+
+		/*
+		 * To handle device symlinks, we see if the
+ 		 * device number matches, not the name
+ 		 */
+		if (stat64(mnt->mnt_fsname, &ms) < 0)
+			continue;
+		if (sb.st_rdev != ms.st_rdev)
 			continue;
 
 		endmntent(fp);
@@ -1770,6 +1785,15 @@ int main(int argc, char *argv[])
 			continue;
 		}
 
+		/* Handle i.e. lvm device symlinks */
+		if (S_ISLNK(buf.st_mode)) {
+			struct stat64	buf2;
+
+			if (stat64(argv[i], &buf2) == 0 &&
+			    S_ISBLK(buf2.st_mode))
+				buf = buf2;
+		}
+
 		if (S_ISBLK(buf.st_mode)) {
 			/* Block device */
 			strncpy(dev_name, argv[i], strnlen(argv[i], PATH_MAX));


