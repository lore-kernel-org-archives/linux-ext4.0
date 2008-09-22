From: akpm@linux-foundation.org
Subject: [patch for 2.6.27? 1/1] ext4: create /proc/ext4/*/stats et al more carefully
Date: Mon, 22 Sep 2008 14:07:06 -0700
Message-ID: <200809222107.m8ML76xD029671@imap1.linux-foundation.org>
Cc: linux-ext4@vger.kernel.org, akpm@linux-foundation.org,
	adobriyan@gmail.com, adilger@sun.com, ralf.hildebrandt@charite.de
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59448 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752342AbYIVVIJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Sep 2008 17:08:09 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Alexey Dobriyan <adobriyan@gmail.com>

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=11321

ext4 creates per-suberblock directory in /proc/ext4/ .  Name used as basis
is taken from bdevname, which, surprise, can contain slash.

However, proc while allowing to use proc_create("a/b", parent) form of
PDE creation, assumes that parent/a was already created.

bdevname in question is 'cciss/c0d0p9', directory is not created and all
this stuff goes directly into /proc (which is real bug).

Warning comes when _second_ partition is mounted.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Reported-by: Ralf Hildebrandt <ralf.hildebrandt@charite.de>
Tested-by: Ralf Hildebrandt <ralf.hildebrandt@charite.de>
Cc: Andreas Dilger <adilger@sun.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/mballoc.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN fs/ext4/mballoc.c~ext4-fix-11321-create-proc-ext4-stats-et-al-more-carefully fs/ext4/mballoc.c
--- a/fs/ext4/mballoc.c~ext4-fix-11321-create-proc-ext4-stats-et-al-more-carefully
+++ a/fs/ext4/mballoc.c
@@ -2792,6 +2792,15 @@ static int ext4_mb_init_per_dev_proc(str
 		return -EINVAL;
 	}
 	bdevname(sb->s_bdev, devname);
+	{
+		char *p = devname;
+
+		while (*p != '\0') {
+			if (*p == '/')
+				*p = '!';
+			p++;
+		}
+	}
 	sbi->s_mb_proc = proc_mkdir(devname, proc_root_ext4);
 
 	MB_PROC_HANDLER(EXT4_MB_STATS_NAME, stats);
_
