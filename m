From: Phillip Susi <psusi@ubuntu.com>
Subject: [PATCH] mke2fs: don't interact with a non tty
Date: Tue, 18 Mar 2014 13:11:58 -0400
Message-ID: <1395162718-22586-1-git-send-email-psusi@ubuntu.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rrcs-67-78-168-186.se.biz.rr.com ([67.78.168.186]:44434 "EHLO
	iriserv.iradimed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194AbaCRRMA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 18 Mar 2014 13:12:00 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

mke2fs displays an interactive y/n prompt for certain situations.
This is not appropriate to do when stdin is not a tty.

Signed-off-by: Phillip Susi <psusi@ubuntu.com>
---
 misc/util.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/misc/util.c b/misc/util.c
index 92ab79f..c469744 100644
--- a/misc/util.c
+++ b/misc/util.c
@@ -71,6 +71,8 @@ void proceed_question(void)
 	char buf[256];
 	const char *short_yes = _("yY");
 
+	if (!isatty(0))
+		return;
 	fflush(stdout);
 	fflush(stderr);
 	fputs(_("Proceed anyway? (y,n) "), stdout);
-- 
1.8.3.2

