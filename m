From: Richard Yao <ryao@gentoo.org>
Subject: [PATCH] e2fsprogs: misc: Remove broken whole device check
Date: Mon,  1 Jun 2015 18:39:22 -0400
Message-ID: <1433198362-86983-1-git-send-email-ryao@gentoo.org>
Cc: Theodore Ts'o <tytso@mit.edu>,
	Richard Yao <richard.yao@clusterhq.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:58819 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889AbbFAWjj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Jun 2015 18:39:39 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Richard Yao <richard.yao@clusterhq.com>

Modern Linux major/minor numbering on block devices no longer conform to
the divisible by 64 rule for minor numbering. On my development system,
the correct number is 16. Consequently, this applies only to every 4th
drive on a modern system, which is inconsistent. That caused the
following bug to be filed against Flocker:

https://clusterhq.atlassian.net/browse/FLOC-2041

We could unconditionally pass -F to override this check whenever it
triggers, but that it would also override the libblkid check that
determines whether there are existing partitions, logical volumes or
filesystems on the disk, which seems unwise.

I propose that this check be removed because passing a whole disk to
mke2fs is a valid use case and given how long this has been broken,
users are already accustomed to the behavior where -F is not necessary
to format a whole disk as ext4.

Signed-off-by: Richard Yao <ryao@gentoo.org>
---
 misc/plausible.c | 32 --------------------------------
 1 file changed, 32 deletions(-)

diff --git a/misc/plausible.c b/misc/plausible.c
index 1848a26..97492b9 100644
--- a/misc/plausible.c
+++ b/misc/plausible.c
@@ -18,9 +18,6 @@
 #include "config.h"
 #include <fcntl.h>
 #include <time.h>
-#ifdef HAVE_LINUX_MAJOR_H
-#include <linux/major.h>
-#endif
 #include <sys/types.h>
 #ifdef HAVE_SYS_STAT_H
 #include <sys/stat.h>
@@ -265,35 +262,6 @@ int check_plausibility(const char *device, int flags, int *ret_is_dev)
 	if (ret >= 0)
 		return ret;
 
-#ifdef HAVE_LINUX_MAJOR_H
-#ifndef MAJOR
-#define MAJOR(dev)	((dev)>>8)
-#define MINOR(dev)	((dev) & 0xff)
-#endif
-#ifndef SCSI_BLK_MAJOR
-#ifdef SCSI_DISK0_MAJOR
-#ifdef SCSI_DISK8_MAJOR
-#define SCSI_DISK_MAJOR(M) ((M) == SCSI_DISK0_MAJOR || \
-	((M) >= SCSI_DISK1_MAJOR && (M) <= SCSI_DISK7_MAJOR) || \
-	((M) >= SCSI_DISK8_MAJOR && (M) <= SCSI_DISK15_MAJOR))
-#else
-#define SCSI_DISK_MAJOR(M) ((M) == SCSI_DISK0_MAJOR || \
-	((M) >= SCSI_DISK1_MAJOR && (M) <= SCSI_DISK7_MAJOR))
-#endif /* defined(SCSI_DISK8_MAJOR) */
-#define SCSI_BLK_MAJOR(M) (SCSI_DISK_MAJOR((M)) || (M) == SCSI_CDROM_MAJOR)
-#else
-#define SCSI_BLK_MAJOR(M)  ((M) == SCSI_DISK_MAJOR || (M) == SCSI_CDROM_MAJOR)
-#endif /* defined(SCSI_DISK0_MAJOR) */
-#endif /* defined(SCSI_BLK_MAJOR) */
-	if (((MAJOR(s.st_rdev) == HD_MAJOR &&
-	      MINOR(s.st_rdev)%64 == 0) ||
-	     (SCSI_BLK_MAJOR(MAJOR(s.st_rdev)) &&
-	      MINOR(s.st_rdev)%16 == 0))) {
-		printf(_("%s is entire device, not just one partition!\n"),
-		       device);
-		return 0;
-	}
-#endif
 	return 1;
 }
 
-- 
2.3.6

