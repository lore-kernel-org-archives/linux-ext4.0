From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/4] fs: Prevent doing FALLOC_FL_ZERO_RANGE on append only file
Date: Fri, 11 Apr 2014 20:57:43 +0200
Message-ID: <1397242665-2183-2-git-send-email-lczerner@redhat.com>
References: <1397242665-2183-1-git-send-email-lczerner@redhat.com>
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
	ceph-devel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1397242665-2183-1-git-send-email-lczerner@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Currently punch hole and collapse range fallocate operation are not
allowed on append only file. This should be case for zero range as well.
Fix it.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/open.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 631aea81..7882ff5 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -254,10 +254,11 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 		return -EBADF;
 
 	/*
-	 * It's not possible to punch hole or perform collapse range
-	 * on append only file
+	 * It's not possible to punch hole, perform collapse range
+	 * or zero range on append only file
 	 */
-	if (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_COLLAPSE_RANGE)
+	if (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_COLLAPSE_RANGE |
+		    FALLOC_FL_ZERO_RANGE)
 	    && IS_APPEND(inode))
 		return -EPERM;
 
-- 
1.8.3.1

