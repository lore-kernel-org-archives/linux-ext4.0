From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] filefrag: Fix segfault on virtual fs
Date: Tue, 26 Jun 2012 09:59:08 -0400
Message-ID: <4FE9C02C.8040703@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: maxnet@onlinehome.de
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57089 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310Ab2FZN7W (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Jun 2012 09:59:22 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

filefrag on a virtual fs like proc segfaults:

# filefrag /proc/filesystems 
Floating point exception

because stat.f_blocks is 0, so the calculation of cylgroups is 0,
which leads to a divide by 0 when calculating expected extents.

Since it's only used for ext2 filesystems anyway, just move
the calculation of expected under "if (is_ext2)" to fix this.

Reported-by: Max Beikirch <maxnet@onlinehome.de>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/misc/filefrag.c b/misc/filefrag.c
index 0583e91..b6e7d62 100644
--- a/misc/filefrag.c
+++ b/misc/filefrag.c
@@ -365,11 +366,12 @@ static void frag_report(const char *filename)
 	else
 		printf("%s: %d extents found", filename, num_extents);
 	/* count, and thus expected, only set for indirect FIBMAP'd files */
-	expected = (count/((bs*8)-(fsinfo.f_files/8/cylgroups)-3))+1;
-	if (is_ext2 && expected && expected < num_extents)
-		printf(", perfection would be %d extent%s\n", expected,
-			(expected>1) ? "s" : "");
-	else
+	if (is_ext2) {
+		expected = (count/((bs*8)-(fsinfo.f_files/8/cylgroups)-3))+1;
+		if (expected && expected < num_extents)
+			printf(", perfection would be %d extent%s\n", expected,
+				(expected>1) ? "s" : "");
+	} else
 		fputc('\n', stdout);
 	close(fd);
 	once = 0;

