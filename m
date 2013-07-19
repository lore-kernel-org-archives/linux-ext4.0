From: Robert Yang <liezhi.yang@windriver.com>
Subject: [PATCH 1/2] debugfs.c: the max length of debugfs argument is too short
Date: Fri, 19 Jul 2013 10:17:36 +0800
Message-ID: <1374200257-2873-2-git-send-email-liezhi.yang@windriver.com>
References: <1374200257-2873-1-git-send-email-liezhi.yang@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-ext4@vger.kernel.org>
To: <tytso@mit.edu>, <dvhart@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:35753 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759506Ab3GSCTS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Jul 2013 22:19:18 -0400
In-Reply-To: <1374200257-2873-1-git-send-email-liezhi.yang@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The max length of debugfs argument is 256 which is too short, the
arguments are two paths, the PATH_MAX is 4096 according to
/usr/include/linux/limits.h, use 2048 (4096 / 2) is a reasonable value.

Signed-off-by: Robert Yang <liezhi.yang@windriver.com>
Acked-by: Darren Hart <dvhart@linux.intel.com>
---
 debugfs/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index dcf16e2..b77d0b5 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -2300,7 +2300,7 @@ void do_dump_mmp(int argc EXT2FS_ATTR((unused)), char *argv[])
 static int source_file(const char *cmd_file, int ss_idx)
 {
 	FILE		*f;
-	char		buf[256];
+	char		buf[2048];
 	char		*cp;
 	int		exit_status = 0;
 	int		retval;
-- 
1.8.1.2

