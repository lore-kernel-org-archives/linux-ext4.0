From: Jan Kara <jack@suse.cz>
Subject: [RFC] [PATCH 0/3] Recursive mtime for ext3
Date: Tue, 6 Nov 2007 18:15:37 +0100
Message-ID: <20071106171537.GD23689@duck.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="bKyqfOwhbdpXa4YI"
Cc: linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:42599 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753228AbXKFRPl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Nov 2007 12:15:41 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--bKyqfOwhbdpXa4YI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

  Hello,

  in following three patches is implemented recursive mtime feature for
ext3. The first two patches are mostly clean-up patches, the third patch
implements the feature itself. If somebody is interested in testing this
(or even writing a support of this feature in rsync and similar), please
contact me. Attached are sources of simple tools set_recmod, get_recmod
for testing the feature and also a patch implementing basic support of
the feature in e2fsprogs. Comments welcome.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--bKyqfOwhbdpXa4YI
Content-Type: text/x-c++src; charset=us-ascii
Content-Disposition: attachment; filename="set_recmod.c"

#include <stdio.h>
#include <fcntl.h>
#include <errno.h>
#include <string.h>

#include <sys/ioctl.h>
#include <linux/fs.h>
#include <linux/ext2_fs.h>

#define EXT2_IOC_GETRTIME _IOR('f', 9, unsigned int)

#define S_RECMOD 0x100000

int main(int argc, char **argv)
{
	int fd;
	long flags;

	if (argc < 2)
		return 1;

	fd = open(argv[1], O_RDONLY);
	if (fd < 0) {
		printf("Cannot open: %m\n");
		return 1;
	}
	if (ioctl(fd, EXT2_IOC_GETFLAGS, &flags) < 0) {
		printf("Cannot get flags: %m\n");
		return 1;
	}
	flags |= S_RECMOD;
	if (ioctl(fd, EXT2_IOC_SETFLAGS, &flags) < 0) {
		printf("Cannot set flags: %m\n");
		return 1;
	}

	return 0;
}

--bKyqfOwhbdpXa4YI
Content-Type: text/x-c++src; charset=us-ascii
Content-Disposition: attachment; filename="get_recmod.c"

#include <stdio.h>
#include <fcntl.h>
#include <errno.h>
#include <string.h>

#include <sys/ioctl.h>
#include <linux/fs.h>
#include <linux/ext2_fs.h>

#define EXT2_IOC_GETRTIME _IOR('f', 9, unsigned int)

#define S_RECMOD 0x100000

int main(int argc, char **argv)
{
	int fd;
	long flags;
	unsigned time;

	if (argc < 2)
		return 1;

	fd = open(argv[1], O_RDONLY);
	if (fd < 0) {
		printf("Cannot open: %m\n");
		return 1;
	}
	if (ioctl(fd, EXT2_IOC_GETFLAGS, &flags) < 0) {
		printf("Cannot get flags: %m\n");
		return 1;
	}
	if (ioctl(fd, EXT2_IOC_GETRTIME, &time) < 0) {
		printf("Cannot get rtime: %s\n", strerror(errno));
		return 1;
	}
	printf("RECMOD flags: %d, time %u\n", !!(flags & S_RECMOD), time);

	return 0;
}

--bKyqfOwhbdpXa4YI
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="e2fsprogs-rec_mtime.diff"

diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
index fe7e65a..a12540b 100644
--- a/lib/e2p/feature.c
+++ b/lib/e2p/feature.c
@@ -37,6 +37,8 @@ static struct feature feature_list[] = {
 			"resize_inode" },
 	{	E2P_FEATURE_COMPAT, EXT2_FEATURE_COMPAT_LAZY_BG,
 			"lazy_bg" },
+	{	E2P_FEATURE_COMPAT, EXT2_FEATURE_COMPAT_RTIME,
+			"recursive_mtime" },
 
 	{	E2P_FEATURE_RO_INCOMPAT, EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER,
 			"sparse_super" },
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index a316665..21747c2 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -623,6 +623,7 @@ struct ext2_super_block {
 #define EXT2_FEATURE_COMPAT_RESIZE_INODE	0x0010
 #define EXT2_FEATURE_COMPAT_DIR_INDEX		0x0020
 #define EXT2_FEATURE_COMPAT_LAZY_BG		0x0040
+#define EXT2_FEATURE_COMPAT_RTIME		0x0080
 
 #define EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER	0x0001
 #define EXT2_FEATURE_RO_COMPAT_LARGE_FILE	0x0002
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 83a9091..64b6eb6 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -418,7 +418,8 @@ typedef struct ext2_icount *ext2_icount_
 					 EXT2_FEATURE_COMPAT_RESIZE_INODE|\
 					 EXT2_FEATURE_COMPAT_DIR_INDEX|\
 					 EXT2_FEATURE_COMPAT_LAZY_BG|\
-					 EXT2_FEATURE_COMPAT_EXT_ATTR)
+					 EXT2_FEATURE_COMPAT_EXT_ATTR|\
+					 EXT2_FEATURE_COMPAT_RTIME)
 
 /* This #ifdef is temporary until compression is fully supported */
 #ifdef ENABLE_COMPRESSION
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 4a6cace..5060db7 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -870,7 +870,8 @@ static __u32 ok_features[3] = {
 	EXT3_FEATURE_COMPAT_HAS_JOURNAL |
 		EXT2_FEATURE_COMPAT_RESIZE_INODE |
 		EXT2_FEATURE_COMPAT_DIR_INDEX |
-		EXT2_FEATURE_COMPAT_LAZY_BG,	/* Compat */
+		EXT2_FEATURE_COMPAT_LAZY_BG |
+		EXT2_FEATURE_COMPAT_RTIME,	/* Compat */
 	EXT2_FEATURE_INCOMPAT_FILETYPE|		/* Incompat */
 		EXT3_FEATURE_INCOMPAT_JOURNAL_DEV|
 		EXT2_FEATURE_INCOMPAT_META_BG,
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 833b994..5195e40 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -96,7 +96,8 @@ static void usage(void)
 
 static __u32 ok_features[3] = {
 	EXT3_FEATURE_COMPAT_HAS_JOURNAL |
-		EXT2_FEATURE_COMPAT_DIR_INDEX,	/* Compat */
+		EXT2_FEATURE_COMPAT_DIR_INDEX |
+		EXT2_FEATURE_COMPAT_RTIME,	/* Compat */
 	EXT2_FEATURE_INCOMPAT_FILETYPE,		/* Incompat */
 	EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER	/* R/O compat */
 };

--bKyqfOwhbdpXa4YI--
