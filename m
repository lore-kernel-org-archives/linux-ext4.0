From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] e2fsck: check new sysfs interface to determine if we are on battery
Date: Mon, 20 Feb 2012 19:11:43 -0500
Message-ID: <1329783103-4017-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38923 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754278Ab2BUALr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Feb 2012 19:11:47 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

...since the old way is deprecated.

Addresses-SourceForge-Bug: #3439277

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/unix.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index c38b67a..6f97b0f 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -252,6 +252,14 @@ static int is_on_batt(void)
 	unsigned int	acflag;
 	struct dirent*	de;
 
+	f = fopen("/sys/class/power_supply/AC/online", "r");
+	if (f) {
+		if (fscanf(f, "%d\n", &acflag) == 1) {
+			fclose(f);
+			return (!acflag);
+		}
+		fclose(f);
+	}
 	f = fopen("/proc/apm", "r");
 	if (f) {
 		if (fscanf(f, "%s %s %s %x", tmp, tmp, tmp, &acflag) != 4)
-- 
1.7.9.107.g97f9a

