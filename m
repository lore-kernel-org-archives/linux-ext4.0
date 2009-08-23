From: Karel Zak <kzak@redhat.com>
Subject: [PATCH] blkid: support .ko.gz in modules.dep parser
Date: Sun, 23 Aug 2009 21:13:56 +0200
Message-ID: <1251054836-5708-1-git-send-email-kzak@redhat.com>
Cc: linux-ext4@vger.kernel.org, Karel Zak <kzak@redhat.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933621AbZHWTN6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 23 Aug 2009 15:13:58 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The Linux kernel modules could be compressed, it means modules.dep
parser in libblid has to support .ko.gz extension too.

(Note, I've talked about this problem with Jon Masters and his
suggestion is to exec(/sbin/modinfo) rather than directly parse
modules.dep. BTW, the modules.dep file is deprecated.)

Address-Red-Hat-Bug: #518572
Signed-off-by: Karel Zak <kzak@redhat.com>
---
 lib/blkid/probe.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/lib/blkid/probe.c b/lib/blkid/probe.c
index 8f6cfa6..6b75732 100644
--- a/lib/blkid/probe.c
+++ b/lib/blkid/probe.c
@@ -208,8 +208,8 @@ static int check_for_modules(const char *fs_name)
 #ifdef __linux__
 	struct utsname	uts;
 	FILE		*f;
-	char		buf[1024], *cp, *t;
-	int		i;
+	char		buf[1024], *cp;
+	int		namesz;
 
 	if (uname(&uts))
 		return (0);
@@ -218,6 +218,9 @@ static int check_for_modules(const char *fs_name)
 	f = fopen(buf, "r");
 	if (!f)
 		return (0);
+
+	namesz = strlen(fs_name);
+
 	while (!feof(f)) {
 		if (!fgets(buf, sizeof(buf), f))
 			break;
@@ -229,13 +232,9 @@ static int check_for_modules(const char *fs_name)
 			cp++;
 		else
 			cp = buf;
-		i = strlen(cp);
-		if (i > 3) {
-			t = cp + i - 3;
-			if (!strcmp(t, ".ko"))
-				*t = 0;
-		}
-		if (!strcmp(cp, fs_name)) {
+		if (!strncmp(cp, fs_name, namesz) &&
+		    (!strcmp(cp + namesz, ".ko") ||
+		     !strcmp(cp + namesz, ".ko.gz"))) {
 			fclose(f);
 			return (1);
 		}
-- 
1.6.2.5

