From: Dan Magenheimer <dan.magenheimer@oracle.com>
Subject: [PATCH V8 7/8] ext4: add cleancache support
Date: Thu, 14 Apr 2011 14:19:02 -0700
Message-ID: <20110414211902.GA27813__47504.6087791727$1302816131$gmane$org@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: chris.mason@oracle.com, viro@zeniv.linux.org.uk,
	akpm@linux-foundation.org, adilger.kernel@dilger.ca, tytso@mit.edu,
	mfasheh@suse.com, jlbec@evilplan.org, matthew@wil.cx,
	linux-btrfs@
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:26533 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357Ab1DNVVs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Apr 2011 17:21:48 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[PATCH V8 7/8] ext4: add cleancache support

This seventh patch of eight in this cleancache series "opts-in"
cleancache for ext4.  Filesystems must explicitly enable cleancache
by calling cleancache_init_fs anytime an instance of the filesystem
is mounted. For ext4, all other cleancache hooks are in
the VFS layer including the matching cleancache_flush_fs
hook which must be called on unmount.

Details and a FAQ can be found in Documentation/vm/cleancache.txt

[v6-v8: no changes]
[v5: jeremy@goop.org: simplify init hook and any future fs init changes]
Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
Reviewed-by: Jeremy Fitzhardinge <jeremy@goop.org>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Acked-by: Andreas Dilger <adilger@sun.com>
Cc: Ted Ts'o <tytso@mit.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik Van Riel <riel@redhat.com>
Cc: Jan Beulich <JBeulich@novell.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <joel.becker@oracle.com>
Cc: Nitin Gupta <ngupta@vflare.org>

---

Diffstat:
 fs/ext4/super.c                          |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.39-rc3/fs/ext4/super.c	2011-04-11 18:21:51.000000000 -0600
+++ linux-2.6.39-rc3-cleancache/fs/ext4/super.c	2011-04-13 17:10:52.708850707 -0600
@@ -38,6 +38,7 @@
 #include <linux/ctype.h>
 #include <linux/log2.h>
 #include <linux/crc16.h>
+#include <linux/cleancache.h>
 #include <asm/uaccess.h>
 
 #include <linux/kthread.h>
@@ -1932,6 +1933,7 @@ static int ext4_setup_super(struct super
 			EXT4_INODES_PER_GROUP(sb),
 			sbi->s_mount_opt, sbi->s_mount_opt2);
 
+	cleancache_init_fs(sb);
 	return res;
 }
 
