From: Dan Magenheimer <dan.magenheimer@oracle.com>
Subject: [PATCH V8 5/8] ext3: add cleancache support
Date: Thu, 14 Apr 2011 14:18:02 -0700
Message-ID: <20110414211802.GA27779__18727.8700447225$1302816126$gmane$org@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: chris.mason@oracle.com, viro@zeniv.linux.org.uk,
	akpm@linux-foundation.org, adilger.kernel@dilger.ca, tytso@mit.edu,
	mfasheh@suse.com, jlbec@evilplan.org, matthew@wil.cx,
	linux-btrfs@
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:24960 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320Ab1DNVVT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Apr 2011 17:21:19 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[PATCH V8 5/8] ext3: add cleancache support

This fifth patch of eight in this cleancache series "opts-in"
cleancache for ext3.  Filesystems must explicitly enable
cleancache by calling cleancache_init_fs anytime an instance
of the filesystem is mounted. For ext3, all other cleancache
hooks are in the VFS layer including the matching cleancache_flush_fs
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
 fs/ext3/super.c                          |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.39-rc3/fs/ext3/super.c	2011-04-11 18:21:51.000000000 -0600
+++ linux-2.6.39-rc3-cleancache/fs/ext3/super.c	2011-04-13 17:10:40.918915872 -0600
@@ -36,6 +36,7 @@
 #include <linux/quotaops.h>
 #include <linux/seq_file.h>
 #include <linux/log2.h>
+#include <linux/cleancache.h>
 
 #include <asm/uaccess.h>
 
@@ -1367,6 +1368,7 @@ static int ext3_setup_super(struct super
 	} else {
 		ext3_msg(sb, KERN_INFO, "using internal journal");
 	}
+	cleancache_init_fs(sb);
 	return res;
 }
 
