From: Dan Magenheimer <dan.magenheimer@oracle.com>
Subject: [PATCH V4 5/8] Cleancache: ext3 hook for cleancache
Date: Mon, 30 Aug 2010 15:32:33 -0700
Message-ID: <20100830223233.GA1317__40938.0692326978$1283207777$gmane$org@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: chris.mason@oracle.com, viro@zeniv.linux.org.uk,
	akpm@linux-foundation.org, adilger@sun.com, tytso@mit.edu,
	mfasheh@suse.com, joel.becker@oracle.com, matthew@wil.cx,
	linux-btrfs@vger.
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:57038 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637Ab0H3WfJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Aug 2010 18:35:09 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[PATCH V4 5/8] Cleancache: ext3 hook for cleancache

Filesystems must explicitly enable cleancache by calling
cleancache_init_fs anytime a instance of the filesystem
is mounted and must save the returned poolid.  For ext3,
all other cleancache hooks are in the VFS layer including
the matching cleancache_flush_fs hook which must be
called on unmount.

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
Acked-by: Andreas Dilger <adilger@sun.com>

Diffstat:
 super.c                                  |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.36-rc3/fs/ext3/super.c	2010-08-29 09:36:04.000000000 -0600
+++ linux-2.6.36-rc3-cleancache/fs/ext3/super.c	2010-08-30 09:20:42.000000000 -0600
@@ -37,6 +37,7 @@
 #include <linux/quotaops.h>
 #include <linux/seq_file.h>
 #include <linux/log2.h>
+#include <linux/cleancache.h>
 
 #include <asm/uaccess.h>
 
@@ -1349,6 +1350,7 @@ static int ext3_setup_super(struct super
 	} else {
 		ext3_msg(sb, KERN_INFO, "using internal journal");
 	}
+	sb->cleancache_poolid = cleancache_init_fs(PAGE_SIZE);
 	return res;
 }
 
