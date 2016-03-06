From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH 3/6] misc: add missing declarations on maint
Date: Sat,  5 Mar 2016 17:38:33 -0700
Message-ID: <1457224716-72388-3-git-send-email-adilger@dilger.ca>
References: <1457224716-72388-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-no.shaw.ca ([64.59.134.12]:33814 "EHLO
	smtp-out-no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbcCFAqc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Mar 2016 19:46:32 -0500
In-Reply-To: <1457224716-72388-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix compile warnings for missing declarations on the maint branch.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 misc/util.c  | 3 +++
 util/subst.c | 4 ++++
 2 files changed, 7 insertions(+)

diff --git a/misc/util.c b/misc/util.c
index 2898830..5a24e7e 100644
--- a/misc/util.c
+++ b/misc/util.c
@@ -21,6 +21,9 @@
 #ifdef HAVE_ERRNO_H
 #include <errno.h>
 #endif
+#if HAVE_UNISTD_H
+#include <unistd.h>
+#endif
 #ifdef HAVE_LINUX_MAJOR_H
 #include <linux/major.h>
 #endif
diff --git a/util/subst.c b/util/subst.c
index 91f6d44..db72923 100644
--- a/util/subst.c
+++ b/util/subst.c
@@ -19,8 +19,12 @@
 #ifdef HAVE_SYS_TIME_H
 #include <sys/time.h>
 #endif
+#ifdef HAVE_SYS_TYPES_H
 #include <sys/types.h>
+#endif
+#ifdef HAVE_SYS_STAT_H
 #include <sys/stat.h>
+#endif
 #include <fcntl.h>
 #include <time.h>
 #include <utime.h>
-- 
1.8.0

