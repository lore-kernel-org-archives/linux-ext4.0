From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] e2fsprogs: fix blkid detection of ext4dev as ext4
Date: Wed, 08 Oct 2008 13:34:09 -0500
Message-ID: <48ECFD21.3080203@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:60831 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754572AbYJHSed (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 8 Oct 2008 14:34:33 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If only ext4 is available (as a module or in /proc/filesystems)
blkid wasn't properly testing for it, because the time checks
were backwards and always failed.  This caused old ext4dev
filesystems to fail to mount as ext4.  With this patch it works
fine.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: e2fsprogs/lib/blkid/probe.c
===================================================================
--- e2fsprogs.orig/lib/blkid/probe.c	2008-09-12 10:37:52.000000000 -0500
+++ e2fsprogs/lib/blkid/probe.c	2008-10-08 13:28:42.218001472 -0500
@@ -243,7 +243,7 @@ static int system_supports_ext4(void)
 	static int	ret = -1;
 	time_t		now = time(0);
 
-	if (ret != -1 || (last_check - now) < 5)
+	if (ret != -1 || (now - last_check) < 5)
 		return ret;
 	last_check = now;
 	ret = (fs_proc_check("ext4") || check_for_modules("ext4"));
@@ -256,7 +256,7 @@ static int system_supports_ext4dev(void)
 	static int	ret = -1;
 	time_t		now = time(0);
 
-	if (ret != -1 || (last_check - now) < 5)
+	if (ret != -1 || (now - last_check) < 5)
 		return ret;
 	last_check = now;
 	ret = (fs_proc_check("ext4dev") || check_for_modules("ext4dev"));

