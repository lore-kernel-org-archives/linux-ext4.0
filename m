From: Jim Meyering <jim@meyering.net>
Subject: [PATCH] Don't dereference NULL upon slashless module dependency line.
Date: Mon, 23 Feb 2009 17:20:47 +0100
Message-ID: <87fxi5dt0g.fsf@meyering.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:50732 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014AbZBWQU5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Feb 2009 11:20:57 -0500
Received: from smtp1-g21.free.fr (localhost [127.0.0.1])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 18A7E9401BA
	for <linux-ext4@vger.kernel.org>; Mon, 23 Feb 2009 17:20:50 +0100 (CET)
Received: from mx.meyering.net (mx.meyering.net [82.230.74.64])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 3580D9401CC
	for <linux-ext4@vger.kernel.org>; Mon, 23 Feb 2009 17:20:48 +0100 (CET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


* probe.c (check_for_modules): Skip current line if it has no slash.

Signed-off-by: Jim Meyering <meyering@redhat.com>
---
I found this by inspection while looking for the cause of
a recent rawhide/nash segfault.

 lib/blkid/probe.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/blkid/probe.c b/lib/blkid/probe.c
index 76763ae..f5fff6b 100644
--- a/lib/blkid/probe.c
+++ b/lib/blkid/probe.c
@@ -225,8 +225,9 @@ static int check_for_modules(const char *fs_name)
 			*cp = 0;
 		else
 			continue;
-		if ((cp = strrchr(buf, '/')) != NULL)
-			cp++;
+		if ((cp = strrchr(buf, '/')) == NULL)
+			continue;
+		cp++;
 		i = strlen(cp);
 		if (i > 3) {
 			t = cp + i - 3;
--
1.6.2.rc1.256.g58a87
