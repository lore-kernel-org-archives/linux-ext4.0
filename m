From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] ext4: fix #11321: create /proc/ext4/*/stats et al more
	carefully
Date: Sat, 6 Sep 2008 01:06:52 +0400
Message-ID: <20080905210652.GE11569@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@osdl.org, linux-ext4@vger.kernel.org
To: ralf.hildebrandt@charite.de
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.185]:29683 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403AbYIEVFJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Sep 2008 17:05:09 -0400
Received: by mu-out-0910.google.com with SMTP id g7so452957muf.1
        for <linux-ext4@vger.kernel.org>; Fri, 05 Sep 2008 14:05:07 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ralf, please confirm.



[PATCH] ext4: fix #11321: create /proc/ext4/*/stats more carefully

ext4 creates per-suberblock directory in /proc/ext4/ . Name used as
basis is taken from bdevname, which, surprise, can contain slash.

However, proc while allowing to use proc_create("a/b", parent) form of
PDE creation, assumes that parent/a was already created.

bdevname in question is 'cciss/c0d0p9', directory is not created and all
this stuff goes directly into /proc (which is real bug).

Warning comes when _second_ partition is mounted.

http://bugzilla.kernel.org/show_bug.cgi?id=11321

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/ext4/mballoc.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2792,6 +2792,15 @@ static int ext4_mb_init_per_dev_proc(struct super_block *sb)
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

