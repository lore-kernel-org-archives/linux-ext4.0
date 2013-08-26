From: Robert Yang <liezhi.yang@windriver.com>
Subject: [PATCH 1/3 V4] debugfs.c: the max length of debugfs argument is too short
Date: Mon, 26 Aug 2013 14:22:02 +0800
Message-ID: <1377498124-25842-2-git-send-email-liezhi.yang@windriver.com>
References: <1377498124-25842-1-git-send-email-liezhi.yang@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <tytso@mit.edu>, <dvhart@linux.intel.com>,
	<darrick.wong@oracle.com>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:39050 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883Ab3HZG0a (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Aug 2013 02:26:30 -0400
In-Reply-To: <1377498124-25842-1-git-send-email-liezhi.yang@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The max length of debugfs argument is 256 which is too short, the
arguments are two paths, the PATH_MAX is 4096 according to
/usr/include/linux/limits.h, so use BUFSIZ (which is 8192 on Linux
systems), that's also what the ss library uses.

Signed-off-by: Robert Yang <liezhi.yang@windriver.com>
Acked-by: Darren Hart <dvhart@linux.intel.com>
---
 debugfs/debugfs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 2660218..a6bc932 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -37,6 +37,10 @@ extern char *optarg;
 #include "../version.h"
 #include "jfs_user.h"
 
+#ifndef BUFSIZ
+#define BUFSIZ 8192
+#endif
+
 ss_request_table *extra_cmds;
 const char *debug_prog_name;
 int sci_idx;
@@ -2311,7 +2315,7 @@ void do_dump_mmp(int argc EXT2FS_ATTR((unused)), char *argv[])
 static int source_file(const char *cmd_file, int ss_idx)
 {
 	FILE		*f;
-	char		buf[256];
+	char		buf[BUFSIZ];
 	char		*cp;
 	int		exit_status = 0;
 	int		retval;
-- 
1.8.1.2

