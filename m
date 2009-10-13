From: y@redhat.com
Subject: [PATCH] ismounted: handle <=linux-2.6.19 bug in /proc/swaps
Date: Wed, 14 Oct 2009 01:52:59 +0200
Message-ID: <3540.08238432488$1255478603@news.gmane.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Karel Zak <kzak@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32330 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072AbZJMXx3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Oct 2009 19:53:29 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Karel Zak <kzak@redhat.com>

Linux <= 2.6.19 contained a bug in the /proc/swaps code where the
header would not be displayed (the first line).

This issue has been reported by Mike Frysinger for swapon(8).

Signed-off-by: Karel Zak <kzak@redhat.com>
---
 lib/ext2fs/ismounted.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/lib/ext2fs/ismounted.c b/lib/ext2fs/ismounted.c
index b7f17b8..704f6ff 100644
--- a/lib/ext2fs/ismounted.c
+++ b/lib/ext2fs/ismounted.c
@@ -253,8 +253,16 @@ static int is_swap_device(const char *file)
 	if (!(f = fopen("/proc/swaps", "r")))
 		return 0;
 	/* Skip the first line */
-	if (fgets(buf, sizeof(buf), f))
+	if (!fgets(buf, sizeof(buf), f))
+		goto leave;
+	if (*buf && strncmp(buf, "Filename\t", 9))
+		/* Linux <=2.6.19 contained a bug in the /proc/swaps
+		 * code where the header would not be displayed
+		 */
+		goto valid_first_line;
+
 	while (fgets(buf, sizeof(buf), f)) {
+valid_first_line:
 		if ((cp = strchr(buf, ' ')) != NULL)
 			*cp = 0;
 		if ((cp = strchr(buf, '\t')) != NULL)
@@ -272,6 +280,8 @@ static int is_swap_device(const char *file)
 		}
 #endif 	/* __GNU__ */
 	}
+
+leave:
 	fclose(f);
 	return ret;
 }
-- 
1.6.2.5

